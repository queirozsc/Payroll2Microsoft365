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