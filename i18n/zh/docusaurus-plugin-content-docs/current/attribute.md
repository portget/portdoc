# Attribute

Port uses C# attributes to declaratively define package registration, API generation, dependency injection, and workflow control. This page is a categorized reference for all Port attributes.

---

## Quick Reference

Summary table of all Port attributes.

| Category | Attribute | Target | Description |
|----------|-----------|--------|-------------|
| **[Portdic](#portdic)** | [`[Portdic]`](#portdic) | class | Register main window as Port project entry point |
| **[Package](#package-attributes)** | [`[Package]`](#package) | class | Register Port-managed package |
| | [`[Handler]`](#handler) | property | Inject IPackageHandler (log + property) |
| | [`[Preset]`](#handler) | method | Initialization after injection |
| | [`[API]`](#api) | property, field | Generate REST API endpoint |
| | [`[Valid]`](#valid) | method | Validation gate |
| | [`[Comment]`](#comment) | property | API documentation |
| **[Controller](#flow-attributes)** | [`[Controller]`](#controller--flow) | class | Flow controller |
| | [`[Flow]`](#controller--flow) | class | Workflow definition |
| | [`[FlowStep]`](#flowstep) | method | Workflow step |
| | [`[Handler]`](#handler-1) | property | Inject `IFlowHandler` (basic step control) |
| | [`[Handler]`](#handler-1) | property | Inject `IFlowWithModelHandler<T>` (lifecycle events with model) |
| | [`[Handler]`](#handler-1) | property | Inject `ISchedulerHandler<T>` (transfer scheduling) |
| | [`[Model]`](#model) | class | Define flow model class |
| | [`[ModelBinding]`](#model) | property | Bind model property to a Port entry |
| | [`[FlowWatcherCompare]`](#flowwatchercompare) | method | Step condition watcher |
| | [`[FlowWatcherAction]`](#flowwatcheraction) | method | Step completion action |
| | [`[Timeout]`](#timeout) | method | Step timeout |
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
| [`[Handler]`](#handler) | property | `IPackageHandler` | — | Injects handler — unified access to logging and entry property |
| [`[Preset]`](#handler) | method | — | — | Called once after injection; use for initialization and event wiring |
| [`[API]`](#api) | property, field | — | `EntryDataType`, `PropertyFormat`, `keys` | Generates REST API endpoint |
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
| `invalidComment` | `string` | Error message returned to the caller when the method returns `false` |

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

## Controller Attributes

Attributes used for defining and controlling workflows (process flows).

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| [`[Controller]`](#controller) | class | — | — | Defines a controller containing flows |
| [`[Flow]`](#controller) | class | — | `key` | Defines a workflow class (inner class of Controller) |
| [`[FlowStep]`](#flowstep) | method | — | `index`, `relatedEntry` | Defines a workflow step |
| [`[Handler]`](#handler-1) | property | `IFlowHandler` | — | Injects basic flow step control into a Flow class |
| [`[Handler]`](#handler-1) | property | `IFlowWithModelHandler<T>` | — | Injects model-bound handler with lifecycle events |
| [`[Handler]`](#handler-1) | property | `ISchedulerHandler<T>` | — | Injects transfer scheduler handler |
| [`[Model]`](#model) | class | — | — | Defines a flow model class; properties use `[ModelBinding]` |
| [`[ModelBinding]`](#model) | property | `Entry` | `controllerName`, `entryKey` | Binds a model property to a Port entry |
| [`[FlowWatcherCompare]`](#flowwatchercompare) | method | — | `entry`, `op`, `value` | Defines step execution condition |
| [`[FlowWatcherAction]`](#flowwatcheraction) | method | — | `entry`, `value` | Defines action on step completion |
| [`[Timeout]`](#timeout) | method | — | `ms`, `controller`, `alarmid` | Sets step timeout and alarm |

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
        handler.OnFlowOccured  += Handler_OnFlowOccured;
        handler.OnFlowFinished += Handler_OnFlowFinished;
    }

    // Called when the flow is triggered (before Step 0 runs).
    // e.Model is the bound model populated at flow start.
    private void Handler_OnFlowOccured(object sender, PortFlowOccuredWithModelArgs<WTRCommModel> e)
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
| `OccuredAlarm(alid)` | Raise an alarm by alarm ID |
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
| `OnFlowOccured` | Fired when the flow starts |
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
