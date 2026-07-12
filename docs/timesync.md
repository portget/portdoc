---
id: timesync
---

# TimeSync

**PORT TimeSync Client** is a lightweight Windows tray application that keeps every
PC on your factory network on the same clock. It monitors the clock offset against
one or more SNTP time hosts, can serve time itself, and finds hosts on the LAN
automatically via mDNS — no configuration files, no runtime dependencies.

## Download

| Name | Version | OS | Requirement | Link |
|------|---------|----|-------------|------|
| TimeSync Client (portable) | v1.0.0 | Windows x64 | None — single exe | [TimeSyncClient.zip](pathname:///file/TimeSyncClient.zip) |

:::tip Portable single file
The download is one self-contained executable. No installer, no .NET runtime, and
no extra DLLs are required — unzip and run `TimeSyncClient.exe`.
:::

## Key Features

- **Clock offset monitoring** — polls each registered host over SNTP (RFC 5905) and
  shows live *Offset (ms)*, *RTT (ms)*, and *Stratum* per host.
- **System tray** — the tray icon is tinted by the worst host status
  (green = OK, amber = offset over threshold, red = no reply), with balloon alerts
  when a host degrades. Closing the window hides the app to the tray.
- **Automatic host discovery (mDNS)** — hosts advertising `_porttime._udp.local`
  appear in the *Discovered hosts* list; select one and press **Add** to start
  monitoring it. Works with PORT time hosts on the LAN out of the box.
- **Built-in time host** — optionally serve SNTP time yourself
  (default bind `0.0.0.0:123`). While running, the host advertises itself over
  mDNS so other clients discover it automatically.
- **Start with Windows** — optional per-user autostart, minimized to the tray.

## Quick Start

1. Download and unzip [TimeSyncClient.zip](pathname:///file/TimeSyncClient.zip).
2. Run `TimeSyncClient.exe`. The main window opens; the app also appears in the tray.
3. Wait a moment — time hosts on your LAN show up under **Discovered hosts (mDNS)**.
   Select one and click **Add selected**, or type an address such as
   `192.168.10.10:123` and click **Add**.
4. Watch the **Hosts** grid: each row shows the live offset, round-trip time,
   stratum, and last-checked time.
5. To make this PC a time host, enable **Run local SNTP host** in *Settings* and
   click **Save**.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| Poll interval | 30 s | Seconds between automatic polls of every host |
| Timeout | 1000 ms | Per-query SNTP receive timeout |
| Warn offset | 100 ms | Absolute offset that turns a host amber and raises an alert |
| Run local SNTP host | Off | Serve time on the bind address below |
| Host bind | `0.0.0.0:123` | Bind address of the built-in time host |
| Start with Windows | Off | Per-user autostart at logon (starts in the tray) |
| Start minimized | Off | Start hidden in the tray instead of showing the window |

Settings persist to `%AppData%\PortTimeSync\settings.json`.

## Tray Menu

| Item | Action |
|------|--------|
| **Open** (double-click) | Restore the main window |
| **Sync now** | Poll all hosts immediately |
| **Run local host** | Toggle the built-in SNTP host |
| **Exit** | Stop the host and quit |

## How It Works

- **SNTP** — each poll is a single 48-byte request/response exchange. The client
  computes offset and delay from the four RFC 5905 timestamps and rejects replies
  whose *Originate Timestamp* does not match the request (stale/spoof guard).
  A positive offset means the local clock is behind the host.
- **mDNS discovery** — hosts advertise the service type `_porttime._udp.local`
  (RFC 6762/6763). The client browses continuously and resolves each instance to
  `ip:port`. Multi-homed machines are supported: the client joins the multicast
  group on every IPv4 interface.
- **Firewall note** — the built-in host listens on UDP 123 and mDNS uses
  UDP 5353 (multicast `224.0.0.251`). Allow these inbound on the *Private/Domain*
  profile if hosts are not discovered.

:::note Monitoring only
TimeSync Client reports clock offset — it does not modify the Windows system
clock. Use your OS time service (e.g. `w32tm`) or operator action to correct
clocks, guided by the measured offsets.
:::
