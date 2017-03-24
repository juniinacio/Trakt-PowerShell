$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktPlayback" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Remove all playback item" {
            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'

            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Suspend-TraktScrobble -Movie $movie -Progress 25 | Out-Null

            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
            
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Suspend-TraktScrobble -Episode $episode -Progress 25 | Out-Null
            
            Get-TraktPlayback | Remove-TraktPlayback

            Get-TraktPlayback | Should Be $null
        }

        It "Remove a movie playback item" {
            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'

            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Suspend-TraktScrobble -Movie $movie -Progress 25 | Out-Null

            Get-TraktPlayback -Type movies | Remove-TraktPlayback

            Get-TraktPlayback | Should Be $null
        }

        It "Remove a show playback item" {
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
            
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Suspend-TraktScrobble -Episode $episode -Progress 25 | Out-Null

            Get-TraktPlayback -Type episodes | Remove-TraktPlayback

            Get-TraktPlayback | Should Be $null
        }

        AfterAll {
        }
    }
}