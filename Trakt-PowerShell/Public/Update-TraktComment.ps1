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
function Update-TraktComment
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject,

        # Comment help description
        [Parameter(Mandatory=$true)]
        [String]
        $Comment,

        # Spoiler help description
        [Parameter(Mandatory=$false)]
        [Switch]
        $Spoiler
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/comments/comments/post-a-comment

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Comment') {
            $id = $InputObject.Id
        } else {
            $id = $InputObject
        }

        $uri = 'comments/{0}' -f $id

        $postData = @{}
        $postData.comment = $Comment
        $postData.spoiler = $Spoiler.IsPresent

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Put) -PostData $postData |
        ForEach-Object {
            $_ | ConvertTo-TraktComment
        }
    }
}