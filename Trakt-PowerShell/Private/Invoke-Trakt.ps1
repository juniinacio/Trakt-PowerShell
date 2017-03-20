<#
.Synopsis
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
function Invoke-Trakt
{
    [CmdletBinding(DefaultParameterSetName='None')]
    [OutputType([Object])]
    Param
    (
        # Uri help description
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Uri,
        
        # Paramaters help description
        [Parameter(Mandatory=$false)]
        [Hashtable]
        $Parameters,
        
        # PostData help description
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $PostData,
        
        # Method help description
        [Parameter(Mandatory=$false)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Default
    )

    process
    {
        try {
            $builder = New-Object -TypeName 'System.UriBuilder' -ArgumentList $Script:API_URI
            $builder.Path = $Uri

            $headers = $Script:DEFAULT_HEADERS
            if ($Script:ACCESS_TOKEN -ne $null) {
                $headers.authorization = ('Bearer {0}' -f $Script:ACCESS_TOKEN.access_token)
            }
            
            if ($PSBoundParameters.ContainsKey('Parameters')) {
                $Parameters.GetEnumerator() |
                    ForEach-Object {
                        if ($builder.Query -ne $null -and $builder.Query.Length -gt 1) {
                            $builder.Query = $builder.Query.Substring(1) + '&' + ('{0}={1}' -f $_.Key, $_.Value)
                        } else {
                            $builder.Query = '{0}={1}' -f $_.Key, $_.Value
                        }
                    }   
            }
            
            $requestParameters = @{}

            $requestParameters.Uri = $builder.ToString()
            $requestParameters.Headers = $headers

            if ($PSBoundParameters.ContainsKey('PostData')) {
                $requestParameters.Body = $PostData | ConvertTo-Json -Depth 4

                Write-Verbose $requestParameters.Body
            }
            
            if ($PSBoundParameters.ContainsKey('Method')) {
                $requestParameters.Method = $Method
            }
            
            Invoke-RestMethod @requestParameters
        } catch {
            throw $_
        }
    }
}