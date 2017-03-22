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
function Hide-TraktRecommendation
{
    [CmdletBinding(DefaultParameterSetName='MovieRecommendations')]
    [OutputType([PSCustomObject])]
    Param (
        # Movie help description
        [Parameter(ParameterSetName='MovieRecommendations')]
        [Switch]
        $Movies,

        # Shows help description
        [Parameter(ParameterSetName='ShowRecommendations')]
        [Switch]
        $Shows,

        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='MovieRecommendations')]
        [Parameter(Mandatory=$true, ParameterSetName='ShowRecommendations')]
        [String]
        $Id
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/recommendations
        
        switch ($PSCmdlet.ParameterSetName)
        {
            MovieRecommendations { $uri = 'recommendations/movies/{0}' -f $Id }
            ShowRecommendations { $uri = 'recommendations/shows/{0}'  -f $Id }
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Delete)
    }
}