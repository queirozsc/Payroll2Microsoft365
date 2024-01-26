<#
.SYNOPSIS
    Search for an Active Directory user by a list of usernames
.DESCRIPTION
    Recursive search in Active Directory using a list of usernames
.NOTES
    To get a list of usernames from a full name, use the function Util\Convert-Usernames
.EXAMPLE
    $usernames = Convert-Usernames "SERGIO CARVALHO QUEIROZ"
    $UnverifiedUser = Get-ADUserByUsernames $usernames
    # Search AD, but not validating full name
    $VerifiedUser = Get-ADUserByUsernames $usernames -VerificationName "SERGIO CARVALHO QUEIROZ"
    # Search AD, verifying if the full name is the same of AD User
#>

function Get-ADUserByUsernames {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [array] $Usernames,
        [Parameter(Mandatory=$False)]
        [array] $VerificationName

    )   
    begin {
        $UserFound = $False
    }
    
    process {
        # Check if the array is not empty
        if ($Usernames -ne $null -and $Usernames.Count -gt 0) {
            foreach ($Username in $Usernames) {
                # Search Active Directory by account name
                Write-Verbose "Searching on $env:AD_SERVER_NAME for Username $Username ..."
                try {
                    $ADUser = Get-ADUser -Filter { SamAccountName -eq $Username}
                }
                catch {
                    Send-SentryEvent $_.Exception.Message
                }

                if ($ADUser) {
                    # Double check user by full name
                    if (-not [string]::IsNullOrEmpty($VerificationName)) {
                        $UserFound = ($ADUser.Name.ToUpper() -eq $VerificationName.ToUpper())
                    }
                    else {
                        # It's not necessary to check, then user was found!
                        $UserFound = $True
                    }
                }
                
                # User was found! Break the loop
                if ($UserFound) {
                    Write-Verbose "User $($ADUser.Name) has been found!"
                    break
                }
            }
        }
        else {
            Write-Error "Usernames parameter is empty or null."
        }
    }
    
    end {
        return $ADUser
    }
}
