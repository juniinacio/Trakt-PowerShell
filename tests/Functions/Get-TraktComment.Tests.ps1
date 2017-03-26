$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktComment" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary

            $comment = $movie | Add-TraktComment -Comment "Oh, I wasn't really listening." -Facebook

            $reply = Add-TraktComment -InputObject $comment.Id -Comment "Couldn't agree more with your review!" -Replies
        }

        It "Get a comment or reply" {
            (Get-TraktComment -InputObject $comment) | Should Not BeNullOrEmpty
        }

        It "Get replies for a comment" {
            $replies = Get-TraktComment -InputObject $comment -Replies
            
            $replies | Should Not BeNullOrEmpty
            $replies | Where-Object { $_.Id -eq $reply.Id } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Remove-TraktComment -InputObject $comment | Out-Null
        }
    }
}