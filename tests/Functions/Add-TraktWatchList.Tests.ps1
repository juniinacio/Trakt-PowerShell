$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktWatchList" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Add movie to watchlist" {
            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
            
            $result = $movie | Add-TraktWatchList

            $watchLists = Get-TraktWatchList -Type movies

            ($watchLists | Measure-Object).Count | Should BeGreaterThan 0
            $watchLists | Where-Object { $_.Movie.Title -eq 'Guardians of the Galaxy' } | Should Not BeNullOrEmpty
        }

        It "Add show to watchlist" {
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary

            $result = $show | Add-TraktWatchList

            $watchLists = Get-TraktWatchList -Type seasons

            ($watchLists | Measure-Object).Count | Should BeGreaterThan 0
            $watchLists | Where-Object { $_.Season.Number -eq 1 } | Should Not BeNullOrEmpty
        }

        It "Add episode to watchlist" {
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary
            
            $episode = $show.Seasons[0].Episodes[1]

            $result = $episode | Add-TraktWatchList

            $watchLists = Get-TraktWatchList -Type episodes

            ($watchLists | Measure-Object).Count | Should BeGreaterThan 0
            $watchLists | Where-Object { $_.Show.Title -eq 'Game of Thrones' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktWatchList | Remove-TraktWatchList | Out-Null
        }
    }
}