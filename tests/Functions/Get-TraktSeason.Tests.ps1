Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktSeason" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get all seasons for a show" {
            $seasons = Get-TraktSeason -Summary -Id 'game-of-thrones'

            ($seasons | Measure-Object).Count | Should Not Be 0
            $seasons | Where-Object { $_.Number -eq 1 } | Should Not BeNullOrEmpty
        }

        It "Get single season for a show" {
            $seasons = Get-TraktSeason -Id 'game-of-thrones' -Season -SeasonNumber 1

            ($seasons | Measure-Object).Count | Should Not Be 0
            $seasons | Where-Object { $_.Number -eq 1 -and $_.Title -eq 'Winter Is Coming' } | Should Not BeNullOrEmpty
        }

        It "Get all season comments" {
            $comments = Get-TraktSeason -Id 'game-of-thrones' -Comments -SeasonNumber 1

            ($comments | Measure-Object).Count | Should Not Be 0
            $comments | Where-Object { $_.By -eq 'juni.inacio' } | Should Not BeNullOrEmpty
        }

        It "Get lists containing this season" {
            $lists = Get-TraktSeason -Id 'game-of-thrones' -Lists -SeasonNumber 1 -Type 'all'

            ($lists | Measure-Object).Count | Should Not Be 0
            $lists | Where-Object { $_.Name -eq 'Watchlist' } | Should Not BeNullOrEmpty
        }

        It "Get season ratings" {
            $ratings = Get-TraktSeason -Id 'game-of-thrones' -Ratings -SeasonNumber 1

            ($ratings | Measure-Object).Count | Should Not Be 0
        }

        It "Get season stats" {
            $stats = Get-TraktSeason -Id 'game-of-thrones' -Stats -SeasonNumber 1

            ($stats | Measure-Object).Count | Should Not Be 0
        }

        It "Get users watching right now" {
            $episode = Get-TraktEpisode -Summary -Id "game-of-thrones" -SeasonNumber 1 -EpisodeNumber 1
            Start-TraktScrobble -Episode $episode -Progress 10

            $watching = Get-TraktSeason -Id 'game-of-thrones' -Watching -SeasonNumber 1
            
            ($watching | Measure-Object).Count | Should Not Be 0
            $watching | Where-Object { $_.UserName -eq 'juni.inacio' } | Should Not BeNullOrEmpty

            # Stop-TraktScrobble -Episode $episode -Progress 100
        }

        AfterAll {
        }
    }
}