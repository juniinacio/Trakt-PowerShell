$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Hide-TraktRecommendation" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Hide a movie recommendation" {
        }

        It "Hide a show recommendation" {
        }

        AfterAll {
        }
    }
}