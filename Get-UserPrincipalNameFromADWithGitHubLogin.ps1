<#
.SYNOPSIS
    Short description
.DESCRIPTION
    This script was written to get the UserPrincipalName (which is in the
    format of an email) from AD using the GitHub login in the hope that latter
    is the same as the user's BCT login.

    If so, then the AD lookup will be valid.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    GitHub login name that is hopefully the same as the BCT login
.OUTPUTS
    UserPrincipalName entry from AD
    $null: if $login cannot be found
.NOTES
    General notes
#>
function Get-UserPrincipalNameFromADWithGitHubLogin($login) {
    
    $email = $null

    # try the GitHub login name just in case it's the same
    # as the BCT login.
    # Note: $userInfo.login can never be $null so no need to check it
    $adObject = Get-ADUser -Filter "SAMAccountName -eq '$login'"
    if ($adObject)
    {
        $email = $adObject.UserPrincipalName
    }

    return $email
}

#Get-UserPrincipalNameFromADWithGitHubLogin $gitHubLoginName