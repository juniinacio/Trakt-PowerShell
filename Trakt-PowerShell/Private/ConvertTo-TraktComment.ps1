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
function ConvertTo-TraktComment {
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
            Id = $InputObject.id
            Comment = $InputObject.comment
            Spoiler = $InputObject.spoiler
            Review = $InputObject.review
            ParentId = $InputObject.parent_id
            Replies = $InputObject.replies
            Likes = $InputObject.likes
            UserRating = $InputObject.user_rating
            User = $InputObject.user | ConvertTo-TraktUser
        }

        if ($propertyNames -contains 'created_at') {
            $newProperties.CreatedAt = $InputObject.created_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'updated_at') {
            $newProperties.UpdatedAt = $InputObject.updated_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.Comment')
        $psco
    }
}