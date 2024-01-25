#Setting environmental variables
. .\Set-EnvVariables.ps1

#Retrieving data from payroll
. .\Salar\Connect-SalarAuth.ps1
. .\Salar\Get-SalarWorkers.ps1