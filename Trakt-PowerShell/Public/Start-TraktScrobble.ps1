<#
.Synopsis
    Retrieves people information from Trakt.TV.
.DESCRIPTION
    Retrieves people information from Trakt.TV.
.EXAMPLE
    PS C:\> Get-People -ASinglePerson -Id "bryan-cranston"
    Description
    -----------
    This example shows how to retrieve information over Bryan Cranston.
.EXAMPLE
    PS C:\> Get-People -MovieCredits -Id "bryan-cranston"
    Description
    -----------
    This example shows how to retrieve the movie information for Tron Legacy.
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
    The functionality that best describes this cmdlet
#>
function Start-TraktScrobble
{
    [CmdletBinding(DefaultParameterSetName='StartWatchingMovieInMediaCenter')]
    [OutputType([PSCustomObject])]
    [Alias('Resume-TraktScrobble')]
    Param
    (
        # Movi help description
        [Parameter(Mandatory=$true, ParameterSetName='StartWatchingMovieInMediaCenter')]
        [System.Object]
        $Movie,

        # Episode help description
        [Parameter(Mandatory=$true, ParameterSetName='StartWatchingEpisodeInMediaCenter')]
        [System.Object]
        $Episode,

        # Progress help description
        [Parameter(Mandatory=$true)]
        [Double]
        $Progress
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/scrobble/start/start-watching-in-a-media-center

        $uri = 'scrobble/start'
        
        switch ($PSCmdlet.ParameterSetName)
        {
            StartWatchingMovieInMediaCenter {
                $postData = @{
                    movie = $Movie | ConvertFrom-TraktMovie
                    progress = $Progress
                    app_version = $Script:APP_VERSION
                    app_date = $Script:APP_DATE
                }
            }

            StartWatchingEpisodeInMediaCenter {
                $postData = @{
                    episode = $Episode | ConvertFrom-TraktEpisode
                    progress = $Progress
                    app_version = $Script:APP_VERSION
                    app_date = $Script:APP_DATE
                }
            }
        }

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) -PostData $postData |
        ForEach-Object {
            $_ | ConvertTo-TraktScrobble
        }
    }
}