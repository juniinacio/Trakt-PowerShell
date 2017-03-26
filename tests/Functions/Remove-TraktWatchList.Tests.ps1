$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktWatchList" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary
            $episode = $show.Seasons[0].Episodes[1]

            $movie | Add-TraktWatchList | Out-Null
            $show | Add-TraktWatchList | Out-Null
            $episode | Add-TraktWatchList | Out-Null
        }

        It "Remove movie from watchlist" {
            $movie | Remove-TraktWatchList | Out-Null

            $movies = Get-TraktWatchList -Type movies

            ($movies | Measure-Object).Count | Should Be 0
            $movies | Where-Object { $_.Movie.Title -eq 'Guardians of the Galaxy' } | Should BeNullOrEmpty
        }

        It "Remove show from watchlist" {
            $show | Remove-TraktWatchList | Out-Null

            $seasons = Get-TraktWatchList -Type seasons

            ($seasons | Measure-Object).Count | Should Be 0
            $seasons | Where-Object { $_.Season.Number -eq 1 } | Should BeNullOrEmpty
        }

        It "Remove episode from watchlist" {
            $episode | Remove-TraktWatchList | Out-Null

            $episodes = Get-TraktWatchList -Type episodes

            ($episodes | Measure-Object).Count | Should Be 0
            $episodes | Where-Object { $_.Show.Title -eq 'Game of Thrones' } | Should BeNullOrEmpty
        }

        AfterAll {
        }
    }
}