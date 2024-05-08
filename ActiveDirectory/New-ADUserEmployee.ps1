<#
.SYNOPSIS
    Creates a new Active Directory user for an employee using provided employee information.
.DESCRIPTION
    This function generates possible usernames for the employee based on their full name and country of nationality.
    It verifies if any of the generated usernames are available in Active Directory and creates a new user if a username is available.
    The function sets a default password for the new user and enables the account to change password at logon.
    It logs information and errors during the user creation process.
.PARAMETER Employee
    Specifies a PSCustomObject containing employee information including full name, nationality, and job title.
.EXAMPLE
    $EmployeeData = [PSCustomObject]@{
        NombreCompleto = "John Doe"
        PaisNacionalidad = "USA"
        CargoPlanillas = "HR Manager"
    }
    New-ADUserEmployee -Employee $EmployeeData
    Creates a new Active Directory user for the employee "John Doe" with the job title "HR Manager".
#>
function New-ADUserEmployee {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $Employee        
    )
    
    begin {
        # Generate posible usernames for employee
        $Usernames = Convert-Usernames $Employee.NombreCompleto -Country $Employee.PaisNacionalidad
    }
    
    process {
        # Verify if one of posible usernames is not used
        foreach ($Username in $Usernames) {
            $UsedUsername = Get-ADUser -Filter {SamAccountName -eq $Username}

            # Not used username detected!
            if (!$UsedUsername) {
                break
            }
        }

        # Create basic information of user ( default password = CDLA@[year], ex: CDLA@2024 )
        if (!$UsedUsername -and $Username) {
            $UserDetails = @{
                Name = $Username
                AccountPassword = (ConvertTo-SecureString ("CDLA@" + (Get-Date -Format yyyy)) -AsPlainText -Force)
                Enabled = $true
                ChangePasswordAtLogon = $true
            }
            try {
                Write-Verbose "$($MyInvocation.MyCommand.Name): creating ADUser $($Username, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
                Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4002 -EntryType Information -Message "$($MyInvocation.MyCommand.Name): creating ADUser $($Username, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
                New-ADUser @UserDetails
            }
            catch {
                Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4002 -EntryType Error -Message "$($MyInvocation.MyCommand.Name): error creating ADUser $($Username, $Employee.NombreCompleto)"
                Send-SentryEvent $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name -ObjectId $Username
            }

            # Update AD with full user data
            $ADUser = Get-ADUser -Filter {SamAccountName -eq $Username}
            Set-ADUserEmployee -ADUser $ADUser -Employee $Employee -Verbose
        }
    }
    
    end {
        return $ADUser
    }
}