# Part 3: Your media drive and library

Movies take a lot of space, so keep them on their own drive. An external USB drive is the easy choice; HDD or SSD both work. A hard drive reads about 100 MB/s over USB 3, ten times what a 4K movie needs.

## 3.1 Check the format

**What:** the drive should be **NTFS**.

**Why:** NTFS holds files over 4 GB, and parts 7 and 8 need two things only NTFS has: hardlinks and file permissions.

**How:** File Explorer > right-click the drive > Properties > **File system**.

If it says exFAT or FAT32, it needs formatting to NTFS. **Formatting erases everything on it**, so copy your files off first.

**Check:** File system says NTFS.

## 3.2 Give it a fixed letter

**What:** give the drive a letter it keeps, for example `M:`.

**Why:** Windows can hand a USB drive a new letter after a reboot. The library then points at nothing and your movies vanish from Jellyfin.

**How:** Win+X > **Disk Management** > right-click the drive > Change Drive Letter and Paths > Change > `M:`. Your files aren't touched.

**Check:** unplug, plug back in, reboot. Still `M:`.

## 3.3 Keep it connected

**What:** stop Windows from cutting power to the drive.

**Why:** some USB drives drop off instead of waking up. Downloads then fail and the library empties.

**How:**

- Plug it straight into a USB 3 port (blue or marked SS), not a hub. Lay it flat, away from vents.
- In admin PowerShell, turn off disk sleep and USB power saving:

  ```powershell
  powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0
  powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
  powercfg /setactive SCHEME_CURRENT
  ```

- **Drive with a password?** Some drives (WD My Passport, for example) lock on every power loss and wait for a password. A server can't type it. Remove the password in the maker's app; nothing is erased.

**Check:** after a day, the drive is still there, and Event Viewer > Windows Logs > System has no errors from **disk** or **Ntfs**. If it keeps dropping, try another cable first.

## 3.4 Folders and names

**What:** one folder per movie, named `Title (Year)`, the file named the same.

**Why:** Jellyfin finds the poster and plot by title and year. Clean names match the first time.

**How:**

```text
M:\Media\
  Movies\
    Sintel (2010)\
      Sintel (2010).mkv
      Sintel (2010).en.srt
  Downloads\
```

Subtitles go next to the movie: same name plus a language code (`en`, `fr`, `ro`). Keep other files, like photos, outside `Media`.

**Check:** folder and file names match exactly, apart from the extension.

## 3.5 Add the library

**What:** a Movies library on `M:\Media\Movies`.

**How:** Dashboard > Libraries > **Add Media Library**:

- Content type: **Movies**
- Folder: `M:\Media\Movies`. Not the whole drive.
- Real-time monitoring: **on**, so new movies show up in seconds
- Save artwork into media folders: **off**, so Jellyfin never writes to the drive

**Check:** add one movie. Within a minute it shows up with the right poster. If not: Dashboard > Libraries > **Scan All Libraries**.

Wrong poster? On the movie: ⋯ > **Identify** > search title and year.

## 3.6 Subtitles

**What:** download subtitles by themselves with the OpenSubtitles plugin.

**How:**

1. Make a free account on [opensubtitles.com](https://www.opensubtitles.com).
2. Dashboard > Plugins > Catalog > **Open Subtitles** > Install.
3. Restart Jellyfin: Dashboard > **Restart**.
4. Dashboard > Plugins > Open Subtitles: enter your login.
5. Dashboard > Libraries > Movies > ⋯ > Manage library > Subtitle downloads: tick your languages and **Open Subtitles**.

**Check:** on a movie, ⋯ > Edit subtitles > search finds results.

Next: [Part 4: Let the graphics card do the work](04-gpu.md)
