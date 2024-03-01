function Search-EmployeeADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $Employee
    )
    
    begin {
        
    }
    
    process {
    # Search employee in Active Directory by ID
    $ADUser = Get-ADUserByID $Employee.CodigoColaborador -Verbose

    # User not found?
    if ($ADUser -eq $null) {
        # Generate posible usernames for employee
        $Usernames = Convert-Usernames $Employee.NombreCompleto -Country $Employee.PaisNacionalidad
    
        # Search employee in Active Directory by username
        $ADUser = Get-ADUserByUsernames $Usernames -VerificationName $Employee.NombreCompleto -Verbose
    }

    }
    
    end {
        return $ADUser
    }
}

