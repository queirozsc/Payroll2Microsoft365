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