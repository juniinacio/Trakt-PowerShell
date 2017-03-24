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
function Get-TraktHistory
{
    [CmdletBinding(DefaultParameterSetName='AllTypesOfHistory')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Type help description
        [Parameter(Mandatory=$true, ParameterSetName='ASpecificTypeOfHistory')]
        [Parameter(Mandatory=$true, ParameterSetName='ASpecificHistory')]
        [ValidateSet('movies', 'shows', 'seasons', 'episodes')]
        [String]
        $Type,

        # Id help description
        [Parameter(Mandatory=$true, ParameterSetName='ASpecificHistory')]
        [String]
        $Id,

        # StartAt help description
        [Parameter(Mandatory=$false)]
        [String]
        $StartAt,

        # EndAt help description
        [Parameter(Mandatory=$false)]
        [String]
        $EndAt
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/sync/get-history/get-watched-history

        switch ($PSCmdlet.ParameterSetName)
        {
            AllTypesOfHistory {
                $uri = 'sync/history'
            }

            ASpecificTypeOfHistory {
                $uri = 'sync/history/{0}' -f $Type
            }

            ASpecificHistory {
                $uri = 'sync/history/{0}/{1}' -f $Type, $Id
            }
        }

        $parameters = @{}
        
        if ($PSBoundParameters.ContainsKey("StartAt")) {
            $parameters.start_at = $StartAt
        }

        if ($PSBoundParameters.ContainsKey("EndAt")) {
            $parameters.end_at = $EndAt
        }

        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            $_ | ConvertTo-TraktHistory
        }
    }
}