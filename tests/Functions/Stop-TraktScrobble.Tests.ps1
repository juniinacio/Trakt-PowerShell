$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Stop-TraktScrobble" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1

            Get-TraktHistory | Remove-TraktHistory | Out-Null

            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
        }

        It "Stop or finish watching a movie in a media center" {
            Stop-TraktScrobble -Movie $movie -Progress 90 | Out-Null

            $history = Get-TraktHistory -Type movies

            ($history | Measure-Object).Count | Should BeGreaterThan 0
            $history | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
        }

        It "Stop or finish watching an episode in a media center" {
            Stop-TraktScrobble -Episode $episode -Progress 90 | Out-Null

            $history = Get-TraktHistory -Type shows

            ($history | Measure-Object).Count | Should BeGreaterThan 0
            $history | Where-Object { $_.Title -eq 'The Flash: City of Heroes' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktHistory | Remove-TraktHistory | Out-Null
        }
    }
}