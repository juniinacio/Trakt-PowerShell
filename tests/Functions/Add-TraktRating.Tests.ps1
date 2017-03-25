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
            $rating = $movie | Add-TraktRating -Rating 8
            Get-TraktRating -Type movies | Where-Object { $_.Title -eq $movie.Title } | Should Not BeNullOrEmpty
        }

        It "Add new show rating" {
            $rating = $show | Add-TraktRating -Rating 8
            Get-TraktRating -Type shows | Where-Object { $_.Title -eq $show.Title } | Should Not BeNullOrEmpty
        }

        It "Add new episode rating" {
            $rating = $episode | Add-TraktRating -Rating 8
            Get-TraktRating -Type episodes | Where-Object { $_.Episode.Number -eq $episode.Number } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktRating | Remove-TraktRating
        }
    }
}