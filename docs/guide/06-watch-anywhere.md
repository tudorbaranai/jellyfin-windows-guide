# Part 6: Watch from anywhere

[Tailscale](https://tailscale.com) is a private network between your own devices. With it on, your phone, laptop or any other PC reaches the server from anywhere as if it were at home. Nothing on the router changes, and the server stays hidden from the internet. The free plan is enough.

## 6.1 Tailscale on the PC

**What:** install Tailscale and keep it connected.

**How:**

1. Install it from [tailscale.com/download](https://tailscale.com/download) and sign in.
2. Tray icon > Preferences > **Run unattended**: on. Without it, Tailscale stops when you log out.
3. At [login.tailscale.com](https://login.tailscale.com) > Machines > the PC > ⋯ > **Disable key expiry**. Otherwise the PC drops off after 180 days.
4. Optional: ⋯ > Edit machine name, to something short like `my-server`.

**Check:** restart Windows without logging in. The Machines page shows the PC as connected.

## 6.2 Firewall rule

**What:** let home devices and your Tailscale devices reach Jellyfin, nobody else.

**How:** in admin PowerShell, paste all three lines at once:

```powershell
New-NetFirewallRule -DisplayName "Jellyfin (LAN + Tailscale)" `
  -Direction Inbound -Protocol TCP -LocalPort 8096 `
  -RemoteAddress 100.64.0.0/10,LocalSubnet -Action Allow -Profile Any
```

`100.64.0.0/10` is the range Tailscale uses. `LocalSubnet` is your home network. Run it once; twice makes two rules.

To remove it: `Remove-NetFirewallRule -DisplayName "Jellyfin (LAN + Tailscale)"`

**Check:** the test in 6.3 works.

## 6.3 Your other devices

**How:** on each phone, tablet, laptop or PC you'll watch on:

1. Install Tailscale, sign in with the same account, turn it on.
2. In the Jellyfin app or a browser, add the server `http://my-server:8096`. If the name doesn't work, use `http://100.x.y.z:8096` (`tailscale ip -4` on the server shows it).

**Check:** leave the home network and play a movie. On a phone: Wi-Fi off, mobile data and Tailscale on. On a laptop: connect to your phone's hotspot.

## 6.4 Quality away from home

Away from home, a movie has to fit through your home **upload** speed. Rough needs:

| Stream | Upload needed |
|---|---|
| 720p | 2-4 Mbps |
| 1080p | 5-10 Mbps |
| 4K | 20-40 Mbps |

**How:**

1. Measure your upload with a speed test on the PC.
2. Pick one:
   - **All your devices are trusted:** Dashboard > Networking > LAN networks: your home range and `100.64.0.0/10`, for example `192.168.1.0/24, 100.64.0.0/10`. Tailscale devices then count as home, with no limit. Set limits on each device instead.
   - **Keep a limit:** Dashboard > Playback > Streaming > Internet streaming bitrate limit: about 80% of your upload.
3. On phones: Jellyfin app > Settings > maximum bitrate on mobile data, for example 4 Mbps. That's about 2 GB an hour.

**Check:** on mobile data, Playback Info shows a stream at or under your limit.

Next: [Part 7: Get movies automatically](07-get-movies-automatically.md)
