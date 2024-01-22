#Install the NuGet provider
if (Get-PackageProvider -Name NuGet) {
    Write-Host -ForegroundColor Green "NuGet version " (Get-PackageProvider -Name NuGet).Version.ToString() " installed"
} else {
    try {
        Install-PackageProvider -Name "NuGet" -Force
    }
    catch {
        $_.message
        exit
    }
}

#Set the execution policy (Windows) for Powershell scripts
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -WarningAction Ignore
}
catch {
    #Do nothing
}

#Install Microsoft Graph Powershell SDK into the all users scope
if (Get-InstalledModule Microsoft.Graph) {
    Update-Module Microsoft.Graph
    Write-Host -ForegroundColor Green "Microsoft Graph version " (Get-InstalledModule Microsoft.Graph).Version.ToString() " installed"
} else {
    try {
        Install-Module Microsoft.Graph -Scope AllUsers -Force
    }
    catch {
        $_.message
        exit
    }
}

#Install Sentry.io Powershell module
if (Get-InstalledModule SentryPowershell) {
    Update-Module SentryPowershell
    Write-Host -ForegroundColor Green "Sentry Powersell version " (Get-InstalledModule Microsoft.Graph).Version.ToString() " installed"
} else {
    try {
        Install-Module SentryPowershell
    }
    catch {
        $_.message
        exit
    }
}
