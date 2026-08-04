# Library Reference

Complete API reference for the PortDIC .NET library — all public types organized by category.

---

## Port (static class)

`Port` is the top-level static façade for the entire PortDIC runtime.  
All methods are called directly on the class: `Port.Run()`, `Port.Set(…)`, `Port.Get(…)`, etc.

---

### Initialization

| Method | Description |
|--------|-------------|
| `Port.App<T>()` | Reads `[Portdic]` attribute on `T`, loads the repository, and initializes the runtime. Call once before any `Add` calls. When `T` carries `[Subscribe]` instead, the process starts in Subscriber Mode: it attaches to another process's running repository (wait + retry) without push/pull or server launch. |
| `Port.App<T>(T instance)` | Same as above, plus scans `instance` for GEM message attribute handlers (`[CarrierActionRequest]`, etc.) and wires them automatically. Pass `this` from the main window. In Subscriber Mode, scans `instance` for `[EntryTrigger]` handlers instead. |
| `Port.App<T>(T instance, Action onReady)` | Same as `App<T>(instance)`, plus calls `onReady` once when the port reaches `Synchronized` state. |
| `Port.Run()` | Starts the Port server process, connects gRPC/REST services, initializes all registered packages, and fires `OnReady` when ready. |

```csharp
// Typical WPF startup
Port.App<MainWindow>(this);
Port.Add<LP1Controller>("LP1");
Port.Add<GemHelper>("GEM", new GemCEID(), new GemALID());
Port.Run();
```

---

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Port.Status` | `PortHostStatus` | Current connection state of the Port dictionary service. |

---

### Events

#### Connection Events

| Event | Handler signature | When fired |
|-------|------------------|------------|
| `Port.OnReady` | `EventHandler` | Port reaches `Synchronized` state — safe to call `Set`/`Get`. |
| `Port.OnConnected` | `ConnectedEventHandler(sender, ConnectionEventArgs)` | Any registered serial / TCP / RTSP / MQTT package establishes a connection. `sender` = connection name; `e.ConnectionString` = driver descriptor (e.g. `"COM3:9600"`). |
| `Port.OnDisconnected` | `DisconnectedEventHandler(sender, ConnectionEventArgs)` | Any registered package loses its connection. |

#### Subscriber Events (Subscribe Mode)

Available when the application class carries `[Subscribe("repoName")]` instead of `[Portdic]`.
`Port.Set` / `Port.Get` work in this mode too — they route through the FFI directly to the
Publisher's repository. See the [Attribute → Subscribe Mode](attribute.md#subscribe-mode) page.

| Event | Handler signature | When fired |
|-------|------------------|------------|
| `Port.OnEntryChanged` | `EntryChangedHandler(string key, string value)` | An entry value change detected by the subscriber's shared-memory scan (default 50 ms; state-sync semantics — the latest value per key per tick). Delivered on a background dispatch pipeline, never the UI thread. |
| `Port.OnSubscriberConnected` | `SubscriberConnectedHandler()` | This process registered (or re-registered after a Publisher restart) with the port server. |
| `Port.OnSubscriberDisconnected` | `SubscriberDisconnectedHandler()` | Connection to the Publisher's port server lost; a background monitor keeps retrying until reconnected. |

#### Subscribe Mode UI Binding

`portdic.dll` ships framework-independent binding primitives; the separate
`Portdic.UI` assembly (net472 / net8.0-windows) adds ready-made WPF and WinForms
controls on top of them.

| Type | Description |
|------|-------------|
| `BindableEntry` | Two-way `INotifyPropertyChanged` source for one entry. `Text` / `Number` write through `Port.Set`; live updates arrive already marshaled to the constructing thread's `SynchronizationContext`. Dispose to detach. |
| `SubscriberViewModel` | MVVM base class: `Bind("room1.Temp1")` / `BindGroup("room1.*")` vend tracked bindings; disposing the ViewModel disposes them all. |
| `BindableEntryCollection` | `ObservableCollection<BindableEntry>` for a group wildcard — seeds existing keys from the memory map and adds rows as new keys appear. Bind to a grid's `ItemsSource`. |
| `Portdic.UI.Wpf` | `EntryLabel` (`Key`), `EntryDataGrid` (`GroupPattern`, editable Key/Value grid), and `EntryBinding.Key` / `.GroupPattern` attached properties for standard controls. |
| `Portdic.UI.WinForms` | `EntryLabel`, `EntryDataGridView`, and `EntryBinder.Bind(control, key)` / `EntryBinder.BindGrid(grid, pattern)` helpers for existing controls. |

```csharp
public class RoomViewModel : SubscriberViewModel
{
    public BindableEntry Temp1 { get; }
    public BindableEntryCollection Room1 { get; }
    public RoomViewModel()
    {
        Temp1 = Bind("room1.Temp1");     // XAML: {Binding Temp1.Text, Mode=TwoWay}
        Room1 = BindGroup("room1.*");    // XAML: <DataGrid ItemsSource="{Binding Room1}"/>
    }
}
```

#### Flow Events

| Event | Handler signature | When fired |
|-------|------------------|------------|
| `Port.OnFlowStatusChanged` | `FlowStatusChangedHandler(_, FlowStatusChangedArgs)` | Any flow transitions between states. `e.Key` = `"Category.FlowName"`. `e.NewStatus` / `e.OldStatus` = `FlowAction` ordinal (0=Idle, 1=Init, 2=Executing, 3=Stopped, 4=Canceled, 5=Issue). Prefer this over `OnFlowSleep` for per-flow completion detection. |
| `Port.OnFlowAwake` | `FlowAwakeHandler(_, FlowAwakeArgs)` | Global edge-trigger — fires once when executing flow count goes 0 → 1. `e.Key` = flow that triggered it. |
| `Port.OnFlowSleep` | `FlowSleepHandler(_, FlowSleepArgs)` | Global edge-trigger — fires once when executing flow count drops to 0. Not fired if any flow remains permanently Executing. |
| `Port.OnFlowOccurredAlarm` | `FlowOccurredAlarmHandler(_, FlowOccurredAlarmArgs)` | Flow enters alarm state. `e.AlarmCode`: 1=Stopped, 2=Canceled, 3=Issue (unhandled exception). |

#### Equipment Events

| Event | Handler signature | When fired |
|-------|------------------|------------|
| `Port.OnCarrierSlotStatusChanged` | `LMCSlotStatusChangedHandler` | A carrier slot status changes (occupied / empty / reserved). |
| `Port.ModuleStateChanged` | `ModuleStateChangedHandler` | A module transitions between SEMI E39 process states. |
| `Port.OnFlowCompleted` | `ModuleStateChangedHandler` | A module-level flow completes execution. |
| `Port.OnSubstrateUpdated` | `SubstrateUpdatedHandler(SubstrateUpdatedArgs)` | A substrate's route progress advances. Args carry the substrate key, full route plan with progress index, and the location where the update occurred. |
| `Port.OnRequestLotQueued` | `LotQueuedRequestHandler(CarrierJob)` | A CarrierJob is queued into the TM scheduler by `Port.Job.Execute`. |
| `Port.OnRequestLotProcessing` | `JobExecutingRequestHandler(jobId)` | Lot processing is requested for the given lot ID. |
| `Port.OnJobCompleted` | `JobCompletedHandler` | A job finishes all processing. |
| `Port.OnGemEventReport` | `GemEventReportHandler` | GEM event report is generated. |

```csharp
Port.OnFlowStatusChanged += (_, e) =>
{
    if (e.Key == "Scheduler.Queued" && e.NewStatus == (int)FlowAction.Idle)
        HandleCompletion();
};

