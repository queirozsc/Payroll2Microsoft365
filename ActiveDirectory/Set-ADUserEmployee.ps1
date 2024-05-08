<#
.SYNOPSIS
    Sets various attributes for an Active Directory user based on employee information.
.DESCRIPTION
    This function sets various attributes for an Active Directory user based on the provided ADUser and Employee objects.
    It updates attributes such as title, department, manager, display name, employee ID, and more.
.PARAMETER ADUser
    Specifies a PSCustomObject representing the Active Directory user whose attributes are to be set.
.PARAMETER Employee
    Specifies a PSCustomObject containing employee information used to update Active Directory user attributes.
.EXAMPLE
    $ADUserObject = Get-ADUser -Identity "username"
    $EmployeeData = Get-EmployeeData -Identity "username"
    Set-ADUserEmployee -ADUser $ADUserObject -Employee $EmployeeData
    Sets various attributes for the Active Directory user "username" based on employee information.
#>
function Set-ADUserEmployee {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $ADUser,
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $Employee
    )    
    begin {

    }
    
    process {
        if (!$WhatIf.IsPresent) {
            Write-Verbose "$($MyInvocation.MyCommand.Name): ADUser $($ADUser.SamAccountName, $ADUser.Name, $ADUser.Title) x Employee $($Employee.NombreCompleto, $Employee.CargoPlanillas, $Employee.Divisiones[0].Nombre, $Employee.CentrosCosto[0].Nombre, $Employee.Superior[0].Nome)"

            # Join names in a full name and convert to title case
            $Fullname = Join-Names -FirstName $Employee.PrimerNombre `
                -SecondName $Employee.SegundoNombre `
                -ThirdName $Employee.TercerNombre `
                -FatherSurname $Employee.ApellidoPaterno `
                -MotherSurname $Employee.ApellidoMaterno `
                -MarriedSurname $Employee.ApellidoCasada `
                | Format-TitleCase

            # Join only names
            $GivenName = Join-Names -FirstName $Employee.PrimerNombre `
                -SecondName $Employee.SegundoNombre `
                -ThirdName $Employee.TercerNombre `
                | Format-TitleCase

            # Join only surnames
            $Surname = Join-Names -FatherSurname $Employee.ApellidoPaterno `
                -MotherSurname $Employee.ApellidoMaterno `
                -MarriedSurname $Employee.ApellidoCasada `
                | Format-TitleCase

            # Verify if there are a manager of employee
            if ($Employee.Superior.Count) {
                # Search the manager by ID
                $Manager = Get-ADUserByID $Employee.Superior[0].Codigo
            }

            # Clear the user data (LDAP attributes: https://documentation.sailpoint.com/connectors/active_directory/help/integrating_active_directory/ldap_names.html)
            try {
                Write-Verbose "$($MyInvocation.MyCommand.Name): cleaned ADUser $($ADUser.SamAccountName, $ADUser.Name)"
                Set-ADUser -Identity $ADUser.SamAccountName -Clear title,company,department,division,manager,description,displayname,employeeid,employeenumber,givenname,sn,streetaddress,l,mail -Confirm:$false
            }
            catch {
                Send-SentryEvent -Message $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name -ObjectId $ADUser.SamAccountName
            }

            # Update the user
            try {
                Write-Verbose "$($MyInvocation.MyCommand.Name): updating ADUser $($ADUser.SamAccountName, $ADUser.Name, $ADUser.Title)"
                Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4001 -EntryType Information -Message "$($MyInvocation.MyCommand.Name): updating ADUser $($ADUser.SamAccountName, $ADUser.Name, $ADUser.Title)"
                Set-ADUser -Identity $ADUser.SamAccountName `
                    -UserPrincipalName ($ADUser.SamAccountName + '@' + $env:AD_DOMAIN) `
                    -Title ($Employee.CargoPlanillas | Format-TitleCase) `
                    -Division ($Employee.Divisiones[0].Nombre | Format-TitleCase) `
                    -Department ($Employee.CentrosCosto[0].Nombre | Format-TitleCase) `
                    -Company ($env:AD_ORGANIZATION | Format-TitleCase) `
                    -Manager $Manager `
                    -DisplayName $Fullname `
                    -EmployeeID $Employee.CodigoColaborador `
                    -EmployeeNumber $Employee.CodigoAsistencia `
                    -GivenName $GivenName `
                    -Surname $Surname `
                    -PostalCode $Employee.NumeroDocumento `
                    -EmailAddress ($ADUser.SamAccountName + '@' + $env:AD_DOMAIN) `
                    -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -UserPrincipalName ($ADUser.SamAccountName + '@' + $env:AD_DOMAIN) `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -Title ($Employee.CargoPlanillas | Format-TitleCase) `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -Department ($Employee.Divisiones[0].Nombre | Format-TitleCase) `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -Division ($Employee.CentrosCosto[0].Nombre | Format-TitleCase) `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -Company ($env:AD_ORGANIZATION | Format-TitleCase) `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -Manager $Manager `
                    # -Confirm:$false

                    if ($Employee.ProfesionOficio) {
                        Set-ADUser -Identity $ADUser.SamAccountName `
                        -Description ($Employee.ProfesionOficio | Format-TitleCase) `
                        -Confirm:$false
                    }

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -DisplayName $Fullname `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -EmployeeID $Employee.CodigoColaborador `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -EmployeeNumber $Employee.CodigoAsistencia `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -GivenName $GivenName `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -Surname $Surname `
                    # -Confirm:$false

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -PostalCode $Employee.NumeroDocumento `
                    # -Confirm:$false

                    if ($Employee.DireccionPersonal) {
                        Set-ADUser -Identity $ADUser.SamAccountName `
                        -StreetAddress ($Employee.DireccionPersonal | Format-TitleCase) `
                        -Confirm:$false
                    }

                    if ($Employee.Ciudad) {
                        Set-ADUser -Identity $ADUser.SamAccountName `
                        -City ($Employee.Ciudad | Format-TitleCase) `
                        -Confirm:$false
                    }

                    # Set-ADUser -Identity $ADUser.SamAccountName `
                    # -EmailAddress ($ADUser.SamAccountName + '@' + $env:AD_DOMAIN) `
                    # -Confirm:$false

                }
            catch {
                Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4001 -EntryType Error -Message "$($MyInvocation.MyCommand.Name): error updating ADUser $($ADUser.SamAccountName, $ADUser.Name)"
                Send-SentryEvent -Message $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name -ObjectId $ADUser.SamAccountName
            }
        }
    }
    
    end {
        
    }
}