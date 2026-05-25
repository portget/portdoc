# FTP

## Overview

PortDIC provides an FTP/FTPS communication handler (`IFTPHandler`) backed by `portftp.dll` . It supports file upload/download, directory management, bulk transfers, and progress callbacks. Both plain FTP and FTPS (TLS/SSL) are supported.

Each `[FTP]` class registers its own independent FTP connection.

---

## Quick Setup

### 1. Define an FTP handler class

```csharp
using Portdic;
using Portdic.FTP;

[FTP]
public class MyFTPHandler
{
    [FTPHandler]
    public IFTPHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetHost("192.168.1.100");
        handler.SetPort(21);
        handler.SetUsername("admin");
        handler.SetPassword("password");
        handler.SetSecure(false);   // true = FTPS (TLS)

        handler.OnProgress += OnProgress;
        handler.OnList += OnList;
        handler.OnEvent += OnEvent;
    }

    private void OnProgress(string name, string fileName, long transferred, long total, int percent)
    {
        Console.WriteLine($"[{name}] {fileName}: {percent}% ({transferred}/{total} bytes)");
    }

    private void OnList(string name, string json)
    {
        Console.WriteLine($"[{name}] Listing: {json}");
    }

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
    }
}
```

### 2. Register and run

```csharp
Port.Add<MyFTPHandler>("ftp_server1");
Port.Run();
```

---

## FTPS (Secure FTP)

```csharp
[Preset]
private void Preset()
{
    handler.SetHost("secure.server.com");
    handler.SetPort(990);           // FTPS implicit port
    handler.SetUsername("user");
    handler.SetPassword("pass");
    handler.SetSecure(true);        // enable TLS
    handler.SetPassive(true);       // passive mode (recommended)

    handler.OnEvent += OnEvent;
}
```

---

## File Operations

### Upload and download

```csharp
// Upload a single file
int result = handler.Upload(@"C:\local\report.csv", "/remote/reports/report.csv");

// Download a single file
int result = handler.Download("/remote/data/log.txt", @"C:\local\log.txt");

// Bulk upload — all files in a local directory
int count = handler.UploadDir(@"C:\local\batch", "/remote/batch");

// Bulk download — all files from a remote directory
int count = handler.DownloadDir("/remote/archive", @"C:\local\archive");
```

Returns the number of bytes (single file) or file count (bulk), or `-1` on error.

### Directory management

```csharp
// Get current working directory
string pwd = handler.Pwd();

// Change directory
handler.Cwd("/remote/data");

// Go up one level
handler.Cdup();

// Create directory
handler.Mkdir("/remote/new_folder");

// Remove empty directory
handler.Rmdir("/remote/old_folder");
```

### File management

```csharp
// Delete a file
handler.Delete("/remote/old_report.csv");

// Rename / move a file
handler.Rename("/remote/temp.csv", "/remote/final.csv");

// Get file size in bytes
long size = handler.Size("/remote/data.zip");
```

### Directory listing

```csharp
// Full listing (returns JSON array)
string json = handler.List("/remote/data");
// Each entry: { "name", "size", "is_dir", "modified", "raw" }

// File names only
string names = handler.Nlst("/remote/data");
// Returns JSON string array: ["file1.txt", "file2.csv", ...]
```

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[FTP]` | Class | Marks the class as an FTP handler container |
| `[FTPHandler]` | Property | Injects the `IFTPHandler` instance |
| `[Preset]` | Method | Called before `Open()` to configure the handler |

### Configuration methods

| Method | Description |
|--------|-------------|
| `SetHost(string host)` | FTP server address (e.g., `"192.168.1.100"`) |
| `SetPort(int port)` | Port number. Default: 21 (FTP), 990 (FTPS implicit) |
| `SetUsername(string username)` | Authentication username |
| `SetPassword(string password)` | Authentication password |
| `SetSecure(bool secure)` | `true` = FTPS (TLS/SSL); `false` = plain FTP |
| `SetPassive(bool passive)` | `true` = passive mode (default); `false` = active mode |

### Connection methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Open the FTP connection |
| `Close()` | `ERROR_CODE` | Close the FTP connection |
| `IsConnected` | `bool` | `true` if connected |

### Transfer methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Upload(localPath, remotePath)` | `int` | Upload a file |
| `Download(remotePath, localPath)` | `int` | Download a file |
| `UploadDir(localDir, remoteDir)` | `int` | Upload all files in a directory |
| `DownloadDir(remoteDir, localDir)` | `int` | Download all files from a directory |

### Directory & file methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Pwd()` | `string` | Current working directory |
| `Cwd(path)` | — | Change directory |
| `Cdup()` | — | Go to parent directory |
| `Mkdir(path)` | — | Create directory |
| `Rmdir(path)` | — | Remove empty directory |
| `List(path)` | `string` | JSON array of directory entries |
| `Nlst(path)` | `string` | JSON array of file names only |
| `Delete(path)` | — | Delete a file |
| `Rename(from, to)` | — | Rename or move a file |
| `Size(path)` | `long` | File size in bytes |

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated transfer log files |
| `WriteLog(string v)` | Write a custom entry to the log file |

---

## Events

### `OnProgress`

Fired during file transfer with progress updates.

```csharp
handler.OnProgress += (string name, string fileName, long transferred, long total, int percent) =>
{
    Console.WriteLine($"[{name}] {fileName}: {percent}%");
};
```

| Parameter | Description |
|-----------|-------------|
| `name` | Registration key |
| `fileName` | Name of the file being transferred |
| `transferred` | Bytes transferred so far |
| `total` | Total file size in bytes |
| `percent` | Progress percentage (0–100) |

### `OnList`

Fired when a directory listing result is available.

```csharp
handler.OnList += (string name, string json) =>
{
    // json: [{"name":"file.txt","size":1024,"is_dir":false,"modified":"...","raw":"..."}]
    Console.WriteLine(json);
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

| `eventType` | Triggered When |
|-------------|----------------|
| `CONNECTING` | Connection attempt started |
| `CONNECTED` | Connected to FTP server |
| `TLS_ESTABLISHED` | TLS handshake completed (FTPS) |
| `DISCONNECTED` | Connection closed |
| `UPLOADING` | File upload started |
| `UPLOADED` | File upload completed |
| `DOWNLOADING` | File download started |
| `DOWNLOADED` | File download completed |
| `CWD` | Directory changed |
| `MKDIR` | Directory created |
| `RMDIR` | Directory removed |
| `DELETED` | File deleted |
| `RENAMED` | File renamed |
| `ERROR` | Error occurred (description contains detail) |

---

## Error Codes

| Code | Value | Meaning |
|------|-------|---------|
| `ERR_CODE_NO_ERROR` | `1` | Success |
| `ERR_CODE_OPEN` | `-1` | Open/connect failed |
| `ERR_CODE_DLL_NOT_LOADED` | `-2` | `portftp.dll` not loaded |
| `ERR_CODE_PORTNAME_EMPTY` | `-3` | Connection name not set |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | `-4` | Required DLL function unavailable |
| `ERR_CODE_CONNECT_FAILED` | `-5` | Connection attempt failed |

---

## Related

- [FileSender](filesender) — QUIC-based high-speed file transfer
- [TCP](tcp) — Raw TCP communication
- [Serial](serial) — RS232/RS485 serial communication
