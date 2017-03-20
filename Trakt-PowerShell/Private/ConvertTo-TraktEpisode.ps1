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
function ConvertTo-TraktEpisode {
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
            Season = $InputObject.season
            Number = $InputObject.number
            Title = $InputObject.title
            IDs = $InputObject.ids
            NumberABS  = $InputObject.number_abs
            Overview  = $InputObject.overview
            Rating  = $InputObject.rating
            Votes  = $InputObject.votes
            AvailableTranslations  = $InputObject.available_translations
            Runtime  = $InputObject.runtime
            Parent = $ParentObject
        }

        if ($propertyNames -contains 'first_aired') {
            $newProperties.FirstAired  = $InputObject.first_aired | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'updated_at') {
            $newProperties.UpdatedAt  = $InputObject.updated_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Episode')
        $psco
    }
}