#Install the NuGet provider
Write-Host -ForegroundColor Gray "Installing NuGet..."
if (Get-PackageProvider -Name NuGet) {
    Write-Host -ForegroundColor Green "NuGet version $((Get-PackageProvider -Name NuGet).Version.ToString()) installed"
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
Write-Host -ForegroundColor Gray "Setting the execution policy..."
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -WarningAction Ignore
    Write-Host -ForegroundColor Green "ExecutionPolicy setted to $(Get-ExecutionPolicy -Scope CurrentUser) for CurrentUser scope"
}
catch {
    Write-Host -ForegroundColor Red $_.Exception.Message
}

#Install Microsoft Graph Powershell SDK into the all users scope
Write-Host -ForegroundColor Gray "Installing Microsoft Graph Powershell SDK..."
if (Get-InstalledModule Microsoft.Graph) {
    Update-Module Microsoft.Graph
    Write-Host -ForegroundColor Green "Microsoft Graph version $((Get-InstalledModule Microsoft.Graph).Version.ToString()) installed"
} else {
    try {
        Install-Module Microsoft.Graph -Scope AllUsers -Force
    }
    catch {
        Write-Host -ForegroundColor Red $_.message
        exit
    }
}