Port.OnConnected += (sender, e) =>
    Console.WriteLine($"{sender} connected: {e.ConnectionString}");
```

---

### Registration — Add

| Method | Description |
|--------|-------------|
| `Port.Add<T>(string key)` | Registers a singleton of type `T` identified by `key`. If `T` carries `[Page]`, pushes its `[Entry]` fields to the database instead. If `T` is `SetTrigger`, registers a set-trigger for `key`. |
| `Port.Add<T>(string key, string model)` | Registers `T` and binds it to the named flow model. |
| `Port.Add<TController, TModel>(string key)` | Registers a `[Controller]`/`[Model]` pair. |
| `Port.Add<T>(string key, params object[] models)` | Registers `T` alongside model instances. When `T` carries `[GEM]`, binds `[CEID]`, `[ALID]`, `[SVID]`, `[DVID]`, `[ECVID]` models. When `T` is `GetTrigger`, registers a get-trigger. |
| `Port.Add(IDevice device)` | Registers a device instance directly. |
| `Port.Add(IModule module)` | Registers a module instance directly. |
| `Port.Add<T>(string key, PageFile pageFile)` | Registers `T` with an associated `PageFile` page binding. |
| `Port.Add<T>(string key, params string[] subkey)` | Registers a module entity (`LoadModuleEntity`, `ProcessModuleEntity`, `TransferModuleEntity`, or a subclass) under the location `key` and binds it to the pre-registered controller keys in `subkey`. |
| `Port.Add<T>(string key, int slotMaxCount, params string[] subkey)` | Same as above, plus seeds the per-location `LocationEntity` singleton with `slotMaxCount` — the single source of truth for slot counts (e.g. 25 for a FOUP load port, 1 for a single-wafer stage, 2 for a dual-arm transfer module). Throws `ArgumentOutOfRangeException` when `slotMaxCount < 1` and `InvalidOperationException` when `T` is not a module entity type. |

```csharp
Port.Add<LP1Controller>("LP1");
Port.Add<StageController, StageModel>("Stage1");
Port.Add<GemHelper>("GEM", new GemCEID(), new GemALID(), new GemSVID());

// Module registration with slot capacity → seeds LocationEntity
Port.Add<ILoadModuleEntity>("LP1", 25, "LP1Controller");     // engine default (EmptyParameter/EmptyConfigure)
Port.Add<IProcessModuleEntity>("Stage1", 1, "Stage1Controller");
Port.Add<MyEquipment>("TM1", 2, "RobotController");   // TransferModuleEntity<P,C> subclass

int slots = Port.Entity.Location("LP1").SlotCount;    // 25
```

---

### Set — Data Values

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.Set(string category, string entireName, EntryValue value)` | `bool` | Sets a typed `EntryValue`. |
| `Port.Set(string categoryMessage, EntryValue value)` | `bool` | Same using dot-notation (`"category.key"`). |
| `Port.Set(string category, string entireName, double value)` | `bool` | Sets a `double`. |
| `Port.Set(string category, string entireName, string value)` | `bool` | Sets a `string`. |
| `Port.Set(string categoryMessage, string value)` | `bool` | Sets a `string` via dot-notation. |
| `Port.Set(string categoryMessage, double value)` | `bool` | Sets a `double` via dot-notation. |
| `Port.Set(string categoryMessage, int value)` | `bool` | Sets an `int` via dot-notation. |
| `Port.Set(SecsSystemBytes systemBytes, ISecsData value)` | `bool` | Sets SECS data correlated by system bytes. |

