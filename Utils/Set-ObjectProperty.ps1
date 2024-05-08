<#
.SYNOPSIS
    Sets or adds a property to an existing PowerShell custom object.
.DESCRIPTION
    This function sets or adds a property to an existing PowerShell custom object. It checks if the property already exists,
    and if so, updates its value. If the property doesn't exist, it adds the property to the object.
.PARAMETER ExistingObject
    The existing PowerShell custom object to which the property will be added or updated.
.PARAMETER Name
    The name of the property to be added or updated.
.PARAMETER Value
    The value to assign to the property.
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
    Adds new properties to existing object
#>
function Set-ObjectProperty {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $ExistingObject,
        [Parameter(Mandatory=$True)]
        [string] $Name,
        [Parameter(Mandatory=$False)]
        [string] $Value
    )
    
    begin {
        
    }
    
    process {
        # Check if the property exists
        if ($ExistingObject | Get-Member -Name $Name -MemberType Properties -ErrorAction SilentlyContinue) {
            # Property exists, update the value
            $ExistingObject.$Name = $Value
        }
        else {
            # Property doesn't exist, add the property
            try {
                $ExistingObject | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
            }
            catch {
                Send-SentryEvent -Message $_.Exception.Message -FunctionName $MyInvocation.MyCommand.Name -ObjectId $ExistingObject.$Name
            }
        }
    }
    
    end {
        #return $ExistingObject
    }
}
