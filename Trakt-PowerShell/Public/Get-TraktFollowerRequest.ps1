<#
.Synopsis
    Lists your pending follow requests so you can either approve or deny them.
.DESCRIPTION
    Lists your pending follow requests so you can either approve or deny them.
.EXAMPLE
    PS C:\> Get-TraktFollowerRequests

    Description
    -----------
    This example shows how to get your pending follow reguests.
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
function Get-TraktFollowerRequest
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param ()
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/follower-requests/get-follow-requests

        $uri = 'users/requests'
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktFollowerRequest
        }
    }
}