### Set — Flow & Controller Control

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.Set(string flowName, FlowAction action)` | `bool` | Sends a `FlowAction` (Start / Stop / Pause / Resume) to a named flow. |
| `Port.Set(string controller, string flowName, FlowAction action)` | `bool` | Sends a `FlowAction` to a specific controller's named flow. |
| `Port.Set(string controller, ControlAction action)` | `bool` | Applies a `ControlAction` (Lock / Release / Abort) to a controller. |
| `Port.Set(string packageName, NetworkAction action)` | `bool` | Applies a `NetworkAction` (Connect / Reconnect) to a registered package's handler. |

### Set — Simulation Mode

Simulation methods are no-ops unless `Port.SetSimulation(true)` has been called first.

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.SetSimulation(bool flag)` | `void` | Enables or disables simulation mode globally. |
| `Port.SimulationSet(string category, string entireName, EntryValue value)` | `bool` | Sets an `EntryValue` only in simulation mode. |
| `Port.SimulationSet(string category, string entireName, string value)` | `bool` | Sets a `string` only in simulation mode. |
| `Port.SimulationSet(string category, string entireName, double value)` | `bool` | Sets a `double` only in simulation mode. |
| `Port.SimulationSet(string categoryMessage, string value)` | `bool` | Dot-notation; simulation mode only. |
| `Port.SimulationSet(string categoryMessage, double value)` | `bool` | Dot-notation; simulation mode only. |
| `Port.SimulationSet(string categoryMessage, int value)` | `bool` | Dot-notation; simulation mode only. |

---

### Get — Data Values

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.Get(string categoryMessage)` | `EntryValue` | Retrieves a value via dot-notation (`"category.key"`). |
| `Port.Get(string category, string entireName)` | `EntryValue` | Retrieves a value by explicit category and key. |
| `Port.Get(FlowAction action)` | `List<string>` | Returns names of flows in the given state. Only `FlowAction.Executing` is supported; all others return empty list. |
| `Port.Get(string controllerName, out ControlStatus status)` | `bool` | Writes the controller's current `ControlStatus` into `status`. Returns `false` if controller not found. |

### Get — Objects & Metadata

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.GetEntity<T>(string category)` | `T` | Returns the singleton `IEntity` registered under `category`. Supported types: `CarrierEntity`, `LoadModuleEntity`, `ProcessModuleEntity`, `TransferModuleEntity`, `LocationEntity`, `FlowEntity`, `ModuleSubstrateEntity`. (The active job is not an entity — use `Port.Job.GetActiveJob`.) |
| `Port.Entity.Location(string category)` | `LocationEntity` | Returns the `LocationEntity` singleton seeded by `Port.Add<T>(key, slotMaxCount, ...)`; exposes `LocationKey` and `SlotCount`. |
| `Port.GetEntity<T>(string category, int subKey)` | `T` | Returns the per-slot singleton identified by `category:subKey` (1-based). Primary use: `ModuleSubstrateEntity` per slot. |
| `Port.GetEntryKeys(string category)` | `List<string>` | Returns the bare entry key names registered under `category`. |
| `Port.GetEntryKeysWithCategory(string category)` | `List<string>` | Returns fully-qualified keys in `"category.key"` format. |
| `Port.GetModule(string key)` | `IModule` | Returns the module registered under `key`. |
| `Port.GetDevice(string key)` | `IDevice` | Returns the device registered under `key`. |

---

### Push / Pull — Database Management

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.Push(string reponame, object obj)` | `bool` | Scans a `[Document]`-decorated class instance and pushes all `[EntryEnum]` and `[Entry]` fields to the database. Also accepts a directory path string. |
| `Port.Push(string reponame, string key, PortDataType dataType, params IEntryAttribute[])` | `bool` | Registers a single entry in `"category.name"` format. |
| `Port.Push(string reponame, string key, PortDataType dataType, string enumName, params IEntryAttribute[])` | `bool` | Registers a single enum-typed entry with the named enum. |
| `Port.Push(string reponame, Page page)` | `bool` | Pushes an entire `Page` to the repository. |
| `Port.Push(RepositoryInfo repo)` | `bool` | Pushes from a `RepositoryInfo` (directory-based). |
| `Port.Pull(string reponame, string root)` | `bool` | Runs `port pull <reponame>` in `root` and generates `entry.cs`. Returns `true` on exit code 0. |
| `Port.Output(string outputDir)` | `bool` | Generates `entry.cs` for the currently loaded repository into `outputDir` (created when missing). Each page category becomes a `[PageDocument]` class whose constants carry `[PageEntry]` metadata; the classes can be re-pushed via `Port.Push()`. Call **before** `Port.Run()` — the page DB is locked while the server runs. Equivalent CLI: `port output <dir>`. |

```csharp
// Push a [Document]-decorated class
Port.Push("myapp", new CustomEFEM());

// Push a single entry
Port.Push("myapp", "EFEM.LP1_Cont_o", PortDataType.Enum, "OffOn",
    new PropertyAttribute("Min", "0"), new PropertyAttribute("Max", "1"));

// Pull and generate C# constants
Port.Pull("myapp", "./generated");

// Generate entry.cs directly from the page DB (call before Port.Run())
Port.Repository.Load("myapp");
Port.Output("./generated");
```

---

### Document

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.Document<T>(string filename)` | `Document<T>` | Loads a document file and extracts a table using `[ColumnHeader]` attributes on `T`. |
| `Port.Document<T>(string reponame, string filename, IParser parser)` | `Document<T>` | Same, with an explicit `IParser` for column mapping. |

---

