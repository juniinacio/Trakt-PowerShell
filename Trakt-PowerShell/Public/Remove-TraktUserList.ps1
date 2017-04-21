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
function Remove-TraktUserList
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id,

        # ListId help description
        [Parameter(Mandatory=$true)]
        [Object]
        $ListId
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/list/delete-a-user's-custom-list

        $uri = 'users/{0}/lists/{1}' -f $Id, $ListId
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Delete)
    }
}