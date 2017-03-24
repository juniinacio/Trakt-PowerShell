Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktCollection" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Summary -Id 'tron-legacy-2010'
            $show = Get-TraktShow -Summary -Id "the-flash"

            Update-TraktCollection -InputObject $movie
            Update-TraktCollection -InputObject $show
        }

        It "Get movies collection" {
            $collection = Get-TraktCollection -Type movies
            
            ($collection | Measure-Object).Count | Should BeGreaterThan 0
            $collection | Where-Object { $_.Title -eq 'TRON: Legacy' } | Should Not BeNullOrEmpty
        }

        It "Get shows collection" {
            $collection = Get-TraktCollection -Type shows

            ($collection | Measure-Object).Count | Should BeGreaterThan 0
            $collection | Where-Object { $_.Title -eq 'The Flash' } | Should Not BeNullOrEmpty
        }

        AfterAll {
            Get-TraktCollection -Type movies | Remove-TraktCollection | Out-Null
            Get-TraktCollection -Type shows | Remove-TraktCollection | Out-Null
        }
    }
}