function Get-ADUsers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False)]
        [string] $Filter
    )    
    begin {
        
    }
    
    process {
        try {
            $ADUsers = Get-ADUser -Filter { (!PostalCode -or (PostalCode -eq '')) }
        }
        catch {
            Send-SentryEvent $_.Exception.Message
        }
    }
    
    end {
        return $ADUsers
    }
}