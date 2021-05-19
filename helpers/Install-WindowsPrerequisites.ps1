<#
.SYNOPSIS
    Short description
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
    # PowerShellForGitHub must be installed. Check for it and install if needed
    $psForGitHub = Get-Module -Name PowerShellForGitHub
    if ($null -eq $psForGitHub)
    {
        # install it
        Install-Module -Name PowerShellForGitHub
    }

    # Windows Feature Remote Server Administration Tool for Active Directory Module for PowerShell
    # must be enabled
    $rsat = Get-WindowsFeature -Name 'RSAT-AD-Powershell'
    if ($null -eq $rsat)
    {
        Install-WindowsFeature RSAT-AD-Powershell
        Install-WindowsFeature RSAT-Role-Tools
        Install-WindowsFeature RSAT-AD-Tools
    }
}