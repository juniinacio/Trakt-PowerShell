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
function ConvertTo-TraktCrew {
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

        $newProperties = @{}

        if ($propertyNames -contains 'production') {
            $newProperties.Production = $InputObject.production | ConvertTo-TraktCrewMember
        }

        if ($propertyNames -contains 'art') {
            $newProperties.Art = $InputObject.art | ConvertTo-TraktCrewMember
        }

        if ($propertyNames -contains 'crew') {
            $newProperties.Crew = $InputObject.crew | ConvertTo-TraktCrewMember
        }

        if ($propertyNames -contains 'costume & make-up') {
            $newProperties.'Costume & Make-up' = $InputObject.'costume & make-up' | ConvertTo-TraktCrewMember
        }

        if ($propertyNames -contains 'directing') {
            $newProperties.Directing = $InputObject.directing | ConvertTo-TraktCrewMember
        }

        if ($propertyNames -contains 'writing') {
            $newProperties.Writing = $InputObject.writing | ConvertTo-TraktCrewMember
        }

        if ($propertyNames -contains 'camera') {
            $newProperties.Camera = $InputObject.Camera | ConvertTo-TraktCrewMember
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Crew')
        $psco
    }
}