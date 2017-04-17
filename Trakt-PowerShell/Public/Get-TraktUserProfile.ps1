<#
.Synopsis
    Get a user's profile information. If the user is private, info will only be returned if you send OAuth and are either that user or an approved follower.
.DESCRIPTION
    Get a user's profile information. If the user is private, info will only be returned if you send OAuth and are either that user or an approved follower.
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
function Get-TraktUserProfile
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/profile/get-user-profile

        $uri = 'users/{0}' -f $Id
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktUser
        }
    }
}