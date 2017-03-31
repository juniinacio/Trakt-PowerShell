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
function ConvertTo-TraktRecommendationShow {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        $InputObject
    )

    begin {
        $textInfo = (Get-Culture).TextInfo
    }
    
    process {
        $propertyNames = $InputObject | Get-Member -MemberType properties |
        Where-Object {
            $_.MemberType -eq 'Property' -or $_.MemberType -eq 'NoteProperty'
        } |
        Select-Object -ExpandProperty Name

        $newProperties = @{
            Title = $InputObject.title
            Year = $InputObject.year
            IDs = $InputObject.ids
            Overview = $InputObject.overview
            FirstAired = $InputObject.first_aired
            Airs = $InputObject.airs
            Runtime = $InputObject.runtime
            Certification = $InputObject.certification
            Network = $InputObject.network
            Country = $InputObject.country
            Trailer = $InputObject.trailer
            Homepage = $InputObject.homepage
            Status = $textInfo.ToTitleCase($InputObject.status)
            Rating = $InputObject.rating
            Votes = $InputObject.votes
            Language = $InputObject.language
            AvailableTranslations = $InputObject.available_translations
            Genres = $InputObject.genres
            AiredEpisodes = $InputObject.aired_episodes
        }

        if ($propertyNames -contains 'updated_at') {
            $newProperties.UpdatedAt = $InputObject.updated_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Recommendation.Show')
        $psco
    }
}