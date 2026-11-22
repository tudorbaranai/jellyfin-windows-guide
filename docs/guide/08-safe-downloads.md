# Part 8: Make downloads safe

Even a legal source can serve a bad file. So the downloads folder becomes a sandbox: programs aren't downloaded, and if one gets in anyway, it can't run.

A video file (`.mkv`, `.mp4`) isn't a program. The danger is a program dressed up as one, like `Movie.mkv.exe`, or an extra file in the torrent, like `Codec.exe` or `Watch.lnk`.

## 8.1 Show file extensions

**What:** see a file's full name, and stop drives from running things when plugged in.

**How:**

- File Explorer > View > Show > **File name extensions**.
- Settings > Bluetooth & devices > AutoPlay > **Off**.

**Check:** files show their extension, like `.mkv`.

## 8.2 Never download programs

**What:** qBittorrent skips any file that matches a list.

**How:** qBittorrent > Tools > Options > Downloads > tick **Excluded file names**, then paste, **one per line**:

```text
*.exe
*.com
*.scr
*.bat
*.cmd
*.ps1
*.vbs
*.js
*.jar
*.msi
*.lnk
*.url
*.hta
*.zip
*.rar
*.7z
*.iso
```

**Check:** a torrent with an `.exe` inside shows that file as "Do not download".

## 8.3 Nothing runs from the downloads folder

**What:** forbid running any file inside the downloads folder.

**Why:** if a program slips through, double-clicking it does nothing. The apps only write, move and read files, so they keep working.

**How:** in admin PowerShell:

```powershell
icacls "M:\Media\Downloads" /deny "*S-1-1-0:(OI)(CI)(IO)(X)" /C
```

`S-1-1-0` means Everyone, in any Windows language. `(X)` means run. It covers everything inside the folder. Undo with `icacls "M:\Media\Downloads" /remove:d "*S-1-1-0"`.

**Check:** a harmless program copied in refuses to start:

```powershell
Copy-Item C:\Windows\System32\whoami.exe M:\Media\Downloads\test.exe
M:\Media\Downloads\test.exe
Remove-Item M:\Media\Downloads\test.exe
```

The second line should say "Access is denied".

## 8.4 Reject fakes by size

**What:** a minimum size per quality in Radarr.

**Why:** a "1080p movie" of 80 MB is fake. Radarr skips it before downloading.

**How:** Radarr > Settings > **Quality**. Sizes are in MB per minute. Drag the left handle:

| Quality | Minimum (MB/min) | For a 2-hour film |
|---|---|---|
| SD, DVD, 480p | 2 | 240 MB |
| 720p | 5 | 600 MB |
| 1080p | 8 | 1 GB |
| 2160p | 20 | 2.4 GB |

**Check:** Radarr > a movie > Interactive Search shows tiny releases with a red icon that names the size.

## 8.5 Windows Security

**How:** Windows Security:

| Setting | Where | Set to |
|---|---|---|
| Real-time protection | Virus & threat protection > Manage settings | On. Never exclude the downloads folder |
| Potentially unwanted apps | App & browser control > Reputation-based protection | On |
| Controlled folder access | Virus & threat protection > Ransomware protection | On, with `M:\Media` added |

Controlled folder access only lets trusted programs change protected folders. Allow the server apps, or downloads fail with "Access is denied": Ransomware protection > Allow an app > add `qbittorrent.exe`, `Radarr.Console.exe`, `jellyfin.exe` and `ffmpeg.exe`.

It blocks you too: deleting files in `M:\Media` can fail. Turn it off for the change, then back on.

**Check:** Windows Security > Protection history shows no blocks for the server apps after a download.

## 8.6 Two more habits

- Leave qBittorrent's **Run external program** (Tools > Options > Downloads) empty.
- Keep a backup on a drive that's **unplugged** between backups. Ransomware encrypts every drive that's connected ([part 10](10-everyday-use.md#back-up)).

Next: [Part 9: The Netflix look](09-netflix-look.md)
