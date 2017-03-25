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
function Get-TraktComment
{
    [CmdletBinding(DefaultParameterSetName='GetACommentOrReply')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='GetACommentOrReply')]
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='GetRepliesForAComment')]
        [Object]
        $InputObject,

        # Replies help description
        [Parameter(Mandatory=$true, ParameterSetName='GetRepliesForAComment')]
        [Switch]
        $Replies
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/comments/comment/get-a-comment-or-reply

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Comment') {
            $id = $InputObject.Id
        } else {
            $id = $InputObject
        }

        switch ($PSCmdlet.ParameterSetName)
        {
            GetACommentOrReply {
                $uri = 'comments/{0}' -f $id
            }

            GetRepliesForAComment {
                $uri = 'comments/{0}/replies' -f $id
            }
        }

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktComment
        }
    }
}