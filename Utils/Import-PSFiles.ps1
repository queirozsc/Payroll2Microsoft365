<#
.SYNOPSIS
    Imports PowerShell files (*.ps1) from a specified folder.
.DESCRIPTION
    This function imports PowerShell files (*.ps1) from the specified folder path. It is useful for bulk importing
    functions or scripts stored in separate files.
.PARAMETER Path
    The path to the folder containing the PowerShell files to import. This parameter is mandatory and accepts input
    from the pipeline.
.EXAMPLE
    Import-PSFiles -Path "C:\Scripts"
    This example imports all PowerShell files (*.ps1) from the "C:\Scripts" folder.
#>
function Import-PSFiles {
    [CmdletBinding(SupportsShouldProcess=$True)] # Allows the use of -Confirm and -Whatif
    param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [ValidateScript({Test-Path $_ -PathType Container})] # Validate the path is a folder and not a file
        [string]$Path
    )
    
    begin {
        $Files = Get-ChildItem -Path "$Path" -File -Filter *.ps1
    }
    
    process {
        foreach ($File in $Files) {
            #if ($PSCmdlet.ShouldProcess("$File", "Importing function")) {
                Write-Verbose "Importing file $($File.Name)" 
                Import-Module $File.FullName
            #}
        }
    }
    
    end {
        
    }
}