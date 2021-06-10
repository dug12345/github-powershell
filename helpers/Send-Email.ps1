
<#
.SYNOPSIS
    Sends the email with list of users to be removed from GitHub
.DESCRIPTION
    Accepts a collection of PSCustomObject that encapsulates the info for each
    user to be removed
.EXAMPLE
    invoked as a function
.INPUTS
    String: email msg containing list of users to be removed
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

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