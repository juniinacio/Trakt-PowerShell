$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktUserList" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get a user's custom lists" {
            $lists = Get-TraktUserList -Id sean

            ($lists | Measure-Object).Count | Should Not Be 0
            $lists | Where-Object { $_.By -eq 'sean' } | Should Not BeNullOrEmpty
        }

        It "Get a user's custom lists" {
            $list = Get-TraktUserList -Id sean -ListId 'star-wars-in-machete-order'

            ($list | Measure-Object).Count | Should Be 1
            $list.By | Should Be 'sean'
        }

        AfterAll {
        }
    }
}