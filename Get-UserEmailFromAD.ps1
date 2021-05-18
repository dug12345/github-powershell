<#
.SYNOPSIS
    Retrieves the user's UserPrincipalName entry from AD using the user name as lookup
.DESCRIPTION
    The user name must be in the form FirstName<space>LastName
.EXAMPLE
    PS C:\> .\Get-UserEmailFromAD 'Mickey Mouse'
.INPUTS
    String: FirstName<space>LastName
.OUTPUTS
    Mickey's email: firstname.lastname@terumobct.com
.NOTES
    UserPrincipalName is in the format of firstname.lastname@terumobct.com
#>
function Get-UserEmailFromAD($name) {
    
    $email = $null

    if ($name)
    {
        $adObject = Get-ADUser -Filter "Name -eq '$name'"
        if ($adObject)
        {
            $email = $adObject.UserPrincipalName
        }
    }

    return $email
}

#Get-UserEmailFromAD $name