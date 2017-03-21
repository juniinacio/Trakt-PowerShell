<#
.Synopsis
    Gets all recommendations from Trakt.TV.
.DESCRIPTION
    Gets all recommendations from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktRecommendation -Movies
    
    Description
    -----------
    This example shows how to retrieve all movie recommendations from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktRecommendation -Shows

    Description
    -----------
    This example shows how to retrieve all movie recommendations from Trakt.TV.
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
function Get-TraktRecommendation
{
    [CmdletBinding(DefaultParameterSetName='MovieRecommendations')]
    [OutputType([PSCustomObject])]
    Param (
        # Movie help description
        [Parameter(ParameterSetName='MovieRecommendations')]
        [Switch]
        $Movies,

        # HideMovie help description
        [Parameter(ParameterSetName='HideAMovieRecommendation')]
        [Switch]
        $HideMovie,

        # Shows help description
        [Parameter(ParameterSetName='ShowRecommendations')]
        [Switch]
        $Shows,

        # HideShow help description
        [Parameter(ParameterSetName='HideAShowRecommendation')]
        [Switch]
        $HideShow,

        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='HideAMovieRecommendation')]
        [Parameter(Mandatory=$true, ParameterSetName='HideAShowRecommendation')]
        [String]
        $Id,

        # Extended help description
        [Parameter(Mandatory=$false, ParameterSetName='MovieRecommendations')]
        [Parameter(Mandatory=$false, ParameterSetName='ShowRecommendations')]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/recommendations
        
        switch ($PSCmdlet.ParameterSetName)
        {
            MovieRecommendations { $uri = 'recommendations/movies' }
            HideAMovieRecommendation { $uri = 'recommendations/movies/{0}' -f $Id }
            ShowRecommendations { $uri = 'recommendations/shows' }
            HideAShowRecommendation { $uri = 'recommendations/shows/{0}' -f $Id }
        }
        
        $parameters = @{}

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $parameters.extended = $Extended
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            if ($PSCmdlet.ParameterSetName -like '*Movie*') {
                $_ | ConvertTo-TraktMovieRecommendation
            } else {
                $_ | ConvertTo-TraktShowRecommendation
            }
        }
    }
}