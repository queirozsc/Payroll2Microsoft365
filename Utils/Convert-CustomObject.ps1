<#
.SYNOPSIS
    Converts properties of an existing custom object based on a specified mapping table.
.DESCRIPTION
    This function creates a new custom object by mapping properties from an existing custom object to new property names 
    defined in a hashtable.
.PARAMETER ExistingObject
    The existing custom object whose properties are to be mapped.
.PARAMETER PropertyMapping
    A hashtable containing the mapping of existing property names to new property names.
.EXAMPLE
    $employee = [PSCustomObject]@{
        "CodigoColaborador" = 5402945
        "CargoPlanillas" = "TÉCNICO DE LABORATORIO"
    }

    $mapping = @{
        "CodigoColaborador" = "PostalCode"
        "CargoPlanillas" = "Title"
    }

    $user = Convert-CustomObject -ExistingObject $employee -PropertyMapping $mapping
    
    Create a new object with values:

    PostalCode Title
    ---------- -----
    5402945 TÉCNICO DE LABORATORIO
#>
function Convert-CustomObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $ExistingObject,
        [Parameter(Mandatory=$True)]
        [hashtable] $PropertyMapping 
    )
    
    begin {
        $NewObject = [PSCustomObject]@{}
    }
    
    process {
        # Create a new object based on the mapping table
        foreach ($MappedProperty in $PropertyMapping.Keys) {
            $DestinationProperty = $propertyMapping[$MappedProperty]
            $NewObject | Add-Member -MemberType NoteProperty -Name $DestinationProperty -Value $ExistingObject.$MappedProperty
        }
    }
    
    end {
        return $NewObject
    }
}
