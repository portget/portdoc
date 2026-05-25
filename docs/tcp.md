# TCP

## Overview

PortDIC provides a TCP communication handler (`ITCPHandler`) backed by `porttcp.dll` . It supports both **client** and **server** modes, background reading, automatic reconnection, and file logging.

Each `[TCP]` class registers its own independent TCP connection — multiple connections can coexist in the same application.

---

## Quick Setup

### 1. Define a TCP handler class

```csharp
using Portdic;
using Portdic.TCP;

[TCP]
public class MyTcpClient
{
    [TCPHandler]
    public ITCPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(TcpMode.Client);
        handler.SetHost("192.168.1.100");
        handler.SetPort(5000);
        handler.SetTimeout(5000);

        handler.OnDataReceived += OnData;
        handler.OnEvent += OnEvent;
    }

    private void OnData(string name, byte[] data, string hex)
    {
        Console.WriteLine($"[{name}] Received: {hex}");
    }

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
    }
}
```

### 2. Register and run

```csharp
Port.Add<MyTcpClient>("tcp_client1");
Port.Run();
```

---

## Client vs Server Mode

### TCP Client

```csharp
[TCP]
public class TcpClient_Example
{
    [TCPHandler]
    public ITCPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(TcpMode.Client);
        handler.SetHost("192.168.1.100");
        handler.SetPort(5000);
        handler.SetTimeout(5000);                     // connect timeout (ms)
        handler.SetReconnection(1000, 0);             // retry every 1s, infinite retries

        handler.OnDataReceived += OnData;
        handler.OnEvent += OnEvent;
    }

    // Send data after CONNECTED event
    private void OnEvent(string name, string eventType, string description)
    {
        if (eventType == "CONNECTED")
            handler.Send("Hello Server\r\n");
    }

    private void OnData(string name, byte[] data, string hex)
    {
        Console.WriteLine($"[{name}] {hex}");
    }
}

Port.Add<TcpClient_Example>("client1");
```

### TCP Server

```csharp
[TCP]
public class TcpServer_Example
{
    [TCPHandler]
    public ITCPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(TcpMode.Server);
        handler.SetHost("0.0.0.0");   // listen on all interfaces
        handler.SetPort(6000);

        handler.OnDataReceived += OnData;
        handler.OnEvent += OnEvent;
    }

    private void OnData(string name, byte[] data, string hex)
    {
        // Echo back to all connected clients
        handler.Send(data);
    }

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
    }
}

Port.Add<TcpServer_Example>("server1");
```

---

## Multiple Connections

Each `[TCP]` class registration creates its own independent connection:

```csharp
Port.Add<TcpHelper_Client>("tcp_plc1");
Port.Add<TcpHelper_Client>("tcp_plc2");
Port.Add<TcpHelper_Server>("tcp_server1");
```

The registration key (e.g., `"tcp_plc1"`) is the name passed to `OnDataReceived` and `OnEvent` callbacks.

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[TCP]` | Class | Marks the class as a TCP handler container |
| `[TCPHandler]` | Property | Injects the `ITCPHandler` instance |
| `[Preset]` | Method | Called before `Open()` to configure the handler |

### Configuration methods

| Method | Description |
|--------|-------------|
| `SetMode(TcpMode mode)` | `TcpMode.Client` or `TcpMode.Server` |
| `SetHost(string host)` | Target IP for client; `"0.0.0.0"` for server listening on all interfaces |
| `SetPort(int port)` | Port number |
| `SetTimeout(int timeoutMs)` | Connect timeout in ms (client only). Default: 5000 |

### Connection methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Connect (client) or start listening (server). Starts background reading automatically |
| `Close()` | `ERROR_CODE` | Disconnect or stop server |
| `IsConnected` | `bool` | `true` if connection or server is active |

### Send methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Send(byte[] data)` | `int` | Send raw bytes. In server mode, broadcasts to all clients |
| `Send(string text)` | `int` | Send UTF-8 string |

Returns the number of bytes sent, or `-1` on error.

### Reading

| Method | Description |
|--------|-------------|
| `StartReading()` | Start background reading (auto-called by `Open()`) |
| `StopReading()` | Stop background reading |

### Reconnection (client mode)

| Method | Description |
|--------|-------------|
| `SetReconnection(uint intervalMs, uint maxRetries)` | Enable auto-reconnect with exponential backoff (`intervalMs * 2^attempt`, max 30s). `maxRetries = 0` = infinite |
| `TryReconnect()` | Manually restart reconnect loop after `GIVE_UP` event |

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated SEND/RECV log files at `rootPath` |
| `SetLogger(string rootPath, PortLogConfiguration conf)` | Logging with custom rotation/retention settings |
| `WriteLog(string v)` | Write a custom entry to the active log file |

Log file format: `tcp_{name}_{date}_{hour}.log`

---

## Events

### `OnDataReceived`

Fired when data arrives from the remote peer.

```csharp
handler.OnDataReceived += (string name, byte[] data, string hex) =>
{
    Console.WriteLine($"[{name}] {data.Length} bytes: {hex}");
};
```

| Parameter | Description |
|-----------|-------------|
| `name` | Registration key (e.g., `"tcp_client1"`) |
| `data` | Raw received bytes |
| `hex` | Hex string (e.g., `"48 65 6C 6C 6F"`) |

### `OnEvent`

Fired on connection state changes.

```csharp
handler.OnEvent += (string name, string eventType, string description) =>
{
    Console.WriteLine($"[{name}] {eventType}: {description}");
};
```

| `eventType` | Triggered When |
|-------------|----------------|
| `CONNECTED` | Client connected to server |
| `DISCONNECTED` | Connection closed |
| `ERROR` | Connection error (description contains detail) |
| `LISTENING` | Server started and is accepting connections |
| `CLIENT_CONNECTED` | A client connected to the server |
| `CLIENT_DISCONNECTED` | A client disconnected from the server |
| `GIVE_UP` | Reconnect retries exhausted (`maxRetries` exceeded) |

---

## Error Codes

| Code | Value | Meaning |
|------|-------|---------|
| `ERR_CODE_NO_ERROR` | `1` | Success |
| `ERR_CODE_OPEN` | `-1` | Open/connect failed |
| `ERR_CODE_DLL_NOT_LOADED` | `-2` | `porttcp.dll` not loaded |
| `ERR_CODE_PORTNAME_EMPTY` | `-3` | Connection name not set |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | `-4` | Required DLL function unavailable |
| `ERR_CODE_CONNECT_FAILED` | `-5` | Connection attempt failed |

---

## Related

- [Serial](serial) — RS232/RS485 serial port communication
- [MQTT](mqtt) — Lightweight pub/sub messaging
- [SECS/GEM](secs) — Semiconductor equipment protocol
