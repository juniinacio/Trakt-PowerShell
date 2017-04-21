$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Remove-TraktUserListLike" -Tags "CI" {
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

            $params = @{
                Id = 'juni-inacio'
                ListId = 'star-wars-in-machete-order'
            }
            Add-TraktUserListLike @params | Out-Null
        }

        It "Remove like on a list" {
            $params = @{
                Id = 'juni-inacio'
                ListId = 'star-wars-in-machete-order'
            }
            Remove-TraktUserListLike @params | Out-Null

            $list = Get-TraktUserList -Id 'juni-inacio' -ListId 'star-wars-in-machete-order'

            $list.Likes | Should Be 0
        }

        AfterAll {
            Get-TraktUserList -Id 'juni-inacio' | ForEach-Object { Remove-TraktUserList -Id 'juni-inacio' -ListId $_.IDs.slug }
        }
    }
}