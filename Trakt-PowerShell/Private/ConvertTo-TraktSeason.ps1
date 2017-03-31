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
function ConvertTo-TraktSeason {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        $InputObject,

        # Param1 help description
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        $ParentObject
    )
    
    process {
        $propertyNames = $InputObject | Get-Member -MemberType properties |
        Where-Object {
            $_.MemberType -eq 'Property' -or $_.MemberType -eq 'NoteProperty'
        } |
        Select-Object -ExpandProperty Name

        $newProperties = @{
            Number = $InputObject.number
            IDs = $InputObject.ids
            Parent = $ParentObject
        }

        if ($propertyNames -contains 'rating') {
            $newProperties.Rating = $InputObject.rating
        }

        if ($propertyNames -contains 'votes') {
            $newProperties.Votes = $InputObject.votes
        }

        if ($propertyNames -contains 'episode_count') {
            $newProperties.EpisodeCount = $InputObject.episode_count
        }

        if ($propertyNames -contains 'aired_episodes') {
            $newProperties.AiredEpisodes = $InputObject.aired_episodes
        }

        if ($propertyNames -contains 'title') {
            $newProperties.Title = $InputObject.title
        }

        if ($propertyNames -contains 'overview') {
            $newProperties.Overview = $InputObject.overview
        }

        if ($propertyNames -contains 'first_aired') {
            $newProperties.FirstAired = $InputObject.first_aired
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Season')
        $psco
    }
}