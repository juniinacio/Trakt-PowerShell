<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function ConvertTo-TraktWatchList {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        $InputObject
    )
    
    process {
        $propertyNames = $InputObject | Get-Member -MemberType properties |
        Where-Object {
            $_.MemberType -eq 'Property' -or $_.MemberType -eq 'NoteProperty'
        } |
        Select-Object -ExpandProperty Name

        $newProperties = @{
            Rank = $InputObject.rank
            ListedAt = $InputObject.listed_at | ConvertTo-LocalTime
            Type = $InputObject.type
        }

        if ($propertyNames -contains 'movie') {
            $newProperties.Movie  = $InputObject.movie | ConvertTo-TraktMovie
        }

        if ($propertyNames -contains 'show') {
            $newProperties.Show  = $InputObject.show | ConvertTo-TraktShow
        }

        if ($propertyNames -contains 'season') {
            $newProperties.Season  = $InputObject.season | ConvertTo-TraktSeason -ParentObject $newProperties.Show
        }

        if ($propertyNames -contains 'episode') {
            $newProperties.Episode  = $InputObject.episode | ConvertTo-TraktEpisode -ParentObject $newProperties.Show
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.WatchList')
        $psco
    }
}