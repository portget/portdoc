---
slug: /
sidebar_position: 1
---

# Welcome to PortDIC

`"Any document can be a model."` 
Designed with the motto `"Documents Made Simple. Applications Built Fast"` port empowers users to implement OPC UA, SECS, MQTT, REST APIs, and script-based flow control through straightforward document creation. Additionally, with Port packages, users can create reusable libraries for .Net Frameworks.

Please see the documentation [license](license.md)

---

## From Document to Running Application in Minutes

PORT eliminates traditional programming. You write documents — PORT turns them into a running application.

### 1. Extract Tables from Any Document → Page File

Point `Port.Document<T>()` at any Word or Excel file. Implement `IParser` to describe how each row maps to a key, data type, and package — then PORT generates the `.page` schema and the matching C# class automatically.

```csharp
// Read a Word document table and produce a typed model
var ioDoc = Port.Document<IOModel>("eq-b01-001", @"IO.docx", new Parser());

// Override data types by key pattern — no schema file to edit
ioDoc.Where(v => v.Key.Contains("OnOff")).ToList()
     .ForEach(v => v.DataType = "Enum.OnOff");
ioDoc.Where(v => v.Key.Contains("Temp")).ToList()
     .ForEach(v => v.DataType = "f8");

// Auto-generate .page schema and .cs class from the document
if (ioDoc.Count > 0)
{
    ioDoc.New(@"sample\.page\io.page");   // PORT runtime schema
    ioDoc.New(@"sample\.net\io.cs");      // C# model class
}

// Push the page into the PORT runtime — available to all handlers immediately
Port.Push("eq-b01-001", ioDoc.NewPage("Device"));
```

Implement `IParser` once to tell PORT how to read each row:

```csharp
public class Parser : IParser
{
    public string GetKey(DataTable doc, DataRow row)
        => DocumentConverter.ConvertConstName(row[1].ToString());

    public string GetDataType(DataTable doc, DataRow row) => "Enum.OffOn";
    public string GetPackage(DataTable doc, DataRow row)  => "Device.OnOff";
    public string GetProperty(DataTable doc, DataRow row) => "";
}
```
 

---

### 2. IO Device Binding — Zero Wiring Code

Register a typed IO handler with one line. PORT reads the linked device document, handles polling, reconnection, and type conversion automatically — no driver code needed.

```csharp
Port.App<MainWindow>();

// Bind the digital IO device to the "Device" section of your page file.
// PORT reads heater.device, polls the hardware, and writes values into
// page variables on every cycle.
Port.Add<CrevisFnIO20>("DigitalIO", new PageFile("device", "Device"));

Port.Run();
```

> `PageFile("device", "Device")` links the handler to the `.device` XML document.
> PORT owns the polling loop, reconnection logic, and SECS type conversion — your code registers, then runs.

---

### 3. Flow Control — Document-Driven Process Automation

Register typed controllers with `Port.Add<TController, TModel>()`. PORT binds each controller to its model, executes steps, tracks state, and visualises progress in real time.

```csharp
Port.App<MainWindow>();

// Equipment handlers
Port.Add<LoadportController, LoadportModel>("LP1");
Port.Add<LoadportController, LoadportModel>("LP2");

// Wafer transfer robot
Port.Add<WTRController, WTRCommModel>("WTR");

// Job scheduler — PORT executes steps and tracks state automatically
Port.Add<JobController, JobModel>("Job");

Port.OnReady += (s, e) =>
{
    var device = Port.GetEntryKeysWithCategory("EFEM");
    vm.StartPolling(device.ToArray(), intervalMs: 500);
};

Port.Run();
```

Pair it with a `.rule` file for reactive, condition-based automation:

```text
# safety.rule
set("room1.HeaterOn == true", "room1.Temperature >= 95.0 => room1.HeaterOn = false")
```

---

### 4. Rich Handler Ecosystem — One Platform, Every Protocol

PORT ships built-in handlers so you never write transport or serialisation code:

| Handler | Protocol | What You Configure |
|---------|----------|--------------------|
| `TCPHandler` | TCP (Client / Server) | host, port, mode, reconnection |
| `SerialHandler` | RS232 / RS485 | COM port, baud rate, parity, stop bits |
| `FTPHandler` | FTP / FTPS | host, credentials, passive mode |
| `MQTTHandler` | MQTT | broker address, port, QoS, topics |
| `RTSPHandler` | RTSP (video stream) | stream URL, on-demand / continuous |
| `FileSenderHandler` | QUIC (file transfer) | host, port, save directory |
| `GemHandler` | SECS/GEM (HSMS-SS) | device ID, address, `.svid` / `.ceid` |
| `FlowHandler` | Step-based flow control | `[Flow]` + `[FlowStep]` class pair |
| `TransferHandler` | Substrate transfer scheduling | locations, arms, routing rules |
| `SessionHandler` | SEMI E30 session management | user roles, control states |

Every handler reads from the same shared in-memory page store, so data flows freely between protocols without any glue code.

---

## Key Benefits
- **Readable I/O Rules**: Attach Get/Set constraints to any page variable in plain text — PORT enforces them on every read and write without touching application code.
- **Multi-Protocol**: OPC UA, SECS/GEM, MQTT, and REST API on a single platform
- **Instant Reload**: Changes take effect immediately without recompilation
- **Reusable**: Build and share .NET libraries via Port packages

---
See the [Download](download.md) page for installation instructions and system requirements.
