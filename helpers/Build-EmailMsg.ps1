<#
.SYNOPSIS
    Builds the body of an email message using the list of GitHub users to be removed from the organization
.DESCRIPTION
    Long description
.EXAMPLE
    Invoked as a function
.INPUTS
    [PSCustomObject] : users to be removed

    [PSCustomObject]@{
                fullName = 'Mickey Mouse'
                email = 'mickey.mouse@disney.com'
                bctLogin = 'mickeymouse'
                gitHubLogin = 'mickeymouse'
                disabled = 'X'
.OUTPUTS
    msg string
    'The following user(s) can be removed from TBCTSystems\n<user1>\n' etc.
.NOTES
    General notes
#>
function Build-EmailMsg {
    [CmdletBinding()]
    param (
        [Parameter()]
        [PSCustomObject]
        $users
    )
        $usrList = $null
        $msg = "The following user(s) can be removed from TBCTSystems" + [System.Environment]::NewLine + "Name`t`t`t`tGitHub Login" + [System.Environment]::NewLine
        foreach($user in $users) {
            $usrList += ($user.fullName).ToString() + "`t`t" + ($user.gitHubLogin).ToString() + [System.Environment]::NewLine
        }

        if ($null -eq $usrList) {
            $msg = 'No users to remove'
        } else {
            $msg += $usrList
        }

        return $msg
}