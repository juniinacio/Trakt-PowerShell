<#
.Synopsis
    Gets last activity from Trakt.TV.
.DESCRIPTION
    Gets last activity from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktLastActivity
    
    Description
    -----------
    This example shows how to retrieve your last activity information from Trakt.TV.
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
function Get-TraktLastActivity
{
    [CmdletBinding(DefaultParameterSetName='Summary')]
    [OutputType([PSCustomObject])]
    Param ()
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/last-activities
        
        $uri = 'sync/last_activities'
        
        $parameters = @{}

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $parameters.extended = $Extended
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            $_ | ConvertTo-TraktLastActivity
        }
    }
}