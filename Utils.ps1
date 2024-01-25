<#
.SYNOPSIS
    Convert a full name in a list of usernames
.DESCRIPTION
    Generate username in format initial + father surname and username alternatives
.NOTES
    To avoid conflict with existing username, also generate alternatives usernames.
    Important: to respect Bolivian's order of surnames, it's necessary use -Country parameter
.EXAMPLE
    Convert-Usernames "SERGIO CARVALHO QUEIROZ" 
    # Returns [squeiroz, scqueiroz]
    Convert-Usernames -Fullname "Yersin Jacob Avalos Severiche" -Country "BOLIVIA" 
    # Returns [yavalos, yjavalos, yaavalos]
#>

Function Convert-Usernames {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [string]$Fullname,
        [Parameter(Mandatory=$False)]
        [string]$Country
    )
    
    Begin {
        $Usernames = @()
    }
    
    Process {
        # Split the input string into words
        $Names = ($Fullname.ToLower()).Split(' ')

        $i = ($Names.Count - 1)
        # If bolivian, invert surname order
        if ($Country.ToUpper() -eq "BOLIVIA") {
            $FatherSurname = $Names[$i - 1]
        } else {
            $FatherSurname = $Names[$i] 
        }

        # Apply the username standard: first letter + father surname
        $Usernames += $Names[0][0] + $FatherSurname

        # Generate username alternative with the others surnames
        While ($i -gt 1) {
            $Usernames += $Names[0][0] + $Names[$i - 1][0] + $FatherSurname
            $i--
        }
    }
    
    End {
        Return $Usernames
    }
}

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
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [string]$inputString
    )
    
    begin {
        # Define a list of common prepositions to exclude
        $prepositions = @(
            "a", "e", "i", "o", "u", "y", 
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

<#
.SYNOPSIS
    Generates a full name from names and surnames non empty data
.DESCRIPTION
    Create a full name joining several names and surnames, if it's not empty
.NOTES
    In payroll system, the name of workes is stored in separated fields
.EXAMPLE
    Join-FullName -FirstName SERGIO -FatherSurname CARVALHO -MotherSurname QUEIROZ
    #Returns "SERGIO CARVALHO QUEIROZ"
#>


function Join-Fullname {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
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
