$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Set-TraktCheckin" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary

            $episode = (Get-TraktShow -id "the-flash" -Summary).Seasons[0].Episodes[0]

            Remove-TraktCheckin
        }

        It "Check into an movie" {
            { Set-TraktCheckin -InputObject $movie -Facebook -Twitter -Tumblr -Message 'Guardians of the Galaxy!' | Out-Null } | Should Not Throw
            Remove-TraktCheckin
        }

        It "Check into an episode" {
            { Set-TraktCheckin -InputObject $episode -Facebook -Twitter -Tumblr -Message 'The Flash!' | Out-Null } | Should Not Throw
            Remove-TraktCheckin
        }

        AfterAll {
        }
    }
}