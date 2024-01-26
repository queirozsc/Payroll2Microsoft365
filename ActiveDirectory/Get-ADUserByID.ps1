<#
.SYNOPSIS
    Search for an Active Directory user by identification number
.DESCRIPTION
    Search for an user based on your identification number
.NOTES
    For integration purpose, the ID of employee was stored on Postal Code field of Active Directory
.EXAMPLE
    Get-ADUserByID 7737471
    # Returns Active Directory user who has payroll code equals 7737471
#>


function Get-ADUserByID {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [string] $UserID
    )    
    begin {
        
    }
    
    process {
        try {
            # Get the user by identification document
            Write-Verbose "Searching on $env:AD_SERVER_NAME for UserID $UserID ..."
            $ADUser = Get-ADUser -Filter { PostalCode -eq $UserID}
        }
        catch {
            Send-SentryEvent $_.Exception.Message
        }
        if ($ADUser) {
            Write-Verbose "User $($ADUser.Name) has been found!"
        } else {
            Write-Verbose "User not found!"
        }
    }
    
    end {
        return $ADUser
    }
}