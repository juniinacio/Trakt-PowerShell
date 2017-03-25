$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktComment" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
        }

        It "Post a comment" {
            $comment = $movie | Add-TraktComment -Comment "Oh, I wasn't really listening." -Facebook

            (Get-TraktComment -InputObject $comment) | Should Not BeNullOrEmpty

            Remove-TraktComment -InputObject $comment
        }

        It "Post a reply for a comment" {
            $comment = $movie | Add-TraktComment -Comment "Oh, I wasn't really listening." -Facebook

            $reply = Add-TraktComment -InputObject $comment.Id -Comment "Couldn't agree more with your review!" -Replies

            $replies = Get-TraktComment -InputObject $comment -Replies

            $replies | Should Not BeNullOrEmpty
            $replies | Where-Object { $_.Id -eq $reply.Id } | Should Not BeNullOrEmpty

            Remove-TraktComment -InputObject $comment
        }

        AfterAll {
        }
    }
}