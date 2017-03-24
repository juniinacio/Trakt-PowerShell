Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktCollection" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get movies collection" {
            $collection = Get-TraktCollection -Type movies
            
            ($collection | Measure-Object).Count | Should BeGreaterThan 0
            $collection.Title | Should Be "The Matrix"
        }

        It "Get shows collection" {
            $collection = Get-TraktCollection -Type shows

            ($collection | Measure-Object).Count | Should BeGreaterThan 0
            $collection.Title | Should Be "The Flash"
        }

        AfterAll {
            Get-TraktCollection -Type movies | Remove-TraktCollection
            Get-TraktCollection -Type shows | Remove-TraktCollection
        }
    }
}