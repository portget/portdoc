# FileSender

## Overview

PortDIC provides a QUIC-based file transfer handler (`IFileSenderHandler`) backed by `portfilesender.dll` . It uses the QUIC protocol (UDP-based) for fast, reliable, and secure large-file transfers over an intranet.

**Key characteristics:**
- QUIC over UDP — lower latency than TCP for large files
- TLS with Certificate Pinning — MITM-resistant without a CA
- Parallel multi-stream transfer for multiple files simultaneously
- Chunked streaming I/O (`tokio::fs`) — every transfer streams from disk, so memory use stays flat regardless of file size
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
// Single file (chunked streaming from disk, auto-resume + integrity check)
handler.SendFile(@"C:\reports\daily.csv");

// Equivalent to SendFile; retained for backward compatibility
handler.SendFileMmap(@"C:\archive\backup.tar.gz");

// Multiple files in parallel (one QUIC stream per file)
handler.SendFilesParallel(new[]
{
    @"C:\data\file1.csv",
    @"C:\data\file2.csv",
    @"C:\data\file3.csv",
});
```

### Transfer behavior

The receiver enforces the following rules to protect the destination directory:

- **No overwrite (default).** If a file with the same name already exists in the
  save directory, the transfer is rejected instead of overwriting it. Remove or
  rename the existing file first.
- **Atomic writes.** Incoming data is written to a hidden temporary file and only
  renamed to its final name after the full, verified content is on disk. A failed
  or interrupted transfer never leaves a partial file under the final name.
- **Declared-size enforcement.** The receiver reads exactly the number of bytes the
  sender declared and rejects transfers whose body is short, over-long, or larger
  than the 100 GiB ceiling.
- **Acknowledged completion.** `SendFile` / `SendFileMmap` / `SendFilesParallel`
  succeed only after the receiver acknowledges the exact byte count. If the server
  rejects the file (e.g. name collision) or the sizes disagree, the send call
  fails (`-1` / throws) rather than reporting a false success.
- **End-to-end integrity.** The sender computes a SHA-256 of the file and the
  receiver verifies it before finalizing. A corrupted or mid-transfer-modified
  file is rejected instead of being saved.

### Resumable transfer & automatic retry

Transfers survive transient network interruptions without user intervention:

- **Resume from last verified offset.** Interrupted data is preserved in a hidden
  partial file (keyed by a per-file id derived from name + size + modified-time).
  A subsequent send of the same file continues from where it stopped instead of
  restarting — even across a **server restart**, since the partial is on disk.
- **Automatic retry with backoff.** `SendFile` / `SendFileMmap` reconnect and
  resume on transient failures (connection drop, timeout) with exponential
  backoff, up to a few attempts. Each retry raises a `RETRY` event.
- **No retry on permanent errors.** Server rejection, hash mismatch, or a
  missing/shrinking source file fail immediately without retrying.
- **Idempotent replay.** Re-sending a file that was already received (identical
  content) is acknowledged as success without creating a duplicate.

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
| `SendFile(string filePath)` | `int` | Send a single file (chunked streaming, resume + integrity check) |
| `SendFileMmap(string filePath)` | `int` | Equivalent to `SendFile`; kept for backward compatibility |
| `SendFilesParallel(string[] filePaths)` | `int` | Send multiple files using parallel QUIC streams |

Returns `0` on success; throws `IOException` on failure.

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
| `RETRY` | Client | A transient failure occurred; reconnecting and resuming |
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
