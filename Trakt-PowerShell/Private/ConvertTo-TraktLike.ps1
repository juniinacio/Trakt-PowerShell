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
function ConvertTo-TraktLike {
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
            LikedAt = $InputObject.liked_at | ConvertTo-LocalTime
            Type = $InputObject.type
        }

        if ($propertyNames -contains 'comment') {
            $newProperties.Comment = $InputObject.comment | ConvertTo-TraktComment
        }

        if ($propertyNames -contains 'list') {
            $newProperties.List = $InputObject.list | ConvertTo-TraktList
        }

        if ($propertyNames -contains 'user') {
            $newProperties.User = $InputObject.user | ConvertTo-TraktUser
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Like')
        $psco
    }
}