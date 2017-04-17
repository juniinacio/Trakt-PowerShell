$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktUserHiddenItem" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $show = Get-TraktShow -Summary -Id 'game-of-thrones'
        }

        It "Add hidden items" -Pending {
        }

        AfterAll {
        }
    }
}