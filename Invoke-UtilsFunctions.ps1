# Includes all functions from Utils folder
$folderPath = "$PSScriptRoot\Utils"

# Get all .ps1 files in the folder
$scriptFiles = Get-ChildItem -Path $folderPath -Filter *.ps1

# Loop through each script file and execute it
foreach ($scriptFile in $scriptFiles) {
    #Invoke-Expression -Command "& '$($scriptFile.FullName)'"
    . $scriptFile.FullName
}
