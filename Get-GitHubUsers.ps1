# $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
# $time = Get-Date
# Write-Output $time

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

$organization = 'TBCTSystems'
$userList = New-Object -TypeName "System.Collections.ArrayList"

$organizationMembers = Get-GitHubOrganizationMember -Organization $organization

# disable github telemetry for "faster" processing
Set-GitHubConfiguration -DisableTelemetry

#Import-Module ./Get-LastNameFirstName.ps1
. ./Get-LastNameFirstName.ps1
. ./Get-UserEmailFromAD.ps1
. ./Get-UserEmailFromADWithGitHubLogin.ps1

foreach($member in $organizationMembers)
{
    $userInfo = $null
    $userInfo = Get-GitHubUser -Username $member.UserName

    $email = $null
    if ($userInfo.email) {
        $email = $userInfo.email
    }

    $name = $null
    $name = Get-LastNameFirstName($userInfo.name)
    
    if ($null -eq $email) {
        $email = Get-UserEmailFromAD($name)
    }

    if ($null -eq $email) {
        $email = Get-UserEmailFromADWithGitHubLogin($userInfo.login)
    }

    $adObj = $null
    $bctLogin = $null
    $disabled = $null
    if ($email) {
        $adObj = Get-ADuser -Filter "UserPrincipalName -eq '$email'"
        if ($adObj.Enabled -eq $false) {
            $disabled = 'X'
        }
        $bctLogin = $adObj.SamAccountName
    }

    $userObj = [PSCustomObject]@{
        fullName = $null
        email = $null
        bctLogin = $null
        gitHubLogin = $null
        disabled = $null
    }

    $userObj.gitHubLogin = $userInfo.login
    $userObj.fullName = $name
    $userObj.email = $email
    $userObj.bctLogin = $bctLogin
    $userObj.disabled = $disabled
    [void]$userList.Add($userObj)
}

# export to CSV
#$userList | Select-Object | export-csv -NoTypeInformation -path ./GitHubUsers.csv

#Write-Output($stopwatch.elapsed.totalminutes)

return $userList