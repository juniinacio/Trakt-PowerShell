<#
.Synopsis
    Gets all collected items in a user's collection.
.DESCRIPTION
    Gets all collected items in a user's collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type movies

    Description
    -----------
    This example shows how to get all collected movies from your Trakt.TV collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type shows

    Description
    -----------
    This example shows how to get all collected shows from your Trakt.TV collection.
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
function Set-TraktComment
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject,

        # Like help description
        [Parameter(Mandatory=$false)]
        [Switch]
        $Like
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/comments/like/

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Comment') {
            $id = $InputObject.Id
        } else {
            $id = $InputObject
        }

        $uri = 'comments/{0}/like' -f $id

        $method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Delete
        if ($Like.IsPresent) {
            $method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Post
        }

        Invoke-Trakt -Uri $uri -Method $method
    }
}