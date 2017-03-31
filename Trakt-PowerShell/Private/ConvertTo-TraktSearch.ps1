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
function ConvertTo-TraktSearch {
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
            Type = $textInfo.ToTitleCase($InputObject.type)
            Score = $InputObject.score
        }

        if ($propertyNames -contains 'movie') {
            $newProperties.Movie = $InputObject.movie | ConvertTo-TraktMovie
        }

        if ($propertyNames -contains 'show') {
            $newProperties.Show = $InputObject.show | ConvertTo-TraktShow
        }

        if ($propertyNames -contains 'episode') {
            $newProperties.Episode = $InputObject.episode | ConvertTo-TraktEpisode -ParentObject $newProperties.Show
        }

        if ($propertyNames -contains 'person') {
            $newProperties.Person = $InputObject.person | ConvertTo-TraktPerson
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Search')
        $psco
    }
}