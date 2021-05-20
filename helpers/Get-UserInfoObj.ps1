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
. "$PSScriptRoot\Get-FirstNameLastName.ps1"
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
    # commented 3:53PM
    if ($userInfo.email) {
        $email = $userInfo.email
    }

    $name = $null
    # userInfo.name: FirstName<space>LastName
    # $name: LastName<comma><space>FirstName
    $name = Get-LastNameFirstName $userInfo.name
    
    # get user email from AD using properly formatted name
    if ($null -eq $email) {
         $email = Get-UserEmailFromAD $name
    }

    # Note:
    #   In AD the UserPrincipalName attribute is the same as the user's email.
    #
    # since email is still unknown, build the userprincipalname (which is the same as the email)
    # from the user's name in GithHub.  Use that to build the userprincipalname and then
    # query AD using it
    if ($null -eq $email) {
        $formalName = Get-FirstNameLastName $userInfo.name

        if ($formalName.Count -eq 2) {
            #build the email
            $principalName = $formalName[0] + '.' + $formalName[1] + '@terumobct.com'
            $adObj = $null
            $adObj = Get-ADuser -Filter "UserPrincipalName -eq '$principalName'"
            if ($adObj) {
                $email = $adObj.UserPrincipalName
                $name = $adObj.Name
                if ($adObj.Enabled -eq $false) {
                    $disabled = 'X'
                }
                $bctLogin = $adObj.SamAccountName
            }
        }
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