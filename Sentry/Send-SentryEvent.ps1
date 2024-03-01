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
        [string]$Message,
        [Parameter()]
        [string]$FunctionName,
        [Parameter()]
        [string]$ObjectId
        )
    
    begin {
        $tags = @{
            'powershell_version' = $PSVersionTable.PSEdition + " " + $PSVersionTable.PSVersion
            'function_name' = $FunctionName
            'object_id' = $ObjectID
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