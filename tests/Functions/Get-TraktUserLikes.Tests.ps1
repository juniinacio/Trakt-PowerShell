$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktUserLikes" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get likes" {
            $likes = Get-TraktUserLikes
            
            ($likes | Measure-Object).Count | Should BeGreaterThan 0
        }

        AfterAll {
        }
    }
}