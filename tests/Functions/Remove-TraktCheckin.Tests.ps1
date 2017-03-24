$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktCheckin" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
            
            Set-TraktCheckin -InputObject $movie -Facebook -Twitter -Tumblr -Message 'Guardians of the Galaxy!'
        }

        It "Delete any active checkins" {
            { Remove-TraktCheckin } | Should Not Throw
        }

        AfterAll {
        }
    }
}