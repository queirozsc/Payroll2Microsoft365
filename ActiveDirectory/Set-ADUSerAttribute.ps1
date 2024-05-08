<#
.SYNOPSIS
    Sets a specific attribute for an Active Directory user.
.DESCRIPTION
    This function sets a specific attribute for an Active Directory user specified by the provided ADUser object.
    If the attribute already has a value, it updates it. If the attribute doesn't have a value, it adds it.
.PARAMETER ADUser
    Specifies a PSCustomObject representing the Active Directory user whose attribute is to be set.
.PARAMETER AttributeName
    Specifies the name of the attribute to be set for the Active Directory user.
.PARAMETER AttributeValue
    Specifies the value to set for the attribute.
.EXAMPLE
    $ADUserObject = Get-ADUser -Identity "username"
    Set-ADUserAttribute -ADUser $ADUserObject -AttributeName "Description" -AttributeValue "New description"
    Sets the "Description" attribute for the Active Directory user "username" to "New description".
#>
function Set-ADUSerAttribute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [PSCustomObject] $ADUser,
        [Parameter(Mandatory=$True)]
        [string] $AttributeName,
        [Parameter(Mandatory=$True)]
        [string] $AttributeValue 

    )
    begin {
        
    }
    
    process {
        # Check if the attribute already has a value
        if ($ADUser.$AttributeName) {
            # If the attribute already has a value, update it
            Set-ADUser -Identity $ADUser.SamAccountName -Add @{ $AttributeName = $AttributeValue} -Confirm:$false
        } else {
            # If the attribute doesn't have a value, add it
            Set-ADUser -Identity $ADUser.SamAccountName -Replace @{ $AttributeName = $AttributeValue} -Confirm:$false
        }
    }
    
    end {
        
    }
}