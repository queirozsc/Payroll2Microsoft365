<#
.SYNOPSIS
    Adds new properties to an existing PowerShell object.
.DESCRIPTION
    This function adds new properties to an existing PowerShell object using the Add-Member cmdlet.
.PARAMETER ExistingObject
    The existing PowerShell object to which new properties will be added.
.PARAMETER NewProperties
    A hashtable containing the new properties to be added to the existing object.
.EXAMPLE
    $existingObject = [PSCustomObject]@{
        Name = "John"
    }
    $newProperties = @{
        Age = 30
        City = "New York"
    }
    Add-ObjectProperties -ExistingObject $existingObject -NewProperties $newProperties
    Adds the Age and City properties to the existing object $existingObject.
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