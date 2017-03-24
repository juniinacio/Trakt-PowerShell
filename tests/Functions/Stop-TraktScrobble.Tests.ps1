Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Stop-TraktScrobble" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Stop or finish watching a movie in a media center" {
        }

        It "Stop or finish watching an episode in a media center" {
        }

        AfterAll {
        }
    }
}