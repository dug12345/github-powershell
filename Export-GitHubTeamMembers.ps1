<#
.SYNOPSIS
    Wrapper script for Get-TeamMembers.ps1
.DESCRIPTION
    Generates a csv file of github users by team
.EXAMPLE
    PS C:\> $PSScriptRoot/Export-GitHubTeamMembers.ps1
.INPUTS
    Inputs (if any)
.OUTPUTS
    GitHubTeamMembers.csv
.NOTES
    General notes
#>
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$time = Get-Date
Write-Output $time

.\helpers\Get-TeamMembers.ps1 | Select-Object | Export-Csv -NoTypeInformation -Path ./GitHubTeamMembers.csv

Write-Output(($stopwatch.elapsed.totalminutes).ToString() + ' minutes')