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
        $Username = Clean-SpecialChars ($Names[0][0] + $FatherSurname)
        $Usernames += $Username

        # Generate username alternative with first letters from others surnames
        $Username = ( $Names | ForEach-Object { if ( $_ -ne $FatherSurname ) { $_[0] } } ) -join ''
        $Username += $FatherSurname
        $Username = Clean-SpecialChars $Username
        $Usernames += $Username
        # While ($i -gt 1) {
        #     $Username = Clean-SpecialChars ($Names[0][0] + $Names[$i - 1][0] + $FatherSurname)
        #     $Usernames += $Username
        #     $i--
        # }
    }
    
    End {
        Return $Usernames
    }
}