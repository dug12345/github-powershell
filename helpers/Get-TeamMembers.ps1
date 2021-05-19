
<#
.SYNOPSIS
    Generates a list of github users by team
.DESCRIPTION
    
.EXAMPLE
    PS C:\> $PSScriptRoot/Get-TeamMembers.ps1
    
    Use the wrapper script Get-GitHubTeamMembers.ps1 instead of invoking this script directly
.INPUTS
    Inputs (if any)
.OUTPUTS
    $teamMemberObject = [PSCustomObject]@{
            teamname
            gitHubLoginName
            fullname
            email
.NOTES
    General notes
#>

Set-GitHubConfiguration -DisableTelemetry

. "$PSScriptRoot\Install-WindowsPrerequisites.ps1"
# PowerShellForGitHub must be installed. Check for it and install if needed
Install-WindowPrerequisites

# dot source script to use
. "$PSScriptRoot\Get-UserInfoObj.ps1"

$organization = 'TBCTSystems'
$teamList = New-Object -TypeName "System.Collections.ArrayList"

$teams = get-githubteam -organization $organization | select-object -ExpandProperty 'name'

$teamNum = 0

# the HashMap that will store the user info based on the username key
$memberHashMap = @{}

foreach($team in $teams)
{
    $teamCount = $teams.Count
    $teamNum += 1
    $memberNum = 0
    $teammembers = Get-GitHubTeamMember -Organization $organization -TeamName $team | select-object login, UserName, UserID
    
    foreach($member in $teammembers)
    {
        $memberNum += 1

        # display progress bar
        Write-Progress -Activity "Getting list of GitHub team members" -Status "Progress: [$teamNum/$teamCount $team]" -PercentComplete ($memberNum/$teammembers.Count * 100)

        $userInfo = $null

        # has this member info been retrieved before
        if ($memberHashMap[$member.UserName])
        {
            $userInfo = $memberHashMap[$member.UserName]
        }
        else {
            $userInfo = Get-GitHubUser -UserName $member.UserName

            # add it to the hash map
            $memberHashMap.Add($member.UserName, $userInfo)
        }

        $userObj = Get-UserInfoObj $userInfo

        $teamMemberObject = [PSCustomObject]@{
            teamname = ''
            gitHubLoginName = ''
            fullname = ''
            email = ''
        }

        $teamMemberObject.teamname = $team
        $teamMemberObject.gitHubLoginName = $member.UserName
        $teamMemberObject.fullname = $userObj.fullName
        $teamMemberObject.email = $userObj.email
        [void]$teamList.Add($teamMemberObject)
    }
}

return $teamList

# $teamList | Select-Object | export-csv -NoTypeInformation -path ./GitHubTeamMembers.csv
# Write-Output($stopwatch.elapsed.totalminutes)