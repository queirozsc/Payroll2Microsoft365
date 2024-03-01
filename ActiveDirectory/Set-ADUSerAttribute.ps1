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