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

#requires -RunAsAdministrator

. "$PSScriptRoot\Install-WindowsPrerequisites.ps1"
. "$PSScriptRoot\Set-GitHubPAT.ps1"
. "$PSScriptRoot\Get-UserInfoObj.ps1"

# PowerShellForGitHub must be installed. Check for it and install if needed
Install-WindowPrerequisites

Set-GitHubPAT

# yes...it's hardcoded but TBCTDevelopment doesn't
# have many users.
$organization = 'TBCTSystems'
$userList = New-Object -TypeName "System.Collections.ArrayList"

# disable github telemetry for "faster" processing
Set-GitHubConfiguration -DisableTelemetry

# get all members in the TBCTSystems organization
$organizationMembers = Get-GitHubOrganizationMember -Organization $organization

$memberNum = 0
foreach($member in $organizationMembers)
{
    # display progress bar
    $memberNum += 1
    Write-Progress -Activity "Getting list of GitHub TBCTSystems users" -Status "Progress:" -PercentComplete ($memberNum/$organizationMembers.Count * 100)
   
    $userInfo = $null

    # get GitHub info for each user
    $userInfo = Get-GitHubUser -Username $member.UserName

    # build the UserInfo object for each user
    $userObj = Get-UserInfoObj $userInfo
    
    [void]$userList.Add($userObj)
}

# export to CSV
#$userList | Select-Object | export-csv -NoTypeInformation -path ./GitHubUsers.csv

# return list of UserInfo objects for further processing
return $userList