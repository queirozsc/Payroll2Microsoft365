<#
.SYNOPSIS
    Search-EmployeeADUser: Searches for an employee's Active Directory user account.
.DESCRIPTION
    This function searches for an employee's Active Directory (AD) user account based on their employee ID and name. If the user is not found using the employee ID, it generates possible usernames based on the employee's full name and searches again. It returns the AD user object if found, otherwise, it returns $null.
.PARAMETER Employee
    Specifies the employee object containing information such as employee ID, full name, and nationality country.
.NOTES
    - This function requires administrative privileges to search Active Directory.
    - It is designed to be used in conjunction with other functions to manage employee accounts in Active Directory.
    - Use verbose output for detailed information during the search process.
.EXAMPLE
    $employee = [PSCustomObject]@{
        CodigoColaborador = "12345"
        NombreCompleto = "John Doe"
        PaisNacionalidad = "USA"
    }
    Search-EmployeeADUser -Employee $employee
    - Searches for an employee named "John Doe" with employee ID "12345" in Active Directory.
.INPUTS
    Employee: Accepts a PSCustomObject representing an employee with properties like CodigoColaborador, NombreCompleto, and PaisNacionalidad.
.OUTPUTS
    Returns a PSCustomObject representing the Active Directory user account of the employee if found, otherwise returns $null.
.FUNCTIONALITY
    - Searches for an employee's Active Directory user account by employee ID.
    - If not found, generates possible usernames based on the employee's full name and searches again.
#>
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

