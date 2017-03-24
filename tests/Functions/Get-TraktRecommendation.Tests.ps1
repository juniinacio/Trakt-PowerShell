$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktRecommendation" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get movie recommendations" {
            $recommendations = Get-TraktRecommendation -Movies

            ($recommendations | Measure-Object).Count | Should Not Be 0
        }

        It "Get show recommendations" {
            $recommendations = Get-TraktRecommendation -Shows

            ($recommendations | Measure-Object).Count | Should Not Be 0
        }

        AfterAll {
        }
    }
}