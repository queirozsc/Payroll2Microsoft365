# Includes all util functions
#Import-PSFiles -Path ".\Utils" -Verbose
. .\Utils\Add-ObjectProperties.ps1
. .\Utils\Convert-CustomObject.ps1
. .\Utils\Convert-Usernames.ps1
. .\Utils\Filter-CustomObject.ps1
. .\Utils\Format-TitleCase.ps1
. .\Utils\Import-PSFiles.ps1
. .\Utils\Join-Names.ps1
. .\Utils\Set-ObjectProperty.ps1

# Includes all Sentry.io functions
#Import-PSFiles -Path ".\Sentry" -Verbose
. .\Sentry\Send-SentryEvent.ps1

#Setting variables
. .\Set-Variables.ps1

# Includes all Active Directory functions
#Import-PSFiles -Path ".\ActiveDirectory" -Verbose
. .\ActiveDirectory\Get-ADUsers.ps1
. .\ActiveDirectory\Get-ADUserByID.ps1
. .\ActiveDirectory\Get-ADUserByUsernames.ps1
. .\ActiveDirectory\Set-ADUsersEmployees.ps1

# Includes all Microsoft Graph functions
#Import-PSFiles -Path ".\MicrosoftGraph" -Verbose
. .\MicrosoftGraph\Connect-Microsoft365.ps1

# Includes all Payroll functions
#Import-PSFiles -Path ".\Payroll" -Verbose -WhatIf:$false
. .\Payroll\Get-PayrollToken.ps1
. .\Payroll\Get-PayrollEmployees.ps1