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
function Add-TraktRating
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject,

        # Rating help description
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateRange(1, 10)]
        [int]
        $Rating,

        # RatedAt help description
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateRange(1, 10)]
        [datetime]
        $RatedAt
    )

    begin {
        $uri = 'sync/ratings'

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
            $newInputObject.rating = $Rating
            if ($PSBoundParameters.ContainsKey('RatedAt')) {
                $newInputObject.RatedAt = $RatedAt.ToString('u')
            }
            $postData.movies += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Show') {
            $newInputObject = $InputObject | ConvertFrom-TraktShow
            $newInputObject.rating = $Rating
            if ($PSBoundParameters.ContainsKey('RatedAt')) {
                $newInputObject.RatedAt = $RatedAt.ToString('u')
            }
            $newInputObject.Remove('seasons')
            $postData.shows += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Episode') {
            $newInputObject = $InputObject | ConvertFrom-TraktEpisode
            $newInputObject.rating = $Rating
            if ($PSBoundParameters.ContainsKey('RatedAt')) {
                $newInputObject.RatedAt = $RatedAt.ToString('u')
            }
            $postData.episodes += $newInputObject
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