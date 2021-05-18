<#
.SYNOPSIS
    Converts the string input (see below) to string output (see below)
.DESCRIPTION
    Name must be in the .OUTPUTS form in order to do a lookup in AD.
    This script does that conversion
.EXAMPLE
    PS C:\> Get-LastnameFirstName 'Mickey Mouse'
    
    Converts 'Mickey Mouse' to 'Mouse, Mickey'
.INPUTS
    String: FirstName<space>LastName
.OUTPUTS
    String: LastName<comma><space>FirstName
    $null if string cannot be properly formatted
.NOTES
    General notes
#>
function Get-LastNameFirstName {
    param (
        [Parameter()]
        [string]
        $name
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
    elseif ($fullName.length -gt 3) {
        # name more than 3
        $name = $null
    }

    return $name
}

# need this line to debug this function stand-alone
#Get-LastNameFirstName $name