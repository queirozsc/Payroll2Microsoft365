<#
.SYNOPSIS
    Returns a new custom object by filtering an existing object by any property
.DESCRIPTION
    Create a new custom object by filtering an existing object. You can use any property as filter criteria
.EXAMPLE
    $employees = Get-PayrollEmployees
    $employee = Filter-CustomObject -OriginalObject $employees -FilterProperty CodigoColaborador -FilterValue 7737471
    # Returns a single employee with ID equals to 7737471
#>
function Filter-CustomObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $OriginalObject,
        [Parameter(Mandatory=$True)]
        [string] $FilterProperty,  
        [Parameter(Mandatory=$True)]
        [string] $FilterValue  
    )
    
    begin {
        
    }
    
    process {
        # Filter the existing object based on the specified property and value
        $FilteredObject = $originalObject | Where-Object { $_.$filterProperty -eq $filterValue }
    }
    
    end {
        return $FilteredObject
    }
}