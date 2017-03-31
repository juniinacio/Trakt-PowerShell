<#
.Synopsis
    Get the user's settings so you can align your app's experience with what they're used to on the trakt website.
.DESCRIPTION
    Get the user's settings so you can align your app's experience with what they're used to on the trakt website.
.EXAMPLE
    PS C:\> Get-TraktUserSettings

    Description
    -----------
    This example shows how to get your user settings from Trakt.TV.
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
function Get-TraktUserSettings
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/users/settings/retrieve-settings

        $uri = 'users/settings'
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) |
        ForEach-Object {
            $_ | ConvertTo-TraktUserSettings
        }
    }
}