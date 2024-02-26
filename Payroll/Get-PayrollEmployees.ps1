<#
.SYNOPSIS
    Connects to Salar API to get a list of employees
.DESCRIPTION
    Connects to Salar API and returns a list of employees
.EXAMPLE
    Get-PayrollEmployees
    # Returns all employees, actives and inactives
    Get-PayrollEmployees -InactivesOnly
    # Returns all inactives employees
    $StartDate = Get-Date "01/01/2024"
    $EndDate = Get-Date
    Get-PayrollEmployees -StartDate $StartDate -EndDate $EndDate
    # Returns all employees from 01/01/2024 to now
#>

function Get-PayrollEmployees {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False)]
        [switch] $ActivesOnly,
        [Parameter(Mandatory=$False)]
        [switch] $InactivesOnly,
        [Parameter(Mandatory=$False)]
        [datetime] $StartDate,
        [Parameter(Mandatory=$False)]
        [datetime] $EndDate
    )
    
    begin {
        # API URI to get list of employees
        $SALAR_URI = 'https://clinicaamericas.salar10.net/api/Colaboradores/Consultar'
        
        # Prepare bearer authorization
        $SALAR_AUTHORIZATION = "Bearer " + $env:SALAR_TOKEN

        # Prepare POST message
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", $SALAR_AUTHORIZATION)
        $headers.Add("Cookie", "SALAR.CLINAME.SESION=1brhcycza3df2ymjmdblip4z")
        $postParam = @{
            "IdEmpresa" = $env:SALAR_ID_EMPRESA
            "Cuenta" = $env:SALAR_CUENTA
            "Contrasena" = $env:SALAR_CONTRASENA
        }
    }
    
    process {
        # Adjust POST message to filter by status of employee
        # 1 = Active / 2 = Inactive
        if ($ActivesOnly) {
            $postParam["Estado"] = "1"
        } elseif ($InactivesOnly) {
            $postParam["Estado"] = "2"
        }

        # Adjust POST message to filter by dates
        if ($StartDate -ne $null) {
            $postParam["FechaIngresoInicio"] = (Get-Date $StartDate -Format yyyy-MM-dd)
        }
        if ($EndDate -ne $null) {
            $postParam["FechaIngresoFin"] = (Get-Date $EndDate -Format yyyy-MM-dd)
        }

        # Prepare POST message
        $body = ConvertTo-Json $postParam

        # Invoke API to get a list of employees
        try {
            $employees = Invoke-RestMethod $SALAR_URI -Method 'POST' -Headers $headers -Body $body `
                            | Select-Object -ExpandProperty Resultado
        }
        catch {
            Send-SentryEvent $_.Exception.Message
        }

        foreach ($Employee in $Employees) {
            # Join names in a full name and convert to title case
            $NombreCompleto = Join-Names -FirstName $Employee.PrimerNombre `
                                -SecondName $Employee.SegundoNombre `
                                -ThirdName $Employee.TercerNombre `
                                -FatherSurname $Employee.ApellidoPaterno `
                                -MotherSurname $Employee.ApellidoMaterno `
                                -MarriedSurname $Employee.ApellidoCasada `
                                | Format-TitleCase
            Set-ObjectProperty -ExistingObject $Employee -Name NombreCompleto -Value $NombreCompleto
            
            # Department
            $Division = $Employee.Divisiones[0].Codigo | Format-TitleCase
            Set-ObjectProperty -ExistingObject $Employee -Name Division -Value $Division

            # -Division
            $CentroCosto = $Employee.CentrosCosto[0].Codigo | Format-TitleCase
            Set-ObjectProperty -ExistingObject $Employee -Name CentroCosto -Value $CentroCosto

            # Superior
            $NombreSuperior = $Employee.Superior[0].Nombre | Format-TitleCase
            Set-ObjectProperty -ExistingObject $Employee -Name NombreSuperior -Value $NombreSuperior
            

        }
    }
    
    end {
        return $employees
    }
}

