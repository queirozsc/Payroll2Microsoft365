<#
.SYNOPSIS
    Generates a full name from names and surnames non empty data
.DESCRIPTION
    Create a full name joining several names and surnames, if it's not empty
.NOTES
    In payroll system, the name of workes is stored in separated fields
.EXAMPLE
    Join-Names -FirstName SERGIO -FatherSurname CARVALHO -MotherSurname QUEIROZ
    #Returns "SERGIO CARVALHO QUEIROZ"
#>
function Join-Names {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False)]
        [string]$FirstName,
        [Parameter(Mandatory=$False)]
        [string]$SecondName,
        [Parameter(Mandatory=$False)]
        [string]$ThirdName,
        [Parameter(Mandatory=$False)]
        [string]$FatherSurname,
        [Parameter(Mandatory=$False)]
        [string]$MotherSurname,
        [Parameter(Mandatory=$False)]
        [string]$MarriedSurname
    )
    begin {
        # Combine non-empty strings
        $combinedString = ""
    }
    
    process {
        foreach ($input in $FirstName, $SecondName, $ThirdName, $FatherSurname, $MotherSurname, $MarriedSurname) {
            if (-not [string]::IsNullOrEmpty($input)) {
                $combinedString += "$input "
            }
        }
    }
    
    end {
        return $combinedString.Trim()
    }
}