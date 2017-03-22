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
function ConvertTo-TraktPeople {
    [CmdletBinding()]
    [OutputType([Object])]
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
            Name = $InputObject.name
            IDs = $InputObject.ids
        }

        if ($propertyNames -contains 'biography') {
            $newProperties.Biography  = $InputObject.biography
        }

        if ($propertyNames -contains 'birthplace') {
            $newProperties.Birthplace  = $InputObject.birthplace
        }

        if ($propertyNames -contains 'homepage') {
            $newProperties.Homepage  = $InputObject.homepage
        }

        if (-not [string]::IsNullOrEmpty($InputObject.birthday)) {
            $newProperties.Birthday  = [DateTime]$InputObject.birthday
        }

        if (-not [string]::IsNullOrEmpty($InputObject.death)) {
            $newProperties.Death  = [DateTime]$InputObject.death
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.People')
        $psco
    }
}