$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktFollowerRequests" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get follow requests" {
            $followerRequests = Get-TraktFollowerRequests

            $followerRequests | Should Not BeNullOrEmpty
            $followerRequests.By | Should Be 'trakt-powershell'
        }

        AfterAll {
        }
    }
}