<#
.SYNOPSIS
    Pester test for Get-ADObjWithGitHubLogin function
.DESCRIPTION
    Pester test for Get-ADObjWithGitHubLogin function
.EXAMPLE
    PS C:\> invoke-pester Get-ADObjWithGitHubLogin.Tests.ps1
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
Describe "Test Get-ADObjWithGitHubLogin" {
    BeforeAll {
        . $PSScriptRoot/../helpers/Get-ADObjWithGitHubLogin.ps1
    }

    Context "devopsrvc GitHubLogin" {
        BeforeEach {
            $adObj = Get-ADObjWithGitHubLogin "devopsrvc"
        }

        It "AD object entries should be correct" {
            $adObj.Enabled | Should -Be $true
            $adObj.GivenName | Should -Be "devopsrvc"
            $adObj.Name | Should -Be "devopsrvc"
            $adObj.SAMAccountName | Should -Be "devopsrvc"
            $adObj.UserPrincipalName | Should -Be "devopsrvc@terumobct.com"
        }
    }
}