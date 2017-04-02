$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Set-TraktComment" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary

            $comment = $movie | Add-TraktComment -Comment "Oh, I wasn't really listening." -Facebook
        }

        It "Like a comment" {
            $comment | Set-TraktComment -Like

            (Get-TraktComment -InputObject $comment).Likes | Should BeGreaterThan 0
        }

        It "Remove like on a comment" {
            $comment | Set-TraktComment

            (Get-TraktComment -InputObject $comment).Likes | Should Be 0
        }

        AfterAll {
            Remove-TraktComment -InputObject $comment | Out-Null
        }
    }
}