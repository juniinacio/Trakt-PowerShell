<#
.Synopsis
    Gets episodes information from Trakt.TV.
.DESCRIPTION
    Gets episodes information from Trakt.TV.
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

        # Type help description
        [Parameter(Mandatory=$false, ParameterSetName='ListsContainingThisEpisode')]
        [ValidateSet('all', 'personal', 'official', 'watchlists')]
        [String]
        $Type,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )

    DynamicParam {
        if ($PSCmdlet.ParameterSetName -eq 'AllEpisodeComments' -or $PSCmdlet.ParameterSetName -eq 'ListsContainingThisEpisode') {
            $parameterName = 'Sort'

            $runtimeDefinedParameterDictionary = New-Object -TypeName 'System.Management.Automation.RuntimeDefinedParameterDictionary'

            $attributeCollection = New-Object -TypeName 'System.Collections.ObjectModel.Collection[System.Attribute]'

            $parameterAttribute = New-Object -TypeName 'System.Management.Automation.ParameterAttribute'
            $parameterAttribute.Mandatory = $false

            $attributeCollection.Add($parameterAttribute)

            if ($PSCmdlet.ParameterSetName -eq 'AllEpisodeComments') {
                $validValues = 'newest', 'oldest', 'likes', 'replies'
            } else {
                $validValues = 'popular', 'likes', 'comments', 'items', 'added', 'updated'
            }
            $validateSetAttribute = New-Object -TypeName 'System.Management.Automation.ValidateSetAttribute' -ArgumentList $validValues

            $attributeCollection.Add($validateSetAttribute)

            $runtimeDefinedParameter = New-Object -TypeName 'System.Management.Automation.RuntimeDefinedParameter' -ArgumentList ($parameterName, [string], $attributeCollection)
            $runtimeDefinedParameterDictionary.Add($parameterName, $runtimeDefinedParameter)

            return $runtimeDefinedParameterDictionary
        }
    }

    begin {
        $parentObject = Get-TraktSeason -Id $Id -Summary | Where-Object { $_.Number -eq $SeasonNumber }
    }
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/episodes
        
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
            if ($PSCmdlet.ParameterSetName -eq 'AllEpisodeComments') {
                $_ | ConvertTo-TraktComment
            } elseif ($PSCmdlet.ParameterSetName -eq 'ListsContainingThisEpisode') {
                $_ | ConvertTo-TraktList
            } elseif ($PSCmdlet.ParameterSetName -eq 'EpisodeRatings') {
                $_ | ConvertTo-TraktRating
            } elseif ($PSCmdlet.ParameterSetName -eq 'EpisodeStats') {
                $_ | ConvertTo-TraktStats
            } elseif ($PSCmdlet.ParameterSetName -eq 'UsersWatchingRightNow') {
                $_ | ConvertTo-TraktUser
            } else {
                $_ | ConvertTo-TraktEpisode -ParentObject $parentObject
            }
        }
    }
}