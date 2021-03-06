$Global:IsStaging = $true

Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force

InModuleScope Trakt-PowerShell {
    Describe "Add-TraktUserList" -Tags "CI" {
        BeforeAll {
            Connect-Trakt | Out-Null
        }

        It "Create custom list" {
            $params = @{
                Id = 'juni-inacio'
                Name = 'Star Wars in machete order'
                Description = "Next time you want to introduce someone to Star Wars for the first time, watch the films with them in this order: IV, V, II, III, VI."
                Privacy = 'public'
                DisplayNumbers = $true
                AllowComments = $true
            }
            Add-TraktUserList @params | Out-Null

            $list = Get-TraktUserList -Id 'juni-inacio' -ListId 'star-wars-in-machete-order'
            
            ($list | Measure-Object).Count | Should Be 1
            $list.By | Should Be 'juni.inacio'
        }

        AfterAll {
            Get-TraktUserList -Id 'juni-inacio' | ForEach-Object { Remove-TraktUserList -Id 'juni-inacio' -ListId $_.IDs.slug }
        }
    }
}