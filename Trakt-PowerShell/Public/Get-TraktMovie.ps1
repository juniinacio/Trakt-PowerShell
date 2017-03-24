<#
.Synopsis
    Gets all movies information from Trakt.TV.
.DESCRIPTION
    Gets all movies information from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktMovie -Played
    
    Description
    -----------
    This example shows how to retrieve the most played movies from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktMovie -Summary -Id "tron-legacy-2010"

    Description
    -----------
    This example shows how to retrieve the movie information for Tron Legacy from Trakt.TV.
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
function Get-TraktMovie
{
    [CmdletBinding(DefaultParameterSetName='TrendingMovies')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Trending help description
        [Parameter(ParameterSetName='TrendingMovies')]
        [Switch]
        $Trending,
        
        # Popular help description
        [Parameter(ParameterSetName='PopularMovies')]
        [Switch]
        $Popular,
        
        # Played help description
        [Parameter(ParameterSetName='MostPlayedMovies')]
        [Switch]
        $Played,
        
        # Watched help description
        [Parameter(ParameterSetName='MostWatchedMovies')]
        [Switch]
        $Watched,
        
        # Collected help description
        [Parameter(ParameterSetName='MostCollectedMovies')]
        [Switch]
        $Collected,
        
        # Anticipated help description
        [Parameter(ParameterSetName='MostAnticipatedMovies')]
        [Switch]
        $Anticipated,
        
        # BoxOffice help description
        [Parameter(ParameterSetName='TheWeekendBoxOffice')]
        [Switch]
        $BoxOffice,
        
        # Updates help description
        [Parameter(ParameterSetName='RecentlyUpdatedMovies')]
        [Switch]
        $Updates,
        
        # Summary help description
        [Parameter(ParameterSetName='ASingleMovie')]
        [Switch]
        $Summary,
        
        # Aliases help description
        [Parameter(ParameterSetName='AllMovieAliases')]
        [Switch]
        $Aliases,
        
        # Releases help description
        [Parameter(ParameterSetName='AllMovieReleases')]
        [Switch]
        $Releases,
        
        # Translations help description
        [Parameter(ParameterSetName='AllMovieTranslations')]
        [Switch]
        $Translations,
        
        # Comments help description
        [Parameter(ParameterSetName='AllMovieComments')]
        [Switch]
        $Comments,

        # Comments help description
        [Parameter(ParameterSetName='ListsContainingThisMovie')]
        [Switch]
        $Lists,
        
        # People help description
        [Parameter(ParameterSetName='AllPeopleForAMovie')]
        [Switch]
        $People,
        
        # Ratings help description
        [Parameter(ParameterSetName='MovieRatings')]
        [Switch]
        $Ratings,
        
        # Related help description
        [Parameter(ParameterSetName='RelatedMovies')]
        [Switch]
        $Related,
        
        # Stats help description
        [Parameter(ParameterSetName='MovieStats')]
        [Switch]
        $Stats,
        
        # Watching help description
        [Parameter(ParameterSetName='UsersWatchingRightNow')]
        [Switch]
        $Watching,
        
        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='ASingleMovie')]
        [Parameter(Mandatory=$true, ParameterSetName='AllMovieAliases')]
        [Parameter(Mandatory=$true, ParameterSetName='AllMovieReleases')]
        [Parameter(Mandatory=$true, ParameterSetName='AllMovieTranslations')]
        [Parameter(Mandatory=$true, ParameterSetName='AllMovieComments')]
        [Parameter(Mandatory=$true, ParameterSetName='ListsContainingThisMovie')]
        [Parameter(Mandatory=$true, ParameterSetName='AllPeopleForAMovie')]
        [Parameter(Mandatory=$true, ParameterSetName='MovieRatings')]
        [Parameter(Mandatory=$true, ParameterSetName='RelatedMovies')]
        [Parameter(Mandatory=$true, ParameterSetName='MovieStats')]
        [Parameter(Mandatory=$true, ParameterSetName='UsersWatchingRightNow')]
        [String]
        $Id,
        
        # Country help description
        [Parameter(Mandatory=$false, ParameterSetName='AllMovieReleases')]
        [ValidateScript({$_.Length -eq 2})]
        [String]
        $Country,
        
        # Country help description
        [Parameter(Mandatory=$false, ParameterSetName='AllMovieTranslations')]
        [ValidateScript({$_.Length -eq 2})]
        [String]
        $Language,
        
        # StartDate help description
        [Parameter(Mandatory=$false, ParameterSetName='RecentlyUpdatedMovies')]
        [DateTime]
        $StartDate,
        
        # Period help description
        [Parameter(Mandatory=$false, ParameterSetName='MostPlayedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostWatchedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostCollectedMovies')]
        [ValidateSet('weekly', 'monthly', 'yearly', 'all')]
        [String]
        $Period = 'weekly',

        # Type help description
        [Parameter(Mandatory=$false, ParameterSetName='ListsContainingThisMovie')]
        [ValidateSet('all', 'personal', 'official', 'watchlists')]
        [String]
        $Type,

        # Sort help description
        [Parameter(Mandatory=$false, ParameterSetName='ListsContainingThisMovie')]
        [ValidateSet('newest', 'oldest', 'likes', 'replies')]
        [String]
        $Sort,
        
        # Page help description
        [Parameter(Mandatory=$false, ParameterSetName='TrendingMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='PopularMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostPlayedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostWatchedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostCollectedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostAnticipatedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='RecentlyUpdatedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='AllMovieComments')]
        [Parameter(Mandatory=$false, ParameterSetName='ListsContainingThisMovie')]
        [Parameter(Mandatory=$false, ParameterSetName='RelatedMovies')]
        [Int]
        $Page = 1,
        
        # Limit help description
        [Parameter(Mandatory=$false, ParameterSetName='TrendingMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='PopularMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostPlayedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostWatchedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostCollectedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='MostAnticipatedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='RecentlyUpdatedMovies')]
        [Parameter(Mandatory=$false, ParameterSetName='AllMovieComments')]
        [Parameter(Mandatory=$false, ParameterSetName='ListsContainingThisMovie')]
        [Parameter(Mandatory=$false, ParameterSetName='RelatedMovies')]
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
        # LINK: http://docs.trakt.apiary.io/#reference/movies
        
        switch ($PSCmdlet.ParameterSetName)
        {
            TrendingMovies { $uri = 'movies/trending' }
            PopularMovies { $uri = 'movies/popular' }
            MostPlayedMovies { $uri = 'movies/played/{0}' -f $Period.ToLower() }
            MostWatchedMovies { $uri = 'movies/watched/{0}' -f $Period.ToLower() }
            MostCollectedMovies { $uri = 'movies/collected/{0}' -f $Period.ToLower() }
            MostAnticipatedMovies { $uri = 'movies/anticipated' }
            TheWeekendBoxOffice { $uri = 'movies/boxoffice' }
            RecentlyUpdatedMovies {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    $uri = 'movies/updates/{0}' -f $StartDate.ToString('yyyy-MM-dd')
                } else {
                    $uri = 'movies/updates'
                }
            }
            ASingleMovie { $uri = 'movies/{0}' -f $Id }
            AllMovieAliases { $uri = 'movies/{0}/aliases' -f $Id }
            AllMovieReleases {
                if ($PSBoundParameters.ContainsKey('Country')) {
                    $uri = 'movies/{0}/releases/{1}' -f $Id, $Country
                } else {
                    $uri = 'movies/{0}/releases' -f $Id
                }
            }
            AllMovieTranslations {
                if ($PSBoundParameters.ContainsKey('Language')) {
                    $uri = 'movies/{0}/translations/{2}' -f $Id, $Language
                } else {
                    $uri = 'movies/{0}/translations' -f $Id
                }
            }
            AllMovieComments { $uri = 'movies/{0}/comments' -f $Id }
            ListsContainingThisMovie {
                if ($PSBoundParameters.ContainsKey('Type')) {
                    if ($PSBoundParameters.ContainsKey('Sort')) {
                        $uri = 'movies/{0}/lists/{1}/{2}' -f $Id, $Type, $Sort
                    } else {
                        $uri = 'movies/{0}/lists/{1}' -f $Id, $Type
                    }
                } else {
                    $uri = 'movies/{0}/lists' -f $Id
                }
            }
            AllPeopleForAMovie { $uri = 'movies/{0}/people' -f $Id }
            MovieRatings { $uri = 'movies/{0}/ratings' -f $Id }
            RelatedMovies { $uri = 'movies/{0}/related' -f $Id }
            MovieStats { $uri = 'movies/{0}/stats' -f $Id }
            UsersWatchingRightNow { $uri = 'movies/{0}/watching' -f $Id }
        }
        
        $parameters = @{}
        
        if ($PSBoundParameters.ContainsKey("Page")) {
            $parameters['page'] = $Page
        }

        if ($PSBoundParameters.ContainsKey("Limit")) {
            $parameters.limit = $Limit
        }

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $parameters.extended = $Extended
        }

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            if ($PSCmdlet.ParameterSetName -eq 'TrendingMovies') {
                $_ | ConvertTo-TraktTrendingMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'MostPlayedMovies') {
                $_ | ConvertTo-TraktPlayedMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'MostWatchedMovies' -or $PSCmdlet.ParameterSetName -eq 'MostCollectedMovies') {
                $_ | ConvertTo-TraktWatchedMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'MostAnticipatedMovies') {
                $_ | ConvertTo-TraktAnticipatedMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'TheWeekendBoxOffice') {
                $_ | ConvertTo-TraktBoxOfficeMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'RecentlyUpdatedMovies') {
                $_ | ConvertTo-TraktUpdatedMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'AllMovieAliases') {
                $_ | ConvertTo-TraktAliasesMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'AllMovieReleases') {
                $_ | ConvertTo-TraktReleasesMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'AllMovieTranslations') {
                $_ | ConvertTo-TraktTranslationsMovie
            } elseif ($PSCmdlet.ParameterSetName -eq 'AllMovieComments') {
                $_ | ConvertTo-TraktComment
            } elseif ($PSCmdlet.ParameterSetName -eq 'ListsContainingThisMovie') {
                $_ | ConvertTo-TraktList
            } elseif ($PSCmdlet.ParameterSetName -eq 'AllPeopleForAMovie') {
                $_ | ConvertTo-TraktPeople
            } elseif ($PSCmdlet.ParameterSetName -eq 'MovieRatings') {
                $_ | ConvertTo-TraktRating
            } elseif ($PSCmdlet.ParameterSetName -eq 'MovieStats') {
                $_ | ConvertTo-TraktStats
            } else {
                $_ | ConvertTo-TraktMovie
            }
        }
    }
}