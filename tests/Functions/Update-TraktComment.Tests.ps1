$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Update-TraktComment" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $movie = Get-TraktMovie -Id "guardians-of-the-galaxy-2014" -Summary
            $comment = $movie | Add-TraktComment -Comment "Oh, I wasn't really listening." -Facebook
        }

        It "Update a comment" {
            $update = Update-TraktComment -InputObject $comment -Comment "Agreed, this show is awesome. AMC in general has awesome shows and I can't wait to see what they come up with next."
            $update | Should Not BeNullOrEmpty
            $update.Comment | Should Be "Agreed, this show is awesome. AMC in general has awesome shows and I can't wait to see what they come up with next."
        }

        It "Update a reply" -Pending {
        }

        AfterAll {
            Remove-TraktComment -InputObject $comment | Out-Null
        }
    }
}