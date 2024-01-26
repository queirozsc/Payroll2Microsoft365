function Set-ADUsersEmployees {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (
        [Parameter(Mandatory=$True)]
        [array] $Employees
    )    
    begin {
        $MappingProperties = @{
            "PaisNacionalidad" = "Country"
            "Divisiones" = "Department"
            "NombreCompleto" = "DisplayName"
            "CentrosCosto" = "Division"
            "Nombres" = "GivenName"
            "CodigoColaborador" = "PostalCode"
            "CodigoUsuario" = "SamAccountName"
            "Apellidos" = "Surname"
            "CargoPlanillas" = "Title"
        }
    }
    
    process {
        foreach ($Employee in $Employees) {
            # Join names in a full name and convert to title case
            $NombreCompleto = Join-Fullname -FirstName $Employee.PrimerNombre `
                            -SecondName $Employee.SegundoNombre `
                            -ThirdName $Employee.TercerNombre `
                            -FatherSurname $Employee.ApellidoPaterno `
                            -MotherSurname $Employee.ApellidoMaterno `
                            -MarriedSurname $Employee.ApellidoCasada `
                        | Format-TitleCase
            
            # Generate usernames from full names
            $Usernames = Convert-Usernames -Fullname $NombreCompleto -Country $Employee.PaisNacionalidad

            # Convert job title to title case
            $JobTitle = Format-TitleCase $Employee.CargoPlanillas

            # Get the department from employee
            $Department = $Employee.Divisiones[0].Codigo | Format-TitleCase

            # Get the division from employee
            $Division = $Employee.CentrosCosto[0].Codigo | Format-TitleCase

            Write-Verbose "Searching $Fullname ($JobTitle, $Department, $Division) by usernames [$usernames] ..."

        }
    }
    
    end {
        
    }
}