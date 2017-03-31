$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktRating" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'
            $show = Get-TraktShow -Summary -Id 'game-of-thrones'
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
        }

        It "Add new movie rating" {
            $result = $movie | Add-TraktRating -Rating 8
            
            $rating = Get-TraktRating -Type movies | Where-Object { $_.Title -eq $movie.Title }

            $rating | Should Not BeNullOrEmpty
            $rating.Title | Should Be 'TRON: Legacy'
            $rating.Rating | Should Be 8
            $rating.Type | Should Be 'movie'
        }

        It "Add new show rating" {
            $result = $show | Add-TraktRating -Rating 7
            
            $rating = Get-TraktRating -Type shows | Where-Object { $_.Title -eq $show.Title }

            $rating | Should Not BeNullOrEmpty
            $rating.Title | Should Be 'Game of Thrones'
            $rating.Rating | Should Be 7
            $rating.Type | Should Be 'show'
        }

        It "Add new episode rating" {
            $result = $episode | Add-TraktRating -Rating 8
            
            $rating = Get-TraktRating -Type episodes | Where-Object { $_.Episode.Number -eq $episode.Number }

            $rating | Should Not BeNullOrEmpty
            $rating.Title | Should Be 'The Flash'
            $rating.Rating | Should Be 8
            $rating.Type | Should Be 'episode'
        }

        AfterAll {
            Get-TraktRating | Remove-TraktRating
        }
    }
}