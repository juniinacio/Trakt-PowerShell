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
function Get-TraktCalendar {
    [CmdletBinding(DefaultParameterSetName='GetMyShows')]
    [OutputType([PSCustomObject])]
    Param
    (
        # MyShows help description
        [Parameter(ParameterSetName='GetMyShows')]
        [Switch]
        $MyShows,
        
        # MyNewShows help description
        [Parameter(ParameterSetName='GetMyNewShows')]
        [Switch]
        $MyNewShows,
        
        # MySeasonPremieres help description
        [Parameter(ParameterSetName='GetMySeasonPremieres')]
        [Switch]
        $MySeasonPremieres,

        # MyMovies help description
        [Parameter(ParameterSetName='GetMyMovies')]
        [Switch]
        $MyMovies,

        # MyDVD help description
        [Parameter(ParameterSetName='GetMyDVDReleases')]
        [Switch]
        $MyDVD,

        # AllShows help description
        [Parameter(ParameterSetName='GetShows')]
        [Switch]
        $AllShows,

        # AllNewShows help description
        [Parameter(ParameterSetName='GetNewShows')]
        [Switch]
        $AllNewShows,
        
        # AllSeasonPremieres help description
        [Parameter(ParameterSetName='GetSeasonPremieres')]
        [Switch]
        $AllSeasonPremieres,
        
        # AllMovies help description
        [Parameter(ParameterSetName='GetMovies')]
        [Switch]
        $AllMovies,
        
        # AllDVD help description
        [Parameter(ParameterSetName='GetDVDReleases')]
        [Switch]
        $AllDVD,

        # StartDate help description
        [Parameter(Mandatory=$false)]
        [String]
        $StartDate,

        # Days help description
        [Parameter(Mandatory=$false)]
        [ValidateRange(0,31)]
        [Int]
        $Days,
        
        # Extended help description
        [Parameter(Mandatory=$false)]
        [ValidateSet('min', 'images', 'full', 'full-images', 'metadata')]
        [String]
        $Extended
    )
    
    process
    {
        # LINK: http://docs.trakt.apiary.io/#reference/calendars/
        
        switch ($PSCmdlet.ParameterSetName)
        {
            GetMyShows {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/my/shows/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/my/shows/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/my/shows'
                }
            }

            GetMyNewShows {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/my/shows/new/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/my/shows/new/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/my/shows/new'
                }
            }

            GetMySeasonPremieres {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/my/shows/premieres/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/my/shows/premieres/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/my/shows/premieres'
                }
            }

            GetMyMovies {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/my/movies/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/my/movies/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/my/movies'
                }
            }
            
            GetMyDVDReleases {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/my/dvd/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/my/dvd/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/my/dvd'
                }
            }

            GetShows {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/all/shows/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/all/shows/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/all/shows'
                }
            }

            GetNewShows {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/all/shows/new/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/all/shows/new/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/all/shows/new'
                }
            }

            GetSeasonPremieres {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/all/shows/premieres/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/all/shows/premieres/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/all/shows/premieres'
                }
            }

            GetMovies {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/all/movies/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/all/movies/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/all/movies'
                }
            }
            
            GetDVDReleases {
                if ($PSBoundParameters.ContainsKey('StartDate')) {
                    if ($PSBoundParameters.ContainsKey('Days')) {
                        $uri = 'calendars/all/dvd/{0}/{1}' -f $StartDate, $Days
                    } else {
                        $uri = 'calendars/all/dvd/{0}' -f $StartDate
                    }
                } else {
                    $uri = 'calendars/all/dvd'
                }
            }
        }
        
        $parameters = @{}

        if ($PSBoundParameters.ContainsKey("Extended")) {
            $parameters.extended = $Extended
        }
        
        Invoke-Trakt -Uri $uri -Method ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) -Parameters $parameters |
        ForEach-Object {
            if ($PSCmdlet.ParameterSetName -like '*Shows*' -or $PSCmdlet.ParameterSetName -like '*Season*') {
                $_ | ConvertTo-TraktCalendarShow
            } else {
                $_ | ConvertTo-TraktCalendarMovie
            }
        }
    }
}