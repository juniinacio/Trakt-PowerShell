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
function Set-TraktCheckin
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject,

        # Facebook help description
        [Parameter(Mandatory=$false)]
        [Switch]
        $Facebook,

        # Twitter help description
        [Parameter(Mandatory=$false)]
        [Switch]
        $Twitter,

        # Tumblr help description
        [Parameter(Mandatory=$false)]
        [Switch]
        $Tumblr,

        # Message help description
        [Parameter(Mandatory=$true)]
        [String]
        $Message,

        # VenueId help description
        [Parameter(Mandatory=$false)]
        [String]
        $VenueId,

        # VenueName help description
        [Parameter(Mandatory=$false)]
        [String]
        $VenueName
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/checkin/checkin/check-into-an-item

        $uri = 'checkin'

        $postData = @{
            app_version = $Script:APP_VERSION
            app_date = $Script:APP_DATE
            message = $Message
        }

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Movie') {
            $newInputObject = $InputObject | ConvertFrom-TraktMovie
            $postData.movie = $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Episode') {
            $newInputObject = $InputObject | ConvertFrom-TraktEpisode
            $postData.episode = $newInputObject
        } else {
            throw 'Unknown object type passed to the cmdlet.'
        }

        $sharing = @{
            facebook = $Facebook.IsPresent
            twitter = $Twitter.IsPresent
            tumblr = $Tumblr.IsPresent
        }
        $postData.sharing = [PSCustomObject]$sharing

        if ($PSBoundParameters.ContainsKey('VenueId')) {
            $postData.venue_id = $VenueId
        }

        if ($PSBoundParameters.ContainsKey('VenueName')) {
            $postData.venue_name = $VenueName
        }

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) -PostData $postData |
        ForEach-Object {
            $_ | ConvertTo-TraktCheckin
        }
    }
}