<#
.Synopsis
    Get items a user likes. This will return an array of standard media objects. You can optionally limit the type of results to return.
.DESCRIPTION
    Get items a user likes. This will return an array of standard media objects. You can optionally limit the type of results to return.
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
function Get-TraktUserLikes
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Type help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('comments', 'lists')]
        [String]
        $Type
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/remove-hidden-items/get-likes
        
        $uri = 'users/likes'
        if ($PSBoundParameters.ContainsKey('Type')) {
            $uri = 'users/likes/{0}' -f $Type
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktLike
        }
    }
}