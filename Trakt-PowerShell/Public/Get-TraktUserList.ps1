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
function Get-TraktUserList
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id,

        # ListId help description
        [Parameter(Mandatory=$false)]
        [String]
        $ListId
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/lists/get-a-user's-custom-lists

        $uri = 'users/{0}/lists' -f $Id

        if ($PSBoundParameters.ContainsKey('Description')) {
            $uri = 'users/{0}/lists/{1}' -f $Id, $ListId
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktList
        }
    }
}