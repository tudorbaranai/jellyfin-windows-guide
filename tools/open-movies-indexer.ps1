# open-movies-indexer.ps1
#
# A tiny Torznab "indexer" for testing the Radarr pipeline with legal content.
# It lists four Blender Foundation open movies (Creative Commons, free to share)
# and points at their official torrents on webtorrent.io. Each torrent has a web
# seed, so it downloads over plain HTTP even when no other peer is online.
#
# Run (normal PowerShell, no admin needed):
#   powershell -ExecutionPolicy Bypass -File .\open-movies-indexer.ps1
# Then in Prowlarr: Indexers > Add Indexer > Generic Torznab,
#   URL http://localhost:9998  (use "localhost", not 127.0.0.1), API Path /api.
# Stop it with Ctrl+C.

param([int]$Port = 9998)

$movies = @(
  @{ Title = 'Big Buck Bunny 2008';     Torrent = 'https://webtorrent.io/torrents/big-buck-bunny.torrent';    Hash = 'dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c'; Size = 276445467; Date = 'Thu, 10 Apr 2008 00:00:00 +0000'; Info = 'https://peach.blender.org/' },
  @{ Title = 'Sintel 2010';             Torrent = 'https://webtorrent.io/torrents/sintel.torrent';            Hash = '08ada5a7a6183aae1e09d831df6748d566095a10'; Size = 129302391; Date = 'Mon, 27 Sep 2010 00:00:00 +0000'; Info = 'https://durian.blender.org/' },
  @{ Title = 'Tears of Steel 2012';     Torrent = 'https://webtorrent.io/torrents/tears-of-steel.torrent';    Hash = '209c8226b299b308beaf2b9cd3fb49212dbd13ec'; Size = 571426507; Date = 'Wed, 26 Sep 2012 00:00:00 +0000'; Info = 'https://mango.blender.org/' },
  @{ Title = 'Cosmos Laundromat 2015';  Torrent = 'https://webtorrent.io/torrents/cosmos-laundromat.torrent'; Hash = 'c9e15763f722f23e98a29decdfae341b98d53056'; Size = 220864086; Date = 'Mon, 10 Aug 2015 00:00:00 +0000'; Info = 'https://gooseberry.blender.org/' }
)

$caps = @"
<?xml version="1.0" encoding="UTF-8"?>
<caps>
  <server title="Open Movies Test" />
  <limits default="100" max="100" />
  <searching>
    <search available="yes" supportedParams="q" />
    <movie-search available="yes" supportedParams="q" />
    <tv-search available="no" supportedParams="q" />
  </searching>
  <categories>
    <category id="2000" name="Movies" />
  </categories>
</caps>
"@

function Get-Results([string]$q) {
  # Words of the query, without years: "Sintel 2010" -> "sintel".
  $words = @()
  if ($q) {
    $words = @($q.ToLower() -split '[^a-z0-9]+' | Where-Object { $_ -and ($_ -notmatch '^(19|20)\d\d$') })
  }
  $items = foreach ($m in $movies) {
    $titleWords = $m.Title.ToLower() -split '[^a-z0-9]+'
    $match = $true
    foreach ($w in $words) { if ($titleWords -notcontains $w) { $match = $false } }
    if ($match) {
@"
    <item>
      <title>$($m.Title)</title>
      <guid>urn:btih:$($m.Hash)</guid>
      <link>$($m.Torrent)</link>
      <comments>$($m.Info)</comments>
      <pubDate>$($m.Date)</pubDate>
      <size>$($m.Size)</size>
      <category>2000</category>
      <enclosure url="$($m.Torrent)" length="$($m.Size)" type="application/x-bittorrent" />
      <torznab:attr name="category" value="2000" />
      <torznab:attr name="size" value="$($m.Size)" />
      <torznab:attr name="seeders" value="1" />
      <torznab:attr name="peers" value="1" />
      <torznab:attr name="infohash" value="$($m.Hash)" />
    </item>
"@
    }
  }
@"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:torznab="http://torznab.com/schemas/2015/feed">
  <channel>
    <title>Open Movies Test</title>
$($items -join "`n")
  </channel>
</rss>
"@
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Open Movies Test indexer on http://localhost:$Port/api  (Ctrl+C to stop)"

try {
  while ($listener.IsListening) {
    # Wait in short steps so Ctrl+C works.
    $task = $listener.GetContextAsync()
    while (-not $task.AsyncWaitHandle.WaitOne(500)) { }
    $ctx = $task.GetAwaiter().GetResult()

    $t = $ctx.Request.QueryString['t']
    $q = $ctx.Request.QueryString['q']
    if ($t -eq 'caps') { $body = $caps } else { $body = Get-Results $q }
    Write-Host ("{0:HH:mm:ss}  t={1}  q={2}" -f (Get-Date), $t, $q)

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $ctx.Response.ContentType = 'application/xml; charset=utf-8'
    $ctx.Response.ContentLength64 = $bytes.Length
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $ctx.Response.Close()
  }
}
finally {
  $listener.Stop()
  $listener.Close()
}
