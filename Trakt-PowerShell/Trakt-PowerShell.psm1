$Script:CLIENT_ID = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('OABjADIAMAAzAGUAZgBjAGUAOQA4AGMAZgA2ADMAYwAyADUAYQAzADkAZQA3ADYAYwA1ADUANgA3ADQAZgA0ADMANQA4AGEANwAxADkAOQA1ADcAOQA0AGMAZQBmADgAMAAwADYAMwAwAGMANwBiADAAZgBhAGIAZAAzADgAOAA='))
$Script:CLIENT_SECRET = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('MQBmADYAZAA5AGEAOAA1ADAANgBlADIAOAA0AGUAMAA4AGMAOABmADcAMAAyAGMAMQAwADEAMgAyADMAOQBhADYAZQAyADMAOAA1ADIAOAAzAGYAYQAwADcAMAAxADgAMABhADcANAAxADcAMwA3ADIANQAwADMAZAA0ADMAMQA='))
$Script:SITE_URI = "https://trakt.tv"
$Script:API_URI = "https://api.trakt.tv"

if ((Get-Variable -Name 'IsStaging' -ValueOnly -Scope Global -EA 0) -eq $true) {
    $Script:CLIENT_ID = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('YQA1AGEAZABjAGQAMQBjAGUAZgBkADQANAA3AGEAMgA4ADIAZQA3ADQAZAA5AGUAMQAzADIAOQA2AGUAYQBjADYANAA2ADAAYgAzADYAMABhAGMAMgA0ADEANgAzAGIAYwA3ADEANwAzAGEAMQBjAGMANAA4ADgAYwBjAGIAZAA='))
    $Script:CLIENT_SECRET = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('OABiADAANgBhAGQAMgBlADIANQA1AGYAMQBhADIANwA2AGYAMwBkAGMAOQAzADEANwA4ADYAOQA2ADIAZgA1ADIAYgAxADIANQA0AGYAMQA5ADMAZAA2AGMANQBkAGMAOAA4ADcAMwA5AGIAZgA2AGMANQA1ADkAOABlADQANgA='))
    $Script:SITE_URI = "https://staging.trakt.tv"
    $Script:API_URI = "https://api-staging.trakt.tv"
}

$Script:REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'

$Script:DEFAULT_HEADERS = @{
    'Content-type' = 'application/json'
    'trakt-api-key' = $Script:CLIENT_ID
    'trakt-api-version' = 2
}

$Script:APP_STORAGE = Join-Path -Path $env:APPDATA -ChildPath 'Trakt-PowerShell\storage'
if (-not (Test-Path -Path $Script:APP_STORAGE -PathType Container)) {
    New-Item -Path $Script:APP_STORAGE -ItemType Directory | Out-Null
}

$Script:ACCESS_TOKEN_PATH = Join-Path -Path $Script:APP_STORAGE -ChildPath "access_token.clixml"
if (Test-Path -Path $Script:ACCESS_TOKEN_PATH -PathType Leaf) {
    $Script:ACCESS_TOKEN = Import-Clixml -Path $Script:ACCESS_TOKEN_PATH
}

$Script:APP_VERSION = '1.0'

$Script:APP_DATE = '2017-01-01'

$Paths = @(
    'Private', 'Public'
)

foreach ($path in $Paths) {
    Get-ChildItem -Path "$PSScriptRoot\$path\*.ps1" |
    ForEach-Object {
        if ($_.Name -notlike '*_TEMPLATE*') {
            Write-Verbose "Including file '$($_.FullName)'."
            . $_.FullName
        }
    }
}

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1").BaseName