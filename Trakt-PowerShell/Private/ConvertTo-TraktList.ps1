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
function ConvertTo-TraktList {
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
            Name = $InputObject.name
            Description = $InputObject.description
            Privacy = $InputObject.privacy
            DisplayNumbers = $InputObject.display_numbers
            AllowComments = $InputObject.allow_comments
            SortBy = $InputObject.sort_by
            SortHow = $InputObject.sort_how
            ItemCount = $InputObject.item_count
            CommentCount = $InputObject.comment_count
            Likes = $InputObject.likes
            IDs = $InputObject.ids
            User = $InputObject.user | ConvertTo-TraktUser
        }

        if ($propertyNames -contains 'created_at') {
            $newProperties.CreatedAt = $InputObject.created_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'updated_at') {
            $newProperties.UpdatedAt = $InputObject.updated_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.List')
        $psco
    }
}