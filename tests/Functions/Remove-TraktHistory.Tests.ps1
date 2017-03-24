$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktHistory" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id 'the-avengers-2012' -Summary
            
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary

            Update-TraktHistory -InputObject $movie | Out-Null
            Update-TraktHistory -InputObject $show.Seasons[0].Episodes[1] | Out-Null
        }

        It "Remove movie from watched history" {
            Remove-TraktHistory -InputObject $movie | Out-Null

            $history = Get-TraktHistory

            $history | Where-Object { $_.Title -eq 'The Avengers' } | Should BeNullOrEmpty
        }

        It "Remove show from watched history" {
            Remove-TraktHistory -InputObject $show.Seasons[0].Episodes[1] | Out-Null

            $history = Get-TraktHistory

            $history | Where-Object { $_.Title -eq 'Game of Thrones: 15-Minute Preview' } | Should BeNullOrEmpty
        }

        AfterAll {
        }
    }
}