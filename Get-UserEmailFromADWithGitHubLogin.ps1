function Get-UserEmailFromADWithGitHubLogin {
    [CmdletBinding()]
    param (
        [String]
        $gitHubLoginName
    )

    $email = $null

    # try the GitHub login name just in case it's the same
    # as the BCT login.
    # Note: $userInfo.login can never be $null so no need to check it
    $adObject = Get-ADUser -Filter "SAMAccountName -eq '$gitHubLoginName'"
    if ($adObject)
    {
        $email = $adObject.UserPrincipalName
    }

    return $email
}