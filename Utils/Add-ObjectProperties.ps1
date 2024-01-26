<#
.SYNOPSIS
    Adds properties in a custom object
.DESCRIPTION
    Adds properties to a existing custom object
.NOTES
    For use with cmdlets, passing an object through the pipeline
.EXAMPLE
    $employee = [PSCustomObject]@{
        "CodigoColaborador" = 5402945
        "CargoPlanillas" = "TÉCNICO DE LABORATORIO"
    }

    $properties = @{
        "PaisNacionalidad" = "BOLIVIA"
        "LugarNacimiento" = "SANTA CRUZ"
    }

    $user = Add-ObjectProperties -ExistingObject $employee -NewProperties $properties
    # Adds new properties to existing object
#>
function Add-ObjectProperties {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $ExistingObject,
        [Parameter(Mandatory=$True)]
        [hashtable] $NewProperties 
    )
    
    begin {
    }
    
    process {
        # Add new properties to the existing object
        $ExistingObject | Add-Member $NewProperties
    }
    
    end {
        return $ExistingObject
    }
}