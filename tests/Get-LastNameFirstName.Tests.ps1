
<#
.SYNOPSIS
    Pester test
.DESCRIPTION
    Tests various use cases when name is null etc.
.EXAMPLE
    PS C:\> Invoke-Pester .\Get-LastNameFirstName.Tests.ps1
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
Describe 'Format user name to correct format' {

    BeforeAll {
        # source script
        . "$PSScriptRoot/../helpers/Get-LastNameFirstname.ps1"
    }
    Context 'name is $null' {
        BeforeEach{
            $name = Get-LastNameFirstName $null
        }
        It '$null name should be $null' {
            $name | Should -BeNullOrEmpty
        }  
    }

    Context 'FirstName LastName' {
      BeforeEach{
          $name = Get-LastNameFirstName 'Mickey Mouse'
      }
      It 'should be LastName<comma><space>FirstName' {
          $name | Should -Be 'Mouse, Mickey'
      }
    }

    Context 'FirstName MiddleName LastName' {
        BeforeEach {
            $name = Get-LastNameFirstName 'Wolfgang Amadeus Mozart'
        }

        It 'should be MiddleName<space>LastName<space><comma><space>FirstName' {
          $name | Should -Be 'Amadeus Mozart, Wolfgang'
        }
    }

    Context 'name has more than 3 names' {
        BeforeEach {
            $name = Get-LastNameFirstname 'Daniel Michael Blake Day-Lewis'
        }

        It '$name should be $null' {
            $name | Should -BeNullOrEmpty
        }
    }
}
        