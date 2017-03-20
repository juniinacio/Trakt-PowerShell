$Script:CLIENT_ID = '8c203efce98cf63c25a39e76c55674f4358a71995794cef800630c7b0fabd388'
$Script:CLIENT_SECRET = '1f6d9a8506e284e08c8f702c1012239a6e2385283fa070180a7417372503d431'

$Script:REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'
$Script:SITE_URI = "https://trakt.tv"
$Script:API_URI = "https://api.trakt.tv"

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