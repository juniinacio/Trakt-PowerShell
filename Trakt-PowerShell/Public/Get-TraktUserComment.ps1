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
function Get-TraktUserComment
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id,

        # CommentType help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('all', 'reviews', 'shouts')]
        [String]
        $CommentType,

        # Type help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('all', 'movies', 'shows', 'seasons', 'episodes', 'lists')]
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
        # LINK: http://docs.trakt.apiary.io/#reference/users/comments/get-comments

        $uri = 'users/{0}' -f $Id
        if ($PSBoundParameters.ContainsKey('CommentType')) {
            if ($PSBoundParameters.ContainsKey('CommentType')) {
                $uri = 'users/{0}/comments/{1}/{2}' -f $Id, $CommentType, $Type
            } else {
                $uri = 'users/{0}/comments/{1}' -f $Id, $CommentType
            }
        }

        $parameters = @{}

        if ($Extended.IsPresent) {
            $parameters.extended = 'metadata'
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktUserComment
        }
    }
}