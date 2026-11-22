# Part 10: Everyday use

## Watch

Open the Jellyfin app or a browser, sign in with the everyday account, pick a movie. Away from home, turn Tailscale on first.

Quality: gear icon > **Quality**. **Auto** on Wi-Fi. On mobile data, a cap like 720p 3 Mbps.

## Add a movie

- **From any device:** add it to your TMDB watchlist ([part 7.7](07-get-movies-automatically.md#77-add-movies-from-your-tmdb-watchlist)).
- **In Radarr:** Add New > the title > Add ([part 7.8](07-get-movies-automatically.md#78-add-a-movie-in-radarr)).
- **By hand:** put it in `M:\Media\Movies\Title (Year)\Title (Year).mkv`. It shows up within a minute. If not: Dashboard > Libraries > **Scan All Libraries**.

## Restart the server

Dashboard > **Restart**. Or in admin PowerShell: `Restart-Service JellyfinServer`.

**Shutdown** in the Dashboard stops the server until the next reboot.

## Update Jellyfin

1. If you use the plugins from [part 9](09-netflix-look.md): check the catalog has builds for the new version.
2. Back up (below).
3. Run the new installer from jellyfin.org. It updates in place.

Radarr, Prowlarr and the plugins update themselves. qBittorrent tells you when there's a new version.

## Back up

Settings, users and watch history live in `C:\ProgramData\Jellyfin\Server`. In admin PowerShell (make the `Backups` folder once first):

```powershell
Stop-Service JellyfinServer
Compress-Archive -Path C:\ProgramData\Jellyfin\Server `
  -DestinationPath "$HOME\Backups\jellyfin-$(Get-Date -Format yyyy-MM-dd).zip"
Start-Service JellyfinServer
```

For the movies, copy them to a second drive, then unplug it. `robocopy` copies only what changed:

```powershell
robocopy M:\Media\Movies B:\Movies /MIR /R:1 /W:1
```

`B:` is the backup drive. `/MIR` also deletes from the backup what's gone from the source, so double-check the letters.

## Once a week

- Dashboard > Activity: no errors.
- Free space on `M:`.
- `powercfg /getactivescheme`: still your power plan ([part 2](02-keep-it-on.md)).
- Windows Security > Protection history: nothing blocked that shouldn't be.