### MQTT Broker

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.StartMqttBroker(string reponame, string options = "")` | `int` | Starts the embedded MQTT broker for the repository. `options` = comma-separated `key=value` pairs forwarded to the Go DLL. Returns `MqttBrokerErrorCode`. |
| `Port.StopMqttBroker(string reponame)` | `int` | Stops the MQTT broker. Returns `MqttBrokerErrorCode`. |
| `Port.PublishMqttModelValue(string reponame, string modelName, string controllerName, string key, string value)` | `int` | Publishes a single value to `{modelName}/{controllerName}/{key}`. |
| `Port.PublishMqttModelValues(string reponame, string modelName, string controllerName, Dictionary<string, string> values)` | `int` | Publishes multiple key-value pairs in one call. |

### MqttBrokerErrorCode

| Constant | Value | Meaning |
|----------|-------|---------|
| `Success` | 0 | Operation succeeded. |
| `DllNotLoaded` | -1 | `portmqtt.dll` is not loaded. |
| `BrokerStartFailed` | -2 | The Go broker returned a non-zero exit code. |
| `PublishFailed` | -3 | Broker rejected one or more publishes. |

---

### Utility

| Method | Returns | Description |
|--------|---------|-------------|
| `Port.RecordMsTime(string category, string fullKey)` | `void` | Writes elapsed milliseconds since the first call for `category` into the shared-memory entry at `fullKey`. Auto-resets when the entry value is `0.0`. |
| `Port.IsTransferBlocked(string tmName, string location)` | `bool` | Returns `true` if a `[TransferBlockWhenExecutingFlow]` flow for the given TM and location is currently Executing. |
| `Port.IsProcessModule(string moduleKey)` | `bool` | Returns `true` when `moduleKey` was registered as a process module via `Port.Add<IProcessModuleEntity>(moduleKey, controllerKey)`. Use this to branch on the registered module type instead of matching location-name conventions. |
| `Port.Job.Queued(CarrierJob job)` | `bool` | Registers a `CarrierJob` in the queue under its `ID` without starting it. |
| `Port.Job.Execute(string jobID, int repeatCount = 0)` | `bool` | Starts a queued job: resolves the load port from `CarrierJob.Location`, converts slot routes to scheduler recipes, and begins execution. |
| `Port.Job.Execute(CarrierJob job)` | `bool` | One-call register + start when the carrier `ID` is already docked. |
| `Port.Job.GetActiveJob(string moduleKey)` | `CarrierJob` | The active job on the transfer module, or `null`. |
| `Port.Job.ClearActiveJob(string moduleKey)` | `void` | Clears the active job on the transfer module. |
| `Port.Job.GetAllRoutes()` | `IEnumerable<RouteInfo>` | Snapshot of every substrate route and its step progress. |
| `Port.HandleCrash(Exception ex)` | `void` | Reports an unhandled exception to the Port diagnostic system. |
| `Port.SetDumpUsed(bool value)` | `void` | Enables or disables heap dump collection for diagnostic monitoring. |

---

### NetworkAction Enum

| Value | Int | Description |
|-------|-----|-------------|
| `None` | 0 | No operation. |
| `Connect` | 1 | Calls `Open()` on the package handler. |
| `Reconnect` | 2 | Calls `TryReconnect()` on the package handler. |

---

### FlowAction Values (reference)

| Ordinal | Name | Meaning |
|---------|------|---------|
| 0 | Idle | Flow is not running. |
| 1 | Initialization | Flow is initializing. |
| 2 | Executing | Flow is actively running. |
| 3 | Stopped | Flow was stopped. |
| 4 | Canceled | Flow was canceled. |
| 5 | Issue | Flow failed with an unhandled exception. |

---

## IPortDic

The main entry point for all Port Dictionary operations. Obtain an instance via `Port.GetDictionary(name)`.

### Methods — Set

| Signature | Description |
|-----------|-------------|
| `bool Set(string category, string entireName, EntryValue value)` | Sets a typed `EntryValue` for the given category/key pair. |
| `bool Set(string category, string entireName, double value)` | Sets a `double` value for the given category/key pair. |
| `bool Set(string category, string entireName, string value)` | Sets a `string` value for the given category/key pair. |
| `bool Set(string categoryMessage, string value, bool isAsync = false)` | Sets a `string` using dot-notation (`"category.key"`). |
| `bool Set(string categoryMessage, double value)` | Sets a `double` using dot-notation (`"category.key"`). |
| `bool Set(string categoryMessage, int value)` | Sets an `int` using dot-notation (`"category.key"`). |
| `bool Set(SecsSystemBytes systemBytes, ISecsData value)` | Sets SECS data correlated by system bytes. |
| `bool Set(string flowName, FlowAction action)` | Controls a named flow (Start / Stop / Pause / Resume). |

**Returns** `true` on success, `false` if the port is not running or the operation fails.  
**Throws** `NotExistsKeyException` when the key has not been registered.

```csharp
port.Set("room1", "BulbOnOff", "On");
port.Set("Process.Temperature", 150.5);
port.Set("ProductionFlow", FlowAction.Start);
```

---

### Methods — Get

| Signature | Description |
|-----------|-------------|
| `EntryValue Get(string categoryMessage)` | Retrieves a value using dot-notation (`"category.key"`). |
| `EntryValue Get(string category, string entireName)` | Retrieves a value by explicit category and key. |

**Returns** an `EntryValue` with `.Text()` / `.Double()` / `.Int()` accessors, or `null` if not found.

```csharp
var temp = port.Get("Process.Temperature");
Console.WriteLine(temp.Double());     // 150.5

