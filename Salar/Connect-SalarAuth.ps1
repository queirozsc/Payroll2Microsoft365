<#
.SYNOPSIS
    Connects to Salar API to get token
.DESCRIPTION
    Connects to Salar API and stores token return in env variable for further use
.NOTES
    It's necessary to set env variables before run
.EXAMPLE
    Connect-Salar
#>
. $PSScriptRoot\..\Set-EnvVariables.ps1
. $PSScriptRoot\..\Sentry\Send-SentryEvent.ps1
function Connect-Salar {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $SALAR_URI = 'https://clinicaamericas.salar10.net/api/Autenticacion/Autenticar'
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $postParam = @{
            "IdEmpresa" = $env:SALAR_ID_EMPRESA
            "Cuenta" = $env:SALAR_CUENTA
            "Contrasena" = $env:SALAR_CONTRASENA
        }
        $body = ConvertTo-Json $postParam        
    }
    
    process {
        try {
            $response = Invoke-RestMethod $SALAR_URI -Method 'POST' -Headers $headers -Body $body
        }
        catch {
            Send-SentryEvent $response.Mensajes[0]
        }
        if ($response.Exito) {
            $env:SALAR_TOKEN = $response.Token
            Write-Host -Foreground Green "Successfuly connected to Salar! Token " $env:SALAR_TOKEN
        } else {
            Send-SentryEvent $response.Mensajes[0]
        }        
    }
    
    end {
        $response | ConvertTo-Json        
    }
}

Connect-Salar