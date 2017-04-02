$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktHiddenItem" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get hidden items" {
            $items = Get-TraktHiddenItem -Section recommendations -Verbose

            ($items | Measure-Object).Count | Should BeGreaterThan 0
            
            $items | Where-Object { $_.Movie.Title -eq 'Die Hard' } | Should Not BeNullOrEmpty
            $items | Where-Object { $_.Show.Title -eq 'South Park' } | Should Not BeNullOrEmpty
        }

        AfterAll {
        }
    }
}