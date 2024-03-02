function Enable-ActiveEmployees {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (
        
    )
    
    begin {
        # Get active employees
        $ActiveEmployees = Get-PayrollEmployees -ActivesOnly

        # Enterprise team
        if (!$EnterpriseTeams) {
            $EnterpriseTeams = Get-Microsoft365Teams -Name "Somos CDLA" -CreateIfMissing
        }    
    }
    
    process {
        foreach ($Employee in $ActiveEmployees) {
            #Write-Verbose "Enable-ActiveEmployees: processing $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
            #Write-EventLog -LogName "Application" -Source "Payroll-Microsoft365" -EventID 4001 -EntryType Information -Message "Enable-ActiveEmployees: processing $($Employee.CodigoColaborador, $Employee.NombreCompleto, $Employee.CargoPlanillas)"
            
            # Search employee's user in Active Directory
            $ADUser = Search-EmployeeADUser -Employee $Employee -Verbose

            # AD user found?
            if ($ADUser -ne $null) {
                # Update AD user data
                Set-ADUserEmployee -ADUser $ADUser -Employee $Employee -Verbose

                # Remove AD user from all standard security groups

                # Update payroll employee data
            } else {
                # Create AD user
                $ADUser = New-ADUserEmployee $Employee -Verbose
            }


            # Search user in Microsoft Entra Id
            $EntraIdUser = Get-MicrosoftEntraIdUser -ADUser $ADUser
            if ($EntraIdUser) {
                # Remove user from all teams
                Remove-Microsoft365TeamMember -Microsoft365User $EntraIdUser

                # Add user to enterprise team
                New-Microsoft365TeamMember -Microsoft365Teams $EnterpriseTeams -Microsoft365User $EntraIdUser

                # Add user to Division team
                $DivisionTeams = Get-Microsoft365Teams -Name "Somos $($Employee.Division)" -CreateIfMissing
                New-Microsoft365TeamMember -Microsoft365Teams $DivisionTeams -Microsoft365User $EntraIdUser

                # Department team
                $DepartmentTeams = Get-Microsoft365Teams -Name "Somos $($Employee.CentroCosto)" -CreateIfMissing
                New-Microsoft365TeamMember -Microsoft365Teams $DepartmentTeams -Microsoft365User $EntraIdUser
            }

        }
    }
    
    end {
        
    }
}