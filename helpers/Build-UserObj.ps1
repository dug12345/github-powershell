<#
.SYNOPSIS
    Helper function to populate the UserObj with entries from AD ($adObj)
.DESCRIPTION
    Long description
.EXAMPLE
    Invoked as a function
.INPUTS
    $adObj: AD info object
.OUTPUTS
    $userObj = [PSCustomObject]@{
        fullName 
        email
        bctLogin
        gitHubLogin
        disabled
.NOTES
    General notes
#>
function Build-UserObj {
    [CmdletBinding()]
    param (
        [Parameter()]
        [PSCustomObject]
        $adObj
    )

    $userObj.email = $adObj.UserPrincipalName
    $userObj.fullName = $adObj.Name
    if ($adObj.Enabled -eq $false) {
        $userObj.disabled = 'X'
    }
    $userObj.bctLogin = $adObj.SamAccountName
    $userObj.gitHubLogin = $userInfo.login

    return $userObj
}