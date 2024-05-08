<#
.SYNOPSIS
    Joins individual name components into a single string.
.DESCRIPTION
    This function joins individual name components, such as first name, last name, and so on, into a single string,
    separating each component with a space. It removes any leading or trailing spaces from the resulting string.
.PARAMETER FirstName
    The first name component.
.PARAMETER SecondName
    The second name component.
.PARAMETER ThirdName
    The third name component.
.PARAMETER FatherSurname
    The father's surname component.
.PARAMETER MotherSurname
    The mother's surname component.
.PARAMETER MarriedSurname
    The married surname component.
.EXAMPLE
    Join-Names -FirstName SERGIO -FatherSurname CARVALHO -MotherSurname QUEIROZ
    Returns "SERGIO CARVALHO QUEIROZ"
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