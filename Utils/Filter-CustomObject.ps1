<#
.SYNOPSIS
    Filters a custom object based on a specified property and value.
.DESCRIPTION
    This function filters a custom object based on a specified property and value. It returns a new custom 
    object containing only the elements that match the specified property-value pair.
.PARAMETER OriginalObject
    The original custom object to filter.
.PARAMETER Property
    The property name to filter on.
.PARAMETER Value
    The value to filter by.
.EXAMPLE
    $employees = Get-PayrollEmployees
    $employee = Filter-CustomObject -OriginalObject $employees -Property CodigoColaborador -Value 7737471
    Returns a single employee with ID equals to 7737471
#>
function Filter-CustomObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $OriginalObject,
        [Parameter(Mandatory=$True)]
        [string] $Property,  
        [Parameter(Mandatory=$False)]
        [string] $Value  
    )
    
    begin {
        
    }
    
    process {
        # Filter the existing object based on the specified property and value
        $FilteredObject = $originalObject | Where-Object { $_.$Property -eq $Value }
    }
    
    end {
        return $FilteredObject
    }
}