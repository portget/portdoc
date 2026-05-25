# FileSender

## Overview

PortDIC provides a QUIC-based file transfer handler (`IFileSenderHandler`) backed by `portfilesender.dll` . It uses the QUIC protocol (UDP-based) for fast, reliable, and secure large-file transfers over an intranet.

**Key characteristics:**
- QUIC over UDP — lower latency than TCP for large files
- TLS with Certificate Pinning — MITM-resistant without a CA
- Parallel multi-stream transfer for multiple files simultaneously
- Chunked streaming I/O (`tokio::fs`) — efficient for files > 100 MB
- 30-second idle timeout to prevent resource exhaustion

Each `[FileSender]` class registers its own independent QUIC endpoint.

---

## Quick Setup

### Server (receives files)

```csharp
using Portdic;
using Portdic.FileSender;

[FileSender]
public class FileReceiveServer
{
    [FileSenderHandler]
    public IFileSenderHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(FileSenderMode.Server);
        handler.SetHost("0.0.0.0");         // listen on all interfaces
        handler.SetPort(5000);
        handler.SetSaveDirectory(@"C:\Received");

        handler.OnFileReceived += OnFileReceived;
        handler.OnProgress += OnProgress;
        handler.OnEvent += OnEvent;
    }

    private void OnFileReceived(string name, string fileName, string filePath, long fileSize)
    {
        Console.WriteLine($"[{name}] Received: {fileName} ({fileSize} bytes) → {filePath}");
    }

    private void OnProgress(string name, string fileName, long transferred, long total, int percent)
    {
        Console.WriteLine($"[{name}] {fileName}: {percent}%");
    }

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
    }
}

Port.Add<FileReceiveServer>("file_server");
Port.Run();
```

### Client (sends files)

```csharp
[FileSender]
public class FileSendClient
{
    [FileSenderHandler]
    public IFileSenderHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(FileSenderMode.Client);
        handler.SetHost("192.168.1.100");
        handler.SetPort(5000);

        handler.OnProgress += OnProgress;
        handler.OnEvent += OnEvent;
    }

    private void OnProgress(string name, string fileName, long transferred, long total, int percent)
    {
        Console.WriteLine($"[{name}] {fileName}: {percent}%");
    }

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
    }
}

Port.Add<FileSendClient>("file_client");
Port.Run();
```

---

## Certificate Pinning (Secure Transfer)

QUIC uses TLS. By default the server generates a self-signed certificate; clients connect in skip-verify mode. To eliminate MITM risk, use Certificate Pinning:

**Step 1 — Server: retrieve the certificate after `Open()`**

```csharp
// After Open() succeeds on the server:
byte[] certDer = handler.GetServerCert();
File.WriteAllBytes(@"server.cer", certDer);   // distribute via trusted channel
```

**Step 2 — Client: pin the certificate before `Open()`**

```csharp
// In Preset() on the client side:
byte[] certDer = File.ReadAllBytes(@"server.cer");
handler.SetPinnedCert(certDer);               // must call before Open()
handler.Open();                               // uses Certificate Pinning
```

---

## Sending Files

```csharp
// Single file (loads into memory)
handler.SendFile(@"C:\reports\daily.csv");

// Large file (chunked streaming — recommended for files > 100 MB)
handler.SendFileMmap(@"C:\archive\backup.tar.gz");

// Multiple files in parallel (one QUIC stream per file)
handler.SendFilesParallel(new[]
{
    @"C:\data\file1.csv",
    @"C:\data\file2.csv",
    @"C:\data\file3.csv",
});
```

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[FileSender]` | Class | Marks the class as a FileSender handler container |
| `[FileSenderHandler]` | Property | Injects the `IFileSenderHandler` instance |
| `[Preset]` | Method | Called before `Open()` to configure the handler |

### `FileSenderMode` enum

| Value | Description |
|-------|-------------|
| `FileSenderMode.Server` | Listen and receive files |
| `FileSenderMode.Client` | Connect and send files |

### Configuration methods

| Method | Description |
|--------|-------------|
| `SetMode(FileSenderMode mode)` | Client or Server mode |
| `SetHost(string host)` | Server: bind address. Client: target server address |
| `SetPort(int port)` | QUIC port number |
| `SetSaveDirectory(string path)` | Directory to save received files (server mode only) |

### Connection methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Start server or prepare client endpoint |
| `Close()` | `ERROR_CODE` | Stop server or disconnect client |

### Send methods (client mode)

| Method | Returns | Description |
|--------|---------|-------------|
| `SendFile(string filePath)` | `int` | Send a single file (loads into memory) |
| `SendFileMmap(string filePath)` | `int` | Send a large file using chunked streaming |
| `SendFilesParallel(string[] filePaths)` | `int` | Send multiple files using parallel QUIC streams |

Returns `0` on success, `-1` on error.

### Security methods

| Method | Returns | Description |
|--------|---------|-------------|
| `GetServerCert()` | `byte[]` | Get server's DER certificate (server mode, after `Open()`) |
| `SetPinnedCert(byte[] certDer)` | — | Pin the expected server certificate before `Open()` (client mode) |

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated log files. Format: `quic_{name}_{date}_{hour}.log` |
| `SetLogger(string rootPath, PortLogConfiguration conf)` | Logging with custom rotation/retention |
| `WriteLog(string v)` | Write a custom entry to the log file |

---

## Events

### `OnProgress`

Fired periodically during file transfer.

```csharp
handler.OnProgress += (string name, string fileName, long transferred, long total, int percent) =>
{
    Console.WriteLine($"[{name}] {fileName}: {percent}% ({transferred}/{total})");
};
```

### `OnFileReceived`

Fired when a file is fully received (server mode only).

```csharp
handler.OnFileReceived += (string name, string fileName, string filePath, long fileSize) =>
{
    Console.WriteLine($"[{name}] Saved: {fileName} → {filePath} ({fileSize} bytes)");
};
```

### `OnEvent`

Fired on connection and transfer state changes.

```csharp
handler.OnEvent += (string name, string eventType, string description) =>
{
    Console.WriteLine($"[{name}] {eventType}: {description}");
};
```

| `eventType` | Mode | Triggered When |
|-------------|------|----------------|
| `SERVER_STARTED` | Server | Server is listening for connections |
| `CLIENT_READY` | Client | Client endpoint is ready |
| `CONNECTED` | Both | Connection established |
| `FILE_SENDING` | Client | File transfer started |
| `FILE_SENT` | Client | File transfer completed |
| `FILE_INCOMING` | Server | Incoming file transfer detected |
| `FILE_RECEIVED` | Server | File fully received and saved |
| `BATCH_COMPLETE` | Client | All parallel files transferred |
| `DISCONNECTED` | Both | Connection closed |
| `ERROR` | Both | Error occurred (description contains detail) |

---

## Error Codes

| Code | Value | Meaning |
|------|-------|---------|
| `ERR_CODE_NO_ERROR` | `1` | Success |
| `ERR_CODE_OPEN` | `-1` | Open failed |
| `ERR_CODE_DLL_NOT_LOADED` | `-2` | `portfilesender.dll` not loaded |
| `ERR_CODE_PORTNAME_EMPTY` | `-3` | Connection name not set |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | `-4` | Required DLL function unavailable |
| `ERR_CODE_CONNECT_FAILED` | `-5` | Connection attempt failed |

---

## Related

- [FTP](ftp) — FTP/FTPS file transfer (TCP-based)
- [TCP](tcp) — Raw TCP client/server communication
