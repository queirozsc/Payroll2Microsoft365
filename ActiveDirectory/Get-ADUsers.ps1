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
            Send-SentryEvent -Message $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name
        }
    }
    
    end {
        return $ADUsers
    }
}