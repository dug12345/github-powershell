<#
.SYNOPSIS
    sets the GitHub PAT as required by GitHubForPowerShell module
.DESCRIPTION
    The PAT ($secureString) is set in Developer -> Settings -> Personal Access Token
    for this repo
.EXAMPLE
    Invoked as a function
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    General notes
#>
function Set-GitHubPAT {
    # get PAT from environment variable
    # 'GithubPAT' env variable must be set for user not system otherwise
    # runEmailTask.ps1 will fail
    $secureString = ($env:GithubPAT | ConvertTo-SecureString -AsPlainText -Force)
    $cred = New-Object System.Management.Automation.PSCredential "username is ignored", $secureString
    Set-GitHubAuthentication -Credential $cred
    $secureString = $null # clear this out now that it's no longer needed
    $cred = $null # clear this out now that it's no longer needed 
}