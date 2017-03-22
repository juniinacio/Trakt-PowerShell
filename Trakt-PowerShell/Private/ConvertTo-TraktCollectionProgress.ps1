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
function ConvertTo-TraktCollectionProgress {
    [CmdletBinding()]
    [OutputType([Object])]
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
            Aired = $InputObject.aired
            Completed = $InputObject.completed
            Seasons = $InputObject.seasons | ConvertTo-TraktSeason -ParentObject $ParentObject
            HiddenSeasons = $InputObject.hidden_seasons
            NextEpisode = $InputObject.next_episode
            LastCollectedAt = ''
        }

        if ($propertyNames -contains 'last_collected_at') {
            if (-not [string]::IsNullOrEmpty($InputObject.last_collected_at)) {
                $newProperties.LastCollectedAt = $InputObject.last_collected_at | ConvertTo-LocalTime
            }
        }        

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Collection.Progess')
        $psco
    }
}