#Setting environmental variables
. .\Set-EnvVariables.ps1

#Setting logging to Sentra.io
Import-Module SentryPowershell
$tags = @{
    'backendType' = "Powershell " + $PSVersionTable.PSEdition + " " + $PSVersionTable.PSVersion
}
$sentry = New-Sentry -SentryDsn $env:SENTRA_DSN -Tags $tags

#Retrieving data from payroll
. .\Salar\Connect-SalarAuth.ps1