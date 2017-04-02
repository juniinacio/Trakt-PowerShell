<#
.Synopsis
    Deny a follower using the id of the request. If the id is not found, was already approved, or was already denied, a 404 error will be returned.
.DESCRIPTION
    Deny a follower using the id of the request. If the id is not found, was already approved, or was already denied, a 404 error will be returned.
.EXAMPLE
    PS C:\> Deny-TraktFollowerRequests -InputObject 123

    Description
    -----------
    This example shows how to deny your pending follow reguests.
.EXAMPLE
    PS C:\> Get-TraktFollowerRequests | Deny-TraktFollowerRequests

    Description
    -----------
    This example shows how to deny all your pending follow reguests.
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
function Deny-TraktFollowerRequest
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/follower-requests/get-follow-requests

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.FollowerRequest') {
            $id = $InputObject.Id
        } elseif ($InputObject -is [int] -or $InputObject -is [string] -or $InputObject -is [long]) {
            $id = $InputObject
        } else {
            throw 'Unknown object type passed to the cmdlet.'
        }

        $uri = 'users/requests/{0}' -f $id
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Delete)
    }
}