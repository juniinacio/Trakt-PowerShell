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
function ConvertTo-TraktActivity {
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

        if ($propertyNames -contains 'watched_at') {
            $newProperties.WatchedAt = $InputObject.watched_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'collected_at') {
            $newProperties.CollectedAt = $InputObject.collected_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'collected_at') {
            $newProperties.CollectedAt = $InputObject.collected_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'rated_at') {
            $newProperties.RatedAt = $InputObject.rated_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'watchlisted_at') {
            $newProperties.WatchlistedAt = $InputObject.watchlisted_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'commented_at') {
            $newProperties.CommentedAt = $InputObject.commented_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'paused_at') {
            $newProperties.PausedAt = $InputObject.paused_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'liked_at') {
            $newProperties.LikedAt = $InputObject.liked_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.LastActivity')
        $psco
    }
}