$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Search-Trakt" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get text query results" {
            $results = Search-Trakt -Type movie -Query 'tron'

            ($results | Measure-Object).Count | Should BeGreaterThan 0

            $results = Search-Trakt -Type show -Query 'flash'

            ($results | Measure-Object).Count | Should BeGreaterThan 0

            $results = Search-Trakt -Type episode -Query 'City of Heroes'

            ($results | Measure-Object).Count | Should BeGreaterThan 0
            $results | Where-Object { $_.Title -eq 'The Flash' } | Should Not BeNullOrEmpty
        }

        It "Get ID lookup results" {
            $results = Search-Trakt -IMDB -Id 'tt0848228' -Type movie

            $results | Where-Object { $_.Title -eq 'The Avengers' } | Should Not BeNullOrEmpty

            $results = Search-Trakt -Trakt -Id '12061' -Type movie

            $results | Where-Object { $_.Title -eq 'Many Words for Modern' } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}