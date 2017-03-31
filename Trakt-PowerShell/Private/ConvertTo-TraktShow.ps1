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
function ConvertTo-TraktShow {
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
        $properties = @{
            Title = $InputObject.title
            Year = $InputObject.year
            IDs = $InputObject.ids
            overview = $InputObject.overview
            FirstAired = $null
            Airs = ''
            Runtime = $InputObject.runtime
            Certification = $InputObject.certification
            Network = $InputObject.network
            Country = $InputObject.country
            Trailer = $InputObject.trailer
            Homepage = $InputObject.homepage
            Status = $textInfo.ToTitleCase($InputObject.status)
            Rating = $InputObject.rating
            Votes = $InputObject.votes
            UpdatedAt = $null
            Language = $InputObject.language
            AvailableTranslations = $InputObject.available_translations
            Genres = $InputObject.genres
            AiredEpisodes = $InputObject.aired_episodes
        }

        if (-not [string]::IsNullOrEmpty($InputObject.first_aired)) {
            $properties.FirstAired  = $InputObject.first_aired | ConvertTo-LocalTime
        }

        if ($InputObject.status -ne 'ended') {
            if ([string]::IsNullOrEmpty($InputObject.airs.day) -eq $false -and [string]::IsNullOrEmpty($InputObject.airs.time) -eq $false -and [string]::IsNullOrEmpty($InputObject.airs.timezone) -eq $false) {
                $properties.Airs = '{0} at {1} {2} time' -f $InputObject.airs.day, $InputObject.airs.time, $InputObject.airs.timezone
            }
        }

        if (-not [string]::IsNullOrEmpty($InputObject.updated_at)) {
            $properties.UpdatedAt  = $InputObject.updated_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$properties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Show')
        $psco
    }
}