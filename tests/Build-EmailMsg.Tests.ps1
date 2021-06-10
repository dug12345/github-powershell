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
Describe "Build email msg from PSObject" {
    BeforeAll {
        . "$PSScriptRoot/../helpers/Build-EmailMsg.ps1"
    }

    Context 'no user to remove' {
        BeforeEach {
            $usersToRemove = $null
            $msg = Build-EmailMsg $usersToRemove
        }

        It 'No users to remove' {
            $msg | Should -Be 'No users to remove'
        }
    }
    Context "one user to remove" {
        BeforeEach {
            $usersToRemove = [PSCustomObject]@{
                fullName = 'Burkhart, Ashley112951'
                email = 'ashley.burkhart@terumobct.com'
                bctLogin = 'aburusb'
                gitHubLogin = 'aburusb'
                disabled = 'X'
            }

            $msg = Build-EmailMsg $usersToRemove
        }

        It "one user to be removed" {
            $msg | Should -Match 'aburusb'
            $msg | Should -Match "Burkhart, Ashley112951"
        }
    }
    Context "two users to remove" {
        BeforeEach {
            $user1 = [PSCustomObject]@{
                fullName = 'Mickey Mouse'
                email = 'mickey.mouse@disney.com'
                bctLogin = 'mickeymouse'
                gitHubLogin = 'mickeymouse'
                disabled = 'X'
            }

            $user2 = [PSCustomObject]@{
                fullName = 'Goofy'
                email = 'goofy@disney.com'
                bctLogin = 'goofy'
                gitHubLogin = 'goofy'
                disabled = 'X'
            }

            $userList = New-Object -TypeName "System.Collections.ArrayList"
            $userList.Add($user1)
            $userList.Add($user2)

            $msg = Build-EmailMsg $userList
        }

        It '2 users to be removed' {
            $msg | Should -Match 'Mickey Mouse'
            $msg | Should -Match 'Goofy'
        }
    }
}