<#
.Synopsis
    Gets all shows information form Trakt.TV.
.DESCRIPTION
    Gets all shows information form Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktShow -Popular

    Description
    -----------
    This example shows how to retrieve the most popular Shows from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktShow -Id "the-flash-2014" -Summary -Extended full
    
    Description
    -----------
    This example shows how to retrieve the show information for a single show from Trakt.TV including extended information.
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
function Get-TraktShow
{
    [CmdletBinding(DefaultParameterSetName='TrendingShows')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Trending help description
        [Parameter(ParameterSetName='TrendingShows')]
        [Switch]
        $Trending,
        
        # Popular help description
        [Parameter(ParameterSetName='PopularShows')]
        [Switch]
        $Popular,
        
        # Played help description
        [Parameter(ParameterSetName='MostPlayedShows')]
        [Switch]
        $Played,
        
        # Watched help description
        [Parameter(ParameterSetName='MostWatchedShows')]
        [Switch]
        $Watched,
        
        # Collected help description
        [Parameter(ParameterSetName='MostCollectedShows')]
        [Switch]
        $Collected,
        
        # Anticipated help description
        [Parameter(ParameterSetName='MostAnticipatedShows')]
        [Switch]
        $Anticipated,
        
        # Updates help description
        [Parameter(ParameterSetName='RecentlyUpdatedShows')]
        [Switch]
        $Updates,
        
        # Summary help description
        [Parameter(ParameterSetName='ASingleShow')]
        [Switch]
        $Summary,
        
        # Aliases help description
        [Parameter(ParameterSetName='AllShowAliases')]
        [Switch]
        $Aliases,
        
        # Translations help description
        [Parameter(ParameterSetName='AllShowTranslations')]
        [Switch]
        $Translations,
        
        # Comments help description
        [Parameter(ParameterSetName='AllShowComments')]
        [Switch]
        $Comments,
        
        # Lists help description
        [Parameter(ParameterSetName='ListsContianingThisShow')]
        [Switch]
        $Lists,
        
        # CollectionProgress help description
        [Parameter(ParameterSetName='ShowCollectionProgress')]
        [Switch]
        $CollectionProgress,
        
        # WatchedProgress help description
        [Parameter(ParameterSetName='ShowWatchedProgress')]
        [Switch]
        $WatchedProgress,
        
        # People help description
        [Parameter(ParameterSetName='AllPeopleForAShow')]
        [Switch]
        $People,

        # Ratings help description
        [Parameter(ParameterSetName='ShowRatings')]
        [Switch]
        $Ratings,

        # Related help description
        [Parameter(ParameterSetName='RelatedShows')]
        [Switch]
        $Related,

        # Stats help description
        [Parameter(ParameterSetName='ShowStats')]
        [Switch]
        $Stats,

        # Watching help description
        [Parameter(ParameterSetName='UsersWatchingRightNow')]
        [Switch]
        $Watching,

        # NextEpisode help description
        [Parameter(ParameterSetName='NextEpisode')]
        [Switch]
        $NextEpisode,

        # LastEpisode help description
        [Parameter(ParameterSetName='LastEpisode')]
        [Switch]
        $LastEpisode,
        
        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='ASingleShow')]
        [Parameter(Mandatory=$true, ParameterSetName='AllShowAliases')]
        [Parameter(Mandatory=$true, ParameterSetName='AllShowReleases')]
        [Parameter(Mandatory=$true, ParameterSetName='AllShowTranslations')]
        [Parameter(Mandatory=$true, ParameterSetName='AllShowComments')]
        [Parameter(Mandatory=$true, ParameterSetName='ListsContianingThisShow')]
        [Parameter(Mandatory=$true, ParameterSetName='ShowCollectionProgress')]
        [Parameter(Mandatory=$true, ParameterSetName='ShowWatchedProgress')]
        [Parameter(Mandatory=$true, ParameterSetName='AllPeopleForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='ShowRatings')]
        [Parameter(Mandatory=$true, ParameterSetName='RelatedShows')]
        [Parameter(Mandatory=$true, ParameterSetName='ShowStats')]
        [Parameter(Mandatory=$true, ParameterSetName='UsersWatchingRightNow')]
        [Parameter(Mandatory=$true, ParameterSetName='NextEpisode')]
        [Parameter(Mandatory=$true, ParameterSetName='LastEpisode')]
        [String]
        $Id,
        
        # Country help description
        [Parameter(Mandatory=$false, ParameterSetName='AllShowReleases')]
        [ValidateScript({$_.Length -eq 2})]
        [String]
        $Country,
        
        # Country help description
        [Parameter(Mandatory=$true, ParameterSetName='AllShowTranslations')]
        [ValidateScript({$_.Length -eq 2})]
        [String]
        $Language,
        
        # StartDate help description
        [Parameter(Mandatory=$false, ParameterSetName='RecentlyUpdatedShows')]
        [DateTime]
        $StartDate,
        
        # Period help description
        [Parameter(Mandatory=$false, ParameterSetName='MostPlayedShows')]
        [Parameter(Mandatory=$false, ParameterSetName='MostWatchedShows')]
        [Parameter(Mandatory=$false, ParameterSetName='MostCollectedShows')]
        [ValidateSet('weekly', 'monthly', 'yearly', 'all')]
        [String]
        $Period,

        # Type help description
        [Parameter(Mandatory=$false, ParameterSetName='ListsContianingThisShow')]
        [ValidateSet('all', 'personal', 'official', 'watchlists')]
        [String]
        $Type,

        # Sort help description
        [Parameter(Mandatory=$false, ParameterSetName='MostPlayedShows')]
        [Parameter(Mandatory=$false, ParameterSetName='ListsContianingThisShow')]
        [ValidateSet('newest', 'oldest', 'likes', 'replies')]
        [String]
        $Sort,
        
        # Page help description
        [Parameter(Mandatory=$false)]
        [Int]
        $Page = 1,
        
        # Limit help description
        [Parameter(Mandatory=$false)]
        [Int]
        $Limit = 10,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended = 'min'
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/Shows
        
        switch ($PSCmdlet.ParameterSetName)
        {
            TrendingShows { $uri = 'shows/trending' }
            PopularShows { $uri = 'shows/popular' }
            MostPlayedShows { $uri = 'shows/played/{0}' -f $Period.ToLower() }
            MostWatchedShows { $uri = 'shows/watched/{0}' -f $Period.ToLower() }
            MostCollectedShows { $uri = 'shows/collected/{0}' -f $Period.ToLower() }
            MostAnticipatedShows { $uri = 'shows/anticipated' }
            RecentlyUpdatedShows {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    $uri = 'shows/updates/{0}' -f $StartDate.ToString('yyyy-MM-dd')
                } else {
                    $uri = 'shows/updates'
                }
            }
            ASingleShow { $uri = 'shows/{0}' -f $Id }
            AllShowAliases { $uri = 'shows/{0}/aliases' -f $Id }
            AllShowTranslations { $uri = 'shows/{0}/translations/{2}' -f $Id, $Language }
            AllShowComments {
                if ($PSBoundParameters.ContainsKey('Sort')) {
                    $uri = 'shows/{0}/comments/{1}' -f $Id, $Sort
                } else {
                    $uri = 'shows/{0}/comments' -f $Id
                }
            }
            ListsContianingThisShow {
                if ($PSBoundParameters.ContainsKey('Type')) {
                    if ($PSBoundParameters.ContainsKey('Sort')) {
                        $uri = 'shows/{0}/lists/{1}/{2}' -f $Id, $Type, $Sort
                    } else {
                        $uri = 'shows/{0}/lists/{1}' -f $Id, $Type
                    }
                } else {
                    $uri = 'shows/{0}/comments' -f $Id
                }
            }
            ShowCollectionProgress { $uri = 'shows/{0}/progress/collection' -f $Id }
            ShowWatchedProgress { $uri = 'shows/{0}/progress/watched' -f $Id }
            AllPeopleForAShow { $uri = 'shows/{0}/people' -f $Id }
            ShowRatings { $uri = 'shows/{0}/ratings' -f $Id }
            RelatedShows { $uri = 'shows/{0}/related' -f $Id }
            ShowStats { $uri = 'shows/{0}/stats' -f $Id }
            UsersWatchingRightNow { $uri = 'shows/{0}/watching' -f $Id }
            NextEpisode { $uri = 'shows/{0}/next_episode' -f $Id }
            LastEpisode { $uri = 'shows/{0}/last_episode' -f $Id }
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
            if ($_.Show -ne $null -and $PSCmdlet.ParameterSetName -ne 'MostPlayedShows') {
                $_.Show | ConvertTo-TraktShow
            } elseif ($PSCmdlet.ParameterSetName -eq 'MostPlayedShows') {
                $_ | ConvertTo-TraktPlayed
            } else {
                $_ | ConvertTo-TraktShow
            }
        }
    }
}