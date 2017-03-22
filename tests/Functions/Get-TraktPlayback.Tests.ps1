Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktPlayback" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'

            Start-TraktScrobble -Movie $movie -Progress 10 | Out-Null
            Suspend-TraktScrobble -Movie $movie -Progress 25 | Out-Null

            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
            
            Start-TraktScrobble -Episode $episode -Progress 10 | Out-Null
            Suspend-TraktScrobble -Episode $episode -Progress 25 | Out-Null
        }

        It "Get all playback progress" {
            $playback = Get-TraktPlayback

            ($playback | Measure-Object).Count | Should Not Be 0
            $playback | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
            $playback | Where-Object { $_.Title -eq 'The Flash: City of Heroes' } | Should Not BeNullOrEmpty
        }

        It "Get movies playback progress" {
            $playback = Get-TraktPlayback -Type movies

            ($playback | Measure-Object).Count | Should Not Be 0
            $playback | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
        }

        It "Get episodes playback progress" {
            $playback = Get-TraktPlayback -Type episodes

            ($playback | Measure-Object).Count | Should Not Be 0
            $playback | Where-Object { $_.Title -eq 'The Flash: City of Heroes' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktPlayback | Remove-TraktPlayback | Out-Null
        }
    }
}