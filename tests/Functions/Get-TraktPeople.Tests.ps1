$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktPeople" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get a single person" {
            $people = Get-TraktPeople -Summary -Id 'bryan-cranston'

            ($people | Measure-Object).Count | Should Not Be 0
            $people.Name | Should Be 'Bryan Cranston'
        }

        It "Get movie credits" {
            $people = Get-TraktPeople -Movie -Id 'bryan-cranston'

            $people.Cast | Where-Object { $_.Character -eq 'Joe Brody' } | Should Not BeNullOrEmpty
        }

        It "Get show credits" {
            $people = Get-TraktPeople -Show -Id 'bryan-cranston'

            $people.Cast | Where-Object { $_.Character -eq 'Walter White' } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}