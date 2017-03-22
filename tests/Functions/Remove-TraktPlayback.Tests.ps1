Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktPlayback" -Tags "CI" {
        BeforeAll {
        }

        It "Remove a playback item" {
        }

        AfterAll {
        }
    }
}