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
function ConvertTo-TraktFollowerRequest {
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
            User = $InputObject.user | ConvertTo-TraktUser
        }

        if ($propertyNames -contains 'id') {
            $newProperties.Id = $InputObject.id 
        }

        if ($propertyNames -contains 'requested_at') {
            $newProperties.RequestedAt = $InputObject.requested_at | ConvertTo-LocalTime
        }

        if ($propertyNames -contains 'followed_at') {
            $newProperties.FollowedAt  = $InputObject.followed_at | ConvertTo-LocalTime
        }

        $psco = [PSCustomObject]$newProperties
        $psco.PSObject.TypeNames.Insert(0, 'Trakt.FollowRequest')
        $psco
    }
}