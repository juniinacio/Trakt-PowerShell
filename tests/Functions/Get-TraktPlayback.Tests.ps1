$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktPlayback" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'

            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
        }

        It "Get movies playback progress" {
            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Suspend-TraktScrobble -Movie $movie -Progress 25 | Out-Null

            $playback = Get-TraktPlayback -Type movies

            ($playback | Measure-Object).Count | Should Not Be 0
            $playback | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty

            Start-TraktScrobble -Movie $movie -Progress 25 | Out-Null
            Stop-TraktScrobble -Movie $movie -Progress 90 | Out-Null
        }

        It "Get episodes playback progress" {
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Suspend-TraktScrobble -Episode $episode -Progress 25 | Out-Null

            $playback = Get-TraktPlayback -Type episodes

            ($playback | Measure-Object).Count | Should Not Be 0
            $playback | Where-Object { $_.Title -eq 'The Flash' } | Should Not BeNullOrEmpty

            Start-TraktScrobble -Episode $episode -Progress 25 | Out-Null
            Stop-TraktScrobble -Episode $episode -Progress 90 | Out-Null
        }

        It "Get all playback progress" {
            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Suspend-TraktScrobble -Movie $movie -Progress 25 | Out-Null
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Suspend-TraktScrobble -Episode $episode -Progress 25 | Out-Null

            $playback = Get-TraktPlayback

            ($playback | Measure-Object).Count | Should Not Be 0
            $playback | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
            $playback | Where-Object { $_.Title -eq 'The Flash' } | Should Not BeNullOrEmpty

            Start-TraktScrobble -Movie $movie -Progress 25 | Out-Null
            Stop-TraktScrobble -Movie $movie -Progress 90 | Out-Null
            Start-TraktScrobble -Episode $episode -Progress 25 | Out-Null
            Stop-TraktScrobble -Episode $episode -Progress 90 | Out-Null
        }

        AfterAll {
            Get-TraktPlayback | Remove-TraktPlayback | Out-Null
            Get-TraktHistory | Remove-TraktHistory | Out-Null
        }
    }
}