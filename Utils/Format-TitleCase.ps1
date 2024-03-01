<#
.SYNOPSIS
    Format a string in title case, except prepositions
.DESCRIPTION
    Format a string to title case, but prepositions in lower case
.EXAMPLE
    Format-TitleCase "CLINICA METROPOLITANA DE LAS AMERICAS" 
    # Returns "Clinica Metropolitana de las Americas"
#>
function Format-TitleCase {
    [CmdletBinding()]
    param (
        [CmdletBinding()]
        [Parameter(Mandatory=$False, ValueFromPipeline=$True)]
        [string]$inputString
    )
    
    begin {
        # Define a list of common prepositions to exclude
        $prepositions = @(
            "a", "e", "i", "o", "u", "y", 
            "al",
            "con", 
            "en", "entre",
            "da", "de", "do", "desde", "del"
            "la", "las", "lo", "los"
            "para", "por", 
            "sin"
        )
        
        # Instantiate required object
        $textInfo = (Get-Culture).TextInfo

        $titleCaseString = ""
    }
    
    process {
        # Split the input string into words
        $words = $inputString -split '\s+'


        # Process the words
        foreach ($word in $words) {
            # Check if the current word is a preposition, if yes, keep it in lowercase
            if ($prepositions -contains $word.ToLower()) {
                $titleCaseString += " $($word.ToLower())"
            }
            else {
                # Capitalize the first letter of non-preposition words
                $titleCaseString += " $($textInfo.ToTitleCase($word.ToLower()))"
            }
        }
    }
    
    end {
        return $titleCaseString.Trim()
    }
}