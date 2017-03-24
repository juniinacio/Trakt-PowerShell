Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktCollection" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id 'the-avengers-2012' -Summary

            $show = Get-TraktShow -Id 'game-of-thrones' -Summary

            $movie | Update-TraktCollection | Out-Null
            $show | Update-TraktCollection | Out-Null
        }

        It "Add item to movies collection" {
            $movie | Remove-TraktCollection | Out-Null
            
            $collection = Get-TraktCollection -Type movies

            $collection | Where-Object { $_.Title -eq 'The Avengers' } | Should BeNullOrEmpty
        }

        It "Add item to shows collection" {
            $show | Remove-TraktCollection | Out-Null
            
            $collection = Get-TraktCollection -Type shows

            $collection | Where-Object { $_.Title -eq 'Game of Thrones' } | Should BeNullOrEmpty
        }

        AfterAll {
        }
    }
}