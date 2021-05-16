function Get-UserEmailFromAD {
    [CmdletBinding()]
    param (
        [String]
        $name
    )

    $email = $null

    if ($name)
    {
        $adObject = Get-ADUser -Filter "Name -eq '$name'"
        if ($adObject)
        {
            $email = $adObject.UserPrincipalName
            #$name = $adObject.Name
        }
    }

    return $email
}