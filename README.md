# github-powershell

Reference: https://github.com/microsoft/PowerShellForGitHub

Required OS: Windows Server (tested on Windows Server 2019)

===== Install steps =====

1. Install PowerShell 7 (or latest version) 
2. Get & install module

    Install-Module PowerShellForGitHub

3. Set GitHub authenticaion (required by PowerShellForGitHub module)

    Configuration
    To avoid severe API rate limiting by GitHub, you should configure the module with your own personal access token.

    Create a new API token by going to https://github.com/settings/tokens/new (provide a description and check any appropriate scopes)

    Call Set-GitHubAuthentication, enter anything as the username (the username is ignored but required by the dialog that pops up), and paste in the API token as the password.  
    That will be securely cached to disk and will persist across all future PowerShell sessions. If you ever wish to clear it in the future, just call Clear-GitHubAuthentication).

4. Clone this repo to local folder

5. To display GitHub users whose AD entry has been disabled allowing return of GitHub license

      ./Show-GitHubUsersToRemove.ps1
  
      Displays on the console a list of GitHub users in TBCTSystems organization whose AD entry has been disabled
      
6. To generate a CSV list of all GitHub members
      
     ./Export-AllGitHubHusers.ps1
     
     The generated list will be in GitHubUsers.csv
     
7. To generate a CSV list of all GitHub members sorted by team
     
     ./Export-GitHubTeamMembers.ps1
     
     The generated list will be in GitHubTeamMembers.csv

===== Unit Tests using Pester =====

Unit test modules are in tests folder.

To run a pester test:

    cd to tests/ folder

    Pester tests can be identified with "Tests" as part of the filename

    Invoke-Pester ./<filename>.Tests.ps1
    
To run all pester tests:

    cd to tests/ folder
    
    Invoke-Pester *
