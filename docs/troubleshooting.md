# Troubleshooting

Start at the top. Most problems are one of the first three.

## Can't connect at all

**Likely:** Jellyfin is stopped. In admin PowerShell:

```powershell
Get-Service JellyfinServer
Start-Service JellyfinServer
```

If it stops again, read the newest log in `C:\ProgramData\Jellyfin\Server\log`.

## Works on the PC, not from other devices

**Likely:** the firewall rule from [part 6.2](guide/06-watch-anywhere.md#62-firewall-rule) is missing. Check:

```powershell
Get-NetFirewallRule -DisplayName "Jellyfin (LAN + Tailscale)" | Get-NetFirewallAddressFilter
```

## Works at home, not away

In order:

1. Tailscale is on, on the device you're watching on.
2. The PC is awake. If it slept, the power plan changed ([part 2](guide/02-keep-it-on.md)).
3. `tailscale status` on the PC shows it online. Logged out after a reboot? Turn on **Run unattended** ([part 6.1](guide/06-watch-anywhere.md#61-tailscale-on-the-pc)).
4. The key expired: sign in on the PC, then disable key expiry.
5. The name doesn't work: use `http://100.x.y.z:8096`.

## Wrong poster, or the movie doesn't appear

**Likely:** the name isn't `Title (Year)`, or the file isn't in its own folder ([part 3.4](guide/03-drive-and-library.md#34-folders-and-names)). Rename it, then ⋯ > **Identify**, or Scan All Libraries.

## The whole library is empty

**Likely:** the drive disconnected or got a new letter. Check it's in File Explorer, set the letter back ([part 3.2](guide/03-drive-and-library.md#32-give-it-a-fixed-letter)), and check the cable. Don't delete and re-add the library: that loses watch history.

## Transcoding at home on a small file

**Seen:** Playback Info says Transcoding, "video bitrate exceeds the limit".

**Likely:** the player's Quality is below the file's bitrate. Gear icon > Quality > **Auto**.

## Buffering away from home

**Likely:** the movie needs more than your home upload. Lower the quality, or set a limit ([part 6.4](guide/06-watch-anywhere.md#64-quality-away-from-home)).

## Transcoding uses the CPU

**Seen:** CPU high during a transcode, the GPU's Video Encode graph flat.

1. Dashboard > Playback > Transcoding still says **Nvidia NVENC**. Updates can reset it.
2. The driver is current.
3. The file's format is ticked for hardware decoding. AV1 on older cards always uses the CPU.

## Subtitles start a transcode

**Likely:** they're image subtitles (PGS, from a Blu-ray), which have to be burned into the picture. Use a text `.srt` subtitle instead ([part 3.6](guide/03-drive-and-library.md#36-subtitles)).

## Download crawls, then says Errored

**Likely, in order:**

1. **The drive dropped out.** qBittorrent > View > Log says `Access is denied` or `cannot find the path`, and Event Viewer > System shows **disk** or **Ntfs** errors at the same minute. Fix the drive ([part 3.3](guide/03-drive-and-library.md#33-keep-it-connected)).
2. **A VPN blocks peer-to-peer.** Many free VPN plans do.
3. **Controlled folder access** blocks qBittorrent. Allow it ([part 8.5](guide/08-safe-downloads.md#85-windows-security)).

Then right-click the torrent > **Force recheck** > Start. An errored torrent doesn't restart by itself.

## Prowlarr's Internet Archive indexer times out

**Likely:** the Internet Archive doesn't answer searches from Prowlarr. Nothing on your side is wrong. Add movies by hand, or use another source you have the right to use.

## "Access is denied" in the media folder

**Likely:** Controlled folder access. Windows Security > Protection history names the program. Turn it off for the change, then back on, or allow the program ([part 8.5](guide/08-safe-downloads.md#85-windows-security)).

## Sites are slow while downloading

**Likely:** the downloads use all your upload. Set an upload limit of about 80% and about 100 connections in qBittorrent ([part 7.1](guide/07-get-movies-automatically.md#71-qbittorrent)).

## Watchlist movies stop showing up after a Radarr update

**Likely:** the new Radarr closed the 10-minute shortcut ([part 7.7](guide/07-get-movies-automatically.md#faster-check-every-10-minutes-optional)). Look for `ERROR` lines in `C:\ProgramData\WatchlistSync\sync.log`. Radarr's own 12-hour check still works, so movies still arrive, just slower.

## Radarr: "Unable to parse file"

**Likely:** the release name has no year. Activity > Queue > the item > **Manual Import** > pick the movie.

## Prowlarr can't add an indexer to Radarr: 409 Conflict

**Likely:** Radarr already has one with that name. Delete it in Radarr > Settings > Indexers, then Prowlarr > Indexers > **Sync App Indexers**.

## New plugins do nothing

**Likely:** Jellyfin hasn't restarted. Dashboard > **Restart**, then Ctrl + F5.

## Home rows I unticked still show

**Likely:** the 24-hour cache. Restart Jellyfin, then Ctrl + F5. Still there? Untick the row in the server list (Dashboard > Plugins > Home Screen Sections), which limits every user.

## Games stutter, or a transcode fails while gaming

**Likely:** the game and the transcode share the graphics card. Play direct-play files, or stop Jellyfin while gaming: `Stop-Service JellyfinServer`, then `Start-Service JellyfinServer`.
