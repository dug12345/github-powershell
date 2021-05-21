
<#
.SYNOPSIS
    Pester test
.DESCRIPTION
    Tests scenarios with gitHubLogin name
.EXAMPLE
    PS C:\> Invoke-Pester .\Get-UserEmailFromAD.Tests.ps1
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
Describe 'Get user email from AD entry using gitHubLogin' {
    BeforeAll {
        . "$PSScriptRoot/../helpers/Get-UserEmailFromAD.ps1"
    }
    Context 'name is $null' {
        BeforeEach {
            $email = Get-UserEmailFromAD $null
        }
        It 'email should be $null' {
            $email | Should -BeNullOrEmpty
        }
    }

    Context 'name does not exist in AD' {
        BeforeEach {
            $email = Get-UserEmailFromAD 'Mouse, Mickey'
        }
        It 'email should be $null' {
            $email | Should -BeNullOrEmpty
        }
    }

    Context 'name is valid format: LastName, FirstName' {
        BeforeEach {
            $email = Get-UserEmailFromAD 'Guerrero, Dan'
        }
        It 'email should be valid' {
            $email | Should -Be 'dan.guerrero@terumobct.com'
        }
    }

    Context 'name is invalid' {
        BeforeEach {
            $email = Get-UserEmailFromAD 'Liberace'
        }
        It 'email should $null' {
            $email | Should -BeNullOrEmpty
        }
    }
}