# SERIAL

## Overview

PortDIC provides a serial port communication handler (`ISerialHandler`) backed by `portserial.dll` . It supports RS232 and RS485 communication with configurable baud rate, data bits, parity, stop bits, background reading, auto-reconnection, and file logging.

Each `[Serial]` class registers its own independent COM port — multiple ports can be open simultaneously.

---

## Quick Setup

### 1. Define a serial handler class

```csharp
using Portdic;
using Portdic.Serial;

[Serial]
public class MySerialHandler
{
    [SerialHandler]
    public ISerialHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetPortName("COM3");
        handler.SetBaudRate(9600);
        handler.SetDataBits(8);
        handler.SetParity(SerialParity.None);
        handler.SetStopBits(SerialStopBits.One);
        handler.SetTimeout(1000);

        handler.OnDataReceived += OnData;
        handler.OnEvent += OnEvent;
    }

    private void OnData(string portName, byte[] data, string hex)
    {
        Console.WriteLine($"[{portName}] Received: {hex}");
    }

    private void OnEvent(string portName, string eventType, string description)
    {
        Console.WriteLine($"[{portName}] {eventType}: {description}");
    }
}
```

### 2. Register and run

```csharp
Port.Add<MySerialHandler>("serial_com3");
Port.Run();
```

---

## Multiple COM Ports

Each `[Serial]` class registration creates its own independent port instance:

```csharp
Port.Add<SerialHelper_COM3>("serial_com3");
Port.Add<SerialHelper_COM4>("serial_com4");
```

```csharp
[Serial]
public class SerialHelper_COM3
{
    [SerialHandler]
    public ISerialHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetPortName("COM3");
        handler.SetBaudRate(9600);
        handler.SetDataBits(8);
        handler.SetParity(SerialParity.None);
        handler.SetStopBits(SerialStopBits.One);
        handler.SetTimeout(1000);
        handler.OnDataReceived += OnData;
        handler.OnEvent += OnEvent;
    }

    private void OnData(string portName, byte[] data, string hex)
        => Console.WriteLine($"[COM3] {hex}");

    private void OnEvent(string portName, string eventType, string description)
        => Console.WriteLine($"[COM3] {eventType}: {description}");
}

[Serial]
public class SerialHelper_COM4
{
    [SerialHandler]
    public ISerialHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetPortName("COM4");
        handler.SetBaudRate(115200);
        handler.SetDataBits(8);
        handler.SetParity(SerialParity.None);
        handler.SetStopBits(SerialStopBits.One);
        handler.SetTimeout(500);
        handler.OnDataReceived += OnData;
        handler.OnEvent += OnEvent;
    }

    private void OnData(string portName, byte[] data, string hex)
        => Console.WriteLine($"[COM4] {hex}");

    private void OnEvent(string portName, string eventType, string description)
        => Console.WriteLine($"[COM4] {eventType}: {description}");
}
```

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[Serial]` | Class | Marks the class as a serial handler container |
| `[SerialHandler]` | Property | Injects the `ISerialHandler` instance |
| `[Preset]` | Method | Called before `Open()` to configure the handler |

### Configuration methods

| Method | Description |
|--------|-------------|
| `SetPortName(string portName)` | COM port name (e.g., `"COM3"`, `"COM4"`) |
| `SetBaudRate(int baudRate)` | Baud rate (e.g., 9600, 19200, 38400, 57600, 115200) |
| `SetDataBits(int dataBits)` | Data bits: 5, 6, 7, or **8** (default) |
| `SetParity(SerialParity parity)` | Parity mode (see table below). Default: `None` |
| `SetStopBits(SerialStopBits stopBits)` | Stop bits. Default: `One` |
| `SetTimeout(int timeoutMs)` | Read timeout in ms. Default: 1000 |

### `SerialParity` enum

| Value | Description |
|-------|-------------|
| `SerialParity.None` | No parity bit |
| `SerialParity.Odd` | Odd parity |
| `SerialParity.Even` | Even parity |

### `SerialStopBits` enum

| Value | Description |
|-------|-------------|
| `SerialStopBits.One` | 1 stop bit |
| `SerialStopBits.Two` | 2 stop bits |

### Connection methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Open the serial port and start background reading |
| `Close()` | `ERROR_CODE` | Close the serial port |
| `IsConnected` | `bool` | `true` if the port is currently open |
| `GetAvailablePorts()` | `string[]` | Returns all available COM port names on the system |

### Send methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Send(byte[] data)` | `int` | Send raw bytes |
| `Send(string text)` | `int` | Send UTF-8 string |

