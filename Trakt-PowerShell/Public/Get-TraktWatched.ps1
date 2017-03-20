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
function Get-TraktWatched
{
    [CmdletBinding(DefaultParameterSetName='Summary')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # Id help description
        [Parameter(Mandatory=$true)]
        [ValidateSet('movies', 'shows')]
        [String]
        $Type,

        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('noseasons')]
        [String]
        $Extended = 'noseasons'
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/movies
        
        $uri = 'sync/watched/{0}' -f $Type
        
        $Parameters = @{}

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $Parameters.extended = $Extended
        }
            
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $Parameters |
        ForEach-Object {
            $_ | ConvertTo-TraktWatched
        }
    }
}