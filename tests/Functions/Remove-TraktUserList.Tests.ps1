$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktUserList" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null

            $params = @{
                Id = 'juni-inacio'
                Name = 'Star Wars in machete order'
                Description = "Next time you want to introduce someone to Star Wars for the first time, watch the films with them in this order: IV, V, II, III, VI."
                Privacy = 'public'
                DisplayNumbers = $true
                AllowComments = $true
            }
            Add-TraktUserList @params | Out-Null
        }

        It "Delete a user's custom list" {

            Remove-TraktUserList -Id 'juni-inacio' -ListId 'star-wars-in-machete-order'

            $lists = Get-TraktUserList -Id 'juni-inacio'
            
            ($lists | Measure-Object).Count | Should Be 0
        }

        AfterAll {
        }
    }
}