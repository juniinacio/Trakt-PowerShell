$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktWatchList" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Add movie to watchlist" {
            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
            $movie | Add-TraktWatchList | Out-Null

            $movies = Get-TraktWatchList -Type movies

            ($movies | Measure-Object).Count | Should BeGreaterThan 0
            $movies | Where-Object { $_.Movie.Title -eq 'Guardians of the Galaxy' } | Should Not BeNullOrEmpty
        }

        It "Add show to watchlist" {
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary
            $show | Add-TraktWatchList | Out-Null

            $seasons = Get-TraktWatchList -Type seasons

            ($seasons | Measure-Object).Count | Should BeGreaterThan 0
            $seasons | Where-Object { $_.Season.Number -eq 1 } | Should Not BeNullOrEmpty
        }

        It "Add episode to watchlist" {
            $episode = $show.Seasons[0].Episodes[1]
            $episode | Add-TraktWatchList | Out-Null

            $episodes = Get-TraktWatchList -Type episodes

            ($episodes | Measure-Object).Count | Should BeGreaterThan 0
            $episodes | Where-Object { $_.Show.Title -eq 'Game of Thrones' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktWatchList | Remove-TraktWatchList | Out-Null
        }
    }
}