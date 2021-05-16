function Get-LastNameFirstName {
    [CmdletBinding()]
    param (
        [String] $Name
    )

    $fullName = $null

    if ($name)
    {
        $fullName = $name.Split(" ")
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
        $name = $fullName[1]+ ' ' + $fullName[2] + ', ' + $fullName[0]
    }

    return $name
}