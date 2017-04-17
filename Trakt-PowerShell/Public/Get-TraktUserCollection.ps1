<#
.Synopsis
    Get all collected items in a user's collection. A collected item indicates availability to watch digitally or on physical media.
.DESCRIPTION
    Get all collected items in a user's collection. A collected item indicates availability to watch digitally or on physical media.
.EXAMPLE
    PS C:\> Get-TraktUserProfile -Id 'sean'
    
    Description
    -----------
    This example shows how to retrieve the user profile information from sean from Trakt.TV.
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
function Get-TraktUserCollection
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id,

        # Type help description
        [Parameter(Mandatory=$true)]
        [ValidateSet('movies', 'shows')]
        [String]
        $Type,

        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/collection/get-collection

        $uri = 'users/{0}/collection/{1}' -f $Id, $Type

        $parameters = @{}

        if ($Extended.IsPresent) {
            $parameters.extended = 'metadata'
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            if ($Type -eq 'movies') {
                $_ | ConvertTo-TraktCollectionMovie
            } else {
                $_ | ConvertTo-TraktCollectionShow
            }
        }
    }
}