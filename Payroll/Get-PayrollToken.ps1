<#
.SYNOPSIS
    Connects to Salar API to get token
.DESCRIPTION
    Connects to Salar API and stores token return in env variable for further use
.EXAMPLE
    Get-PayrollToken
#>
function Get-PayrollToken {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        # API URI for authentication
        $SALAR_URI = 'https://clinicaamericas.salar10.net/api/Autenticacion/Autenticar'
        
        # Prepare POST message
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
            # Invoke API for authentication
            Write-Verbose "Connecting to $SALAR_URI ..."
            $response = Invoke-RestMethod $SALAR_URI -Method 'POST' -Headers $headers -Body $body
        }
        catch {
            # Send error to Sentry.io
            Send-SentryEvent $response.Mensajes[0]
        }
        # If successfull, store token for further use
        if ($response.Exito) {
            $env:SALAR_TOKEN = $response.Token
            Write-Verbose "Token: $env:SALAR_TOKEN"
        } else {
            # Send error to Sentry.io
            Send-SentryEvent $response.Mensajes[0]
        }        
    }
    
    end {
        return $response.Token    
    }
}