<#
.Synopsis
    Gets all collected items in a user's collection.
.DESCRIPTION
    Gets all collected items in a user's collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type movies

    Description
    -----------
    This example shows how to get all collected movies from your Trakt.TV collection.
.EXAMPLE
    PS C:\> Get-TraktCollection -Type shows

    Description
    -----------
    This example shows how to get all collected shows from your Trakt.TV collection.
.INPUTS
    None
.OUTPUTS
    PSCustomObject
.NOTES
    None
.COMPONENT
    None
.ROLE
    None
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function Remove-TraktCheckin
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/checkin/checkin/delete-any-active-checkins
        
        $uri = 'checkin'

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Delete) |
        ForEach-Object {
            $_
        }
    }
}