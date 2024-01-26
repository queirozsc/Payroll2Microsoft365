function Set-ADUsersEmployees {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (
        [Parameter(Mandatory=$True)]
        [array] $Employees
    )    
    begin {

    }
    
    process {
        foreach ($Employee in $Employees) {
            # Join names in a full name and convert to title case
            $Fullname = Join-Fullname -FirstName $Employee.PrimerNombre `
                                -SecondName $Employee.SegundoNombre `
                                -ThirdName $Employee.TercerNombre `
                                -FatherSurname $Employee.ApellidoPaterno `
                                -MotherSurname $Employee.ApellidoMaterno `
                                -MarriedSurname $Employee.ApellidoCasada `
                                | Format-TitleCase
            
            # Join only names
            $GivenName = Join-Fullname -FirstName $Employee.PrimerNombre `
                                -SecondName $Employee.SegundoNombre `
                                -ThirdName $Employee.TercerNombre `
                                | Format-TitleCase

            # Join only surnames
            $Surname = Join-Fullname -FatherSurname $Employee.ApellidoPaterno `
                            -MotherSurname $Employee.ApellidoMaterno `
                            -MarriedSurname $Employee.ApellidoCasada `
                            | Format-TitleCase

            # Generate usernames from full names
            $Usernames = Convert-Usernames -Fullname $Fullname -Country $Employee.PaisNacionalidad

            # Search a user in AD by identification number
            Write-Verbose "Searching $Fullname by ID ..."
            $UserToUpdate = Get-ADUserByID $Employee.NumeroDocumento

            # Check if the user is found
            if ($UserToUpdate) {
                $UserToUpdate | Format-List
                $Employee | Format-List

                # Verify if there are a manager of employee
                if ($Employee.Superior.Count) {
                    # Search the manager by ID
                    $Manager = Get-ADUserByID $Employee.Superior[0].Codigo
                }

                if ($PSCmdlet.ShouldProcess("$Fullname", "Set-ADUser")) {
                    # Update the user
                    Set-ADUser -Identity $UserToUpdate `
                    -City ($Employee.Ciudad | Format-TitleCase) `
                    -Company ($env:EMPRESA | Format-TitleCase) `
                    -Description ($Employee.ProfesionOficio | Format-TitleCase) `
                    -Department ($Employee.Divisiones[0].Codigo | Format-TitleCase) `
                    -Division ($Employee.CentrosCosto[0].Codigo | Format-TitleCase) `
                    -DisplayName $Fullname `
                    -EmployeeID $Employee.CodigoColaborador `
                    -EmployeeNumber $Employee.CodigoAsistencia `
                    -GivenName $GivenName `
                    -Manager $Manager `
                    -Surname $GivenName `
                    -PostalCode $Employee.NumeroDocumento `
                    -Title ($Employee.CargoPlanillas | Format-TitleCase) `
                    -StreetAddress ($Employee.DireccionPersonal | Format-TitleCase)                     
                }

            }

        }
    }
    
    end {
        
    }
}

$employee = Filter-CustomObject $employees -Property CodigoColaborador -Value 11604867
Set-ADUsersEmployees $employee -Verbose

$employee = Filter-CustomObject $employees -Property CodigoColaborador -Value 9661676
Set-ADUsersEmployees $employee -Verbose