<#
.SYNOPSIS
    Retrieves Active Directory user information based on the provided identification document.
.DESCRIPTION
    This function searches for a user in Active Directory using a provided identification document (UserID).
    It logs errors and sends event notifications in case of failure.
.PARAMETER UserID
    Specifies the identification document of the user to search for.
.EXAMPLE
    Get-ADUserByID -UserID "123456789"
    Retrieves the user information from Active Directory based on the identification document "123456789".
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