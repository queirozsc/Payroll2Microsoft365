<#
.SYNOPSIS
    Cleanses a string by replacing Spanish special characters with their corresponding non-special characters.
.DESCRIPTION
    This function replaces Spanish special characters (á, é, í, ó, ú, ü, ñ) with their non-special counterparts (a, e, i, o, u, u, n).
.PARAMETER OriginalString
    The original string containing Spanish special characters to be cleansed.
.EXAMPLE
    $originalString = "Español"
    Clean-SpecialChars -OriginalString $originalString
    Returns "Espanol" after removing special characters from the original string.
#>

function Clean-SpecialChars {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $OriginalString
    )    
    begin {
        $CleansedString = $OriginalString
    }
    
    process {
        # Replace spanish special letters 
        $CleansedString = $CleansedString -replace 'á', 'a'
        $CleansedString = $CleansedString -replace 'é', 'e'
        $CleansedString = $CleansedString -replace 'í', 'i'
        $CleansedString = $CleansedString -replace 'ó', 'o'
        $CleansedString = $CleansedString -replace 'ú', 'u'
        $CleansedString = $CleansedString -replace 'ü', 'u'
        $CleansedString = $CleansedString -replace 'ñ', 'n'
    }
    
    end {
        return $CleansedString
    }
}