# github-powershell

Reference: https://github.com/microsoft/PowerShellForGitHub

Required OS: Windows Server (tested on Windows Server 2019)

===== Install steps =====

1. Powershell must be installed on system 

2. Clone this repo to local folder

3.  cd to the local folder

4.  To generate a list of GitHub users to be removed from the TBCTSystems organization and
    send the list in an email:

     Note: The command examples can be run one of two ways:
         1. in a DOS cmd window as Administrator
         2. in a PowerShell session

      1: powershell.exe -executionpolicy bypass ./runEmailTask.ps1
      2. ./runEmailTask.ps1

5. Displays on the console a list of GitHub users in TBCTSystems organization whose AD entry has been disabled

      1: powershell.exe -executionpolicy bypass ./Show-GitHubUsersToRemove.ps1
      2: ./Show-GitHubUsersToRemove.ps1
  
6. To generate a CSV list of all GitHub members
      
     1: powershell.exe -executionpolicy bypass ./Export-Users.ps1
     2: ./Export-Users.ps1
     
     The generated list will be in GitHubUsers.csv
     
7. To generate a CSV list of all GitHub members sorted by team
     
     1: powershell.exe -executionpolicy bypass ./Export-TeamMembers.ps1
     2: ./Export-TeamMembers.ps1
     
     The generated list will be in GitHubTeamMembers.csv

===== Unit Tests using Pester =====

Unit test modules are in tests folder.

Pester tests must be invoked from within a PowerShell session.

To run a pester test:

    cd to tests/ folder

    Pester tests can be identified with "Tests" as part of the filename

    Invoke-Pester ./<filename>.Tests.ps1
    
To run all pester tests:

    cd to tests/ folder
    
    Invoke-Pester *
