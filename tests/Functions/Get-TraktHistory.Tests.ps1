Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktHistory" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get watched history" {
            $history = Get-TraktHistory

            ($history | Measure-Object).Count | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}