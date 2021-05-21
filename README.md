# github-powershell

Configuration
To avoid severe API rate limiting by GitHub, you should configure the module with your own personal access token.

Create a new API token by going to https://github.com/settings/tokens/new (provide a description and check any appropriate scopes)
Call Set-GitHubAuthentication, enter anything as the username (the username is ignored but required by the dialog that pops up), and paste in the API token as the password. That will be securely cached to disk and will persist across all future PowerShell sessions. If you ever wish to clear it in the future, just call Clear-GitHubAuthentication).
For automated scenarios (like GithHub Actions) where you are dynamically getting the access token needed for authentication, refer to Example 2 in Get-Help Set-GitHubAuthentication -Examples for how to configure in a promptless fashion.

Alternatively, you could configure PowerShell itself to always pass in a plain-text access token to any command (by setting $PSDefaultParameterValues["*-GitHub*:AccessToken"] = "<access token>"), although keep in mind that this is insecure (any other process could access this plain-text value).
  
Install PowerShell 7
