$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktFollowerRequest" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get follow requests" {
        }

        AfterAll {
        }
    }
}