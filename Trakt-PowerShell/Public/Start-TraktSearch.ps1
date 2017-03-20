<#
.Synopsis
    Returns all movies or shows a user has watched sorted by most plays.
.DESCRIPTION
    Returns all movies or shows a user has watched sorted by most plays.
.EXAMPLE
    PS C:\> Get-TraktWatched -Type movies
    
    Description
    -----------
    This example shows how to retrieve all movies watched from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktWatched -Movies -Id "bryan-cranston"
    
    Description
    -----------
    This example shows how to retrieve all episodes watched from Trakt.TV.
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
function Start-TraktSearch
{
    [CmdletBinding(DefaultParameterSetName='Summary')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # Type help description
        [Parameter(Mandatory=$true, ParameterSetName='TextQueryResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TraktIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='IMDBIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TMDBIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TVDBIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TVRageIDLookupResults')]
        [ValidateSet('movie', 'show', 'episode', 'person', 'list')]
        [String]
        $Type,

        # Query help description
        [Parameter(ParameterSetName='TextQueryResults')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Query,

        # Trakt help description
        [Parameter(ParameterSetName='TraktIDLookupResults')]
        [Switch]
        $Trakt,

        # IMDB help description
        [Parameter(ParameterSetName='IMDBIDLookupResults')]
        [Switch]
        $IMDB,

        # TMDB help description
        [Parameter(ParameterSetName='TMDBIDLookupResults')]
        [Switch]
        $TMDB,

        # TVDB help description
        [Parameter(ParameterSetName='TVDBIDLookupResults')]
        [Switch]
        $TVDB,

        # TVRage help description
        [Parameter(ParameterSetName='TVRageIDLookupResults')]
        [Switch]
        $TVRage,

        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='TraktIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='IMDBIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TMDBIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TVDBIDLookupResults')]
        [Parameter(Mandatory=$true, ParameterSetName='TVRageIDLookupResults')]
        [String]
        $Id
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/movies
        
        switch ($PSCmdlet.ParameterSetName)
        {
            TextQueryResults        { $uri = 'search/{0}' -f $Type }
            TraktIDLookupResults    { $uri = 'search/{0}/{1}' -f 'trakt', $Id }
            IMDBIDLookupResults     { $uri = 'search/{0}/{1}' -f 'imdb', $Id }
            TMDBIDLookupResults     { $uri = 'search/{0}/{1}' -f 'tmdb', $Id }
            TVDBIDLookupResults     { $uri = 'search/{0}/{1}' -f 'tvdb', $Id }
            TVRageIDLookupResults   { $uri = 'search/{0}/{1}' -f 'tvrage', $Id }
        }
        
        $parameters = @{}

        if ($PSCmdlet.ParameterSetName -eq 'TextQueryResults') {
            $parameters.query = $Query
        } else {
            $parameters.type = $Type
        }
            
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            $_ | ConvertTo-TraktSearch
        }
    }
}