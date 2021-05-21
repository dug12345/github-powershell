<#
.SYNOPSIS
    Installs Windows features and PowerShellForGitHub module
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Install-WindowPrerequisites()
{
    # Windows Feature Remote Server Administration Tool for Active Directory Module for PowerShell
    # must be enabled
    $rsat = Get-WindowsFeature -Name 'RSAT-AD-Powershell' | Select-Object -Property InstallState
    if ($rsat.InstallState -eq 'Available')
    {
        Install-WindowsFeature RSAT-AD-Powershell
        Install-WindowsFeature RSAT-Role-Tools
        Install-WindowsFeature RSAT-AD-Tools
    }
}