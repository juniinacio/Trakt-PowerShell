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
function Add-TraktComment
{
    [CmdletBinding(DefaultParameterSetName='PostAComment')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='PostAComment')]
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='PostAReplyForAComment')]
        [Object]
        $InputObject,

        # Comment help description
        [Parameter(Mandatory=$true, ParameterSetName='PostAComment')]
        [Parameter(Mandatory=$true, ParameterSetName='PostAReplyForAComment')]
        [ValidateScript({($_ -Split '\s' | Measure-Object).Count -ge 5})]
        [String]
        $Comment,

        # Spoiler help description
        [Parameter(Mandatory=$false, ParameterSetName='PostAComment')]
        [Parameter(Mandatory=$false, ParameterSetName='PostAReplyForAComment')]
        [Switch]
        $Spoiler,

        # Facebook help description
        [Parameter(Mandatory=$false, ParameterSetName='PostAComment')]
        [Switch]
        $Facebook,

        # Twitter help description
        [Parameter(Mandatory=$false, ParameterSetName='PostAComment')]
        [Switch]
        $Twitter,

        # Tumblr help description
        [Parameter(Mandatory=$false, ParameterSetName='PostAComment')]
        [Switch]
        $Tumblr,

        # Medium help description
        [Parameter(Mandatory=$false, ParameterSetName='PostAComment')]
        [Switch]
        $Medium,

        # Replies help description
        [Parameter(Mandatory=$true, ParameterSetName='PostAReplyForAComment')]
        [Switch]
        $Replies
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/comments/comments/post-a-comment

        $postData = @{}

        if ($PSCmdlet.ParameterSetName -eq 'PostAComment') {
            $uri = 'comments'

            if ($InputObject.PSObject.TypeNames -contains 'Trakt.Movie') {
                $newInputObject = $InputObject | ConvertFrom-TraktMovie
                $postData.movie = $newInputObject
            } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Show') {
                $newInputObject = $InputObject | ConvertFrom-TraktShow
                $postData.show = $newInputObject
            } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Season') {
                $newInputObject = $InputObject | ConvertFrom-TraktSeason
                $postData.season = $newInputObject
            } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Episode') {
                $newInputObject = $InputObject | ConvertFrom-TraktEpisode
                $postData.episode = $newInputObject
            } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.List' -or $InputObject.PSObject.TypeNames -contains 'Trakt.WatchList') {
                $newInputObject = $InputObject | ConvertFrom-TraktList
                $postData.list = $newInputObject
            } else {
                throw 'Unknown object type passed to the cmdlet.'
            }

            $sharing = @{
                facebook = $Facebook.IsPresent
                twitter = $Twitter.IsPresent
                tumblr = $Tumblr.IsPresent
                medium = $Medium.IsPresent
            }
            $postData.sharing = [PSCustomObject]$sharing
        } else {
            if ($InputObject.PSObject.TypeNames -contains 'Trakt.Comment') {
                $id = $InputObject.Id
            } elseif ($InputObject -is [int] -or $InputObject -is [string] -or $InputObject -is [long]) {
                $id = $InputObject
            } else {
                throw 'Unknown object type passed to the cmdlet.'
            }

            $uri = 'comments/{0}/replies' -f $id
        }

        $postData.comment = $Comment
        $postData.spoiler = $Spoiler.IsPresent

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) -PostData $postData |
        ForEach-Object {
            $_ | ConvertTo-TraktComment
        }
    }
}