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
function ConvertTo-TraktTranslationsShow {
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

        $newProperties = @{
            Title = $InputObject.title
            Overview = $InputObject.overview
            Tagline = $InputObject.tagline
            Language = $InputObject.language
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Translations.Show')
        $psco
    }
}