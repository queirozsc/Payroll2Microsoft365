function Enable-ActiveEmployees {
    # Set SupportsShouldProcess to True, to make -WhatIf and -Confirm accessible
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="High")]
    param (
        
    )
    
    begin {
        # Get active employees
        $ActiveEmployees = Get-PayrollEmployees -ActivesOnly
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

            # Add AD user to standard security groups

        }
    }
    
    end {
        
    }
}