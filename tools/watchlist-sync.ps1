<#
.SYNOPSIS
    Makes Radarr check your TMDB watchlist now, instead of within 12 hours.

.DESCRIPTION
    Radarr checks each TMDB list at most once every 12 hours, and that limit
    can't be changed in its settings. But when it's asked to sync one specific
    list, it skips the 12-hour check (Radarr v7, FetchAndParseImportListService:
    FetchSingleList has no interval check). It also skips the "clean library"
    step there, so this can't remove movies.

    This script finds your TMDb User list in Radarr and asks Radarr to sync it.
    Run it every few minutes with Task Scheduler.

    The Radarr API key is read from Radarr's own config file, so it isn't
    stored in this script.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\watchlist-sync.ps1
#>
param(
    [string]$RadarrUrl  = 'http://localhost:7878',
    [string]$ConfigPath = 'C:\ProgramData\Radarr\config.xml',
    # Only needed if you have more than one enabled TMDb User list.
    [string]$ListName,
    [string]$LogPath    = 'C:\ProgramData\WatchlistSync\sync.log'
)

$ErrorActionPreference = 'Stop'

function Write-Log([string]$Message) {
    $dir = Split-Path $LogPath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message" | Add-Content $LogPath
    # Keep the log small: about a week at one line every 10 minutes.
    $lines = @(Get-Content $LogPath)
    if ($lines.Count -gt 1000) { $lines | Select-Object -Last 500 | Set-Content $LogPath }
}

try {
    [xml]$config = Get-Content $ConfigPath
    $apiKey = $config.Config.ApiKey
    if (-not $apiKey) { throw "No ApiKey found in $ConfigPath" }
    $headers = @{ 'X-Api-Key' = $apiKey }

    $lists = Invoke-RestMethod "$RadarrUrl/api/v3/importlist" -Headers $headers
    $tmdb = @($lists | Where-Object { $_.implementation -eq 'TMDbUserImport' -and $_.enabled })
    if ($ListName) { $tmdb = @($tmdb | Where-Object { $_.name -eq $ListName }) }
    if ($tmdb.Count -ne 1) {
        throw "Expected one enabled TMDb User list, found $($tmdb.Count): $($tmdb.name -join ', '). Use -ListName."
    }
    $list = $tmdb[0]

    $body = @{ name = 'ImportListSync'; definitionId = $list.id } | ConvertTo-Json
    $cmd = Invoke-RestMethod "$RadarrUrl/api/v3/command" -Method Post -Headers $headers `
        -Body $body -ContentType 'application/json'

    Write-Log "Asked Radarr to sync '$($list.name)' (list $($list.id), command $($cmd.id))"
}
catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    exit 1
}
