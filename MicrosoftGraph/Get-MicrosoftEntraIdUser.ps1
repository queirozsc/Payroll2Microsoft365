function Get-MicrosoftEntraIdUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [PSCustomObject] $ADUser
    )
    
    begin {
        
    }
    
    process {
        # Search Microsoft 365 by UserPrincipalName
        $Microsoft365User = Get-MgUser `
            -ConsistencyLevel eventual `
            -Count userCount `
            -Search  "UserPrincipalName:$($ADUser.UserPrincipalName)" `
            -Top 1
    }
    
    end {
        return $Microsoft365User
    }
}