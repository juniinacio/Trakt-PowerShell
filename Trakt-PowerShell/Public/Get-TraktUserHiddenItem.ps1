<#
.Synopsis
    Get hidden items for a section. This will return an array of standard media objects.
.DESCRIPTION
    Get hidden items for a section. This will return an array of standard media objects.
.EXAMPLE
    PS C:\> Get-TraktHiddenItem -Section recommendations

    Description
    -----------
    This example shows how to get all hidden recommendations.
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
function Get-TraktUserHiddenItem
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
            $_ | ConvertTo-TraktHiddenItem
        }
    }
}