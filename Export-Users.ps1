<#
.SYNOPSIS
    Generates a list of all github users and exports the list to GitHubUsers.csv
.DESCRIPTION
    This is a wrapper to Get-GitHubUsers.ps1.

    The generated CSV file can be imported into an Excel spreadsheet and filtered accordingly
.EXAMPLE
    PS C:\> ./Export-Users.ps1
.INPUTS
    none
.OUTPUTS
    GitHubUser.csv
    
    CSV file with the following columns:
    FullName    Email   bctLogin    gitHubLogin disabled

    where
        FullName: LastName, FirstName (if known)
        bctLogin/gitHubLogin: login name of respective domain
        disabled: 'X' indicates that the user's AD account has been disabled
.NOTES
    General notes
#>
./helpers/Get-GitHubUsers.ps1 | Select-Object | Export-CSV -NoTypeInformation -Path ./GitHubUsers.csv