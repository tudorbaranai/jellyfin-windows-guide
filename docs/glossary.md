# Glossary

**Server and client.** The server (Jellyfin on your PC) holds the movies. Clients (the apps on your TV, phone or laptop) play them.

**Direct play.** Jellyfin sends the file as it is. The PC does almost nothing and the quality is the original. The goal for most plays.

**Transcoding.** Jellyfin converts the file on the fly because the device can't play it or the connection is too slow. Heavy work, best done by a graphics card. The file on disk never changes.

**What causes a transcode:**

| Cause | Avoid it with |
|---|---|
| A format the device can't play (AV1 on most phones, HEVC on old TVs) | H264 or HEVC video, AAC audio |
| Image subtitles (PGS, from Blu-ray) | Text `.srt` subtitles |
| Not enough upload away from home | A lower quality in the player |
| DTS or TrueHD audio on a phone | An AAC or AC3 audio track |

**NVENC.** The video encoder on NVIDIA cards. It does transcodes without loading the CPU.

**Resolution.** How many pixels: 720p (HD), 1080p (Full HD), 2160p (4K).

**Bitrate.** Data per second, in Mbps. Higher means more detail and bigger files. Size in GB ≈ Mbps × 0.45 × hours.

**Remux and encode.** A remux is a disc copied as it is: best quality, biggest file. An encode is compressed again: smaller, a little less detail. A good 1080p encode is 4-10 GB.

**Codec and container.** The codec is how the video is compressed (H264, HEVC, AV1). The container is the file around it (`.mkv`, `.mp4`).

**HDR.** Brighter, richer colour on screens that support it. On other screens it can look dull or force a transcode.

**Upload speed.** How fast your home sends data out. Away from home, every movie has to fit through it.

**Tailscale.** A private network between your own devices. Your devices reach the server from anywhere, with nothing opened on the router.

**Indexer.** A source Prowlarr searches for movies.

**Hardlink.** A second name for the same file. Radarr uses it to put a download in the library instantly, without using space twice.

**Torznab.** The language Prowlarr uses to talk to a source.
