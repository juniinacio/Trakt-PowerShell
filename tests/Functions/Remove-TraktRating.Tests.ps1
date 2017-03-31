$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktRating" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'
            $movie | Add-TraktRating -Rating 8 | Out-Null

            $show = Get-TraktShow -Summary -Id 'game-of-thrones'
            $show | Add-TraktRating -Rating 8 | Out-Null

            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
            $episode | Add-TraktRating -Rating 8 | Out-Null
        }

        It "Remove movie rating" {
            $rating = $movie | Remove-TraktRating
            Get-TraktRating -Type movies | Where-Object { $_.Title -eq $movie.Title } | Should BeNullOrEmpty
        }

        It "Remove show rating" {
            $rating = $show | Remove-TraktRating
            Get-TraktRating -Type shows | Where-Object { $_.Title -eq $show.Title } | Should BeNullOrEmpty
        }

        It "Remove episode rating" {
            $rating = $episode | Remove-TraktRating
            Get-TraktRating -Type episodes | Where-Object { $_.Episode.Number -eq $episode.Number } | Should BeNullOrEmpty
        }

        AfterAll {
            Get-TraktRating | Remove-TraktRating | Out-Null
        }
    }
}