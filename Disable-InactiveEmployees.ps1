<#
.SYNOPSIS
    Disable-InactiveEmployees: Disables inactive employees in Active Directory and Microsoft 365.
.DESCRIPTION
    This function disables inactive employees both in Active Directory and Microsoft 365, based on a list of inactive employees retrieved from the payroll system. It also handles exceptions for employees who continue as contractors.
.PARAMETER None
    This function does not accept any parameters directly. It relies on the presence of a CSV file named 'Inactive_Employees_Exceptions.csv' to load a list of exceptions.
.NOTES
    - This function requires administrative privileges to perform Active Directory and Microsoft 365 operations.
    - It is recommended to run this function with caution, especially in production environments, as it can disable user accounts and remove licenses.
    - Use the -WhatIf and -Confirm parameters to simulate actions and confirm them before execution.
.EXAMPLE
    Disable-InactiveEmployees
    - Disables inactive employees based on the default parameters.
.INPUTS
    None. This function does not accept input from the pipeline.
.OUTPUTS
    None. This function does not output objects.
.FUNCTIONALITY
    - Retrieves a list of inactive employees from the payroll system.
    - Loads exceptions for inactive employees from a CSV file.
    - Processes each inactive employee:
        - Logs processing information.
        - Checks for exceptions and skips processing if found.
        - Searches for the employee's user in Active Directory.
        - Removes the user from security groups in Active Directory if applicable.
        - Disables the user in Active Directory if applicable.
        - Searches for the user in Microsoft 365.
        - Removes the user from groups in Microsoft 365 if applicable.
        - Removes licenses from the user in Microsoft 365 if applicable.
#>

function Disable-InactiveEmployees {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (

    )    

    begin {
        # Get inactive employees
        $InactiveEmployees = Get-PayrollEmployees -InactivesOnly

        if (Test-Path '.\Inactive_Employees_Exceptions.csv') {
            # Load exception list from csv file
            $Exceptions = Import-Csv -Path '.\Inactive_Employees_Exceptions.csv' -Header 'CodigoColaborador'
        }
    }
    
    process {
        foreach ($Employee in $InactiveEmployees) {
            Write-Verbose "Disable-InactiveEmployees: processing $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
            Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 3001 -EntryType Information -Message "Disable-InactiveEmployees: processing $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"

            # Search if employee is in execption list 
            # (necessary for employees who continue as contractors)
            if ($Employee.CodigoColaborador -in $Exceptions.CodigoColaborador) {
                Write-Verbose "Disable-InactiveEmployees: skipping $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
                Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 3002 -EntryType Information -Message "Disable-InactiveEmployees: skipping $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
            } else {
                # Search employee's user in Active Directory
                $ADUser = Search-EmployeeADUser -Employee $Employee -Verbose

                # AD User found?
                if ($ADUser) {
                    
                    # Remove user from security groups
                    if (!$WhatIf.IsPresent) {
                        Write-Verbose "Disable-InactiveEmployees: removing user from security groups $($ADUser.SamAccountName, $ADUser.PostalCode, $ADUser.Name, $ADUser.Title)"
                        Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 3003 -EntryType Information -Message "Disable-InactiveEmployees: removing user from security groups $($ADUser.SamAccountName, $ADUser.PostalCode, $ADUser.Name, $ADUser.Title)"
                        Get-ADGroup -Filter "GroupCategory -eq 'Security'" | `
                            Remove-ADGroupMember -Members $ADUser -Confirm:$False -ErrorAction SilentlyContinue
                    }
                    
                    # Inactive user in Active Directory
                    if (!$WhatIf.IsPresent -and $ADUser.Enabled) {
                        Write-Verbose "Disable-InactiveEmployees: inactiving user $($ADUser.SamAccountName, $ADUser.PostalCode, $ADUser.Name, $ADUser.Title)"
                        Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 3004 -EntryType Information -Message "Disable-InactiveEmployees: inactivating user $($ADUser.SamAccountName, $ADUser.PostalCode, $ADUser.Name, $ADUser.Title)"
                        Set-ADUser -Identity $ADUser.SamAccountName -Enabled $False
                    }
                    
                    # Search AD user in Microsoft 365
                    $Microsoft365User = Get-Microsoft365ADUser $ADUser

                    if ($Microsoft365User) {
                        # Get all groups from user
                        $Microsoft365Groups = Get-MgUserMemberOf -UserId $Microsoft365User.Id

                        # Remove user from Microsoft 365 groups
                        if (!$WhatIf.IsPresent) {
                            foreach($Microsoft365Group in $Microsoft365Groups) {
                                if (!$Microsoft365Group.DeletedDateTime) {
                                    Write-Verbose "Disable-InactiveEmployees: removing user from Microsoft 365 group $($Microsoft365User.UserPrincipalName, $Microsoft365Group.AdditionalProperties.displayName)"
                                    Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 3005 -EntryType Information -Message "Disable-InactiveEmployees: removing user from Microsoft 365 group $($Microsoft365User.UserPrincipalName, $Microsoft365Group.AdditionalProperties.displayName)"
                                    Remove-MgGroupMemberByRef -GroupId $Microsoft365Group.Id -DirectoryObjectId $Microsoft365User.Id -Confirm:$False -ErrorAction SilentlyContinue
                                }
                            }
                        }
                        
                        # Get all licenses from user
                        $Microsoft365Licenses = Get-MgUserLicenseDetail -UserId $Microsoft365User.Id

                        # Remove user licenses
                        if (!$WhatIf.IsPresent) {
                            foreach($Microsoft365License in $Microsoft365Licenses) {
                                Write-Verbose "Disable-InactiveEmployees: removing licensing $($Microsoft365User.UserPrincipalName, $Microsoft365License.SkuPartNumber)"
                                Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 3006 -EntryType Information -Message "Disable-InactiveEmployees: removing licensing $($Microsoft365User.UserPrincipalName, $Microsoft365License.SkuPartNumber)"
                                Set-MgUserLicense -UserId $Microsoft365User.Id -AddLicenses @() -RemoveLicenses $Microsoft365License.SkuId  -Confirm:$False -ErrorAction SilentlyContinue
                                #Remove-MgUserLicenseDetail -LicenseDetailsId $Microsoft365License.Id -UserId $Microsoft365User.Id -Confirm:$False #-ErrorAction SilentlyContinue
                            }
                        }
                    }
                }
            }
        }
        


    }
    
    end {
        
    }
}


