# Part 2: Keep the PC on

## 2.1 Never sleep when plugged in

**What:** no sleep or hibernate on power, screen off after 10 minutes.

**Why:** a sleeping PC is an offline server.

**How:** in admin PowerShell:

```powershell
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change monitor-timeout-ac 10
```

`0` means never. Only the "plugged in" values change.

**Check:** leave it alone for 30 minutes, then open `http://localhost:8096` from another device at home ([part 5](05-watch-at-home.md)) or just see that the PC is still awake.

These settings belong to the active **power plan**. Windows updates, battery saver or the maker's app can switch plans, and the PC sleeps again. Check now and then:

```powershell
powercfg /getactivescheme
```

## 2.2 Use a cable

**What:** connect the PC to the router with an Ethernet cable, if you can.

**Why:** Wi-Fi drops and sleeps. A cable is steadier for streaming.

**How:** plug it in. Settings > Network & internet > Ethernet > network profile **Private**.

**Check:** `ipconfig` shows an address under "Ethernet adapter".

## 2.3 Updates outside your movie hours

**What:** tell Windows when you use the PC, so it restarts at other times.

**How:** Settings > Windows Update > Advanced options > **Active hours** > Manually, for example 08:00 to 02:00.

**Check:** the page shows your range.

## 2.4 If it's a laptop

- **Lid does nothing** when plugged in, in admin PowerShell:

  ```powershell
  powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
  powercfg /setactive SCHEME_CURRENT
  ```

- **Cap the battery** at 60-80% in the maker's app (MyASUS, Lenovo Vantage, Dell Power Manager and the like). A battery kept at 100% all day wears out and can swell.

Next: [Part 3: Your media drive and library](03-drive-and-library.md)
