$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$time = Get-Date
Write-Output $time

Set-GitHubConfiguration -DisableTelemetry

$organization = 'TBCTSystems'
$teamList = New-Object -TypeName "System.Collections.ArrayList"

$teams = get-githubteam -organization $organization | select-object -ExpandProperty 'name'

foreach($team in $teams)
{
    $teammembers = Get-GitHubTeamMember -Organization $organization -TeamName $team | select-object login, UserName, UserID
    
    foreach($member in $teammembers)
    {
            $fullName = $null
            $email = $null
            $userInfo = $null
            $name = $null
            $adObject = $null
            $gitHubLoginName = $null
            

            $userInfo = Get-GitHubUser -UserName $member.UserName
         
            if ($userInfo.email) {
                $email = $userInfo.email
            }

            if ($userInfo.name)
            {
                $fullName = $userInfo.name.Split(" ")
            }

            if ($fullName.Length -eq 1)
            {
                $name = $userInfo.name
            }
            elseif ($fullName.length -eq 2)
            {
                $name = $fullName[1] + ', ' + $fullName[0]
            }
            elseif ($fullName.length -eq 3)
            {
                $name = $fullName[2] + ', ' + $fullName[0]
            }
            
            if (($null -eq $userInfo.email) -and ($name))
            {
                $adObject = Get-ADUser -Filter "Name -eq '$name'"
                if ($adObject)
                {
                    $email = $adObject.UserPrincipalName
                    $name = $adObject.Name
                }
            }

            # one last shot at the email & name
            #if ($null -eq $userInfo.email)
            if ($null -eq $email)
            {
                # try the GitHub login name just in case it's the same
                # as the BCT login.
                # Note: $userInfo.login can never be $null so no need to check it
                $gitHubLoginName = $userInfo.login
                $adObject = Get-ADUser -Filter "SAMAccountName -eq '$gitHubLoginName'"
                if ($adObject)
                {
                    $email = $adObject.UserPrincipalName
                    $name = $adObject.Name
                }
            }

            $teamMemberObject = [PSCustomObject]@{
                teamname = ''
                gitHubLoginName = ''
                fullname = ''
                email = ''
            }

            $teamMemberObject.teamname = $team
            $teamMemberObject.gitHubLoginName = $member.UserName
            $teamMemberObject.fullname = $name
            $teamMemberObject.email = $email
            [void]$teamList.Add($teamMemberObject)
    }
}

$teamList | Select-Object | export-csv -NoTypeInformation -path ./GitHubTeamMembers.csv
Write-Output($stopwatch.elapsed.totalminutes)