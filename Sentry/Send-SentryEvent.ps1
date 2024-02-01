<#
.SYNOPSIS
    Sends a message to Sentry.io
.DESCRIPTION
    Generate an event on Sentry.io for logging
.NOTES
    SentryPowershell is limite to send only Events
.LINK
    https://clinicadelasamericas.sentry.io/
.EXAMPLE
    Send-SentryEvent "Error message"
#>
function Send-SentryEvent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Message
        )
    
    begin {
        $tags = @{
            'backendType' = "Powershell " + $PSVersionTable.PSEdition + " " + $PSVersionTable.PSVersion
        }
        $sentry = New-Sentry -SentryDsn $env:SENTRA_DSN -Tags $tags        
    }
    
    process {
        $body = $sentry.GetBaseRequestBody($Message)
        $event = $sentry.StoreEvent($body)
        Write-Error $Message
    }
    
    end {
        
    }
}