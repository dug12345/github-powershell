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
Describe 'FirstName LastName' {

    BeforeAll {
        . "$PSScriptRoot/../helpers/Get-FirstNameLastName.ps1"
        $nameArr = $null
    }

    Context 'name is $null' {
        BeforeEach {
            $nameArr = Get-FirstNameLastName $null
        }

        It '$firstNameLastName should be $null' {
            $nameArr | Should -BeNullOrEmpty
        }
    }

    Context 'name is properly formatted to FirstName<space>LastName (i.e. Mickey Mouse)' {
        BeforeEach {
            $nameArr = Get-FirstNameLastName 'Mickey Mouse'
        }

        It 'first name should be Mickey' {
            $nameArr[0] | Should -Be 'Mickey'
        }

        It 'last name should be Mouse' {
            $nameArr[1] | Should -Be 'Mouse'
        }
    }

    Context 'name is more than 2 (i.e. John Paul Jones)' {
        BeforeEach {
            $nameArr = Get-FirstNameLastName 'John Paul Jones'
        }

        It 'name array should be empty' {
            $nameArr.Count | Should -Be 0
        }
    }
}