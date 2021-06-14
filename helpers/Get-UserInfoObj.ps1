<#
.SYNOPSIS
    Creates the user object that contains information on the user
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> ./Get-UserInfoObj.ps1
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
. "$PSScriptRoot\Build-UserObj"
. "$PSScriptRoot\Get-ADObjWithGitHubLogin"
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

        $adObj = Get-ADUser -Filter "UserPrincipalName -eq '$email'"
        if ($adObj) {

            # there is a 1to1 mapping between UPN & AD entry...that is
            # no 2 AD entries can have the same UPN unlike
            # using the GivenName & Surname (see below)
            $userObj = Build-UserObj $adObj

            # all done...no need to continue
            return $userObj              
        }
    }

    # ok...try to get the AD entry by using the name from GitHub profile

    # here when the email and username was unsuccessful in retrieving
    # the AD entry for this user

    # To get the AD entry for this user:
    # 1. try to build the email from the user name in GitHub profile and then access AD with that
    # 2. try to get the AD entry using the gitHubLogin...

    # Note:
    #   In AD the UserPrincipalName attribute is the same as the user's email.
    #
    # since email is still unknown, build the userprincipalname (which is the same as the email)
    # from the user's name in GithHub.  Use that to build the userprincipalname and then
    # query AD using it
    if ($userInfo.name) {
        $formalName = Get-FirstNameLastName $userInfo.name
        if ($formalName.Count -eq 2) {
            $Surname = $formalName[1]
            $Given = $formalName[0]
            $adObj = @()
            $adObj = Get-ADuser -Filter "(GivenName -eq '$Given') -and (Surname -eq '$Surname')"
            if ($adObj) {

                # GivenName & Surname can be associated with 2 AD entries: "normal" & privileged
                # check for that
                if ($adObj.Length -gt 1) {
                    $adObj = $adObj[0]
                }

                $userObj = Build-UserObj $adObj
                return $userObj
            }
        }
    }

    # still no AD info???
    # 2. try to get the AD entry using the gitHubLogin...

    # attempt to get email using the gitHubLogin name just in case
    # it's the same as the BCT LoginName
    # $upn = Get-UserPrincipalNameFromADWithGitHubLogin $userInfo.login
    # if ($upn) {

    #     $adObj = Get-ADUser -Filter "UserPrincipalName -eq '$upn'"
    #     if ($adObj) {

    #         $userObj = Build-UserObj $adObj

    #         return $userObj              
    #     }         
    # }

    $adObj = Get-ADObjWithGitHubLogin $userInfo.login
    if ($adObj) {
        $userObj = Build-UserObj $adObj
        return $userObj
    }

    # at this point, just return whatever information I have

    $name = $null

    # userInfo.name: FirstName<space>LastName
    # $name: LastName<comma><space>FirstName
    $name = Get-LastNameFirstName $userInfo.name
    
    # get user email from AD using properly formatted name
    if ($null -eq $email) {
         $email = Get-UserEmailFromAD $name
    }

    $userObj.gitHubLogin = $userInfo.login
    $userObj.fullName = $name
    $userObj.email = $email
    $userObj.bctLogin = $bctLogin
    $userObj.disabled = $disabled

    return $userObj
}

#Get-UserInfoObj $userInfo