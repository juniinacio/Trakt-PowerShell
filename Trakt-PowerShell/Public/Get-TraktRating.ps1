<#
.Synopsis
    Gets all collected items in a user's collection.
.DESCRIPTION
    Gets all collected items in a user's collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type movies

    Description
    -----------
    This example shows how to get all collected movies from your Trakt.TV collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type shows

    Description
    -----------
    This example shows how to get all collected shows from your Trakt.TV collection.
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
function Get-TraktRating
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (   
        # Type help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('movies', 'shows', 'seasons', 'episodes', 'all')]
        [String]
        $Type,

        # Rating help description
        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 10)]
        [int]
        $Rating
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/get-ratings/get-ratings
                
        $uri = 'sync/ratings'

        if ($PSBoundParameters.ContainsKey('Type')) {
            if ($PSBoundParameters.ContainsKey('Rating')) {
                $uri = 'sync/ratings/{0}/{1}' -f $Type, $Rating
            } else {
                $uri = 'sync/ratings/{0}' -f $Type
            }
        }

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktRatings
        }
    }
}