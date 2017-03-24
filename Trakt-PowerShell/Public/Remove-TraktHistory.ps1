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
function Remove-TraktHistory
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (   
        # InputObject help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object]
        $InputObject
    )

    begin {
        $uri = 'sync/history/remove'

        $postData = @{
            movies = @()
            shows = @()
            episodes = @()
            ids = @()
        }
    }
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/add-to-collection/add-items-to-collection

        if ($InputObject.PSObject.TypeNames -contains 'Trakt.Movie') {
            $newInputObject = $InputObject | ConvertFrom-TraktMovie
            $postData.movies += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Show') {
            $newInputObject = $InputObject | ConvertFrom-TraktShow
            $postData.shows += $newInputObject
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Season') {
            $InputObject.Episodes | ConvertFrom-TraktEpisode | ForEach-Object {
                $postData.episodes += $_
            }
        } elseif ($InputObject.PSObject.TypeNames -contains 'Trakt.Episode') {
            $newInputObject = $InputObject | ConvertFrom-TraktEpisode
            $postData.episodes += $newInputObject
        } elseif ($InputObject -is [String] -or $InputObject -is [int] -or $InputObject -is [long] -or $InputObject.PSObject.TypeNames -contains 'Trakt.History') {
            if ($InputObject.PSObject.TypeNames -contains 'Trakt.History') {
                $postData.ids += $InputObject.Id
            } else {
                $postData.ids += $InputObject
            }
        } else {
            throw 'Unknown object type passed to the cmdlet.'
        }
    }

    end {
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) -PostData $postData |
        ForEach-Object {
            $_ #| ConvertTo-TraktCollection
        }
    }
}