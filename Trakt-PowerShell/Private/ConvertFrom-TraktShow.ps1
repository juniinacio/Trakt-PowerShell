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
function ConvertFrom-TraktShow {
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
            seasons = $InputObject.Seasons | ForEach-Object {
                if ($_.Number -gt 0) {
                    [PSCustomObject]@{
                        watched_at = (Get-Date).ToUniversalTime().ToString()
                        number = $_.Number
                    }
                }
            }
        }

        if ($propertyNames -contains 'title') {
            $newProperties.title  = $InputObject.title
        }

        if ($propertyNames -contains 'year') {
            $newProperties.year  = $InputObject.year
        }

        if ($propertyNames -contains 'ids') {
            $newProperties.ids  = $InputObject.IDs
        }

        [PSCustomObject]$newProperties
    }
}