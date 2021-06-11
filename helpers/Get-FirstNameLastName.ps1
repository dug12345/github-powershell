<#
.SYNOPSIS
    Given a name string, extract the first and last name
.DESCRIPTION
    Long description
.EXAMPLE
    Invoked as a function
.INPUTS
    $name: string "FirstName LastName"
.OUTPUTS
    array object with firstName in the 0 index
    lastName in the 1 index
.NOTES
    General notes
#>
function Get-FirstNameLastName {
    
    param (
        [string]
        $name
    )

    # can't process empty name
    if ("" -eq $name) {
        return $null
    }

    $firstNameLastName = @()

    $fullName = $name.Split(' ')
    if ($fullName.Length -eq 2)
    {
        $firstNameLastName += $fullName[0]
        $firstNameLastName += $fullName[1]
    }

    # return array with firstName in the 0 index
    # and lastName in the 1 index
    return $firstNameLastName
}