<#
.SYNOPSIS
    Retrieves a user's AD entry using the GitHub login name
.DESCRIPTION
    Assumes GitHub login name is the same as the BCT Login name
.EXAMPLE
   Invoked as a function
.INPUTS
    string: gitHub login name
.OUTPUTS
    AD entry (if any)
    $null: if not found
.NOTES
    Tries to retrieve the user's AD entry using the GitHub login
    just in case the GitHub login is the same the user's BCT login
#>
function Get-ADObjWithGitHubLogin
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $gitHubLogin
    )

    $ADObj = $null

    $ADObj = Get-ADUser -filter "SAMAccountName -eq '$gitHubLogin'"
    if ($ADObj)
    {
        return $ADObj
    }

    return $null
}