<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
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

