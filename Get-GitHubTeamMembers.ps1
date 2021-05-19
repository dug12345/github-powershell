$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$time = Get-Date
Write-Output $time

.\helpers\Get-TeamMembers.ps1 | Select-Object | Export-Csv -NoTypeInformation -Path ./test.csv

Write-Output($stopwatch.elapsed.totalminutes)