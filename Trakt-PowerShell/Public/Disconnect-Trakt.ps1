<#
.SYNOPSIS
    Creates a login session to the Trakt.TV website.
.DESCRIPTION
    Creates a login session to the Trakt.TV website.
.EXAMPLE
    PS C:\> Connect-Trakt

    Description
    -----------
    This example shows how to connect with Trakt.TV.
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