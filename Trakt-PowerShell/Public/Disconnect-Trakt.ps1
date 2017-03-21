<#
.SYNOPSIS
    Disconnects the module from Trakt.TV.
.DESCRIPTION
    Disconnects the module from Trakt.TV.
.EXAMPLE
    PS C:\> Disconnect-Trakt

    Description
    -----------
    This example shows how to disconnect from Trakt.TV.
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
    None
#>
function Disconnect-Trakt {
    [CmdletBinding()]
    [OutputType([Void])]
    Param ()
    
    process {
        if (Test-Path -Path $Script:ACCESS_TOKEN_PATH -PathType Leaf) {
            Remove-Item -Path $Script:ACCESS_TOKEN_PATH -Force -Confirm:$false
        }
    }
}