Returns the number of bytes sent, or `-1` on error.

### Reading

| Method | Description |
|--------|-------------|
| `StartReading()` | Start background reading (auto-called by `Open()`) |
| `StopReading()` | Stop background reading |

### Auto-reconnection

| Method | Description |
|--------|-------------|
| `SetAutoConnection(bool enable, int intervalMs)` | Enable auto-reconnect when the port disconnects. Retries every `intervalMs` ms |
| `TryReconnect()` | Manually restart the reconnect loop |

```csharp
handler.SetAutoConnection(true, 1000);  // retry every 1 second
```

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated SEND/RECV log files at `rootPath` |
| `SetLogger(string rootPath, PortLogConfiguration conf)` | Logging with custom rotation/retention settings |
| `WriteLog(string v)` | Write a custom entry to the active log file |

Log file format: `serial_{portName}_{date}_{hour}.log`

---

## Events

### `OnDataReceived`

Fired when data arrives from the serial port.

```csharp
handler.OnDataReceived += (string portName, byte[] data, string hex) =>
{
    Console.WriteLine($"[{portName}] {data.Length} bytes: {hex}");
};
```

| Parameter | Description |
|-----------|-------------|
| `portName` | COM port name (e.g., `"COM3"`) |
| `data` | Raw received bytes |
| `hex` | Hex string (e.g., `"48 65 6C 6C 6F"`) |

### `OnEvent`

Fired on connection state changes.

```csharp
handler.OnEvent += (string portName, string eventType, string description) =>
{
    Console.WriteLine($"[{portName}] {eventType}: {description}");
};
```

| `eventType` | Triggered When |
|-------------|----------------|
| `CONNECTED` | Serial port opened successfully |
| `DISCONNECTED` | Serial port closed |
| `ERROR` | Error opening or communicating (description contains detail) |

---

## Port Discovery

List all available COM ports before configuring:

```csharp
var ports = handler.GetAvailablePorts();
foreach (var port in ports)
    Console.WriteLine(port);  // e.g., COM3, COM4, COM7
```

---

## Error Codes

| Code | Value | Meaning |
|------|-------|---------|
| `ERR_CODE_NO_ERROR` | `1` | Success |
| `ERR_CODE_OPEN` | `-1` | Open failed |
| `ERR_CODE_DLL_NOT_LOADED` | `-2` | `portserial.dll` not loaded |
| `ERR_CODE_PORTNAME_EMPTY` | `-3` | Port name not set |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | `-4` | Required DLL function unavailable |
| `ERR_CODE_CONNECT_FAILED` | `-5` | Connection attempt failed |

---

## Common Configurations

| Device Type | Baud | Data | Parity | Stop | Notes |
|-------------|------|------|--------|------|-------|
| Arduino / general | 9600 | 8 | None | 1 | Default settings |
| Industrial RS485 | 19200 | 8 | None | 1 | Half-duplex |
| High-speed device | 115200 | 8 | None | 1 | Fast transfer |
| Legacy equipment | 9600 | 7 | Even | 2 | Older protocols |

---

## Related

- [TCP](tcp) — Ethernet TCP client/server communication
- [MQTT](mqtt) — Lightweight pub/sub messaging
- [SECS/GEM](secs) — Semiconductor equipment protocol (HSMS over TCP)
