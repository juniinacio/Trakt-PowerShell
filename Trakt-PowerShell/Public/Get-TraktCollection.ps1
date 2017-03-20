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
function Get-TraktCollection
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # Type help description
        [Parameter(Mandatory=$true)]
        [ValidateSet('movies', 'shows')]
        [String]
        $Type,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [Switch]
        $Extended
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/get-collection/get-collection

        $uri = 'sync/collection/{0}' -f $Type
        
        $parameters = @{}

        if ($Extended.IsPresent) {
            $parameters.extended = 'metadata'
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            if ($Type -eq 'movies') {
                $_ | ConvertTo-TraktMovieCollection
            } else {
                $_ | ConvertTo-TraktShowCollection
            }
        }
    }
}