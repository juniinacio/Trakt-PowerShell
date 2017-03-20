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
function ConvertTo-TraktLastActivity {
    [CmdletBinding()]
    [OutputType([Object])]
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
        $newProperties = @{
            All = $InputObject.all | ConvertTo-LocalTime
            Movies = $InputObject.movies | ConvertTo-TraktActivity
            Episodes = $InputObject.episodes | ConvertTo-TraktActivity
            Shows = $InputObject.shows | ConvertTo-TraktActivity
            Seasons = $InputObject.seasons | ConvertTo-TraktActivity
            Comments = $InputObject.comments | ConvertTo-TraktActivity
            Lists = $InputObject.lists | ConvertTo-TraktActivity
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.LastActivity')
        $psco
    }
}