var status = port.Get("room1", "BulbOnOff");
Console.WriteLine(status.Text());     // "On"
```

---

### Methods — Registration

| Signature | Description |
|-----------|-------------|
| `void Add<T>(string key)` | Registers a singleton of type `T` identified by `key`. |
| `void Add<T>(string key, string model)` | Registers `T` and binds it to a flow model name. |
| `void Add<TController, TModel>(string key)` | Registers a `[Controller]` + `[Model]` pair. |
| `void Add<T>(string key, params object[] models)` | Registers `T` alongside one or more model instances (`[CEID]`, `[ALID]`, `[SVID]`, …). |
| `void Add(ref IReference packages, ReferenceModel bindingMessage)` | Scans assemblies for `[Import]` attributes and performs bulk injection. |
| `bool Add(FuncCode funCode, Options options)` | Registers a protocol handler by function code + options. |
| `bool Add(FuncCode funCode, Type type)` | Registers a protocol handler type by function code. |
| `bool New(string category, string entireName, DataType dataType, params IEntryAttribute[] attributes)` | Dynamically defines a new entry in the dictionary. |

```csharp
port.Add<LP1Controller>("LP1");
port.Add<VisionController, VisionModel>("Vision");
port.Add<GemHandler>("GEM", new CeidModel(), new AlidModel());
```

---

### Methods — Lifecycle & Utility

| Signature | Description |
|-----------|-------------|
| `bool Run([CallerMemberName] string callerName = "")` | Starts the Port server and all communication services. |
| `T BroadCast<T>() where T : IBroadcast` | Returns or creates a broadcast protocol object (GEM / MQTT / RTSP / OPC UA). |
| `IFlowController GetController(string name)` | Returns the flow controller for the named package. |
| `T GetObject<T>(string category) where T : class, IEntity` | Returns the singleton entity registered under `category`. |
| `T GetObject<T>(string category, int subKey) where T : class, IEntity` | Returns the per-slot entity at `category:subKey`. |
| `bool Push(string repoName, string category, Page list)` | Pushes a `Page` to the specified repository/category. |
| `bool Push(string repoName, string category, Page list, string outputDir, string namespaceName = "portdic")` | Pushes a `Page` and generates a C# const-key file. |
| `void Profile()` | Activates performance profiling and diagnostic monitoring. |

---

### Events

| Event | Handler Type | When Fired |
|-------|-------------|------------|
| `OnStatusChanged` | `StatusHandler` | Port server status changes (Initializing → Running → Stopped / Failed). |
| `OnOccurred` | `PortEventHandler` | Any system event (Info / Warning / Error / CatchException). |
| `OnRequest` | `RequestHandler` | An external command or request arrives. |
| `OnFlowOccurred` | `FlowOccurredHandler` | A flow transitions to the executing state. |
| `OnFlowFinished` | `FlowFinishedHandler` | A flow completes all steps successfully. |
| `OnFlowIssue` | `FlowIssueHandler` | A flow is interrupted (Stopped / Cancelled / Failed). |

```csharp
port.OnStatusChanged += (s, e) => {
    if (e.Status == PortStatus.Running)
        Console.WriteLine("Ready");
};

port.OnFlowFinished += (s, e) => {
    var elapsed = e.End - e.Since;
    Console.WriteLine($"Flow '{e.Key}' done in {elapsed.TotalMilliseconds} ms");
};
```

---

## IFlowController

Controls flow execution for a registered package. Retrieve via `port.GetController(name)`.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Status` | `ControlStatus` | Current execution state (`Idle` or `Executing`). |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `AbortAllFlow()` | `bool` | Aborts all running flows immediately. |
| `Lock()` | `bool` | Aborts running flows and blocks new ones until `Release()`. |
| `Release()` | `bool` | Releases a `Lock()`, allowing flows to execute again. |
| `Shared(IShared handler)` | `void` | Dispatches shared data to all `[Shared]`-decorated methods on the controller. |

```csharp
var ctrl = port.GetController("LP1");
if (ctrl.Status == ControlStatus.Executing)
{
    ctrl.Lock();
    // ... emergency work ...
    ctrl.Release();
}
```

---

## ControlStatus Enum

| Value | Int | Description |
|-------|-----|-------------|
| `Unknown` | -1 | Status cannot be determined. |
| `Idle` | 0 | No flow is currently executing. |
| `Executing` | 1 | One or more flows are running. |

---

## PortLogConfiguration

Configuration object for file-based logging in TCP, Serial, and FileSender handlers.  
Pass an instance to `SetLogger(rootPath, conf)`.

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `RotationHours` | `int` | `1` | Log file rotation interval in hours (1–24). |
| `RetentionDay` | `int` | `0` | Days to keep log files. `0` = keep forever. |
| `LogFileExt` | `string` | `".log"` | File extension including the leading dot (e.g. `".txt"`). |
| `LogNameFormat` | `string` | `""` | Filename prefix. Empty = protocol default (`"tcp"`, `"serial"`, `"quic"`). |

**Generated filename pattern:** `{LogNameFormat}_{date}-{slot}{LogFileExt}`

| `RotationHours` | Current time | Generated name (`LogNameFormat="tcp"`) |
|---|---|---|
| 1 | 14:35 | `tcp_2025-01-01-14.log` |
| 6 | 14:35 | `tcp_2025-01-01-12.log` |
| 24 | 14:35 | `tcp_2025-01-01-00.log` |

```csharp
handler.SetLogger("./logs", new PortLogConfiguration
{
    RotationHours  = 6,
    RetentionDay   = 7,
    LogNameFormat  = "myapp",
    LogFileExt     = ".log"
});
```

---

## ITCPHandler

TCP Client / Server communication. Injected automatically into `[TCPHandler]` properties of `[TCP]` classes.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `IsConnected` | `bool` | `true` when the connection or server is active. |

### Methods — Configuration

