<#
.SYNOPSIS
    Gets a list GitHub users for TBCTSystems organization
.DESCRIPTION
    This is the script that does the heavy lifting of
    0. installing required modules and features
    1. querying GitHub for users
    2. querying AD to determine whether the user's AD account is enabled
    3. creating the $userObj and returning it to the caller

    This script returns a PSCustomObject that can be used used in the
    typical PS pipeline
.EXAMPLE
    PS C:\> .\Get-GitHubUsers.ps1 | Select-Object | Export-CSV -NoTypeInformation -path ./users.csv
    
    Generate a csv file of users in TBCTSystems organization
.INPUTS
    none
.OUTPUTS
     $userObj = [PSCustomObject]@{
        fullName
        email
        bctLogin
        gitHubLogin
        disabled
    }
.NOTES
    Use the Get-ListGitHubUsersToRemove.ps1 wrapper
#>

# References:
# https://github.com/microsoft/PowerShellForGitHub
# https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2019-ps

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

# yes...it's hardcoded but TBCTDevelopment doesn't
# have many users.
$organization = 'TBCTSystems'
$userList = New-Object -TypeName "System.Collections.ArrayList"

$organizationMembers = Get-GitHubOrganizationMember -Organization $organization

# disable github telemetry for "faster" processing
Set-GitHubConfiguration -DisableTelemetry

# dot source script to use
. "$PSScriptRoot\Get-UserInfoObj.ps1"

$memberNum = 0
foreach($member in $organizationMembers)
{
    # display progress bar
    $memberNum += 1
    Write-Progress -Activity "Getting list of GitHub TBCTSystems users to remove" -Status "Progress:" -PercentComplete ($memberNum/$organizationMembers.Count * 100)
   
    $userInfo = $null
    $userInfo = Get-GitHubUser -Username $member.UserName

    $userObj = Get-UserInfoObj $userInfo
    
    [void]$userList.Add($userObj)
}

# export to CSV
#$userList | Select-Object | export-csv -NoTypeInformation -path ./GitHubUsers.csv


return $userList