<#
.SYNOPSIS
    Retrieves Active Directory user information based on the provided array of usernames.
.DESCRIPTION
    This function searches for users in Active Directory using an array of usernames.
    It optionally verifies the user by full name if a verification name is provided.
.PARAMETER Usernames
    Specifies an array of usernames to search for in Active Directory.
.PARAMETER VerificationName
    Specifies an optional array of verification names to cross-check against the full name of the found users.
.EXAMPLE
    Get-ADUserByUsernames -Usernames @("user1", "user2") -VerificationName @("User1 Full Name", "User2 Full Name")
    Retrieves the user information from Active Directory for "user1" and "user2" and verifies them against their full names.
.EXAMPLE
    $usernames = Convert-Usernames "SERGIO CARVALHO QUEIROZ"
    $UnverifiedUser = Get-ADUserByUsernames $usernames
    Search AD, but not validating full name
.EXAMPLE
    $VerifiedUser = Get-ADUserByUsernames $usernames -VerificationName "SERGIO CARVALHO QUEIROZ"
    Search AD, verifying if the full name is the same of AD User#>
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
                Write-Verbose "$($MyInvocation.MyCommand.Name): searching $Username on $env:AD_SERVER_NAME"
                try {
                    $ADUser = Get-ADUser -Filter { SamAccountName -eq $Username}
                }
                catch {
                    Send-SentryEvent -Message $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name -ObjectID $Username
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
                    Write-Verbose "$($MyInvocation.MyCommand.Name): returned ADUser $($ADUser.SamAccountName, $ADUser.Name)"
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
