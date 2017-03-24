$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Suspend-TraktScrobble" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1

            Get-TraktPlayback | Remove-TraktPlayback
        }

        It "Pause watching a movie in a media center " {
            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Suspend-TraktScrobble -Movie $movie -Progress 15 | Out-Null

            $playback = Get-TraktPlayback -Type movies | Where-Object { $_.Title -eq 'TRON: Legacy' }

            $playback | Should Not BeNullOrEmpty
            $playback.Progress | Should Be 15

            Get-TraktPlayback | Remove-TraktPlayback
        }

        It "Pause watching an episode in a media center " {
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Suspend-TraktScrobble -Episode $episode -Progress 15 | Out-Null

            $playback = Get-TraktPlayback -Type episodes | Where-Object { $_.Title -eq 'The Flash' }

            $playback | Should Not BeNullOrEmpty
            $playback.Progress | Should Be 15

            Get-TraktPlayback | Remove-TraktPlayback
        }

        AfterAll {
        }
    }
}