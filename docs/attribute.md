# Attribute

Port uses C# attributes to declaratively define package registration, API generation, dependency injection, and workflow control. This page is a categorized reference for all Port attributes.

---

## Quick Reference

A summary table of all Port attributes.

| Category | Attribute | Target | Description |
|----------|-----------|--------|-------------|
| **[Portdic](#portdic)** | [`[Portdic]`](#portdic) | class | Registers the main window as the Port project entry point |
| **[Package](#package-attributes)** | [`[Package]`](#package) | class | Registers a Port-managed package |
| | [`[Handler]`](#handler) | property | Injects IPackageHandler (log + property) |
| | [`[Preset]`](#handler) | method | Initialization after injection |
| | [`[API]`](#api) | property, field | Generates a REST API endpoint |
| | [`[Valid]`](#valid) | method | Validation gate |
| | [`[Comment]`](#comment) | property | API documentation |
| **[Equipment](#equipment-attributes)** | [`[Equipment]`](#equipment) | class | Transfer-scheduler hub — owns TMC, PMC, LMC, and score methods |
| | [`[TMC]`](#tmc--lmc--pmc) | property | Injects `ITransferModule<T>` into `[Equipment]` or `[Flow]` |
| | [`[LMC]`](#tmc--lmc--pmc) | property | Injects `ILoadModule` (load port) |
| | [`[PMC]`](#tmc--lmc--pmc) | property | Injects `IProcessModule` (process chamber) |
| | [`[TransferScore]`](#transferscore) | method | Define pick/place priority score for the transfer scheduler |
| **[Controller](#controller-attributes)** | [`[Controller]`](#controller--flow) | class | Flow controller |
| | [`[Flow]`](#controller--flow) | class | Workflow definition |
| | [`[FlowStep]`](#flowstep) | method | Workflow step |
| | [`[Handler]`](#handler-1) | property | Injects `IFlowHandler` (basic step control) |
| | [`[Handler]`](#handler-1) | property | Injects `IFlowWithModelHandler<T>` (lifecycle events with model) |
| | [`[Handler]`](#handler-1) | property | Injects `ISchedulerHandler<T>` (transfer scheduling) |
| | [`[Model]`](#model) | class | Define flow model class |
| | [`[ModelBinding]`](#model) | property | Bind model property to a Port entry |
| | [`[FlowWatcherCompare]`](#flowwatchercompare) | method | Step condition watcher |
| | [`[FlowWatcherAction]`](#flowwatcheraction) | method | Step completion action |
| | [`[Timeout]`](#timeout) | method | Step timeout |
| | [`[FlowDelay]`](#flowdelay) | method | Wait N ms before invoking the step body |
| | [`[RecordTime]`](#recordtime) | method | Record elapsed ms into a Port entry on every poll tick |
| | [`[TransferBlockWhenExecutingFlow]`](#transferblockwhenexecutingflow) | class | Block TM transfers to this location while the flow is Executing |
| **[FileSender](#filesender-attributes)** | [`[FileSender]`](#filesender-1) | class | Registers a QUIC file transfer handler container |
| | [`[FileSenderHandler]`](#filesender-1) | property | Injects `IFileSenderHandler` |
| **[Document](#document-attributes)** | [`[Document]`](#document--save) | class | Source document path |
| | [`[Save]`](#document--save) | method | Output file paths |
| | [`[ColumnHeader]`](#document--save) | property | Column header mapping |
| | [`[EntryKey]`](#document--save) | property | Key column |
| | [`[EntryProperty]`](#document--save) | property | Property column |
| | [`[EntryDataType]`](#document--save) | property | Data type |
---




## Portdic

`[Portdic("repoName")]` is the **entry-point attribute**. It must be applied to the application's main class (e.g., `MainWindow`) and registers the project under the given repository name. All Port services, packages, controllers, and flows are resolved within this project scope.

The `repoName` string must match the name used in `.page` file paths and `Port.Push()` / `Port.Add()` calls throughout the project.

**Constructor:**

```csharp
Portdic(string reponame, string pull_path = "")
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `reponame` | `string` | Yes | Repository name — must match all `Port.Add()` / `Port.Push()` calls in the project |
| `pull_path` | `string` | No | Local directory path for pulling remote data; defaults to `""` (disabled) |

```csharp
[Portdic("EQ-01-B05")]
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        Port.App<MainWindow>();

        Port.Add<SessionHelper>("Session");
        Port.Add<LoadportController>("LP1");
        Port.Add<LoadportController>("LP2");
        Port.Add<WTRController>("WTR");
    }
}
```

---

## Package Attributes

Attributes used for defining package classes and generating APIs.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| [`[Package]`](#package) | class | — | — | Registers class as a Port-managed package |
| [`[Handler]`](#handler) | property | `IPackageHandler` | — | Injects a handler, providing unified access to logging and entry properties |
| [`[Preset]`](#handler) | method | — | — | Called once after injection; use this for initialization and event wiring |
| [`[API]`](#api) | property, field | — | `EntryDataType`, `PropertyFormat`, `keys` | Generates a REST API endpoint |
| [`[Valid]`](#valid) | method | — | `message` | Validation gate; returns error message when invalid |
| [`[Comment]`](#comment) | property | — | `string` | API property documentation |

### Package

Registers a class as a managed package in the Port Dictionary system.

**Constructor:** No parameters.

```csharp
Package()
```

```csharp
[Package]
public class Bulb
{
    [Handler]
    public IPackageHandler Handler { get; set; }
 
    [API(EntryDataType.Enum)]
    public string OffOn { get; set; } = "Off";
}
```

### Handler

Injects `IPackageHandler`, which provides unified access to logging and entry property values. Use `SetLogger` in `[Preset]` to enable file logging, then call `Write` anywhere inside the package.

**Constructor:** No parameters — applies to both `[Handler]` and `[Preset]`.

```csharp
Handler()
Preset()
```

```csharp
[Package]
public class Heater
{
    [Handler]
    public IPackageHandler Handler { get; set; }

    [Preset]
    public void Preset()
    {
        // Enable file logging — writes to C:\Logs\Heater\
        Handler.SetLogger(@"C:\Logs");
    }

    [API]
    public double Temp
    {
        get
        {
            // Read entry property (set in .page via property:{...})
            if (Handler.EntryProperty.TryToGetValue("Unit", out string unit))
            {
                Handler.Write($"[INFO] Unit={unit}");
                return unit == "F" ? 212.0 : 100.0;
            }
            return double.NaN;
        }
    }
}
```

**`IPackageHandler` members:**

| Member | Description |
|--------|-------------|
| `SetLogger(rootPath)` | Enable file logging; creates `rootPath/packageName/` sub-directory |
| `SetLogger(rootPath, conf)` | Same with rotation and retention options via `PortLogConfiguration` |
| `Write(message)` | Write a plain text log entry |
| `Write(code, header, dict)` | Write a structured log entry with `LogTypeCode`, header, and key-value data |
| `EntryProperty` | Current `IProperty` for the active Get/Set request; use `TryToGetValue` to read values |

**`IProperty.TryToGetValue` usage:**

```csharp
// .page entry definition
// RoomTemp  f8  property:{"Unit":"C","Max":"300"}

// Inside a package API property getter:
if (Handler.EntryProperty.TryToGetValue("Unit", out string unit))
{
    // unit == "C"
}
if (Handler.EntryProperty.TryToGetValue("Max", out string max))
{
    double limit = double.Parse(max);   // limit == 300.0
}
```

### API

Automatically registers a property as a REST API endpoint. Specify the data type with `EntryDataType`.

**Constructors:**

```csharp
API()
API(EntryDataType dataType)
API(string key)
API(EntryDataType dataType, PropertyFormat format)
API(EntryDataType dataType, PropertyFormat format, params string[] required)
API(EntryDataType dataType, PropertyFormat format, params int[] required)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `dataType` | `EntryDataType` | SECS-compatible data type of the exposed property (default: `Text`) |
| `key` | `string` | Custom entry key name; use when the property name differs from the entry key |
| `format` | `PropertyFormat` | Serialization format for multi-value properties (`Json`, `Array`, etc.) |
| `required` | `string[]` or `int[]` | Required property keys (strings) or required index list (ints) for structured types |

```csharp
// Basic usage
[API]
public string Status { get; set; }

// Enum type
[API(EntryDataType.Enum)]
public string OffOn { get; set; }

// Numeric with JSON property keys
[API(EntryDataType.Num, PropertyFormat.Json, "Unit")]
public double Temp1 { get; set; }

// String type
[API(EntryDataType.Char)]
public string Power { get; set; }

// List type
[API(EntryDataType.List, PropertyFormat.Array, 0, 1, 2)]
public List<string> Readings { get; set; }
```

**EntryDataType values:**

| Type | Description |
|------|-------------|
| `EntryDataType.Text` | Text |
| `EntryDataType.Num` | Numeric (double) |
| `EntryDataType.Char` | ASCII string |
| `EntryDataType.Enum` | Enumeration |
| `EntryDataType.List` | List |

**Linking an API property to a Package in `.page`:**

Use `pkg:PackageName.PropertyName` in the `.page` file to connect an entry to a `[API]` property in a `[Package]` class.

```text
# device/io.page
RoomTemp    f8     pkg:Heater.Temp
BulbStatus  enum   pkg:Bulb.OffOn
Power       char   pkg:Bulb.Power
```

```csharp
// Package class — property names must match the pkg: declaration
[Package]
public class Heater
{
    [API]
    public double Temp { get; set; }  // → pkg:Heater.Temp
}

[Package]
public class Bulb
{
    [API(EntryDataType.Enum)]
    public string OffOn { get; set; }  // → pkg:Bulb.OffOn

    [API(EntryDataType.Char)]
    public string Power { get; set; }  // → pkg:Bulb.Power
}
```

### Valid

Defines a validation method for the package. When it returns `false`, the error message passed as argument is displayed.

**Constructor:**

```csharp
Valid(string invalidComment)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `invalidComment` | `string` | The error message returned to the caller when validation fails |

```csharp
[Valid("Device not connected")]
public bool Valid()
{
    return serialPort.IsOpen;
}
```

### Comment

Adds a description to an API property.

**Constructors:**

```csharp
Comment(string comment)
Comment(Dictionary<string, string> comment)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `comment` | `string` | Single description string for the property |
| `comment` | `Dictionary<string, string>` | Multi-language or multi-key description map |

```csharp
[API, Comment("Current temperature (Celsius)")]
public double Temperature { get; set; }
```

---

## Equipment Attributes

Attributes used for the `[Equipment]` transfer-scheduler hub class. These attributes are parsed by the dedicated `[Equipment]` path in the framework and apply to flat (non-nested) scheduler classes registered via `Port.Add<T>()`.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| [`[Equipment]`](#equipment) | class | — | `tmcName` | Marks the class as the scheduler hub for the named TM |
| [`[TMC]`](#tmc--lmc--pmc) | property | `ITransferModule<T>` | `capacity` | Injects the scheduler singleton |
| [`[LMC]`](#tmc--lmc--pmc) | property | `ILoadModule` | `capacity` | Marks location as load port; injects `ILoadModule` instance |
| [`[PMC]`](#tmc--lmc--pmc) | property | `IProcessModule` | `capacity` | Marks location as process module; injects `IProcessModule` instance |
| [`[TransferScore]`](#transferscore) | method | — | `location`, `direction` | Returns int score for scheduler pick/place decisions |
| [`[Preset]`](#handler-1) | method | — | — | Invoked after all DI is complete; wire scheduler events here |

---

## Controller Attributes

Attributes used for defining and controlling workflows (process flows) inside `[Controller]` classes. Registered via `Port.Add<TController, TModel>(key)`.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| [`[Controller]`](#controller--flow) | class | — | — | Defines a controller containing flows |
| [`[Flow]`](#controller--flow) | class | — | `key` | Defines a workflow class (inner class of Controller) |
| [`[FlowStep]`](#flowstep) | method | — | `index`, `relatedEntry` | Defines a workflow step |
| [`[Handler]`](#handler-1) | property | `IFlowHandler` | — | Injects basic flow step control into a Flow class |
| [`[Handler]`](#handler-1) | property | `IFlowWithModelHandler<T>` | — | Injects model-bound handler with lifecycle events |
| [`[Handler]`](#handler-1) | property | `ISchedulerHandler<T>` | — | Injects transfer scheduler handler |
| [`[Model]`](#model) | class | — | — | Defines a flow model class; properties use `[ModelBinding]` |
| [`[ModelBinding]`](#model) | property | `Entry` | `controllerName`, `entryKey` | Binds a model property to a Port entry |
| [`[TMC]`](#tmc--lmc--pmc) | property | `ITransferModule<T>` | — | Injects transfer module controller into a `[Flow]` class |
| [`[LMC]`](#tmc--lmc--pmc) | property | `ILoadModule` | `capacity` | Injects load port module into a `[Flow]` class |
| [`[PMC]`](#tmc--lmc--pmc) | property | `IProcessModule` | `capacity` | Injects process chamber module into a `[Flow]` class |
| [`[TransferScore]`](#transferscore) | method | — | `location`, `direction` | Returns int score for scheduler pick/place decisions |
| [`[FlowWatcherCompare]`](#flowwatchercompare) | method | — | `entry`, `op`, `value` | Defines step execution condition |
| [`[FlowWatcherAction]`](#flowwatcheraction) | method | — | `entry`, `value` | Defines action on step completion |
| [`[Timeout]`](#timeout) | method | — | `ms`, `controller`, `alarmid` | Sets step timeout and alarm |
| [`[FlowDelay]`](#flowdelay) | method | — | `delayMs` | Wait N ms after step entry before invoking the step body |
| [`[RecordTime]`](#recordtime) | method | — | `category`, `fullKey` | Record elapsed ms into a Port entry on every poll tick |
| [`[TransferBlockWhenExecutingFlow]`](#transferblockwhenexecutingflow) | class | — | `tmName` | Block TM transfers to this location while the flow is Executing |

### Controller

`[Controller]` defines a controller that contains multiple flows. All `[Flow]` classes must be declared as **inner classes** inside a `[Controller]` class.

**Constructors:**

```csharp
Controller()
Flow(string key)
```

| Attribute | Parameter | Type | Description |
|-----------|-----------|------|-------------|
| `[Controller]` | — | — | No parameters; marks the class as a Port flow controller |
| `[Flow]` | `key` | `string` | Flow name — used to identify and trigger the flow at runtime |

```csharp
// Model class — defined outside the controller
[Model]
public class LoadportModel
{
    [ModelBinding(Controller.LP1, EFEM.LP1_Command)]
    [ModelBinding(Controller.LP2, EFEM.LP2_Command)]
    public Entry LP_Command { get; set; }

    [ModelBinding(Controller.LP1, EFEM.LP1_Main_Air_i)]
    [ModelBinding(Controller.LP2, EFEM.LP2_Main_Air_i)]
    public Entry LP_Main_Air_i { get; set; }
}

// Controller — [Flow] classes must be inner classes
[Controller]
public class LoadportController
{
    [Flow("Load")]
    public class FoupLoadFlow
    {
        [Handler]
        public IFlowHandler Handler { get; set; } = null!;

        [FlowStep(0)]
        public void StatusCheck(LoadportModel m)
        {
            Handler.ClearAlarm(-1);
            Debug.WriteLine(m.LP_Main_Air_i.Name + " : " + m.LP_Main_Air_i.Value.String());
            Handler.Next();
        }

        [FlowStep(1)]
        public void SendLoadCommand(LoadportModel m)
        {
            Handler.Next();
        }

        [FlowStep(2)]
        public void Done(LoadportModel m)
        {
            Handler.Done();
        }
    }
}
```

### Handler

Injects a handler interface into a `[Flow]` class. The injected type is determined by the property's declared type.

| Property type | Purpose |
|---------------|---------|
| `IFlowHandler` | Basic step control (`Next()`, `Done()`, logging) |
| `IFlowWithModelHandler<T>` | Lifecycle events that carry the bound model |
| `ISchedulerHandler<T>` | Transfer scheduling for robot arm coordination |

FlowStep methods always receive the model as a **method parameter** — they do not inject it as a property.

**Constructor:** No parameters — applies to `[Handler]` and `[Preset]`.

```csharp
Handler()
Preset()
```

```csharp
// [Handler] — basic step control
[Flow("Load")]
public class FoupLoadFlow
{
    [Handler]
    public IFlowHandler Handler { get; set; } = null!;

    [Preset]
    public void Preset()
    {
        Handler.SetLogger(@"D:\logs");
    }

    [FlowStep(0)]
    public void StatusCheck(LoadportModel m)
    {
        Handler.ClearAlarm(-1);
        Handler.Next();
    }

    [FlowStep(1)]
    public void Done(LoadportModel m)
    {
        Handler.Done();
    }
}

// [Handler] — lifecycle events with model
//
// OnFlowFinished fires after handler.Done() completes.
// e.Model carries the bound model so the caller can act on the result
// (e.g. notify a scheduler that this transfer location is free).
[Flow("Place")]
public class Place
{
    [Handler]
    public IFlowWithModelHandler<WTRCommModel> handler { get; set; } = null!;

    [Handler]
    public ISchedulerHandler<DualArmActionArgs> scheduler { get; set; } = null!;

    [Preset]
    public void Preset()
    {
        handler.SetLogger(@"D:\logs");
        handler.OnFlowOccurred  += Handler_OnFlowOccurred;
        handler.OnFlowFinished += Handler_OnFlowFinished;
    }

    // Called when the flow is triggered (before Step 0 runs).
    // e.Model is the bound model populated at flow start.
    private void Handler_OnFlowOccurred(object sender, PortFlowOccurredWithModelArgs<WTRCommModel> e)
    {
        // e.Model.Target, e.Model.Source, etc. are already populated
    }

    // Called after handler.Done() returns the flow to Idle.
    // Use e.Model to read the final state and notify downstream systems.
    private void Handler_OnFlowFinished(object sender, FlowFinishedWithModelArgs<WTRCommModel> e)
    {
        // e.Model.Target contains the destination that was set when the flow was triggered
        scheduler.TransferCompleted(e.Model.Target);
    }

    [FlowStep(0)]
    public void CheckAction(WTRCommModel m)
    {
        handler.WriteLog("CheckAction", WriteRule.NotAllowDuplicate | WriteRule.WithDebug);
        handler.Next();
    }

    [FlowStep(1)]
    public void Done(WTRCommModel m)
    {
        handler.Done();  // triggers Handler_OnFlowFinished after returning to Idle
    }
}
```

**`IFlowHandler` members:**

| Member | Description |
|--------|-------------|
| `Next()` | Move to the next FlowStep |
| `Done()` | Complete the flow and return to Idle synchronously |
| `Move(stepName)` | Jump to a named step |
| `Alert(message)` | Send an alert notification |
| `OccurredAlarm(alid)` | Raise an alarm by alarm ID |
| `ClearAlarm(alid = -9999)` | Clear alarm; `-9999` clears all alarms |
| `SetLogger(rootPath)` | Enable file logging under `rootPath/flowName/` |
| `WriteLog(message)` | Write a log entry |
| `WriteLog(message, rule)` | Write a log entry with `WriteRule` flags |

**`WriteRule` flags:**

| Flag | Description |
|------|-------------|
| `None` | Write to file only (default) |
| `NotAllowDuplicate` | Skip consecutive duplicate messages |
| `WithDebug` | Also write to `Debug.WriteLine` |
| `WithConsole` | Also write to `Console.WriteLine` |
| `WithTrace` | Also write to `Trace.WriteLine` |

**`IFlowWithModelHandler<T>` additional members:**

| Member | Description |
|--------|-------------|
| `T Model` | The model instance bound to this flow |
| `OnFlowOccurred` | Fired when the flow starts |
| `OnFlowFinished` | Fired when the flow completes; `e.Model` carries the bound model |

### FlowStep

Registers a method as a workflow step. Steps are ordered by index number. The bound model is received as a method parameter — omit it if no model is needed.

**Constructors:**

```csharp
FlowStep(int index = 0, params string[] relatedEntry)
FlowStep(string prev)
FlowStep(int index, ushort ceid, params string[] relatedEntry)
```

| Overload | Parameter | Type | Description |
|----------|-----------|------|-------------|
| Default | `index` | `int` | Step execution order; lower numbers run first (default: `0`) |
| Default | `relatedEntry` | `string[]` | Entry keys that trigger step re-evaluation on value change |
| Named-prev | `prev` | `string` | Name of the preceding step; use when step order is defined by name instead of index |
| CEID | `index` | `int` | Step execution order |
| CEID | `ceid` | `ushort` | Collection Event ID to fire when this step completes |
| CEID | `relatedEntry` | `string[]` | Entry keys that trigger step re-evaluation |

```csharp
// With model parameter
[FlowStep(0)]
public void StatusCheck(LoadportModel m)
{
    Debug.WriteLine(m.LP_Main_Air_i.Value.String());
    Handler.Next();
}

[FlowStep(1)]
public void SendCommand(LoadportModel m)
{
    Handler.Next();
}

[FlowStep(2)]
public void Done(LoadportModel m)
{
    Handler.Done();  // Complete flow and return to Idle
}
```

### FlowWatcherCompare

Defines pre/post conditions for a step. All conditions must be met before proceeding to the next step.

**Constructors:**

```csharp
FlowWatcherCompare(string a, string op, object b, bool OR = false)
FlowWatcherCompare(string controller_name, string model_key_name, string op, object value, bool OR = false)
```

| Overload | Parameter | Type | Description |
|----------|-----------|------|-------------|
| Direct | `a` | `string` | Left-hand entry key; prefix `@` to reference a model binding |
| Direct | `op` | `string` | Comparison operator: `>=`, `<=`, `>`, `<`, `==`, `!=` |
| Direct | `b` | `object` | Right-hand value or entry key |
| Direct | `OR` | `bool` | `true` = combine with previous watcher using OR logic (default: `false` = AND) |
| Controller | `controller_name` | `string` | Limit this watcher to the named controller instance (e.g. `"LP1"`) |
| Controller | `model_key_name` | `string` | Entry key from the controller's model |
| Controller | `op` | `string` | Comparison operator |
| Controller | `value` | `object` | Right-hand comparison value |
| Controller | `OR` | `bool` | OR logic flag (default: `false`) |

```csharp
[FlowStep]
[FlowWatcherCompare("@Temp1", ">=", 50)]                           // Model binding (@)
[FlowWatcherCompare("room2.HeaterTemp4", ">=", 100)]                // Direct reference
[FlowWatcherCompare("room2.HeaterTemp5", ">=", Room2.HeaterTemp4)]  // Entry-to-entry comparison
public void Step1()
{
    Handler.Next();
}
```

**Supported operators:** `>=`, `<=`, `>`, `<`, `==`, `!=`

### FlowWatcherAction

Automatically sets a value when a step completes.

**Constructors:**

```csharp
FlowWatcherAction(string target, object v)
FlowWatcherAction(string controller_name, string target, object v)
```

| Overload | Parameter | Type | Description |
|----------|-----------|------|-------------|
| Direct | `target` | `string` | Entry key to write to when the step finishes |
| Direct | `v` | `object` | Value to write |
| Controller | `controller_name` | `string` | Limit this action to the named controller instance |
| Controller | `target` | `string` | Entry key to write to |
| Controller | `v` | `object` | Value to write |

```csharp
[FlowStep]
[FlowWatcherAction("room2.BulbOnOff", "Off")]    // Sets BulbOnOff = "Off" on completion
[FlowWatcherAction(Room2.BulbOnOff, "On")]        // Using token constants
public void Step1()
{
    Handler.Next();
}
```

### Model

`[Model]` marks a **class** as a flow model. Properties are of type `Entry` and decorated with `[ModelBinding]` to bind to Port entries. The platform instantiates the model and passes it as a **method parameter** to each `[FlowStep]`.

Multiple `[ModelBinding]` attributes on one property let the same model class serve different controllers — the binding that matches the running controller's name is applied.

**Constructors:**

```csharp
// [Model]
Model()
Model(string controllerName)

// [ModelBinding]
ModelBinding(string controller_name, string key)
ModelBinding(string key)
```

| Attribute | Parameter | Type | Description |
|-----------|-----------|------|-------------|
| `[Model]` | — | — | No parameters; marks the class as a Port flow model |
| `[Model]` | `controllerName` | `string` | Restrict this model to a specific controller name |
| `[ModelBinding]` | `controller_name` | `string` | Controller instance name this binding applies to (e.g. `"LP1"`) |
| `[ModelBinding]` | `key` | `string` | Port entry key to bind the property to |
| `[ModelBinding]` (1-arg) | `key` | `string` | Bind to this entry for all controllers (no controller filter) |

```csharp
// Define the model class — outside the controller
[Model]
public class LoadportModel
{
    // Bound to LP1_Command when run under "LP1", LP2_Command under "LP2"
    [ModelBinding(Controller.LP1, EFEM.LP1_Command)]
    [ModelBinding(Controller.LP2, EFEM.LP2_Command)]
    public Entry LP_Command { get; set; }

    [ModelBinding(Controller.LP1, EFEM.LP1_Configure_Value_i)]
    [ModelBinding(Controller.LP2, EFEM.LP2_Configure_Value_i)]
    public Entry LP_Configure_Value_i { get; set; }

    [ModelBinding(Controller.LP1, EFEM.LP1_Main_Air_i)]
    [ModelBinding(Controller.LP2, EFEM.LP2_Main_Air_i)]
    public Entry LP_Main_Air_i { get; set; }
}

// Receive model as a parameter in each FlowStep
[FlowStep(0)]
public void StatusCheck(LoadportModel m)
{
    Debug.WriteLine(m.LP_Configure_Value_i.Name + " : " + m.LP_Configure_Value_i.Value.String());
    Handler.ClearAlarm(-1);
    Handler.Next();
}

[FlowStep(1)]
public void SendLoadCommand(LoadportModel m)
{
    Debug.WriteLine(m.LP_Main_Air_i.Name + " : " + m.LP_Main_Air_i.Value.String());
    Handler.Next();
}
```

**`Entry` members:**

| Member | Description |
|--------|-------------|
| `Name` | Entry key string (e.g. `"EFEM.LP1_Command"`) |
| `Value.String()` | Current value as string |
| `Value.Double()` | Current value as double |
| `Value.Int()` | Current value as int |


### Timeout

Sets a timeout for a FlowStep. When the step exceeds the duration, the specified alarm is raised on the given controller.

**Constructor:**

```csharp
Timeout(int ms, string controller, int alarmid)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `ms` | `int` | Timeout duration in milliseconds |
| `controller` | `string` | Controller instance name this timeout applies to (e.g. `"LP1"`) |
| `alarmid` | `int` | Alarm ID to raise when the timeout expires |

```csharp
[FlowStep]
[Timeout(0, 0)]    // min, max (0 = unlimited)
public void Step1()
{
    Handler.Next();
}
```

### TMC / LMC / PMC

`[TMC]`, `[LMC]`, and `[PMC]` inject module interfaces into a `[Flow]` class. They declare which equipment modules the flow can interact with and provide the scheduler with the equipment topology needed to plan transfers.

| Attribute | Injected Type | Argument | Description |
|-----------|--------------|----------|-------------|
| `[TMC]` | `ITransferModule<T>` | — | Transfer robot arm; `T` is the arm action type (e.g. `DualArmAction`) |
| `[LMC(n)]` | `ILoadModule` | `capacity` (int) | Load port; `capacity` = number of wafer slots (e.g. `25` for a FOUP) |
| `[PMC(n)]` | `IProcessModule` | `capacity` (int) | Process chamber; `capacity` = number of substrate slots |

**Constructors:**

```csharp
TMC()
LMC(int capacity)
PMC(int capacity)
```

```csharp
[Flow("Queued")]
public class Queued
{
    [TMC] public ITransferModule<DualArmAction> TM1 { set; get; } = null!;

    [LMC(25)] public ILoadModule LP1 { get; set; } = null!;
    [LMC(25)] public ILoadModule LP2 { get; set; } = null!;

    [PMC(1)] public IProcessModule Stage1 { set; get; } = null!;
    [PMC(1)] public IProcessModule Stage2 { set; get; } = null!;
    [PMC(1)] public IProcessModule Aligner { set; get; } = null!;

    [Preset]
    public void Preset()
    {
        TM1.SetRule(TransferRule.PreferSwap);
        TM1.SetChildLocation("Upper", "Lower");
        TM1.OnRequestTransferAction   += OnTransferRequested;
        TM1.OnTransferActionCompleted += OnTransferCompleted;
        TM1.OnLotCompleted           += OnLotCompleted;

        Stage1.SetRecipeRootPath(@"D:\Stage1");
        Stage1.OnRequestProcess += Stage1_OnRequestProcess;

        LP1.OnRequestAction += LP1_OnRequestAction;
    }
}
```

**`ITransferModule<T>` members:**

| Member | Description |
|--------|-------------|
| `SetRule(TransferRule)` | Set the scheduling strategy (e.g. `TransferRule.PreferSwap`) |
| `SetChildLocation(params string[])` | Declare virtual arm names within the module (e.g. `"Upper"`, `"Lower"`) |
| `Register(lotId, SubstrateJob[])` | Register a lot with its substrate route list |
| `Execute(lotId)` | Start executing the registered lot |
| `ClearLot()` | Clear the current lot from the scheduler |
| `IsCompleted(lotId)` | Returns `true` when all substrates in the lot have completed |
| `NextRequest()` | Advance the scheduler to the next pending transfer action |
| `OnRequestTransferAction` | Fired when the scheduler needs a physical robot move |
| `OnTransferActionCompleted` | Fired when a robot action completes |
| `OnLotCompleted` | Fired when all substrates in the lot are done |
| `OnSameLocationProcess` | Fired when a substrate needs in-place processing |

**`DualArmAction` members (callback argument for `OnRequestTransferAction` / `OnTransferActionCompleted`):**

| Member | Type | Description |
|--------|------|-------------|
| `ActionType` | `ArmActionType` | `UpperGet`, `UpperPut`, `LowerGet`, or `LowerPut` |
| `Target.Name` | `string` | Destination location name |
| `Target.Index` | `int` | Slot index within the location |
| `SubstrateKey` | `string` | Substrate identifier |

**`ILoadModule` members:**

| Member | Description |
|--------|-------------|
| `OnRequestAction` | Fired when the scheduler requests a load or unload action; argument is `LoadPortActionArgs` |

**`IProcessModule` members:**

| Member | Description |
|--------|-------------|
| `SetRecipeRootPath(path)` | Set the root directory for recipe files |
| `OnRequestProcess` | Fired when the scheduler delivers a substrate for processing; argument is `ProcessArgs` |

---

### Equipment

`[Equipment("tmcName")]` registers a **flat** class as the transfer-scheduler hub for the named Transfer Module. Unlike `[Controller]` — which contains nested `[Flow]` inner classes — an `[Equipment]` class has no sub-flows. Instead, it owns the scheduler, declares all location scores and module properties at the top level, and triggers flows in separate `[Controller]` classes by setting `FlowAction.Executing`.

**Constructor:**

```csharp
Equipment(string TMC)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `TMC` | `string` | Name of the Transfer Module Controller this hub is bound to (e.g. `"TM1"`) |

**Registration** — single-generic, no model:

```csharp
Port.Add<Equipment>();   // key is taken from [Equipment("TM1")] automatically
// or
Port.Add<Equipment>("TM1");
```

**What the framework injects automatically:**

| Step | Action |
|------|--------|
| `[TMC]` property | Injects `ITransferModule<T>` (the scheduler singleton) |
| `[PMC]` property | Marks location as ProcessModule + injects `IProcessModule` instance |
| `[LMC]` property | Marks location as LoadModule + injects `ILoadModule` instance + registers slot count |
| `[TransferScore]` methods | Registers scoring lambdas with the scheduler |
| `[Preset]` method | Invoked after all DI is complete — wire event handlers here |
| `JobEntity` lifecycle | Bridges `JobEntity.Processing` → `OnRequestQueued` / `OnRequestLotProcessing` automatically |

**Comparison with `[Controller]`:**

| Aspect | `[Controller]` | `[Equipment]` |
|--------|---------------|----------------|
| Structure | Has nested `[Flow]` inner classes | Flat — no inner classes |
| Flow execution | Runs steps internally | Triggers flows in other controllers |
| Scheduler ownership | May share the singleton | Always owns the singleton |
| `JobEntity` bridge | Manual | Automatic |
| Registration | `Port.Add<T, M>(key)` | `Port.Add<T>()` |

```csharp
[Equipment("TM1")]
public class Equipment
{
    // ── Module declarations ───────────────────────────────────────────────
    [TMC(2)] public ITransferModule<DualArmAction> TM1 { get; set; } = null!;

    [LMC(25)] public ILoadModule LP1 { get; set; } = null!;
    [LMC(25)] public ILoadModule LP2 { get; set; } = null!;

    [PMC(1)] public IProcessModule Stage1 { get; set; } = null!;
    [PMC(1)] public IProcessModule Stage2 { get; set; } = null!;
    [PMC(1)] public IProcessModule Aligner { get; set; } = null!;

    // ── Arm scores ────────────────────────────────────────────────────────
    [TransferScore("Upper", Direction.In)]  public int InUpper()  => 1;
    [TransferScore("Upper", Direction.Out)] public int OutUpper() => 1;

    // ── Location scores ───────────────────────────────────────────────────
    [TransferScore("LP1", Direction.In)]
    public int InLP1() => (Port.Get(portdic.LP1.LP_Status)?.String() ?? "") == "Loaded" ? 1 : 0;

    [TransferScore("Stage1", Direction.In)]
    public int InStage1() => GateOpen("Stage1") ? StageReady("Stage1") : -1;

    [TransferScore("Stage1", Direction.Out)]
    public int OutStage1() => GateOpen("Stage1") ? 1 : -1;

    [TransferScore("Aligner", Direction.In)]
    public int InAligner() => Port.GetEntity<SubstrateEntity>("Aligner").GetExists() ? 1 : 0;

    // ── Scheduler wiring ─────────────────────────────────────────────────
    [Preset]
    public void Preset()
    {
        TM1.OnScanTarget       += TM1_OnAskTarget;
        TM1.OnRequestTransfer   += OnRequestTransfer;
        TM1.OnRequestQueued    += TM1_OnRequestQueued;
        TM1.OnTransferCompleted += OnTransferCompleted;
        TM1.OnLotCompleted     += TM1_OnLotCompleted;
        TM1.SetRule(TransferRule.PreferSwap);
        TM1.SetChildLocation("Upper", "Lower");
        LP1.OnRequestAction += LoadPort1_OnRequestAction;
    }

    // ── Transfer handler — delegates to robot flow ────────────────────────
    private void OnRequestTransfer(DualArmAction args)
    {
        if (isSkip(args)) { TM1.NextRequest(); return; }
        Port.Set(Cat.Robot, Flows.Robot_Pick, FlowAction.Executing);
    }

    // Blocks transfers to a location while its process flow is Executing.
    private static bool isSkip(DualArmAction args)
        => Port.IsTransferBlocked("TM1", args.Target.Name);

    // ── Transfer-completed handler — triggers process flows ───────────────
    private static void OnTransferCompleted(DualArmAction args)
    {
        if (args.Target.Name.StartsWith("Stage"))
            Port.Set(args.Target.Name, Flows.Stage_Process, FlowAction.Executing);
    }

    private static bool GateOpen(string loc) =>
        (Port.Get($"{loc}.Gate_Open_o")?.String() ?? "") == "On";

    private int StageReady(string loc) =>
        Port.GetEntity<SubstrateEntity>(loc).GetExists() ? 1 : 0;
}
```

---

### TransferScore

`[TransferScore]` decorates methods that return an `int` priority score. The scheduler calls all score methods on each tick and uses the scores to select the best pick/place pair. Methods can be declared directly in an `[Equipment]` class **or** inside a `[Flow]` class within a `[Controller]`, and must return `int`.

**Constructor:**

```csharp
TransferScore(string location, Direction direction)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `location` | `string` | Location name — must match the name of a `[TMC]`, `[LMC]`, or `[PMC]` property, or a virtual child location registered via `SetChildLocation` |
| `direction` | `Direction` | `Direction.In` = score for picking FROM this location; `Direction.Out` = score for placing TO it |

**Score convention:**

| Return value | Meaning |
|-------------|---------|
| `> 0` | Available — higher values are preferred |
| `0` | Not ready — skip this location this tick |
| `< 0` (e.g. `-1`) | Hard block — do not schedule this location under any condition |

```csharp
// Arm scores — arms are always available
[TransferScore("Upper", Direction.In)]  public int InUpper()  => 1;
[TransferScore("Upper", Direction.Out)] public int OutUpper() => 1;
[TransferScore("Lower", Direction.In)]  public int InLower()  => 1;
[TransferScore("Lower", Direction.Out)] public int OutLower() => 1;

// Load port — available only when a FOUP is docked
[TransferScore("LP1", Direction.In)]
public int InLP1() =>
    (Port.Get(portdic.LP1.LP_Status)?.String() ?? "") == "Loaded" ? 1 : 0;

// Stage — hard-blocked while gate is closed; pick-ready only when processing is done
[TransferScore("Stage1", Direction.In)]
public int InStage1() => GateOpen("Stage1") ? StageReady("Stage1") : -1;

[TransferScore("Stage1", Direction.Out)]
public int OutStage1() => GateOpen("Stage1") ? 1 : -1;
```

**`Direction` values:**

| Value | Description |
|-------|-------------|
| `Direction.In` | Pick — get substrate FROM this location |
| `Direction.Out` | Place — put substrate TO this location |


### FlowDelay

Delays the execution of a `[FlowStep]` method body by a fixed number of milliseconds after the step is first entered. On every poll tick the framework checks whether the delay has elapsed; if not, the step body is skipped and the flow remains at the current step without advancing.

**Constructor:**

```csharp
FlowDelay(int delayMs)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `delayMs` | `int` | Minimum wait in milliseconds from the moment the step is entered |

The delay fires **once per step entry**. If `Handler.Next()` is not called inside the body, the step is re-polled on each tick — the delay will not restart between polls.

```csharp
[Flow(Flows.Stage_Process)]
public class StageProcessFlow
{
    [Handler]
    public IFlowHandler Handler { get; set; } = null!;

    // Step 0: signal gate to close, then advance immediately.
    [FlowStep(0)]
    public void CheckStatus(StageModel m)
    {
        m.Gate_Open_o.Set("Off");
        Handler.Next();
    }

    // Step 1: framework waits 3 s after this step is entered before
    // calling StartProcess — gives the gate time to physically close.
    [FlowStep(1), FlowDelay(3000)]
    public void StartProcess(StageModel m)
    {
        m.WaferPresent_i.Set("On");
        m.Start_o.Set("On");
        Handler.Next();
    }

    [FlowStep(2)]
    public void WaitDone(StageModel m)
    {
        if (m.Done_i.Get() != "On") return;
        Handler.Done();
    }
}
```

---

### RecordTime

Records elapsed milliseconds into a Port entry on every poll tick while the decorated `[FlowStep]` is the active step. Attach one attribute per controller instance (category). The timer resets automatically when the entry value is `0.0`.

**Constructor:**

```csharp
RecordTime(string category, string fullKey)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `category` | `string` | Controller instance key (e.g. `"Stage1"`) — only the attribute matching the running instance fires |
| `fullKey` | `string` | Fully-qualified Port entry key to write elapsed ms to (e.g. `"Stage1.ProcessTimer"`) |

`[RecordTime]` can appear multiple times on the same method (one per instance). The framework matches `category` against the current controller key and fires only the matching attribute.

```csharp
// Reset the timer entry to 0.0 in the previous step to start a fresh measurement.
[FlowStep(1)]
public void StartProcess(StageModel m)
{
    m.ProcessTimer.Set(0.0);   // sentinel — RecordTime auto-starts on next poll
    Handler.Next();
}

// One [RecordTime] per stage instance; only the matching one fires each tick.
[FlowStep(2)]
[RecordTime("Stage1", portdic.Stage1.ProcessTimer)]
[RecordTime("Stage2", portdic.Stage2.ProcessTimer)]
[RecordTime("Stage3", portdic.Stage3.ProcessTimer)]
[RecordTime("Stage4", portdic.Stage4.ProcessTimer)]
[RecordTime("Stage5", portdic.Stage5.ProcessTimer)]
public void WaitProcessDone(StageModel m)
{
    if (m.ProcessTimer.Get() < _processDurationMs) return;
    Handler.Next();
}
```

**Timer lifecycle:**

| Event | Action |
|-------|--------|
| Entry value is `0.0` on first poll | Timer resets and starts; entry is set to `1` (ms sentinel) |
| Subsequent polls | Entry is updated to `now − startTime` (ms) |
| Flow advances past this step | No more updates until the step is re-entered |

---

### TransferBlockWhenExecutingFlow

Declares that TM transfers targeting this controller's location should be skipped while the flow is in the `Executing` state. The framework automatically releases the block when the flow transitions back to `Idle` (via `Handler.Done()`).

**Constructor:**

```csharp
TransferBlockWhenExecutingFlow(string tmName)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `tmName` | `string` | Name of the Transfer Module to block (e.g. `"TM1"`) |

Apply this attribute to the `[Flow]` class — not to individual step methods. Multiple attributes are allowed for flows that must block more than one TM.

`[TransferBlockWhenExecutingFlow]` replaces manual `SetBusy(true/false)` calls. The scheduler's `isSkip` callback queries `Port.IsTransferBlocked(tmName, location)` on every transfer request; if true, the request is skipped and the next pending transfer is evaluated instead.

```csharp
[Controller]
public class StageController
{
    // TransferBlockWhenExecutingFlow prevents TM1 from putting a new wafer
    // to this Stage while the current process is running.
    [Flow(Flows.Stage_Process), TransferBlockWhenExecutingFlow("TM1")]
    public class StageProcessFlow
    {
        [Handler]
        public IFlowHandler Handler { get; set; } = null!;

        [FlowStep(0)]
        public void CheckStatus(StageModel m) { Handler.Next(); }

        [FlowStep(1)]
        public void WaitDone(StageModel m)
        {
            if (notDone) return;
            Handler.Done();   // block is released automatically here
        }
    }
}
```

Combine with `[TransferCompletedAfterCall]` when the flow is started by a robot Put event:

```csharp
// AlignerAlignFlow starts when TM1 completes a Put to "Aligner".
// While executing, TM1 is blocked from scheduling any further transfer to "Aligner".
[Flow(Flows.Aligner_Align),
 TransferCompletedAfterCall("TM1", "Aligner"),
 TransferBlockWhenExecutingFlow("TM1")]
public class AlignerAlignFlow
{
    [Handler]
    public IFlowHandler Handler { get; set; } = null!;

    [FlowStep(0)]
    public void StartAlignment(AlignerModel m) { Handler.Next(); }

    [FlowStep(1)]
    public void WaitAlignDone(AlignerModel m)
    {
        if (notDone) return;
        Handler.Done();   // releases block and signals scheduler to schedule Get
    }
}
```

**`Equipment` isSkip wiring:**

```csharp
// In the OnRequestTransfer handler, skip the transfer if the target is blocked.
private static bool isSkip(DualArmAction args)
    => Port.IsTransferBlocked("TM1", args.Target.Name);
```

---

## Document Attributes

Attributes used for extracting data from Excel/Word documents and generating `.page` files and C# constant classes.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| [`[Document]`](#document--save) | class | — | `key` | Specifies source Excel/Word document path |
| [`[Save]`](#document--save) | method | — | `filename` | Specifies output file paths (.page, .cs) |
| [`[ColumnHeader]`](#document--save) | property | — | `header` | Maps to Excel column header |
| [`[EntryKey]`](#document--save) | property | — | — | Designates primary key column |
| [`[EntryProperty]`](#document--save) | property | — | — | Designates additional property column |
| [`[EntryDataType]`](#document--save) | property | — | — | Specifies SECS data type |

### Document + Save

Converts an Excel/Word document into a `.page` file and a C# constants class. This is the approach used in the equipment project to generate `device/io.page` from `IO_Map Ver2.2.docx`.

**Constructors:**

```csharp
Document(string key)
Save(params string[] filename)
ColumnHeader(string header)
```

| Attribute | Parameter | Type | Description |
|-----------|-----------|------|-------------|
| `[Document]` | `key` | `string` | Document category key or source file path; used to identify the document source |
| `[Save]` | `filename` | `string[]` | One or more output file paths — typically a `.page` file and a `.cs` constants file |
| `[ColumnHeader]` | `header` | `string` | Excel column header name to map to this property; omit to match by property name |

**Step 1:** Define a model class that maps Excel columns to `.page` entry fields.

```csharp
public class IOModel
{
    [ColumnHeader, EntryProperty]
    public string Pin_No { set; get; } = string.Empty;

    [ColumnHeader, EntryProperty]
    public string Port_NO { set; get; } = string.Empty;

    [ColumnHeader, EntryKey]           // This column becomes the entry Name
    public string Description { set; get; } = string.Empty;

    [ColumnHeader, EntryProperty]
    public string Model { set; get; } = string.Empty;

    [ColumnHeader, EntryProperty]
    public string Bit_On { set; get; } = string.Empty;

    [EntryDataType]                    // Default data type for all entries
    public string DataType { set; get; } = "enum.OffOn";
}
```

| Attribute | Role |
|-----------|------|
| `[ColumnHeader]` | Maps property to an Excel column by name |
| `[EntryKey]` | Designates this column as the entry name (first field in .page) |
| `[EntryProperty]` | Includes this column in the `property:{...}` JSON |
| `[EntryDataType]` | Sets the data type field (second field in .page) |

**Step 2:** Define the document converter with `[Document]` and `[Save]`.

```csharp
[Document(@"D:\PORT\SampleArduinoLib\equipment\port\IO_Map Ver2.2.docx")]
public class IODocument
{
    [Save(@"D:\PORT\SampleArduinoLib\equipment\port\device\io.page",
          @"D:\PORT\SampleArduinoLib\equipment\port\io1.cs")]
    public Document<IOModel> Convert(Document<IOModel> doc)
    {
        doc.ForEach(v => v.DataType = "enum.OffOn");       // Set all entries to enum type
        doc.ForEach(v => v.Package = "DigitalIO.DI");      // Link all to DigitalIO.DI package
        return doc;
    }
}
```

**Step 3:** Register in your MainWindow to trigger conversion.

```csharp
Port.Add<IODocument>(@"D:\PORT\SampleArduinoLib\equipment\port\IO_Map Ver2.2.docx");
```

**Generated io.page:**
```text
Main_CDA_Pressure_Switch_Check  enum.OffOn  pkg:DigitalIO.DI  property:{"Pin_No":"1","Port_NO":"X01.00","Model":"ISE40A-C6-R-F","Bit_On":"Sensing"}
Door_Lock_On_Check              enum.OffOn  pkg:DigitalIO.DI  property:{"Pin_No":"6","Port_NO":"X01.05","Model":"G7SA-2A2B","Bit_On":"Lock"}
FFU1_Normal_Status              enum.OffOn  pkg:DigitalIO.DI  property:{"Pin_No":"15","Port_NO":"X01.14","Model":"MS-FC300","Bit_On":"Normal"}
```

**Generated io1.cs:**
```csharp
// Auto-generated by Port. Do not edit manually.
namespace equipment
{
    public static class Io1
    {
        public const string Main_CDA_Pressure_Switch_Check = "Main_CDA_Pressure_Switch_Check";
        public const string Door_Lock_On_Check = "Door_Lock_On_Check";
        public const string FFU1_Normal_Status = "FFU1_Normal_Status";
        // ...
    }
}
```

For more detailed usage, see the [.NET Integration Guide](dotnet.md).

---

## FileSender Attributes

Attributes used for declaring QUIC-based file transfer handler classes.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| [`[FileSender]`](#filesender-1) | class | — | — | Registers class as a QUIC file transfer handler container |
| [`[FileSenderHandler]`](#filesender-1) | property | `IFileSenderHandler` | — | Injects the handler for configuration and file operations |

### FileSender

`[FileSender]` marks a class as a QUIC file transfer handler. Register it with `Port.Add<T>(key)` — the platform injects `IFileSenderHandler` into `[FileSenderHandler]` properties and calls `[Preset]` methods before opening the connection.

**Constructors:**

```csharp
FileSender()
FileSenderHandler()
```

```csharp
// Server — receives files
[FileSender]
public class FileReceiveServer
{
    [FileSenderHandler]
    public IFileSenderHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(FileSenderMode.Server);
        handler.SetHost("0.0.0.0");
        handler.SetPort(5000);
        handler.SetSaveDirectory(@"C:\Received");
        handler.OnFileReceived += (n, fn, fp, fs) =>
            Console.WriteLine($"[{n}] {fn} saved to {fp}");
    }
}

// Client — sends files with Certificate Pinning
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

        // Pin the server cert obtained out-of-band
        byte[] cert = File.ReadAllBytes(@"server.cer");
        handler.SetPinnedCert(cert);

        handler.OnEvent += (n, e, d) => Console.WriteLine($"[{n}] {e}: {d}");
    }
}

Port.Add<FileReceiveServer>("file_server");
Port.Add<FileSendClient>("file_client");
Port.Run();
```

**`IFileSenderHandler` members:**

| Member | Description |
|--------|-------------|
| `SetMode(FileSenderMode)` | `FileSenderMode.Server` (receive) or `FileSenderMode.Client` (send) |
| `SetHost(host)` | Server: bind address (e.g. `"0.0.0.0"`). Client: target server address |
| `SetPort(port)` | QUIC port number |
| `SetSaveDirectory(path)` | Directory to save received files (server mode only) |
| `Open()` | Start server or prepare client endpoint; returns `ERROR_CODE` |
| `Close()` | Stop server or disconnect client; returns `ERROR_CODE` |
| `SendFile(filePath)` | Send a single file (loads into memory); returns `0` on success |
| `SendFileMmap(filePath)` | Send a large file using chunked streaming (recommended for > 100 MB) |
| `SendFilesParallel(filePaths)` | Send multiple files via parallel QUIC streams |
| `GetServerCert()` | Returns server's DER certificate after `Open()` (server mode) |
| `SetPinnedCert(certDer)` | Pin expected server certificate before `Open()` (client mode) |
| `SetLogger(rootPath)` | Enable hourly-rotated log files |
| `WriteLog(message)` | Write a custom entry to the log |
| `OnProgress` | Fired periodically with transfer progress `(name, fileName, transferred, total, percent)` |
| `OnFileReceived` | Fired when a file is fully received — server mode only `(name, fileName, filePath, fileSize)` |
| `OnEvent` | Fired on connection and transfer state changes `(name, eventType, description)` |

For the full protocol guide, event types, and error codes, see [FileSender](filesender.md).
