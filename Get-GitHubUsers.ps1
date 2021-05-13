$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$time = Get-Date
Write-Output $time

$organization = 'TBCTSystems'
$userList = New-Object -TypeName "System.Collections.ArrayList"

$organizationMembers = Get-GitHubOrganizationMember -Organization $organization

foreach($member in $organizationMembers)
{
    $fullName = $null
    $email = $null
    $userInfo = $null
    $name = $null

    $userInfo = Get-GitHubUser -Username $member.UserName

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
    if ($null -eq $userInfo.email)
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

    $userObj = [PSCustomObject]@{
        fullName = $null
        email = $null
        gitHubLogin = $null
    }

    $userObj.gitHubLogin = $userInfo.login
    $userObj.fullName = $name
    $userObj.email = $email
    [void]$userList.Add($userObj)
}

$userList | Select-Object | export-csv -NoTypeInformation -path ./GitHubUsers.csv
Write-Output($stopwatch.elapsed.totalminutes)