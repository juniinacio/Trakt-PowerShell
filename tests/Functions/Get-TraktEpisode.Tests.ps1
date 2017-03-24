$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktEpisode" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get a single episode for a show" {
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1

            $episode.Title | Should Be "City of Heroes"
            $episode.Number | Should Be 1
        }

        It "Get all episode translations" {
            $episode = Get-TraktEpisode -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1 -Translations -Language 'en'

            $episode | Should Not Be Null
        }

        It "Get all episode comments" {
            $comments = Get-TraktEpisode -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1 -Comments -Sort 'newest'

            ($comments | Measure-Object).Count | Should Not Be 0
        }

        It "Get lists containing this episode" {
            $lists = Get-TraktEpisode -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1 -Lists -Type 'all' -Sort 'popular'

            # ($lists | Measure-Object).Count | Should Not Be 0
            # $lists | Where-Object { $_.Name -eq 'Watchlist' } | Should Not Be Null
        }

        It "Get episode ratings" {
            $ratings = Get-TraktEpisode -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1 -Ratings

            ($ratings | Measure-Object).Count | Should Not Be 0
        }

        It "Get episode stats" {
            $stats = Get-TraktEpisode -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1 -Stats

            ($stats | Measure-Object).Count | Should Not Be 0
        }

        It "Get users watching right now" {
            $episode = Get-TraktEpisode -Summary -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1
            Start-TraktScrobble -Episode $episode -Progress 10

            $watching = Get-TraktEpisode -Id "the-flash" -SeasonNumber 1 -EpisodeNumber 1 -Watching

            ($watching | Measure-Object).Count | Should Be 1
        }

        AfterAll {
        }
    }
}