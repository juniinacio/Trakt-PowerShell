Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktMovie" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get trending movies" {
        }

        It "Get popular movies" {
            $movies = Get-TraktMovie -Popular

            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Name -eq 'The Matrix' } | Should Not Be Null
        }

        It "Get the most played movies " {
            $movies = Get-TraktMovie -Played -Period 'all'
            
            ($movies | Measure-Object).Count | Should Not Be 0
            $movies | Where-Object { $_.Title -eq 'Gladiator' } | Should Not Be Null
        }

        AfterAll {
        }
    }
}