<#
.SYNOPSIS
    Wrapper to generate a list of GitHub users to remove from TBCTSystems organization
.DESCRIPTION
    Lists those uses whose AD entries have been disabled
.EXAMPLE
    PS C:\> .\Show-GitHubUsersToRemove.ps1
    
    Dipslays list of users that can be removed from the TBCTSystems organization
.INPUTS
    none
.OUTPUTS
    Displays user info on console
.NOTES
    General notes
#>
$usersToRemove = .\helpers\Get-GitHubUsers.ps1  | select-object | Where-Object {$_.disabled -eq 'X'}

if ($usersToRemove)
{
    # found users to remove - display them
    $usersToRemove | Format-Table -AutoSize -Property fullName, email, bctLogin, gitHubLogin
}
else {
    Write-Output "No users to remove."
}