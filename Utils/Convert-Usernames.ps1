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