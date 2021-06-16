<#
.SYNOPSIS
    Creates the user object that contains information on the user (see .OUTPUTS section below)
.DESCRIPTION
    Using info from GitHub profile, this script will attempt to retrieve the user's
    AD entry using the following criteria:
    1. email from GitHub profile
        - same as UserPrincipalName in AD
    2. name from GitHub profile
        - build the UserPrincipalName (in the form FirstName.LastName@terumobct.com)
          from the name information in GitHub profile for this user
    3. GitHub login
        - last attempt to get the AD entry by hoping that the user's GitHub login
          is the same as the user's SAMAccountName in AD
    4. If the AD entry for this user was not found, returns whatever info it has gathered
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

    # 1. did user enter email in GitHub profile?
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

    # 2. ok...try to get the AD entry by using the name from GitHub profile

    # Note:
    #   In AD the UserPrincipalName attribute is the same as the user's email.
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
    # 3. try to get the AD entry using the gitHubLogin...

    $adObj = Get-ADObjWithGitHubLogin $userInfo.login
    if ($adObj) {
        $userObj = Build-UserObj $adObj
        return $userObj
    }

    # 4. at this point, just return whatever information I have

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
    $userObj.bctLogin = $null
    $userObj.disabled = $null

    return $userObj
}

#Get-UserInfoObj $userInfo