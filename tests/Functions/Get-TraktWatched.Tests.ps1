$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktWatched" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
            
            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1

            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Stop-TraktScrobble -Movie $movie -Progress 90 | Out-Null

            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Stop-TraktScrobble -Episode $episode -Progress 90 | Out-Null
        }

        It "Get watched movies" {
            $movies = Get-TraktWatched -Type movies

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
        }

        It "Get watched shows" {
            $shows = Get-TraktWatched -Type shows

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'The Flash' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktHistory | Remove-TraktHistory | Out-Null
        }
    }
}