$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktComment" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary
            $season = $show.Seasons[0]
            $episode = $season.Episodes[0]

            $movie | Add-TraktWatchList | Out-Null

            $list = Get-TraktMovie -id $movie.IDs.slug -Lists -Type all | Where-Object { $_.By -eq 'tmdb' }
        }

        It "Post a comment about a movie" {
            $result = $movie | Add-TraktComment -Comment "This is a great movie." -Facebook
            $comment = Get-TraktComment -InputObject $result

            $comment | Should Not BeNullOrEmpty
            $comment.Comment | Should Be "This is a great movie."

            Remove-TraktComment -InputObject $comment
        }

        It "Post a comment about a show" {
            $result = $show | Add-TraktComment -Comment "This is a great show." -Facebook
            $comment = Get-TraktComment -InputObject $result

            $comment | Should Not BeNullOrEmpty
            $comment.Comment | Should Be "This is a great show."

            Remove-TraktComment -InputObject $comment
        }

        It "Post a comment about an season" {
            $result = $season | Add-TraktComment -Comment "This season was really spectacular." -Facebook
            $comment = Get-TraktComment -InputObject $result

            $comment | Should Not BeNullOrEmpty
            $comment.Comment | Should Be "This season was really spectacular."

            Remove-TraktComment -InputObject $comment
        }

        It "Post a comment about an episode" {
            $result = $season | Add-TraktComment -Comment "This was a really boring episode." -Facebook
            $comment = Get-TraktComment -InputObject $result

            $comment | Should Not BeNullOrEmpty
            $comment.Comment | Should Be "This was a really boring episode."

            Remove-TraktComment -InputObject $comment
        }

        It "Post a comment about a list" {
            $result = $list | Add-TraktComment -Comment "This watchlist needs updating fast." -Facebook
            $comment = Get-TraktComment -InputObject $result

            $comment | Should Not BeNullOrEmpty
            $comment.Comment | Should Be "This watchlist needs updating fast."

            Remove-TraktComment -InputObject $comment
        }

        It "Post a reply for a comment" {
            $result = $movie | Add-TraktComment -Comment "This is a great movie." -Facebook

            $reply = Add-TraktComment -InputObject $result.Id -Comment "Couldn't agree more with you." -Replies

            $replies = Get-TraktComment -InputObject $result.Id -Replies

            $replies | Should Not BeNullOrEmpty
            $replies | Where-Object { $_.Id -eq $reply.Id } | Should Not BeNullOrEmpty

            Remove-TraktComment -InputObject $result
        }

        AfterAll {
            Get-TraktWatchList | Remove-TraktWatchList | Out-Null
        }
    }
}