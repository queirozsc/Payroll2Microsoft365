<#
.SYNOPSIS
    Generate a username from full name
.DESCRIPTION
    Generate username in format initial + father surname and username alternatives
.NOTES
    To avoid conflict with existing username, also generate alternatives usernames.
    Important: to respect Bolivian's order of surnames, it's necessary use -Country parameter
.EXAMPLE
    Generate-Usernames "SERGIO CARVALHO QUEIROZ" # [squeiroz, scqueiroz]
    Generate-Usernames -Fullname "Yersin Jacob Avalos Severiche" -Country "BOLIVIA" #[yavalos, yjavalos, yaavalos]
#>

Function Generate-Usernames {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$Fullname,
        [Parameter()]
        [string]$Country
    )
    
    Begin {
        $Usernames = @()
    }
    
    Process {
        $Names = ($Fullname.ToLower()).Split(' ')
        $i = ($Names.Count - 1)
        if ($Country.ToUpper() -eq "BOLIVIA") {
            $FatherSurname = $Names[$i - 1] #Order surnames in Bolivia: {Name} + {Father surname} + {Mother surname}
        } else {
            $FatherSurname = $Names[$i] 
        }
        $Usernames += $Names[0][0] + $FatherSurname
        While ($i -gt 1) {
            $Usernames += $Names[0][0] + $Names[$i - 1][0] + $FatherSurname
            $i--
        }
    }
    
    End {
        Return $Usernames
    }
}
