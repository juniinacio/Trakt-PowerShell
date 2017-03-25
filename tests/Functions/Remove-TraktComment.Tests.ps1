$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktComment" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary

            $comment = $movie | Add-TraktComment -Comment "Oh, I wasn't really listening." -Facebook
        }

        It "Delete a comment or reply" {
            Remove-TraktComment -InputObject $comment
            { Get-TraktComment -InputObject $comment } | Should Throw
        }

        AfterAll {
        }
    }
}