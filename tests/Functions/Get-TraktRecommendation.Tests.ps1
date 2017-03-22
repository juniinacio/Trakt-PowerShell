Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktRecommendation" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get movie recommendations" {
            $recommendations = Get-TraktRecommendation -Movies

            ($recommendations | Measure-Object).Count | Should Not Be 0
            $recommendations | Where-Object { $_.Title -eq 'I Am Legend' } | Should Not BeNullOrEmpty
        }

        It "Get show recommendations" {
            $recommendations = Get-TraktRecommendation -Shows

            ($recommendations | Measure-Object).Count | Should Not Be 0
            $recommendations | Where-Object { $_.Title -eq 'Lucifer' } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}