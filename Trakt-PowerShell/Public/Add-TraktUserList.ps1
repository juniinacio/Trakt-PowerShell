<#
.Synopsis
    Returns all custom lists for a user.
.DESCRIPTION
    Returns all custom lists for a user.
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
function Add-TraktUserList
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id,

        # Name help description
        [Parameter(Mandatory=$true)]
        [String]
        $Name,

        # Description help description
        [Parameter(Mandatory=$false)]
        [String]
        $Description,

        # Privacy help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('private', 'friends', 'public')]
        [String]
        $Privacy = 'private',

        # DisplayNumbers help description
        [Parameter(Mandatory=$false)]
        [bool]
        $DisplayNumbers = $false,

        # AllowComments help description
        [Parameter(Mandatory=$false)]
        [bool]
        $AllowComments = $true
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/lists/create-custom-list

        $uri = 'users/{0}/lists' -f $Id

        $postData = @{}

        $postData.name = $Name

        if ($PSBoundParameters.ContainsKey('Description')) {
            $postData.description = $Description
        }

        if ($PSBoundParameters.ContainsKey('Privacy')) {
            $postData.privacy = $Privacy
        }

        if ($PSBoundParameters.ContainsKey('DisplayNumbers')) {
            $postData.display_numbers = $DisplayNumbers
        }

        if ($PSBoundParameters.ContainsKey('AllowComments')) {
            $postData.allow_comments = $AllowComments
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) -PostData $postData |
        ForEach-Object {
            $_ | ConvertTo-TraktList
        }
    }
}