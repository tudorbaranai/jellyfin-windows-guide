# Guide

Ten parts, in order. Every step has the same shape: **What** you do, **Why**, **How**, and a **Check** that proves it worked.

Commands are for PowerShell. "Admin PowerShell" means: Start, type `powershell`, right-click, **Run as administrator**.

| Part | What | Time |
|---|---|---|
| [1](01-install-jellyfin.md) | Install Jellyfin and make the accounts | 20 min |
| [2](02-keep-it-on.md) | Keep the PC on | 10 min |
| [3](03-drive-and-library.md) | Your media drive, library and subtitles | 30 min |
| [4](04-gpu.md) | Let the graphics card do the work | 15 min |
| [5](05-watch-at-home.md) | Watch at home | 10 min |
| [6](06-watch-anywhere.md) | Watch from anywhere with Tailscale | 30 min |
| [7](07-get-movies-automatically.md) | Get movies automatically (optional) | 45 min |
| [8](08-safe-downloads.md) | Make downloads safe (do it with part 7) | 20 min |
| [9](09-netflix-look.md) | The Netflix look (optional) | 15 min |
| [10](10-everyday-use.md) | Everyday use | reference |

## Names used in this guide

Swap in your own:

| In the guide | What it is | Find yours |
|---|---|---|
| `M:` | The media drive | File Explorer |
| `192.168.1.50` | The PC's address at home | `ipconfig`, IPv4 address |
| `my-server` | The PC's Tailscale name | `tailscale status` |
| `100.x.y.z` | The PC's Tailscale address | `tailscale ip -4` |
