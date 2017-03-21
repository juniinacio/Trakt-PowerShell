<#
.SYNOPSIS
    Connects the module to Trakt.TV.
.DESCRIPTION
    Connects the module to Trakt.TV.
.EXAMPLE
    PS C:\> Connect-Trakt

    Description
    -----------
    This example shows how to connect with Trakt.TV.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    None
.COMPONENT
    None
.ROLE
    None
.FUNCTIONALITY
    None
#>
function Connect-Trakt {
    [CmdletBinding()]
    [OutputType([Void])]
    Param ()
    
    begin {
    
        function Authorize {
            try {
                Add-Type -AssemblyName 'System.Windows.Forms'
                Add-Type -AssemblyName 'System.Web'

                $Script:code = $null

                $webBrowser = New-Object -TypeName 'System.Windows.Forms.WebBrowser'
                $webBrowser.Width = 400
                $webBrowser.Height = 500
                $webBrowser.Add_DocumentCompleted({
                    if ($webBrowser.Url.AbsoluteUri -match 'oauth/authorize/(?<code>[^&]*)') {
                        $form.Close()
                        $Script:code =  $Matches.code
                    }
                })

                $form = New-Object -TypeName 'System.Windows.Forms.Form'
                $form.Width = 414
                $form.Height = 540
                $form.Add_Shown({ $form.Activate() })
                $form.Controls.Add($webBrowser)

                $webBrowser.Navigate(('{0}/oauth/authorize?response_type=code&client_id={1}&redirect_uri={2}' -f $Script:SITE_URI , $Script:CLIENT_ID, $Script:REDIRECT_URI))

                $null = $form.ShowDialog()

                $Script:code
            } catch {
                throw $_
            }
        }

        function GetToken {
            try {
                if (-not (Test-Path -Path $Script:ACCESS_TOKEN_PATH -PathType Leaf)) {
                    $code = Authorize

                    $body = ConvertTo-Json -InputObject @{
                        code = $code
                        client_id = $Script:CLIENT_ID
                        client_secret = $Script:CLIENT_SECRET
                        grant_type = 'authorization_code'
                        redirect_uri = $Script:REDIRECT_URI
                    }
                    $token = Invoke-RestMethod -Uri ('{0}/oauth/token' -f $Script:API_URI) -Method Post -Body $body -Headers $Script:DEFAULT_HEADERS
                } else {
                    $token = Import-Clixml -Path $Script:ACCESS_TOKEN_PATH

                    $today = [DateTime]::Now
                    
                    $expires = ($token.created_at | ConvertFrom-EpochDate).AddSeconds($token.expires_in)

                    if ($expires -le $today) {
                        $body = ConvertTo-Json -InputObject @{
                            refresh_token = $token.refresh_token
                            client_id = $Script:CLIENT_ID
                            client_secret = $Script:CLIENT_SECRET
                            grant_type = 'refresh_token'
                            redirect_uri = $Script:REDIRECT_URI
                        }
                        $token = Invoke-RestMethod -Uri ('{0}/oauth/token' -f $Script:API_URI) -Method Post -Body $body -Headers $Script:DEFAULT_HEADERS
                    }
                }
                
                $token
            } catch {
                throw $_
            }
        }

        function SaveToken {
            Param (
                [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
                [Object]
                $Token
            )
            
            try {
                $Token | Export-Clixml -Path $Script:ACCESS_TOKEN_PATH
                $Token
            } catch {
                throw $_
            }
        }

        function SetToken {
            Param (
                [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
                [Object]
                $Token
            )
            
            try {
                $Script:ACCESS_TOKEN = $Token
                $Token
            } catch {
                throw $_
            }
        }

    }
    
    process {
        GetToken | SaveToken | SetToken
    }
}