| Method | Description |
|--------|-------------|
| `SetMode(TcpMode mode)` | Sets `Client` or `Server` mode (must be called before `Open()`). |
| `SetHost(string host)` | Sets the remote host address. Server: use `"0.0.0.0"` for all interfaces. |
| `SetPort(int port)` | Sets the port number. |
| `SetTimeout(int timeoutMs)` | Connection timeout in ms for client mode. Default: 5000. |
| `SetReconnection(uint intervalMs, uint maxRetries)` | Enables auto-reconnect with exponential backoff. `maxRetries = 0` = infinite. |

### Methods — Connection

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Connects (client) or starts listening (server). |
| `Close()` | `ERROR_CODE` | Disconnects or stops the server. |
| `TryReconnect()` | `void` | Manually restarts the reconnect loop after `GIVE_UP`. |

### Methods — Data

| Method | Returns | Description |
|--------|---------|-------------|
| `Send(byte[] data)` | `int` | Sends raw bytes. Server: broadcasts to all clients. Returns bytes sent or `-1`. |
| `Send(string text)` | `int` | Sends a UTF-8 string. Returns bytes sent or `-1`. |
| `StartReading()` | `void` | Starts background reading. Fires `OnDataReceived` per packet. |
| `StopReading()` | `void` | Stops background reading (client mode). |

### Methods — Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enables hourly-rotated SEND/RECV logging in `rootPath`. |
| `SetLogger(string rootPath, PortLogConfiguration conf)` | Logging with custom rotation/retention settings. |
| `WriteLog(string v)` | Writes an arbitrary message to the configured log. |

### Events

| Event | Delegate | When Fired |
|-------|----------|------------|
| `OnDataReceived` | `TcpDataReceivedHandler(name, data, hex)` | Data packet received. |
| `OnEvent` | `TcpEventHandler(name, eventType, description)` | CONNECTED / DISCONNECTED / ERROR / LISTENING / CLIENT\_CONNECTED / CLIENT\_DISCONNECTED. |
| `OnConnected` | `ConnectedEventHandler(sender, args)` | Connection established. `args.ConnectionString` = remote address. |
| `OnDisconnected` | `DisconnectedEventHandler(sender, args)` | Connection lost. |

### TCP ERROR\_CODE Enum

| Value | Int | Description |
|-------|-----|-------------|
| `ERR_CODE_NO_ERROR` | 1 | Success. |
| `ERR_CODE_OPEN` | -1 | Connect/listen failed. |
| `ERR_CODE_DLL_NOT_LOADED` | -2 | `porttcp.dll` not loaded. |
| `ERR_CODE_PORTNAME_EMPTY` | -3 | Connection name not set. |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | -4 | Required DLL export missing. |
| `ERR_CODE_CONNECT_FAILED` | -5 | Connection attempt failed. |

### TcpMode Enum

| Value | Description |
|-------|-------------|
| `Client` | Connects to a remote host. |
| `Server` | Listens and accepts multiple clients. |

```csharp
[TCP]
public class MyDevice
{
    [TCPHandler]
    public ITCPHandler handler { get; set; }

    [Preset]
    private void Init()
    {
        handler.SetMode(TcpMode.Client);
        handler.SetHost("192.168.1.100");
        handler.SetPort(5000);
        handler.SetTimeout(5000);
        handler.SetReconnection(1000, 0);
        handler.OnDataReceived += (name, data, hex) =>
            Console.WriteLine($"[{name}] {hex}");
        handler.OnConnected += (s, e) =>
            Console.WriteLine($"Connected: {e.ConnectionString}");
    }
}
```

---

## ISerialHandler

RS232 / RS485 serial port communication. Injected into `[SerialHandler]` properties of `[Serial]` classes.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `IsConnected` | `bool` | `true` when the port is open and connected. |

### Methods — Configuration

| Method | Description |
|--------|-------------|
| `SetPortName(string portName)` | Sets the COM port (e.g. `"COM3"`). |
| `SetBaudRate(int baudRate)` | Sets baud rate (9600 / 19200 / 38400 / 57600 / 115200, …). |
| `SetDataBits(int dataBits)` | Sets data bits (5, 6, 7, or 8). Default: 8. |
| `SetParity(SerialParity parity)` | Sets parity (None / Odd / Even). Default: None. |
| `SetStopBits(SerialStopBits stopBits)` | Sets stop bits (One / Two). Default: One. |
| `SetTimeout(int timeoutMs)` | Read timeout in ms. Default: 1000. |
| `SetAutoConnection(bool enable, int intervalMs)` | Enables auto-reconnect on disconnect. |

### Methods — Connection

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Opens the serial port. |
| `Close()` | `ERROR_CODE` | Closes the serial port. |
| `TryReconnect()` | `void` | Manually restarts the reconnect loop. |
| `GetAvailablePorts()` | `string[]` | Returns a list of available COM port names. |

### Methods — Data

| Method | Returns | Description |
|--------|---------|-------------|
| `Send(byte[] data)` | `int` | Sends raw bytes. Returns bytes sent or `-1`. |
| `Send(string text)` | `int` | Sends a UTF-8 string. Returns bytes sent or `-1`. |
| `StartReading()` | `void` | Starts background reading. Fires `OnDataReceived` per packet. |
| `StopReading()` | `void` | Stops background reading. |

### Methods — Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enables hourly-rotated SEND/RECV logging. |
| `SetLogger(string rootPath, PortLogConfiguration conf)` | Logging with custom configuration. |
| `WriteLog(string v)` | Writes a message to the configured log. |

### Events

| Event | Delegate | When Fired |
|-------|----------|------------|
| `OnDataReceived` | `SerialDataReceivedHandler(portName, data, hex)` | Data received from port. |
| `OnEvent` | `SerialEventHandler(portName, eventType, description)` | CONNECTED / DISCONNECTED / ERROR. |
| `OnConnected` | `ConnectedEventHandler(sender, args)` | Port opened successfully. `args.ConnectionString` = e.g. `"COM3:9600"`. |
| `OnDisconnected` | `DisconnectedEventHandler(sender, args)` | Port connection lost. |

