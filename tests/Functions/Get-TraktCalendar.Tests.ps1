$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktCalendar" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get my shows" {
            $shows = Get-TraktCalendar -MyShows

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get my new shows" {
            $shows = Get-TraktCalendar -MyNewShows

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get my season premieres" {
            $seasons = Get-TraktCalendar -MySeasonPremieres

            ($seasons | Measure-Object).Count | Should Be 0
        }

        It "Get my movies" {
            $movies = Get-TraktCalendar -MyMovies

            ($movies | Measure-Object).Count | Should Be 0
        }

        It "Get my DVD releases" {
            $dvd = Get-TraktCalendar -MyDVD

            ($dvd | Measure-Object).Count | Should Be 0
        }

        It "Get shows" {
            $shows = Get-TraktCalendar -AllShows

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get new shows" {
            $shows = Get-TraktCalendar -AllNewShows

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get season premieres" {
            $seasons = Get-TraktCalendar -AllSeasonPremieres

            ($seasons | Measure-Object).Count | Should Be 0
        }

        It "Get movies" {
            $movies = Get-TraktCalendar -AllMovies

            ($movies | Measure-Object).Count | Should f Be 0
        }

        It "Get DVD releases" {
            $dvd = Get-TraktCalendar -AllDVD

            ($dvd | Measure-Object).Count | Should Be 0
        }

        AfterAll {
        }
    }
}