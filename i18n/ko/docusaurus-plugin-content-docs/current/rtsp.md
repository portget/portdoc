# RTSP

## Overview

PortDIC supports RTSP (Real Time Streaming Protocol) in two complementary modes:

| Mode | Interface | Use Case |
|------|-----------|----------|
| **Broadcast** | `RTSP` via `Port.BroadCast<RTSP>()` | System-wide RTSP relay; lifecycle managed by PortDIC |
| **Handler** | `IRTSPHandler` via `[RTSP]` / `[RTSPHandler]` | Per-instance client connection with full event callbacks |

---

## Broadcast Mode (System-Wide Relay)

The `RTSP` broadcast handler is a singleton. Configure it with `PortApplication.CreateBuilder()` and obtain it via `Port.BroadCast<RTSP>()`.

### Quick Setup

```csharp
using Portdic;

var config = PortApplication.CreateBuilder()
    .New(BroadcastType.RTSP)
    .StreamName("Camera_01")
    .StreamUrl("rtsp://192.168.1.100:554/stream")
    .OnDemand(true)
    .EnableAudio(true)
    .DebugMode(false)
    .Build();

var rtsp = Port.BroadCast<RTSP>();
Port.Run();
```

### Configuration Reference

| Method | Type | Default | Description |
|--------|------|---------|-------------|
| `StreamName(name)` | `string` | `""` | Identifies the stream for logging and monitoring |
| `StreamUrl(url)` | `string` | `""` | RTSP stream URL (e.g., `rtsp://host:554/path`) |
| `OnDemand(bool)` | `bool` | `true` | `true` = stream only when clients are connected |
| `EnableAudio(bool)` | `bool` | `true` | `true` = include audio; `false` = video only |
| `DebugMode(bool)` | `bool` | `false` | Enable verbose debug logging |
| `StreamStatus(int)` | `int` | `0` | Initial status code (0 = inactive) |

### Stream URL Formats

| Scenario | URL Example |
|----------|-------------|
| Anonymous access | `rtsp://192.168.1.100:554/stream` |
| Username + password | `rtsp://admin:password@192.168.1.50:554/h264` |
| Custom path | `rtsp://camera.company.com:554/live/main` |
| Default RTSP port (554) | `rtsp://10.0.0.5/channel1` |

---

## Handler Mode (Per-Instance Client)

The handler pattern creates one independent RTSP client per class registration. This mode is backed by `portrtsp.dll`  and provides full control over the connection lifecycle and events.

### 1. Define an RTSP handler class

```csharp
using Portdic;
using Portdic.RTSP;

[RTSP]
public class CameraStream
{
    [RTSPHandler]
    public IRTSPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetUrl("rtsp://192.168.1.100:554/stream1");
        handler.SetOnDemand(true);
        handler.SetAudio(true);

        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
    }
}
```

### 2. Register and run

```csharp
Port.Add<CameraStream>("camera_01");
Port.Run();
```

### Multiple streams

Each registration creates its own independent RTSP client:

```csharp
Port.Add<CameraEntrance>("cam_entrance");
Port.Add<CameraWarehouse>("cam_warehouse");
Port.Run();
```

```csharp
[RTSP]
public class CameraEntrance
{
    [RTSPHandler]
    public IRTSPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetUrl("rtsp://10.0.0.10:554/ch0");
        handler.SetOnDemand(false);
        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
        => Console.WriteLine($"[Entrance] {eventType}: {description}");
}

[RTSP]
public class CameraWarehouse
{
    [RTSPHandler]
    public IRTSPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetUrl("rtsp://10.0.0.11:554/ch0");
        handler.SetOnDemand(false);
        handler.SetAudio(false);
        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
        => Console.WriteLine($"[Warehouse] {eventType}: {description}");
}
```

### Explicit Open/Close

```csharp
// Open the stream manually
ERROR_CODE code = handler.Open();
if (code != ERROR_CODE.ERR_CODE_NO_ERROR)
    Console.WriteLine($"RTSP open failed: {code}");

// Check connection state
Console.WriteLine(handler.IsConnected);   // true / false

// Close the stream
handler.Close();
```

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[RTSP]` | Class | Marks the class as an RTSP handler container |
| `[RTSPHandler]` | Property | Injects the `IRTSPHandler` instance |
| `[Preset]` | Method | Called before `Open()` to configure the handler |

### Configuration methods

| Method | Description |
|--------|-------------|
| `SetUrl(string url)` | RTSP stream URL (e.g., `rtsp://192.168.1.100:554/stream`) |
| `SetStreamName(string name)` | Logical stream name for logging |
| `SetOnDemand(bool)` | Stream only on demand (`true`) or continuously (`false`) |
| `SetAudio(bool)` | Include audio track. Default: `true` |
| `SetDebug(bool)` | Enable verbose RTSP debug output. Default: `false` |

### Connection methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Open the RTSP stream connection |
| `Close()` | `ERROR_CODE` | Close the RTSP stream connection |
| `IsConnected` | `bool` | `true` if the stream is currently connected |

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated log files. Format: `rtsp_{name}_{date}_{hour}.log` |
| `WriteLog(string message)` | Write a custom entry to the log file |

---

## Events

### `OnEvent`

Fired on connection state changes and errors.

```csharp
handler.OnEvent += (string name, string eventType, string description) =>
{
    Console.WriteLine($"[{name}] {eventType}: {description}");
};
```

| `eventType` | Triggered When |
|-------------|----------------|
| `CONNECTED` | RTSP stream connection established |
| `DISCONNECTED` | Stream disconnected |
| `ERROR` | Error occurred (`description` contains detail) |

---

## Error Codes

| Code | Value | Meaning |
|------|-------|---------|
| `ERR_CODE_NO_ERROR` | `1` | Success |
| `ERR_CODE_OPEN` | `-1` | Open failed |
| `ERR_CODE_DLL_NOT_LOADED` | `-2` | `portrtsp.dll` not loaded |
| `ERR_CODE_PORTNAME_EMPTY` | `-3` | Stream name not set |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | `-4` | Required DLL function unavailable |
| `ERR_CODE_CONNECT_FAILED` | `-5` | Connection attempt failed |

---

## Related

- [MQTT](mqtt) — Lightweight pub/sub messaging for IoT
- [SECS/GEM](secs) — Semiconductor equipment protocol
- [TCP](tcp) — Raw TCP client/server communication