### SerialParity Enum

| Value | Int | Description |
|-------|-----|-------------|
| `None` | 0 | No parity. |
| `Odd` | 1 | Total 1-bits kept odd. |
| `Even` | 2 | Total 1-bits kept even. |

### SerialStopBits Enum

| Value | Int | Description |
|-------|-----|-------------|
| `One` | 0 | One stop bit. |
| `Two` | 1 | Two stop bits. |

### Serial ERROR\_CODE Enum

| Value | Int | Description |
|-------|-----|-------------|
| `ERR_CODE_NO_ERROR` | 1 | Success. |
| `ERR_CODE_OPEN` | -1 | Port open failed. |
| `ERR_CODE_DLL_NOT_LOADED` | -2 | `portserial.dll` not loaded. |
| `ERR_CODE_PORTNAME_EMPTY` | -3 | No port name set. |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | -4 | Required DLL export missing. |
| `ERR_CODE_CONNECT_FAILED` | -5 | Connection could not be confirmed. |

```csharp
[Serial]
public class MySerialDevice
{
    [SerialHandler]
    public ISerialHandler handler { get; set; }

    [Preset]
    private void Init()
    {
        handler.SetPortName("COM3");
        handler.SetBaudRate(9600);
        handler.SetDataBits(8);
        handler.SetParity(SerialParity.None);
        handler.SetStopBits(SerialStopBits.One);
        handler.SetTimeout(1000);
        handler.SetAutoConnection(true, 2000);
        handler.OnDataReceived += (port, data, hex) =>
            Console.WriteLine($"[{port}] {hex}");
    }
}
```

---

## PortLink (Remote Data Link)

QUIC/TLS 1.3 remote-data link backed by `portlink.dll` (namespace `Portdic.Protocol.Link`).
Constructed directly — `new PortLink(name)` — rather than injected by attribute.
See the [PortLink page](link.md) for the full guide (QoS levels, commands, Set mirroring, security).

### Methods

| Method | Description |
|--------|-------------|
| `StartServer(port, psk)` | Listen on `0.0.0.0:port` (UDP) with PSK authentication. |
| `Connect(host, port, nodeId, psk)` | Connect + authenticate; auto-reconnects until `Close()`. |
| `Publish(topic, payload, qos, class, ttlMs, targetNode)` | Q0/Q1 telemetry or alarm. |
| `SendCommand(topic, payload, out result, idemKey, timeoutMs, targetNode)` | Blocking Q2 exactly-once-effect command. |
| `SendCommandAsync(...)` | Thread-pool wrapper returning `(code, result)`. |
| `RespondCommand(corrId, code, payload)` | Answer an incoming command. |
| `EnableMirror(pattern, qos, ttlMs, applyIncoming, targetNode)` / `DisableMirror()` | Automatic `Port.Set` replication to the remote peer. |
| `GetServerCert()` / `SetPinnedCert(der)` (static) | Certificate-pinning distribution and setup. |
| `SetLogger(rootPath[, conf])` | Rotating file logs (`PortLogConfiguration`). |
| `GetLastError()` (static) | Last failure detail for the calling thread. |

### Events

| Event | Delegate | Description |
|-------|----------|-------------|
| `OnMessage` | `LinkMessageHandler(name, nodeId, topic, qos, payload)` | Telemetry/alarm arrived. |
| `OnCommand` | `LinkCommandHandler(name, nodeId, topic, payload, corrId)` | Q2 command arrived — answer via `RespondCommand`. |
| `OnConnection` | `LinkConnectionHandler(name, nodeId, connected)` | Peer session opened/closed. |
| `OnError` | `LinkErrorHandler(name, code, message)` | Asynchronous engine error. |

---

## Package Attributes

Attributes are the primary way to wire classes and properties into the PortDIC runtime.

### Class-Level Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[Package]` | `class` | Declares a class as a Port-managed package. Enables automatic instantiation, lifecycle management, and REST API generation. |
| `[Flow]` | `class` | Marks a class as a sequential/parallel workflow. Steps are executed in `[Step]` index order. |
| `[Controller]` | `class` | Marks a class as a flow controller (used together with `[Model]`). |
| `[TCP]` | `class` | Declares TCP communication support. The runtime injects `ITCPHandler` and calls `[Preset]` before opening. |
| `[Serial]` | `class` | Declares serial communication support. The runtime injects `ISerialHandler` and calls `[Preset]` before opening. |
| `[GEM]` | `class` | Declares SECS/GEM handler support. |
| `[Dashboard]` | `class` | Sets the web dashboard bind address (`"host[:port]"`, port defaults to 8000). Applied with `[Portdic]`; `Port.App<T>()` writes it to `project.env` (`WEB_HOST`/`WEB_PORT`) before the server starts. |

### Property / Field Injection Attributes

| Attribute | Injected Type | Description |
|-----------|--------------|-------------|
| `[TCPHandler]` | `ITCPHandler` | Injects a TCP handler instance. Used inside a `[TCP]` class. |
| `[SerialHandler]` | `ISerialHandler` | Injects a serial handler instance. Used inside a `[Serial]` class. |
| `[Logger]` | `ILogger` | Injects the package logger for centralized log writing. |
| `[Property]` | `IProperty` | Injects the entry property bag. Call `Property.TryToGetValue(key, out val)` to read config. |
| `[StepTimer]` | `IStepTimer` | Injects a step timer for delayed / one-shot actions inside a `[Flow]`. |
| `[FlowControl]` | `IFlowControl` | Injects a flow control object for `JumpStep()` navigation inside a `[Flow]`. |
| `[Import]` | `IFunction` | Marks a dependency on a named function from another package. Resolved automatically at startup. |
| `[FileHandler("path")]` | `IFileHandler` | Injects an XML file reader for the given config file path. |

