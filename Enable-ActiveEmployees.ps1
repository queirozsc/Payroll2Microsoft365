<#
.SYNOPSIS
    Enable-ActiveEmployees: Enables active employees in Active Directory and assigns them to Microsoft 365 Teams.
.DESCRIPTION
    This function enables active employees in Active Directory and assigns them to specific Microsoft 365 Teams based on their division and department. It also updates employee data in Active Directory and Microsoft 365 if necessary.
.PARAMETER None
    This function does not accept any parameters directly. It relies on the Get-PayrollEmployees function to retrieve a list of active employees.
.NOTES
    - This function requires administrative privileges to perform Active Directory and Microsoft 365 operations.
    - It is recommended to run this function with caution, especially in production environments, as it can modify user accounts and team memberships.
    - Use the -WhatIf and -Confirm parameters to simulate actions and confirm them before execution.
.EXAMPLE
    Enable-ActiveEmployees
    - Enables active employees and assigns them to Microsoft 365 Teams based on default parameters.
.INPUTS
    None. This function does not accept input from the pipeline.
.OUTPUTS
    None. This function does not output objects.
.FUNCTIONALITY
    - Retrieves a list of active employees from the payroll system.
    - Retrieves or creates Microsoft 365 Teams for the enterprise, division, and department.
    - Processes each active employee:
        - Searches for the employee's user in Active Directory.
        - Updates Active Directory user data if the user exists.
        - Removes the user from standard security groups in Active Directory if applicable.
        - Creates the user in Active Directory if they don't exist.
        - Searches for the user in Microsoft Entra Id.
        - Removes the user from all teams in Microsoft 365.
        - Adds the user to the enterprise, division, and department teams in Microsoft 365.
#>
function Enable-ActiveEmployees {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (
        
    )
    
    begin {
        # Get active employees
        $ActiveEmployees = Get-PayrollEmployees -ActivesOnly

        # Enterprise team
        if (!$EnterpriseTeams) {
            $EnterpriseTeams = Get-Microsoft365Teams -Name "Somos CDLA" -CreateIfMissing
        }    
    }
    
    process {
        foreach ($Employee in $ActiveEmployees) {
            #Write-Verbose "Enable-ActiveEmployees: processing $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
            #Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4001 -EntryType Information -Message "Enable-ActiveEmployees: processing $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
            
            # Search employee's user in Active Directory
            $ADUser = Search-EmployeeADUser -Employee $Employee -Verbose

            # AD user found?
            if ($ADUser -ne $null) {
                # Update AD user data
                Set-ADUserEmployee -ADUser $ADUser -Employee $Employee -Verbose

                # Remove AD user from all standard security groups

                # Update payroll employee data
            } else {
                # Create AD user
                $ADUser = New-ADUserEmployee $Employee -Verbose
            }


            # Search user in Microsoft Entra Id
            $EntraIdUser = Get-MicrosoftEntraIdUser -ADUser $ADUser
            if ($EntraIdUser) {
                # Remove user from all teams
                Remove-Microsoft365TeamMember -Microsoft365User $EntraIdUser

                # Add user to enterprise team
                New-Microsoft365TeamMember -Microsoft365Teams $EnterpriseTeams -Microsoft365User $EntraIdUser

                # Add user to Division team
                $DivisionTeams = Get-Microsoft365Teams -Name "Somos $($Employee.Division)" -CreateIfMissing
                New-Microsoft365TeamMember -Microsoft365Teams $DivisionTeams -Microsoft365User $EntraIdUser

                # Department team
                $DepartmentTeams = Get-Microsoft365Teams -Name "Somos $($Employee.CentroCosto)" -CreateIfMissing
                New-Microsoft365TeamMember -Microsoft365Teams $DepartmentTeams -Microsoft365User $EntraIdUser
            }

        }
    }
    
    end {
        
    }
}