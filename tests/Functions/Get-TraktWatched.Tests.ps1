Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktWatched" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get watched movies" {
            $movies = Get-TraktWatched -Type movies

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
        }

        It "Get watched shows" {
            $shows = Get-TraktWatched -Type shows

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Game of Thrones' } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}