### Method Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[Preset]` | `method` | Called by the runtime before the connection is opened. Use for handler configuration. |
| `[Step(index, ...)]` | `method` | Marks a flow step. `index` controls execution order. Lower = earlier. |
| `[Valid("message")]` | `method` | Validation gate called before the package starts. Return `false` to block startup. |
| `[Command("key")]` | `method` | Exposes a method as a remote command endpoint. |
| `[Shared]` | `method` | Called by `IFlowController.Shared(handler)` with the shared data object. |
| `[BeforeSync]` | `method` | Called before memory sync operations. |

### Property / Field Marker Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[API(EntryDataType, ...)]` | `property` | Exposes the property as a REST API endpoint. Accepts data type, format, and property keys. |
| `[Comment("text")]` | `property` | Adds documentation text visible in the API. |
| `[Mapping(typeof(T))]` | `property` | Maps the property to a specific data type for automatic conversion. |
| `[ModelProperty("portKey")]` | `property / field` | Marks a field as a model property bound to a port key. |
| `[EnumCode]` | `enum` | Exposes enum values through the API so external systems can query them. |
| `[CEID]` | `class / field` | Marks as a Collection Event ID model for GEM registration. |
| `[ALID]` | `class / field` | Marks as an Alarm ID model for GEM registration. |
| `[SVID]` | `class / field` | Marks as a Status Variable ID model for GEM registration. |
| `[DVID]` | `class / field` | Marks as a Data Value ID model for GEM registration. |
| `[ECVID]` | `class / field` | Marks as an Equipment Constant Variable ID model for GEM registration. |

---

## IFlowControl

Provides step-level navigation inside a `[Flow]` class. Injected via `[FlowControl]`.

| Method | Description |
|--------|-------------|
| `JumpStep(int index)` | Jumps execution to the step with the given `[Step(index)]`. |

---

## IStepTimer

Timing and scheduling utilities inside a `[Flow]` class. Injected via `[StepTimer]`.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Since` | `DateTime` | Timestamp when the current step started. |
| `TotalSeconds` | `double` | Elapsed seconds since `Since`. |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Reserve(string id, int ms, Action func)` | `string` | Schedules `func` to run after `ms` milliseconds. Returns the task ID. |
| `Once(string id, Action action)` | `string` | Executes `action` exactly once per timer lifetime. Duplicate calls with same `id` are ignored. |
| `Reset()` | `void` | Resets `Since` to now and cancels all pending reservations. |

---

## IReference / IFunction

Used by the References & Import system for inter-package dependency injection.

### IReference

| Member | Type | Description |
|--------|------|-------------|
| `this[string key]` | `IFunction` | Looks up a registered function by key. |
| `API` | `IEnumerable<IFunction>` | Returns all registered functions. |

### IFunction

| Member | Type | Description |
|--------|------|-------------|
| `Key` | `string` | Unique identifier of the function. |
| `Type` | `Type` | CLR type of the function implementation. |
| `Binding(string entryKey)` | `IFunction` | Binds the function to a specific entry key. |
| `Benchmark(string entryKey, params string[] args)` | `string` | Runs a benchmark for the function. |

---

## ILogger

Injected via `[Logger]`. Provides centralized log writing for packages.

| Method | Description |
|--------|-------------|
| `Write(string message)` | Writes a message to the package log. |

---

## IProperty

Injected via `[Property]`. Provides access to the entry's declared property bag.

| Method | Returns | Description |
|--------|---------|-------------|
| `TryToGetValue(string key, out string value)` | `bool` | Tries to retrieve a property by key. Returns `false` if not found. |

---

## IFileHandler

Injected via `[FileHandler("path")]`. Reads values from an XML configuration file.

| Method | Returns | Description |
|--------|---------|-------------|
| `GetValue(string section, string key)` | `string` | Returns the text content at `<section><key>`. Returns `""` if not found. |

---

## IBroadcast

Marker interface implemented by `ITCPHandler`, `ISerialHandler`, GEM, MQTT, RTSP, and OPC UA objects. No members — used as a type constraint for `port.BroadCast<T>()`.

---

## Quick Reference — Attribute Map

| What you want | Class attribute | Property/Field attribute |
|---------------|-----------------|--------------------------|
| Managed package | `[Package]` | — |
| Sequential workflow | `[Flow]` | — |
| Flow controller | `[Controller]` | — |
| TCP communication | `[TCP]` | `[TCPHandler]` on `ITCPHandler` property |
| Serial communication | `[Serial]` | `[SerialHandler]` on `ISerialHandler` property |
| SECS/GEM handler | `[GEM]` | — |
| Logging | — | `[Logger]` on `ILogger` property |
| Config property access | — | `[Property]` on `IProperty` property |
| Flow step | — | `[Step(n)]` on method |
| Step timer | — | `[StepTimer]` on `IStepTimer` property |
| Flow navigation | — | `[FlowControl]` on `IFlowControl` property |
| REST API endpoint | — | `[API(EntryDataType.X)]` on property |
| Validation gate | — | `[Valid("msg")]` on `bool` method |
| Remote command | — | `[Command("key")]` on method |
| Pre-connect init | — | `[Preset]` on method |
| Package dependency | — | `[Import("ref", "key")]` on `IFunction` field |
| XML config access | — | `[FileHandler("file.xml")]` on `IFileHandler` property |
