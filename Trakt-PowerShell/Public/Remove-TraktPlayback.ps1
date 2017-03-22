<#
.Synopsis
    Remove a playback item from a user's playback progress list.
.DESCRIPTION
    Remove a playback item from a user's playback progress list.
.EXAMPLE
    PS C:\> Remove-TraktPlayback -Id 1375
    
    Description
    -----------
    This example shows how to remove the playback information for The Flash from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktPlayback | Remove-TraktPlayback
    
    Description
    -----------
    This example shows how to remove all the playback information from Trakt.TV.
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
function Remove-TraktPlayback
{
    [CmdletBinding(DefaultParameterSetName='Summary')]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Id
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/remove-playback/remove-a-playback-item

        if ($Id.GetType().Name -eq 'PSCustomObject') {
            $uri = 'sync/playback/{0}' -f $Id.Id
        } else {
            $uri = 'sync/playback/{0}' -f $Id
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Delete) |
        ForEach-Object {
            $_ | ConvertTo-TraktPlayback
        }
    }
}