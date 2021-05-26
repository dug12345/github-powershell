<#
.SYNOPSIS
    Pester test
.DESCRIPTION
    Tests generated UserInfoObj with known user 'devopsrvc'
.EXAMPLE
    PS C:\> Invoke-Pester .\Get-UserInfoObj.Tests.ps1
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    $userInfo.login cannot be $null.  It must be set to a value
#>
Describe 'userInfoObj tests' {
    BeforeAll {
        . "$PSScriptRoot/../helpers/Get-UserInfoObj.ps1"
    }
    Context 'userInfoObj.login does not exist in AD' {
        BeforeEach {
            $userInfo = [PSCustomObject]@{
                name = $null
                email = $null
                login = 'johndoe'
            }
            $userInfoObj = Get-UserInfoObj $userInfo
        }

        It 'userInfoObj should be $null' {
            $userInfoObj.name | Should -BeNullOrEmpty
            $userInfoObj.email | Should -BeNullOrEmpty
            $userInfoObj.login | Should -BeNullOrEmpty
        }
    }

    Context 'userInfoObj for devopsrvc should create $userInfoObj' {
        BeforeEach {
            $userInfo = [PSCustomObject]@{
                name = $null
                email = $null
                login = 'devopsrvc'
            }
            $userInfoObj = Get-UserInfoObj $userInfo
        }
        It 'userInfoObj should contain valid info for devopsrvc' {
            $userInfoObj.fullName | Should -Be 'devopsrvc'
            $userInfoObj.bctLogin | Should -Be 'devopsrvc'
            $userInfoObj.gitHubLogin | Should -Be 'devopsrvc'
            $userInfoObj.email | Should -Be 'devopsrvc@terumobct.com'
            $userInfoObj.disabled | Should -BeNullOrEmpty
        }      
    }

    Context 'userInfoObj for aburusb (disabled user in AD) should create $userInfoObj with disabled $true' {
        BeforeEach {
            $userInfo = [PSCustomObject]@{
                # FirstName<space>LastName
                name = 'Ashley112951 Burkhart'
                email = 'ashley.burkhart@terumobct.com'
                login = 'aburusb'
            }
            $userInfoObj = Get-UserInfoObj $userInfo
        }
        It 'userInfoObj should contain valid info for aburusb' {
            # LastName<comma><space>FirstName
            $userInfoObj.fullName | Should -Be 'Burkhart, Ashley112951'
            $userInfoObj.bctLogin | Should -Be 'aburusb'
            $userInfoObj.gitHubLogin | Should -Be 'aburusb'
            $userInfoObj.email | Should -Be 'ashley.burkhart@terumobct.com'
            $userInfoObj.disabled | Should -Be $true
        }      
    }
}