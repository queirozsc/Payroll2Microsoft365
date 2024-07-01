# Import all functions
. .\Import-AllModules.ps1

# Connect to Payroll
Get-PayrollToken -Verbose

# Inactive employees
Disable-InactiveEmployees -Verbose

# Active employees
Enable-ActiveEmployees -Verbose
#$Employees = Get-PayrollEmployees -ActivesOnly



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