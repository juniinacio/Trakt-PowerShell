Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktLastActivity" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get last activity" {
            $lastActivity = Get-TraktLastActivity

            ($lastActivity | Measure-Object).Count | Should Not Be 0
        }

        AfterAll {
        }
    }
}