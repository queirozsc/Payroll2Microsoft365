<#
.SYNOPSIS
    Converts a custom object in another custom object, based on a mapping table
.DESCRIPTION
    Creates a new custom object with data from an existing object. Column names are changed based on a mapping table
.NOTES
    For use with cmdlets, passing an object through the pipeline
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
    # Create a new object with values:
    # PostalCode Title
    # ---------- -----
    # 5402945 TÉCNICO DE LABORATORIO
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
