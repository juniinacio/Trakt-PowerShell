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
function ConvertTo-TraktMovie {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        $InputObject
    )
    
    process {
        $properties = @{
            Title = $InputObject.title
            Year = $InputObject.year
            IDs = $InputObject.ids
            Tagline  = $InputObject.tagline
            Overview = $InputObject.overview
            Released = $null
            Runtime = $InputObject.runtime
            Trailer = $InputObject.trailer
            Homepage = $InputObject.homepage
            Rating = $InputObject.rating
            Votes = $InputObject.votes
            UpdatedAt = $InputObject.updated_at
            Language = $InputObject.language
            AvailableTranslations = $InputObject.available_translations
            Genres = $InputObject.genres
            Certification = $InputObject.certification
        }

        if (-not [string]::IsNullOrEmpty($InputObject.released)) {
            $properties.Released  = $InputObject.released | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$properties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Movie')
        $psco
    }
}