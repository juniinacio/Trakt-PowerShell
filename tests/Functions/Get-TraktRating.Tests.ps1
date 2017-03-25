$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktRating" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get ratings" {
            $ratings = Get-TraktRating -Type all

            ($ratings | Measure-Object).Count | Should Be 0
        }

        AfterAll {
        }
    }
}