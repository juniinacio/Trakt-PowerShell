<#
.Synopsis
    Gets all collected items in a user's collection.
.DESCRIPTION
    Gets all collected items in a user's collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type movies

    Description
    -----------
    This example shows how to get all collected movies from your Trakt.TV collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type shows

    Description
    -----------
    This example shows how to get all collected shows from your Trakt.TV collection.
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
function Remove-TraktRating
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject
    )

    begin {
        $uri = 'sync/ratings/remove'

        $postData = @{
            movies = @()
            shows = @()
            episodes = @()
        }
    }
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/add-to-collection/add-items-to-collection

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Movie') {
            $newInputObject = $InputObject | ConvertFrom-TraktMovie
            $postData.movies += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Show') {
            $newInputObject = $InputObject | ConvertFrom-TraktShow
            $newInputObject.Remove('seasons')
            $postData.shows += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Episode') {
            $newInputObject = $InputObject | ConvertFrom-TraktEpisode
            $postData.episodes += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Ratings') {
            switch ($InputObject.Type) {
                movie {
                    $newInputObject = $InputObject.Movie | ConvertFrom-TraktMovie
                    $postData.movies += $newInputObject
                }

                show {
                    $newInputObject = $InputObject.Show | ConvertFrom-TraktShow
                    $newInputObject.Remove('seasons')
                    $postData.shows += $newInputObject 
                }

                episode {
                    $newInputObject = $InputObject.Episode | ConvertFrom-TraktEpisode
                    $postData.episodes += $newInputObject 
                }
            }
        } else {
            throw 'Unknown object type passed to the cmdlet.'
        }
    }

    end {
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) -PostData $postData |
        ForEach-Object {
            $_
        }
    }
}