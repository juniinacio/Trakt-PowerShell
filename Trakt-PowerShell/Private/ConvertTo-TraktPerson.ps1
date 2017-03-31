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
function ConvertTo-TraktPerson {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        $InputObject
    )
    
    process {
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

        if ($propertyNames -contains 'birthday') {
            if (-not [string]::IsNullOrEmpty($InputObject.birthday)) {
                $newProperties.Birthday  = [DateTime]$InputObject.birthday
            }
        }

        if ($propertyNames -contains 'death') {
            if (-not [string]::IsNullOrEmpty($InputObject.death)) {
                $newProperties.Death  = [DateTime]$InputObject.death
            }
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Person')
        $psco
    }
}