<#
.SYNOPSIS
    Creates the user object that contains information on the user
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    object from Get-GitHubOrganizationMember (Get-GitHubUsers)
.OUTPUTS
    $userObj = [PSCustomObject]@{
        fullName
        email
        bctLogin
        gitHubLogin
        disabled
    }
.NOTES
    General notes
#>

# dot source scripts to use
. "$PSScriptRoot\Get-LastNameFirstName.ps1"
. "$PSScriptRoot\Get-UserEmailFromAD.ps1"
. "$PSScriptRoot\Get-UserPrincipalNameFromADWithGitHubLogin.ps1"
function Get-UserInfoObj()
{
    param (
        [Parameter()]
        [PSCustomObject]
        $userInfo
    )

    $userObj = [PSCustomObject]@{
        fullName = $null
        email = $null
        bctLogin = $null
        gitHubLogin = $null
        disabled = $null
    }

    # did user enter email in GitHub profile?
    $email = $null
    if ($userInfo.email) {
        $email = $userInfo.email
    }

    $name = $null
    $name = Get-LastNameFirstName $userInfo.name 
    
    # get user email from AD using properly formatted name
    if ($null -eq $email) {
        $email = Get-UserEmailFromAD $name
    }

    # email still unknown???
    if ($null -eq $email) {
        # attempt to get email using the gitHubLogin name just in case
        # it's the same as the BCT LoginName
        $email = Get-UserPrincipalNameFromADWithGitHubLogin $userInfo.login
    }

    $adObj = $null
    $bctLogin = $null
    $disabled = $null

    # use email to get AD entry
    if ($email) {
        $adObj = Get-ADuser -Filter "UserPrincipalName -eq '$email'"
        if ($adObj.Enabled -eq $false) {
            $disabled = 'X'
        }
        $bctLogin = $adObj.SamAccountName
    }

    $userObj.gitHubLogin = $userInfo.login
    $userObj.fullName = $name
    $userObj.email = $email
    $userObj.bctLogin = $bctLogin
    $userObj.disabled = $disabled

    return $userObj
}

#Get-UserInfoObj $userInfo