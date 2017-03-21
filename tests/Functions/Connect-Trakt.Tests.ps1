Import-Module $(Join-Path -Path $PSScriptRoot -ChildPath '../../Trakt-PowerShell/Trakt-PowerShell.psd1') -Force -ArgumentList $true

InModuleScope Trakt-PowerShell {
    Describe "Connect-Trakt" -Tags "CI" {
        BeforeAll {
            $Script:ACCESS_TOKEN = $null
            if (Test-Path -Path $Script:ACCESS_TOKEN_PATH -PathType Leaf) {
                Remove-Item -Path $Script:ACCESS_TOKEN_PATH -Force -Confirm:$false
            }
        }

        It "Exchange code for access_token" {
            $token = Connect-Trakt

            $Script:ACCESS_TOKEN_PATH | Should Exist
            $token | Should Not BeNullOrEmpty
        }

        It "Exchange refresh_token for access_token " {
            $epoch = Get-Date -Date "01/01/1970"
            $yesterday = (Get-Date).AddDays(-1)
            $seconds = [int](New-TimeSpan -Start $epoch -End $yesterday).TotalSeconds

            $token = Import-Clixml -Path $Script:ACCESS_TOKEN_PATH
            $token.expires_in = 60
            $token.created_at = $seconds

            $token | Export-Clixml -Path $Script:ACCESS_TOKEN_PATH

            $newToken = Connect-Trakt

            $Script:ACCESS_TOKEN_PATH | Should Exist
            $newToken | Should Not BeNullOrEmpty
            $newToken.access_token | Should Not Be $token.access_token

            $newToken2 = Connect-Trakt

            $newToken.access_token | Should Be $newToken2.access_token
        }

        AfterAll {
        }
    }
}