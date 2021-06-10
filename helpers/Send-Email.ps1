
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

# source file
#. $PSScriptRoot\helpers\Build-EmailMsg.ps1

#$usersToRemove = .\helpers\Get-GitHubUsers.ps1  | select-object | Where-Object {$_.disabled -eq 'X'}
#$emailMsg = Build-EmailMsg $usersToRemove

function Send-Email {

    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $emailMsg
    )
    # cannot use clear-text password in PSCredential.
    $password = ConvertTo-SecureString '&!TH875#sc1B*3' -AsPlainText -Force

    # note: username is NOT github.notify but the fully qualified UserPrincipalName in AD
    $credential = New-Object System.Management.Automation.PSCredential ('github.notify@terumobct.com',$password)

    ## Define the Send-MailMessage parameters

    # note: Per company policy, Direct Send has been disabled so it cannot be used.
    # Must use SMTP authentication method.  SmptServer must be smtp.office365.com
    $mailParams = @{
        SmtpServer                 = 'smtp.office365.com'
        Port                       = '587' # or '25' if not using TLS
        UseSSL                     = $true ## or not if using non-TLS
        Credential                 = $credential
        From                       = 'github.notify@terumobct.com'
        To                         = 'dan.guerrero@terumobct.com'
        Subject                    = "GitHub Inventory - $(Get-Date -Format g)"
        Body                        = $emailMsg
        DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
    }

    ## Send the message
    Send-MailMessage @mailParams -WarningAction "Ignore"
}