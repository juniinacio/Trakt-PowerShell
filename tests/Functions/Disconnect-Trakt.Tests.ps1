$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Disconnect-Trakt" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Remove access_token" {
            Disconnect-Trakt

            $Script:ACCESS_TOKEN_PATH | Should Not Exist
        }

        AfterAll {
        }
    }
}