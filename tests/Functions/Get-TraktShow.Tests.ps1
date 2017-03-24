Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Get-TraktShow" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Get trending shows" {
            $shows = Get-TraktShow -Trending

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get popular shows" {
            $shows = Get-TraktShow -Popular

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Dexter' } | Should Not BeNullOrEmpty
        }

        It "Get the most played shows" {
            $shows = Get-TraktShow -Played

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'The Big Bang Theory' } | Should Not BeNullOrEmpty
        }

        It "Get the most watched shows " {
            $shows = Get-TraktShow -Watched

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Grimm' } | Should Not BeNullOrEmpty
        }

        It "Get the most collected shows" {
            $shows = Get-TraktShow -Collected

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Sex and the City' } | Should Not BeNullOrEmpty
        }

        It "Get the most anticipated shows" {
            $shows = Get-TraktShow -Anticipated

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get recently updated shows" {
            $shows = Get-TraktShow -Updates -StartDate '2014-09-22'

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Red Band Society' } | Should Not BeNullOrEmpty
        }
        
        It "Get a single show" {
            $shows = Get-TraktShow -Summary -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Game of Thrones' } | Should Not BeNullOrEmpty
        }

        It "Get all show aliases" {
            $shows = Get-TraktShow -Aliases -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Game of Thrones- Das Lied von Eis und Feuer' } | Should Not BeNullOrEmpty
        }

        It "Get all show translations" {
            $shows = Get-TraktShow -Translations -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Language -eq 'nl' } | Should Not BeNullOrEmpty
        }

        It "Get all show comments" {
            $shows = Get-TraktShow -Comments -Id 'game-of-thrones' -Sort newest

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get lists containing this show" {
            $shows = Get-TraktShow -Lists -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get show collection progress" {
            $shows = Get-TraktShow -CollectionProgress -Id 'game-of-thrones' -Hidden -Specials -CountSpecials

            ($shows | Measure-Object).Count | Should Not Be 0
        }

        It "Get show watched progress " {
            $shows = Get-TraktShow -WatchedProgress -Id 'game-of-thrones' -Hidden -Specials -CountSpecials

            ($shows | Measure-Object).Count | Should Not Be 0
        }

        It "Get all people for a show" {
            $shows = Get-TraktShow -People -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows.Cast | Where-Object { $_.Name -eq 'David Bradley' } | Should Not BeNullOrEmpty
        }

        It "Get show ratings" {
            $shows = Get-TraktShow -Ratings -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
        }

        It "Get related shows" {
            $shows = Get-TraktShow -Related -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
            $shows | Where-Object { $_.Title -eq 'Smallville' } | Should Not BeNullOrEmpty
        }

        It "Get show stats" {
            $shows = Get-TraktShow -Stats -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
        }

        It "Get users watching right now" {
            $shows = Get-TraktShow -Watching -Id 'game-of-thrones'

            # ($shows | Measure-Object).Count | Should Be 0
        }

        It "Get next episode" {
            $shows = Get-TraktShow -NextEpisode -Id 'game-of-thrones'

            # ($shows | Measure-Object).Count | Should Be $null
        }

        It "Get last episode" {
            $shows = Get-TraktShow -LastEpisode -Id 'game-of-thrones'

            ($shows | Measure-Object).Count | Should Not Be 0
        }

        AfterAll {
        }
    }
}