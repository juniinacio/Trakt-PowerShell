Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktMovie" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get trending movies" {
            $movies = Get-TraktMovie -Trending

            ($movies | Measure-Object).Count | Should Be 0
        }

        It "Get popular movies" {
            $movies = Get-TraktMovie -Popular

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'The Matrix' } | Should Not BeNullOrEmpty
        }

        It "Get the most played movies" {
            $movies = Get-TraktMovie -Played -Period 'all'
            
            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Gladiator' } | Should Not BeNullOrEmpty
        }

        It "Get the most watched movies" {
            $movies = Get-TraktMovie -Watched

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'The Game' } | Should Not BeNullOrEmpty
        }

        It "Get the most collected movies" {
            $movies = Get-TraktMovie -Collected -Period 'all'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Batman Begins' } | Should Not BeNullOrEmpty
        }

        It "Get the most anticipated movies" {
            $movies = Get-TraktMovie -Anticipated

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Justice League' } | Should Not BeNullOrEmpty
        }

        It "Get the weekend box office" {
            $movies = Get-TraktMovie -BoxOffice

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Zootopia' } | Should Not BeNullOrEmpty
        }

        It "Get recently updated movies" {
            $movies = Get-TraktMovie -Updates -StartDate '2014-09-22'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Anatomy of a Murder' } | Should Not BeNullOrEmpty
        }

        It "Get a movie" {
            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'

            ($movie | Measure-Object).Count | Should Not Be 0
            $movie.Title | Should Be 'TRON: Legacy'
        }

        It "Get all movie aliases" {
            $movies = Get-TraktMovie -Aliases -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Tron El Legado' } | Should Not BeNullOrEmpty
        }

        It "Get all movie releases" {
            $movies = Get-TraktMovie -Releases -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Country -eq 'us' } | Should Not BeNullOrEmpty
        }

        It "Get all movie translations" {
            $movies = Get-TraktMovie -Translations -Id 'batman-begins-2005'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Language -eq 'nl' } | Should Not BeNullOrEmpty
        }

        It "Get all movie comments" {
            $movies = Get-TraktMovie -Comments -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.By -eq 'sean' } | Should Not BeNullOrEmpty
        }

        It "Get lists containing this movie" {
            $movies = Get-TraktMovie -Lists -Id 'tron-legacy-2010' -Type 'all'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.By -eq 'tmdb' } | Should Not BeNullOrEmpty
        }

        It "Get all people for a movie" {
            $movies = Get-TraktMovie -People -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Name -eq 'Aaron Toney' } | Should Not BeNullOrEmpty
        }

        It "Get movie ratings" {
            $movies = Get-TraktMovie -Ratings -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Rating -eq 8.0 } | Should Not BeNullOrEmpty
        }

        It "Get related movies" {
            $movies = Get-TraktMovie -Related -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'The Matrix Reloaded' } | Should Not BeNullOrEmpty
        }

        It "Get movie stats" {
            $movies = Get-TraktMovie -Stats -Id 'tron-legacy-2010'

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Collectors -eq 15 } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}