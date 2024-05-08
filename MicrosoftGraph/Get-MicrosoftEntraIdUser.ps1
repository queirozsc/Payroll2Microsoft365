<#
.SYNOPSIS
    Retrieves a user from Microsoft 365 by UserPrincipalName.
.DESCRIPTION
    This function retrieves a user from Microsoft 365 by UserPrincipalName.
.PARAMETER ADUser
    Specifies the Active Directory user object to search for in Microsoft 365.
.EXAMPLE
    $ADUser | Get-MicrosoftEntraIdUser
    Retrieves the corresponding user from Microsoft 365 based on the UserPrincipalName property of the provided Active Directory user object.
#>
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