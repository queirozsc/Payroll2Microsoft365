<#
.SYNOPSIS
    Safely set a property in a custom object. If does exist, create the property and set value
.DESCRIPTION
    Safe adds/sets a property in a custom object
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
