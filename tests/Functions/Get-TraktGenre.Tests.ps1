$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktGenre" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get movie genres" {
            $genres = Get-TraktGenre -Type movies

            $genres | Where-Object { $_.Name -eq 'Action' } | Should Not BeNullOrEmpty
        }

        It "Get show genres" {
            $genres = Get-TraktGenre -Type shows

            $genres | Where-Object { $_.Name -eq 'Action' } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}