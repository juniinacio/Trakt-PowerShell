<#
.Synopsis
    Unhide items for a specific section. Here's what type of items can unhidden for each section.

    Section             Objects
    calendar            movie, show 
    progress_watched    show, season 
    progress_collected  show, season 
    recommendations     movie, show 
.DESCRIPTION
    Unhide items for a specific section. Here's what type of items can unhidden for each section.

    Section             Objects
    calendar            movie, show 
    progress_watched    show, season 
    progress_collected  show, season 
    recommendations     movie, show 
.EXAMPLE
    PS C:\> Get-TraktHiddenItem -InputObject 123

    Description
    -----------
    This example shows how to approve your pending follow reguests.
.EXAMPLE
    PS C:\> Get-TraktFollowerRequests | Get-TraktHiddenItem

    Description
    -----------
    This example shows how to approve all your pending follow reguests.
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
function Remove-TraktUserHiddenItem
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Type help description
        [Parameter(Mandatory=$true)]
        [ValidateSet('calendar', 'progress_watched', 'progress_collected', 'recommendations')]
        [String]
        $Section,

        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject
    )

    begin {
        $uri = 'hidden/{0}/remove' -f $Section

        $postData = @{
            movies = @()
            shows = @()
            seasons = @()
        }
    }
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/remove-hidden-items/remove-hidden-items

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Movie') {
            $newInputObject = $InputObject | ConvertFrom-TraktMovie
            $postData.movies = $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Show') {
            $newInputObject = $InputObject | ConvertFrom-TraktShow
            $postData.shows = $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Season') {
            $newInputObject = $InputObject | ConvertFrom-TraktSeason
            $postData.seasons = $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.HiddenItem') {
            if ($InputObject.Type -eq 'movie') {
                $newInputObject = $InputObject.Movie | ConvertFrom-TraktMovie
                $postData.movies = $newInputObject
            } elseif ($InputObject.Type -eq 'show') {
                $newInputObject = $InputObject.Show | ConvertFrom-TraktShow
                $postData.shows = $newInputObject
            } elseif ($InputObject.Type -eq 'episode') {
                $newInputObject = $InputObject.Episode.Season | ConvertFrom-TraktSeason
                $postData.seasons = $newInputObject
            } else {
                throw 'Unknown object type passed to the cmdlet.'
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