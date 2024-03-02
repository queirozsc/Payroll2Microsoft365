#Install Sentry.io Powershell module
Write-Host -ForegroundColor Gray "Installing Sentry..."
if (Get-InstalledModule SentryPowershell) {
    Update-Module SentryPowershell
    Write-Host -ForegroundColor Green "Sentry Powersell version $((Get-InstalledModule Microsoft.Graph).Version.ToString()) installed"
} else {
    try {
        Install-Module SentryPowershell
    }
    catch {
        $_.message
        exit
    }
}
Import-Module SentryPowershell

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
Import-Module Microsoft.Graph

#Install Microsoft Graph Beta Powershell SDK into the all users scope
Write-Host -ForegroundColor Gray "Installing Microsoft Graph Beta Powershell SDK..."
if (Get-InstalledModule Microsoft.Graph.Beta) {
    Update-Module Microsoft.Graph.Beta
    Write-Host -ForegroundColor Green "Microsoft Graph version $((Get-InstalledModule Microsoft.Graph).Version.ToString()) installed"
} else {
    try {
        Install-Module Microsoft.Graph.Beta -Scope AllUsers -Force
    }
    catch {
        Write-Host -ForegroundColor Red $_.message
        exit
    }
}
Import-Module Microsoft.Graph.Beta

# Install Remote Server Administration Tools (RSAT)
Write-Host -ForegroundColor Gray "Installing Remote Server Admistration Tools (RSAT)..."
Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State
Import-Module ActiveDirectory


#Install PoshLog
# Write-Host -ForegroundColor Gray "Installing PoSHLog..."
# if (Get-InstalledModule PoshLog) {
#     Update-Module PoshLog
#     Write-Host -ForegroundColor Green "PoSHLog version $((Get-InstalledModule PoSHLog).Version.ToString()) installed"
# } else {
#     try {
#         Install-Module PoSHLog -Scope AllUsers -Force
#     }
#     catch {
#         Write-Host -ForegroundColor Red $_.message
#         exit
#     }
# }
# Import-Module PoSHLog