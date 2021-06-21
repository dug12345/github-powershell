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
    # dug12345
    $secureString = ("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" | ConvertTo-SecureString -AsPlainText -Force)

    # devopsrvc
    #$secureString = ("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" | ConvertTo-SecureString -AsPlainText -Force)
    $cred = New-Object System.Management.Automation.PSCredential "username is ignored", $secureString
    Set-GitHubAuthentication -Credential $cred
    $secureString = $null # clear this out now that it's no longer needed
    $cred = $null # clear this out now that it's no longer needed 
}