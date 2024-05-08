<#
.SYNOPSIS
    Retrieves Active Directory user information based on the provided filter.
.DESCRIPTION
    This function retrieves all Active Directory users that do not have a postal code set, or have an empty postal code.
.PARAMETER Filter
    Specifies an optional filter to further narrow down the search for Active Directory users.
.EXAMPLE
    Get-ADUsers
    Retrieves all Active Directory users that do not have a postal code set or have an empty postal code.
#>
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