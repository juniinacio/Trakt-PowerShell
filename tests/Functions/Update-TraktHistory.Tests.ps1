$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Update-TraktHistory" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id 'the-avengers-2012' -Summary
            
            $show = Get-TraktShow -Id 'game-of-thrones' -Summary
        }

        It "Add movie to watched history" {
            Update-TraktHistory -InputObject $movie | Out-Null

            $history = Get-TraktHistory

            ($history | Measure-Object).Count | Should Not BeNullOrEmpty
            $history | Where-Object { $_.Title -eq 'The Avengers' } | Should Not BeNullOrEmpty
        }

        It "Add show to watched history" {
            Update-TraktHistory -InputObject $show.Seasons[0].Episodes[1] | Out-Null

            $history = Get-TraktHistory

            ($history | Measure-Object).Count | Should Not BeNullOrEmpty
            $history | Where-Object { $_.Title -eq 'Game of Thrones: 15-Minute Preview' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktHistory | Remove-TraktHistory | Out-Null
        }
    }
}