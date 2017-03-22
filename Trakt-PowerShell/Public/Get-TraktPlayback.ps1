<#
.Synopsis
    Gets all playback information from Trakt.TV.
.DESCRIPTION
    Gets all playback information from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktPlayback -Type movies
    
    Description
    -----------
    This example shows how to retrieve the movies playback information from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktPlayback -Type episodes
    
    Description
    -----------
    This example shows how to retrieve the episodes playback information from Trakt.TV.
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
function Get-TraktPlayback
{
    [CmdletBinding(DefaultParameterSetName='Summary')]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('movies', 'episodes')]
        [String]
        $Type
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/last-activities
        
        if ($PSBoundParameters.ContainsKey('Type')) {
            $uri = 'sync/playback/{0}' -f $Type
        } else {
            $uri = 'sync/playback'
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktPlayback
        }
    }
}