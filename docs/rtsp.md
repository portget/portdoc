# RTSP

## Overview

PortDIC supports RTSP (Real Time Streaming Protocol) through the handler pattern.
Each `[RTSP]` class gets its own independent RTSP connection, and the operating mode
(`Client` or `Server`) is selected by calling `SetMode` in the `[Preset]` method.

| Mode | Description |
|------|-------------|
| `RtspMode.Client` | Connect to a remote RTSP source (default) |
| `RtspMode.Server` | Start an RTSP relay server that re-streams to downstream clients |

---

## Quick Start

### Client Mode (connect to a camera)

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
        handler.SetMode(RtspMode.Client);
        handler.SetUrl("rtsp://192.168.1.100:554/stream1");
        handler.SetOnDemand(true);
        handler.SetAudio(true);

        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
        => Console.WriteLine($"[{name}] {eventType}: {description}");
}
```

```csharp
Port.Add<CameraStream>("camera_01");
Port.Run();
```

### Server Mode (relay / re-streaming)

```csharp
[RTSP]
public class RtspRelay
{
    [RTSPHandler]
    public IRTSPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(RtspMode.Server);
        handler.SetHost("0.0.0.0");   // bind all interfaces
        handler.SetPort(8554);        // listen on this port
        handler.SetOnDemand(true);
        handler.SetAudio(true);

        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
        => Console.WriteLine($"[{name}] {eventType}: {description}");
}
```

```csharp
Port.Add<RtspRelay>("relay_01");
Port.Run();
```

---

## Multiple Streams

Each registration creates its own independent RTSP handler:

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
        handler.SetMode(RtspMode.Client);
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
        handler.SetMode(RtspMode.Client);
        handler.SetUrl("rtsp://10.0.0.11:554/ch0");
        handler.SetOnDemand(false);
        handler.SetAudio(false);
        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
        => Console.WriteLine($"[Warehouse] {eventType}: {description}");
}
```

---

## Explicit Open / Close

```csharp
// Open the stream (or start the server)
ERROR_CODE code = handler.Open();
if (code != ERROR_CODE.ERR_CODE_NO_ERROR)
    Console.WriteLine($"RTSP open failed: {code}");

// Check connection / server state
Console.WriteLine(handler.IsConnected);   // true / false

// Close
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

### Mode

| Method | Description |
|--------|-------------|
| `SetMode(RtspMode mode)` | Select `Client` (default) or `Server` mode |

### Client Configuration

| Method | Description |
|--------|-------------|
| `SetUrl(string url)` | RTSP stream URL (e.g., `rtsp://192.168.1.100:554/stream`) |
| `SetOnDemand(bool)` | Stream only on demand (`true`) or continuously (`false`) |
| `SetAudio(bool)` | Include audio track. Default: `true` |
| `SetDebug(bool)` | Enable verbose RTSP debug output. Default: `false` |

### Server Configuration

| Method | Default | Description |
|--------|---------|-------------|
| `SetHost(string host)` | `"0.0.0.0"` | Bind address for server mode |
| `SetPort(int port)` | `8554` | Listen port for server mode |
| `SetStreamName(string name)` | — | Logical stream name for logging |

### Connection

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Connect to source or start the relay server |
| `Close()` | `ERROR_CODE` | Disconnect or stop the relay server |
| `IsConnected` | `bool` | `true` if connected / server is running |

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
| `CONNECTED` | Client connected / server started |
| `DISCONNECTED` | Client disconnected / server stopped |
| `ERROR` | Error occurred (`description` contains detail) |

---

## RTSP URL Formats

| Scenario | URL Example |
|----------|-------------|
| Anonymous access | `rtsp://192.168.1.100:554/stream` |
| Username + password | `rtsp://admin:password@192.168.1.50:554/h264` |
| Custom path | `rtsp://camera.company.com:554/live/main` |
| Default RTSP port (554) | `rtsp://10.0.0.5/channel1` |

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
