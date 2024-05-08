<#
.SYNOPSIS
    Sends an event to Sentry.io for logging and monitoring purposes.
.DESCRIPTION
    This function sends an event to Sentry.io for logging and monitoring purposes, providing context such as the message, function name, and object ID.
.NOTES
    SentryPowershell is limite to send only Events
.LINK
    https://clinicadelasamericas.sentry.io/
.PARAMETER Message
    The message to be logged in Sentry.io.
.PARAMETER FunctionName
    The name of the function where the event originated.
.PARAMETER ObjectId
    The ID of the object related to the event, if applicable.
.EXAMPLE
    Send-SentryEvent -Message "An error occurred" -FunctionName "MyFunction" -ObjectId "12345"
    Sends an error event to Sentry.io with the provided message and context.
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