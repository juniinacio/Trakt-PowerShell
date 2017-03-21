<#
.Synopsis
    Gets all season information form TraktTV.
.DESCRIPTION
    Gets all season information form TraktTV.
.EXAMPLE
    PS C:\> Get-TraktSeason -Id "the-flash-2014" -Summary

    Description
    -----------
    This example shows how to retrieve season information for the show the flash from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktSeason -Id "the-flash-2014" -Season -SeasonNumber 2
    
    Description
    -----------
    This example shows how to retrieve a single season information for the show the flash from Trakt.TV.
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
function Get-TraktSeason
{
    [CmdletBinding(DefaultParameterSetName='AllSeasonsForAShow')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Summary help description
        [Parameter(ParameterSetName='AllSeasonsForAShow')]
        [Switch]
        $Summary,
        
        # Seasons help description
        [Parameter(ParameterSetName='SingleSeasonForAShow')]
        [Switch]
        $Season,
        
        # Comments help description
        [Parameter(ParameterSetName='AllSeasonComments')]
        [Switch]
        $Comments,

        # Lists help description
        [Parameter(ParameterSetName='ListsContainingThisSeason')]
        [Switch]
        $Lists,

        # Ratings help description
        [Parameter(ParameterSetName='SeasonRatings')]
        [Switch]
        $Ratings,

        # Stats help description
        [Parameter(ParameterSetName='SeasonStats')]
        [Switch]
        $Stats,

        # Watching help description
        [Parameter(ParameterSetName='UsersWatchingRightNow')]
        [Switch]
        $Watching,
        
        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='AllSeasonsForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='SingleSeasonForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='AllSeasonComments')]
        [Parameter(Mandatory=$true, ParameterSetName='ListsContainingThisSeason')]
        [Parameter(Mandatory=$true, ParameterSetName='SeasonRatings')]
        [Parameter(Mandatory=$true, ParameterSetName='SeasonStats')]
        [Parameter(Mandatory=$true, ParameterSetName='UsersWatchingRightNow')]
        [String]
        $Id,

        # SeasonNumber help description
        [Parameter(Mandatory=$true, ParameterSetName='SingleSeasonForAShow')]
        [Parameter(Mandatory=$true, ParameterSetName='AllSeasonComments')]
        [Parameter(Mandatory=$true, ParameterSetName='SeasonRatings')]
        [Int]
        $SeasonNumber,

        # Sort help description
        [Parameter(Mandatory=$false, ParameterSetName='AllSeasonComments')]
        [ValidateSet('newest', 'oldest', 'likes', 'replies')]
        [String]
        $Sort,

        # Type help description
        [Parameter(Mandatory=$false, ParameterSetName='ListsContianingThisShow')]
        [ValidateSet('all', 'personal', 'official', 'watchlists')]
        [String]
        $Type,

        # SeasonNumber help description
        [Parameter(Mandatory=$false, ParameterSetName='SingleSeasonForAShow')]
        [String]
        $Translations,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'SingleSeasonForAShow') {
            $parentObject = Get-TraktSeason -Id $Id -Summary | Where-Object { $_.Number -eq $SeasonNumber }
        } else {
            $parentObject = Get-TraktShow -Id $Id -Summary
        }
    }
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/movies
        
        switch ($PSCmdlet.ParameterSetName)
        {
            AllSeasonsForAShow { $uri = 'shows/{0}/seasons' -f $Id }
            SingleSeasonForAShow { $uri = 'shows/{0}/seasons/{1}' -f $Id, $SeasonNumber }
            AllSeasonComments {
                if ($PSBoundParameters.ContainsKey('Sort')) {
                    $uri = 'shows/{0}/seasons/{1}/comments/{2}' -f $Id, $SeasonNumber, $Sort
                } else {
                    $uri = 'shows/{0}/seasons/{1}/comments' -f $Id, $SeasonNumber
                }
            }
            ListsContainingThisSeason {
                if ($PSBoundParameters.ContainsKey('Type')) {
                    if ($PSBoundParameters.ContainsKey('Sort')) {
                        $uri = 'shows/{0}/seasons/{1}/lists/{2}/{3}' -f $Id, $SeasonNumber, $Type, $Sort
                    } else {
                        $uri = 'shows/{0}/seasons/{1}/lists/{2}' -f $Id, $SeasonNumber, $Type
                    }
                } else {
                    $uri = 'shows/{0}/seasons/{1}/lists' -f $Id, $SeasonNumber
                }
            }
            SeasonRatings { $uri = 'shows/{0}/seasons/{1}/ratings' -f $Id, $SeasonNumber }
            SeasonStats { $uri = 'shows/{0}/seasons/{1}/stats' -f $Id, $SeasonNumber }
            UsersWatchingRightNow { $uri = 'shows/{0}/seasons/{1}/watching' -f $Id, $SeasonNumber }
        }
        
        $parameters = @{}

        if ($PSBoundParameters.ContainsKey('Translations')) {
            $parameters.translations = $Translations
        }
        
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
            if ($PSCmdlet.ParameterSetName -eq 'SingleSeasonForAShow') {
                $_ | ConvertTo-TraktEpisode -ParentObject $parentObject
            } else {
                $_ | ConvertTo-TraktSeason -ParentObject $parentObject
            }
        }
    }
}