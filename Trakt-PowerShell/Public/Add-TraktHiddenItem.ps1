<#
.Synopsis
    Get hidden items for a section. This will return an array of standard media objects.
.DESCRIPTION
    Get hidden items for a section. This will return an array of standard media objects.
.EXAMPLE
    PS C:\> Get-TraktHiddenItem -InputObject 123

    Description
    -----------
    This example shows how to approve your pending follow reguests.
.EXAMPLE
    PS C:\> Get-TraktFollowerRequests | Get-TraktHiddenItem

    Description
    -----------
    This example shows how to approve all your pending follow reguests.
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
function Get-TraktHiddenItem
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Type help description
        [Parameter(Mandatory=$true)]
        [ValidateSet('calendar', 'progress_watched', 'progress_collected', 'recommendations')]
        [String]
        $Section,

        # Type help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('movie', 'show', 'season')]
        [String]
        $Type
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/hidden-items/get-hidden-items

        $uri = 'users/hidden/{0}' -f $Section

        $parameters = @{}
        
        if ($PSBoundParameters.ContainsKey("Type")) {
            $parameters['Type'] = $Type
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            $_
        }
    }
}