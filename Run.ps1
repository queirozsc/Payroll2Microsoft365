# Import all functions
. .\Import-AllModules.ps1

# Connect to Payroll
#Get-PayrollToken

# Retrieve all employees


    <# if ($env:DEBUG_MODE) {
    $SelectedIDs = $env:SALAR_FILTER_COLABORADORES -Split ';'
    foreach ($ID in $SelectedIDs) {
        $Employee = Filter-CustomObject -OriginalObject $Employees -Property CodigoColaborador -Value $ID
        Set-ADUsersEmployees $Employee -Verbose -WhatIf
    }
}
 #>
#Retrieving data from payroll
<# . .\Salar\Connect-SalarAuth.ps1
. .\Salar\Get-SalarWorkers.ps1


$employee = Filter-CustomObject $employees -Property CodigoColaborador -Value 11604867
Set-ADUsersEmployees $employee -Verbose

$employee = Filter-CustomObject $employees -Property CodigoColaborador -Value 9661676
Set-ADUsersEmployees $employee -Verbose #>