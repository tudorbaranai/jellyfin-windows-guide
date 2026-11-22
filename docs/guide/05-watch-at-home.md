# Part 5: Watch at home

Test at home first. If it works here, any later problem is Tailscale, not Jellyfin.

## 5.1 Find the PC's address

**How:** in PowerShell, `ipconfig`. Under "Ethernet adapter" (or Wi-Fi), the IPv4 address, for example `192.168.1.50`.

**Check:** `http://192.168.1.50:8096` opens Jellyfin in a browser on another device at home. If it doesn't, do the firewall rule in [part 6.2](06-watch-anywhere.md#62-firewall-rule) now.

## 5.2 The apps

| Device | App |
|---|---|
| Android | Jellyfin (Google Play) |
| iPhone, iPad | Swiftfin (App Store) |
| Smart TV | Jellyfin, from the TV's app store |
| Mac, PC | Any browser, or Jellyfin Media Player |

**How:** add the server `http://192.168.1.50:8096` and sign in with the everyday account from [part 1](01-install-jellyfin.md#14-everyday-account).

**Check:** play a movie. Player ⋯ > **Playback Info** should say **Direct playing**. If it says Transcoding, the player's Quality is probably set too low: gear icon > Quality > **Auto**.

## 5.3 Keep the address (optional)

**What:** make the router always give the PC the same address.

**Why:** if it changes, the TV loses the server.

**How:** router admin page > DHCP or LAN > **Address reservation** for the PC.

**Check:** after a router restart, `ipconfig` shows the same address.

Next: [Part 6: Watch from anywhere](06-watch-anywhere.md)
