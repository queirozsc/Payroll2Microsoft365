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
            Write-Verbose "$($MyInvocation.MyCommand.Name): searching $UserID on $env:AD_SERVER_NAME"
            $ADUser = Get-ADUser -Filter { PostalCode -eq $UserID}
        }
        catch {
            Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4001 -EntryType Error -Message "$($MyInvocation.MyCommand.Name): searching $UserID on $env:AD_SERVER_NAME"
            Send-SentryEvent -Message $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name -ObjectId $UserID
        }
        if ($ADUser) {
            Write-Verbose "$($MyInvocation.MyCommand.Name): returned ADUser $($ADUser.SamAccountName, $ADUser.Name)"
        } else {
            Write-Verbose "$($MyInvocation.MyCommand.Name): $UserID not found!"
        }
    }
    
    end {
        return $ADUser
    }
}