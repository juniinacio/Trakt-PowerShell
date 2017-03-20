<#
.Synopsis
    Retrieves Seasons information from Trakt.TV.
.DESCRIPTION
    Retrieves Seasons information from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktEpisode -Summary -Id "the-flash-2014" -SeasonNumber 2 -EpisodeNumber 1 -Extended full
    
    Description
    -----------
    This example shows how to retrieve a single episode information for the flash from Trakt.TV.
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
function Get-TraktEpisode
{
    [CmdletBinding(DefaultParameterSetName='ASingleEpisodeForAShow')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Summary help description
        [Parameter(ParameterSetName='ASingleEpisodeForAShow')]
        [Switch]
        $Summary,
        
        # Translations help description
        [Parameter(ParameterSetName='AllEpisodeTranslations')]
        [Switch]
        $Translations,
        
        # Comments help description
        [Parameter(ParameterSetName='AllEpisodeComments')]
        [Switch]
        $Comments,

        # Lists help description
        [Parameter(ParameterSetName='ListsContainingThisEpisode')]
        [Switch]
        $Lists,

        # Ratings help description
        [Parameter(ParameterSetName='EpisodeRatings')]
        [Switch]
        $Ratings,

        # Stats help description
        [Parameter(ParameterSetName='EpisodeStats')]
        [Switch]
        $Stats,

        # Watching help description
        [Parameter(ParameterSetName='UsersWatchingRightNow')]
        [Switch]
        $Watching,
        
        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='ASingleEpisodeForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeTranslations')]
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeComments')]
        [Parameter(Mandatory=$true, ParameterSetName='ListsContainingThisEpisode')]
        [Parameter(Mandatory=$true, ParameterSetName='EpisodeRatings')]
        [Parameter(Mandatory=$true, ParameterSetName='EpisodeStats')]
        [Parameter(Mandatory=$true, ParameterSetName='UsersWatchingRightNow')]
        [String]
        $Id,

        # SeasonNumber help description
        [Parameter(Mandatory=$true, ParameterSetName='ASingleEpisodeForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeTranslations')]
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeComments')]
        [Parameter(Mandatory=$true, ParameterSetName='ListsContainingThisEpisode')]
        [Parameter(Mandatory=$true, ParameterSetName='EpisodeRatings')]
        [Parameter(Mandatory=$true, ParameterSetName='EpisodeStats')]
        [Parameter(Mandatory=$true, ParameterSetName='UsersWatchingRightNow')]
        [Int]
        $SeasonNumber,

        # EpisodeNumber help description
        [Parameter(Mandatory=$true, ParameterSetName='ASingleEpisodeForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeTranslations')]
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeComments')]
        [Parameter(Mandatory=$true, ParameterSetName='ListsContainingThisEpisode')]
        [Parameter(Mandatory=$true, ParameterSetName='EpisodeRatings')]
        [Parameter(Mandatory=$true, ParameterSetName='EpisodeStats')]
        [Parameter(Mandatory=$true, ParameterSetName='UsersWatchingRightNow')]
        [Int]
        $EpisodeNumber,

        # Language help description
        [Parameter(Mandatory=$true, ParameterSetName='AllEpisodeTranslations')]
        [string]
        $Language,

        # Sort help description
        [Parameter(Mandatory=$false, ParameterSetName='AllEpisodeComments')]
        [ValidateSet('newest', 'oldest', 'likes', 'replies')]
        [String]
        $Sort,

        # Type help description
        [Parameter(Mandatory=$false, ParameterSetName='ListsContianingThisShow')]
        [ValidateSet('all', 'personal', 'official', 'watchlists')]
        [String]
        $Type,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )

    begin {
        $parentObject = Get-TraktSeason -Id $Id -Summary | Where-Object { $_.Number -eq $SeasonNumber }
    }
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/movies
        
        switch ($PSCmdlet.ParameterSetName)
        {
            ASingleEpisodeForAShow { $uri = 'shows/{0}/seasons/{1}/episodes/{2}' -f $Id, $SeasonNumber, $EpisodeNumber }
            AllEpisodeTranslations {
                if ($PSBoundParameters.ContainsKey('Language')) {
                    $uri = 'shows/{0}/seasons/{1}/episodes/{2}/translations/{3}' -f $Id, $SeasonNumber, $EpisodeNumber, $Language
                } else {
                    $uri = 'shows/{0}/seasons/{1}/episodes/{2}/translations' -f $Id, $SeasonNumber, $EpisodeNumber
                }
            }
            AllEpisodeComments {
                if ($PSBoundParameters.ContainsKey('Sort')) {
                    $uri = 'shows/{0}/seasons/{1}/episodes/{2}/comments/{3}' -f $Id, $SeasonNumber, $EpisodeNumber, $Sort
                } else {
                    $uri = 'shows/{0}/seasons/{1}/episodes/{2}/comments' -f $Id, $SeasonNumber, $EpisodeNumber
                }
            }
            ListsContainingThisEpisode {
                if ($PSBoundParameters.ContainsKey('Type')) {
                    if ($PSBoundParameters.ContainsKey('Sort')) {
                        $uri = 'shows/{0}/seasons/{1}/episodes/{2}/lists/{3}/{4}' -f $Id, $SeasonNumber, $EpisodeNumber, $Type, $Sort
                    } else {
                        $uri = 'shows/{0}/seasons/{1}/episodes/{2}/lists/{3}' -f $Id, $SeasonNumber, $EpisodeNumber, $Type
                    }
                } else {
                    $uri = 'shows/{0}/seasons/{1}/episodes/{2}/lists' -f $Id, $SeasonNumber, $EpisodeNumber
                }
            }
            EpisodeRatings { $uri = 'shows/{0}/seasons/{1}/episodes/{2}/ratings' -f $Id, $SeasonNumber, $EpisodeNumber }
            EpisodeStats { $uri = 'shows/{0}/seasons/{1}/episodes/{2}/stats' -f $Id, $SeasonNumber, $EpisodeNumber }
            UsersWatchingRightNow { $uri = 'shows/{0}/seasons/{1}/episodes/{2}/watching' -f $Id, $SeasonNumber, $EpisodeNumber }
        }
        
        $parameters = @{}
        
        if ($PSBoundParameters.ContainsKey("Page")) {
            $parameters.page = $Page
        }

        if ($PSBoundParameters.ContainsKey("Limit")) {
            $parameters.limit = $Limit
        }

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $parameters.extended = $Extended
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            $_ | ConvertTo-TraktEpisode -ParentObject $parentObject
        }
    }
}