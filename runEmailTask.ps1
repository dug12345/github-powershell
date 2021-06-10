<#
.SYNOPSIS
    "Main" entry point
    1. generate a collection of PSCustomObject users in TBCTSystems
    2. filters the collection to those users' AD entry that has been disabled
    3. builds an email message containing list of those users to be removed
    4. sends the list via email
.DESCRIPTION
    
.EXAMPLE
    PowerShell session: ./runEmailTask.ps1
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    General notes
#>

# source files to access the functions
. $PSScriptRoot\helpers\Build-EmailMsg.ps1
. $PSScriptRoot\helpers\Send-Email.ps1

# Get-GitHubUsers is a PS script:
# 1. pipeline support
# 2. no need to source it
$usersToRemove = .\helpers\Get-GitHubUsers.ps1  | select-object | Where-Object {$_.disabled -eq 'X'}
$emailMsg = Build-EmailMsg $usersToRemove
Send-Email $emailMsg

