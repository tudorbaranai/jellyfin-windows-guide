# Part 1: Install Jellyfin

## 1.1 Install as a service

**What:** install Jellyfin so it runs as a Windows service.

**Why:** a service starts with Windows, before anyone logs in, and restarts after a crash. The other option, a tray app, only runs while you're logged in.

**How:**

1. Download the Windows installer from [jellyfin.org](https://jellyfin.org/downloads/windows).
2. When it asks for the install type, pick **Install as a Service**.
3. Keep the default data folder, `C:\ProgramData\Jellyfin\Server`.

Already installed as a tray app? Quit it (tray icon > Exit) and run the installer again. Your settings stay.

**Check:** in PowerShell:

```powershell
Get-Service JellyfinServer | Select-Object Name, Status, StartType
```

Expect `Running` and `Automatic`. If it says `Manual`, in admin PowerShell:

```powershell
Set-Service JellyfinServer -StartupType Automatic
```

## 1.2 Admin account

**What:** open `http://localhost:8096` on the PC and go through the setup wizard.

**How:** pick the languages, then create the admin user with a strong password. Keep it in a password manager.

**Check:** you can open ☰ > **Dashboard**.

## 1.3 Remote access

**What:** allow remote connections, keep port mapping off.

**Why:** "remote" means any device that isn't this PC. Without it, your other devices can't connect, even at home. Port mapping would open your router to the internet, which this guide doesn't need.

**How:** on the wizard's remote access page, or later in Dashboard > Networking:

- Allow remote connections: **on**
- Automatic port mapping: **off** (newer versions don't have it)

**Check:** Dashboard > Networking shows remote access allowed.

## 1.4 Everyday account

**What:** a second user, without admin rights, for watching on your devices.

**Why:** apps stay signed in. If a device is lost or a TV is shared, that login can't change the server.

**How:** Dashboard > Users > **+**. Leave "Allow this user to manage the server" **off**.

**Check:** signed in as this user, there's no Dashboard in the menu.

Next: [Part 2: Keep the PC on](02-keep-it-on.md)
