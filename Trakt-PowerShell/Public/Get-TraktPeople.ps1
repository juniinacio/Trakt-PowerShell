<#
.Synopsis
    Gets all peoples information from Trakt.TV.
.DESCRIPTION
    Gets all peoples information from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktPeople -Summary -Id "bryan-cranston"

    Description
    -----------
    This example shows how to retrieve people information over Bryan Cranston form Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktPeople -Movies -Id "bryan-cranston"

    Description
    -----------
    This example shows how to retrieve the movie credits for Bryan Cranston from Trakt.TV.
.EXAMPLE
    PS C:\> Get-TraktPeople -Shows -Id "bryan-cranston"

    Description
    -----------
    This example shows how to retrieve the show credits for the big bang theory from Trakt.TV.
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
function Get-TraktPeople
{
    [CmdletBinding(DefaultParameterSetName='ASinglePerson')]
    [OutputType([PSCustomObject])]
    Param
    (
        # Summary help description
        [Parameter(ParameterSetName='ASinglePerson')]
        [Switch]
        $Summary,
        
        # Movie help description
        [Parameter(ParameterSetName='MovieCredits')]
        [Switch]
        $Movies,
        
        # Shows help description
        [Parameter(ParameterSetName='ShowCredits')]
        [Switch]
        $Shows,
        
        # Id help description
        [Parameter(Mandatory=$true)]
        [String]
        $Id,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/people
        
        switch ($PSCmdlet.ParameterSetName)
        {
            ASinglePerson { $uri = 'people/{0}' -f $Id }
            MovieCredits { $uri = 'people/{0}/movies' -f $Id }
            ShowCredits { $uri = 'people/{0}/shows' -f $Id }
        }
        
        $parameters = @{}

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $parameters.extended = $Extended
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            if ($PSCmdlet.ParameterSetName -eq 'ASinglePerson') {
                $_ | ConvertTo-TraktPerson
            } elseif ($PSCmdlet.ParameterSetName -eq 'MovieCredits') {
                $_ | ConvertTo-TraktCreditsMovie
            } else {
                $_ | ConvertTo-TraktCreditsShow
            }
        }
    }
}