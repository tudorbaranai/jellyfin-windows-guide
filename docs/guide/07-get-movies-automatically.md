# Part 7: Get movies automatically

Optional. You add a movie to your watchlist; it gets found, downloaded, renamed and shows up in Jellyfin by itself.

```
TMDB watchlist ──► Radarr

Radarr ◄──asks / answers──► Prowlarr ◄──searches / results──► your sources
   │
   └──sends the torrent──► qBittorrent ──► M:\Media\Downloads
                                                  │
Radarr renames it into M:\Media\Movies ◄──────────┘ ──► Jellyfin
```

| App | Job | Address |
|---|---|---|
| qBittorrent | Downloads | `http://localhost:8080` |
| Prowlarr | Holds your sources ("indexers") and searches them | `http://localhost:9696` |
| Radarr | Your wanted list; renames and files movies | `http://localhost:7878` |

**Legal sources only.** These are legal tools. The source decides whether a download is legal. Only add sources you have the right to download from.

Do [part 8](08-safe-downloads.md) right after this one, before the first real download.

## 7.1 qBittorrent

**What:** the downloader, controlled by Radarr.

**How:** install from [qbittorrent.org](https://www.qbittorrent.org) only. Then Tools > Options:

| Section | Setting |
|---|---|
| Downloads | Default Torrent Management Mode **Automatic**. Default Save Path `M:\Media\Downloads` |
| Connection | UPnP / NAT-PMP **off**. Global maximum connections about 100 |
| Speed | Upload limit about 80% of your upload, so the rest of the internet stays fast |
| BitTorrent | Stop seeding at ratio 1.0 |
| Behavior | Start with Windows, close to the notification area |
| Web UI | On, IP `127.0.0.1`, port `8080`, a username and password |

Then add a category: right-click **Categories** in the left panel > Add category: name `radarr`, save path `M:\Media\Downloads\radarr`.

Downloads land on the same drive as the movies, so Radarr can **hardlink** them: the file appears in the library instantly and takes space only once.

**Check:** `http://localhost:8080` asks for your login and shows the `radarr` category.

qBittorrent is an app, not a service: it only runs while you're logged in.

## 7.2 Prowlarr

**What:** the search manager. It holds your sources and hands them to Radarr.

**How:** install from [prowlarr.com](https://prowlarr.com) as a Windows service. On first open, set a login (Forms, required).

**Check:** `http://localhost:9696` opens and asks for your login.

## 7.3 Radarr

**What:** the librarian.

**How:** install from [radarr.video](https://radarr.video) as a Windows service, set a login, then:

1. Settings > Media Management, click **Show Advanced**:
   - Rename Movies: on
   - Standard Movie Format and Movie Folder Format: `{Movie Title} ({Release Year})`
   - Use Hardlinks: on
   - Minimum Free Space (under Importing): `20000` MB
   - Root Folders: add `M:\Media\Movies`
2. Settings > Download Clients > **+** > qBittorrent: host `localhost`, port `8080`, your qBittorrent login, category `radarr`, Remove Completed on. Test > Save.

**Check:** the qBittorrent test is green.

## 7.4 Connect them

**What:** Prowlarr feeds Radarr, Radarr tells Jellyfin.

**How:**

1. Radarr > Settings > General: copy the **API Key**.
2. Prowlarr > Settings > Apps > **+** > Radarr: Prowlarr server `http://localhost:9696`, Radarr server `http://localhost:7878`, paste the key, Sync Level **Full Sync**. Test > Save.
3. Jellyfin > Dashboard > API Keys > **+**, name it `Radarr`, copy it.
4. Radarr > Settings > Connect > **+** > Emby / Jellyfin: host `localhost`, port `8096`, the Jellyfin key, **Update Library** on, tick **On File Import** and **On File Upgrade**. Test > Save.

"On Movie Added" stays greyed out. That's normal.

**Check:** both tests are green.

## 7.5 Add a source

**What:** give Prowlarr somewhere to search. Prowlarr > **Indexers** > Add Indexer.

| The source... | How |
|---|---|
| Is in Prowlarr's list | Search its name > Test > Save |
| Has a Torznab or Newznab API | **Generic Torznab** / **Generic Newznab**, with its API address and key |
| Has neither | Write a definition file. Prowlarr's [internetarchive.yml](https://github.com/Prowlarr/Indexers/blob/master/definitions/v11/internetarchive.yml) is a full example. Put it in `C:\ProgramData\Prowlarr\Definitions\Custom\` and restart Prowlarr |

Radarr needs a `.torrent`, a magnet link or an NZB per movie. A site with only plain downloads won't work.

The Internet Archive is in Prowlarr's list, but it doesn't answer Prowlarr's searches. If a site blocks Prowlarr, respect it; don't disguise Prowlarr.

**Check:** Prowlarr > Search finds a movie you know the source has. With Full Sync, the source also appears in Radarr > Settings > Indexers.

## 7.6 Test it with free movies

**What:** [`tools/open-movies-indexer.ps1`](../../tools/open-movies-indexer.ps1) is a tiny test source with four free Blender films: Big Buck Bunny, Sintel, Tears of Steel and Cosmos Laundromat.

**Why:** it tests the whole chain with legal files, before you add real sources. It only answers this PC and opens nothing to the network.

**How:**

1. Download the script. In PowerShell, in its folder, leave this running:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\open-movies-indexer.ps1
   ```

2. Prowlarr > Indexers > Add Indexer > **Generic Torznab**: name `Open Movies Test`, URL `http://localhost:9998` (`localhost`, not `127.0.0.1`), API Path `/api`. Test > Save.
3. Radarr > Movies > Add New > **Sintel (2010)** > tick **Start search for missing movie** > Add.

**Check:** Sintel shows up in qBittorrent, then in Jellyfin. If Radarr's queue says "Unable to parse file" (the test torrent has no year in its name): Activity > Queue > the item > **Manual Import**.

When done: close the PowerShell window and delete the indexer in Prowlarr.

## 7.7 Add movies from your TMDB watchlist

**What:** add a movie to your watchlist on TMDB, from any device, and Radarr gets it by itself.

**Why TMDB:** Radarr already takes its titles and posters from TMDB, so the match is always right, and the list stays private. Trakt and IMDb lists work too, but an IMDb watchlist has to be public.

**How:**

1. Make a free account on [themoviedb.org](https://www.themoviedb.org). On a phone, add the site to your home screen.
2. Radarr > Settings > Import Lists > **+** > **TMDb User** (not TMDb List or Popular).
3. Click **Authenticate with TMDb** > **Approve**. Nothing opens? Allow pop-ups for `localhost`.
4. Set:

   | Field | Set to |
   |---|---|
   | Enable, Enable Automatic Add, Search on Add | Ticked |
   | Monitor | **Movie Only**, not the whole collection |
   | Minimum Availability | **Released** |
   | Root Folder | `M:\Media\Movies` |
   | List Type | **Watchlist** |

5. Test > Save.
6. Settings > Import Lists > Import List Options (**Show Advanced**): **Clean Library Level** must be **Disabled**. Otherwise, taking a movie off your watchlist can remove it from Radarr.

**Check:** add a movie to your TMDB watchlist. Radarr checks the list every few hours; to check now, Radarr > System > Tasks > **Import List Sync** > the circular arrows. The movie shows up in Radarr and starts downloading.

## 7.8 Add a movie in Radarr

1. Radarr > Movies > **Add New** > search the title.
2. Root folder `M:\Media\Movies`, tick **Start search for missing movie** > Add.

Radarr searches right away, then keeps watching for new releases. Already have the file? Put it in its folder, then click **Refresh & Scan** on the movie's page.

Next: [Part 8: Make downloads safe](08-safe-downloads.md)
