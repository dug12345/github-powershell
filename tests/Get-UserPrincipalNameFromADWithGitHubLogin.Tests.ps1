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
Describe 'Get user email using BCT Login...just in case the login is the same as the BCT login name' {
    BeforeAll {
        . "$PSScriptRoot/../helpers/Get-UserPrincipalNameFromADWithGitHubLogin.ps1"
    }
    Context 'when login doesn''t exist in AD' {
        BeforeEach {
            $loginName = 'mickeymouse'
            $loginName = Get-UserPrincipalNameFromADWithGitHubLogin $loginName
        }
        It 'Get-ADUser object should be $null' {
           $loginName | Should -BeNullOrEmpty
        } 
    }

    Context 'when login name exists in AD' {
        BeforeEach {
            $loginName = 'devopsrvc'
            $email = Get-UserPrincipalNameFromADWithGitHubLogin $loginName
        }
        It 'Get-ADUser object should be devopsrvc@terumobct.com' {
           $email | Should -Be 'devopsrvc@terumobct.com'
        } 
    }
}