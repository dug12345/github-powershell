# github-powershell

Reference: https://github.com/microsoft/PowerShellForGitHub

Set GitHub authenticaion (required by PowerShellForGitHub module)
  Configuration
  To avoid severe API rate limiting by GitHub, you should configure the module with your own personal access token.

  Create a new API token by going to https://github.com/settings/tokens/new (provide a description and check any appropriate scopes)
  Call Set-GitHubAuthentication, enter anything as the username (the username is ignored but required by the dialog that pops up), and paste in the API token as the password. That 
  will be securely cached to disk and will persist across all future PowerShell sessions. If you ever wish to clear it in the future, just call Clear-GitHubAuthentication).


  Alternatively, you could configure PowerShell itself to always pass in a plain-text access token to any command (by setting $PSDefaultParameterValues["*-GitHub*:AccessToken"] = 
  "<access token>"), although keep in mind that this is insecure (any other process could access this plain-text value).

Required OS: Windows Server (tested on Windows Server 2019)

Install PowerShell 7

Clone repo

./Get-ListGitHubUsersToRemove.ps1

  This will install the GitHubPowerShell module and enable the RSAT-AD-Tools windows feature (if needed)
