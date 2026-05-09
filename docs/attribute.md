# Attribute Reference

Port uses C# attributes to declaratively define package registration, API generation, dependency injection, and workflow control. This page is a categorized reference for all Port attributes.

---

## Package Attributes

Attributes used for defining package classes and generating APIs.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| `[Package]` | class | — | `typeof(T)` | Registers class as a Port-managed package |
| `[API]` | property, field | — | `EntryDataType`, `PropertyFormat`, `keys` | Generates REST API endpoint automatically |
| `[Property]` | property | `IProperty` | — | Accesses entry property values (configuration) |
| `[Logger]` | property | `ILogger` | — | Injects logging service |
| `[Valid]` | method | — | `"error message"` | Defines package validation logic |
| `[Comment]` | property | — | `"comment text"` | Adds API documentation |
| `[Mapping]` | property | — | `typeof(T)` | Maps to a specific data type |
| `[ModelProperty]` | field, property | — | `"portKey"` | Marks as data model property |
| `[EnumCode]` | enum | — | `"using"` | Exposes enum values through API |
| `[Command]` | method | — | `"key"` | Registers command endpoint |

### Package

Registers a class as a managed package in the Port Dictionary system.

```csharp
[Package]
public class Bulb
{
    [Logger]
    public ILogger Logger { get; set; }

    [Property]
    public IProperty Property { get; set; }

    [Valid("Device not connected")]
    public bool Valid() => true;

    [API(EntryDataType.Enum)]
    public string OffOn { get; set; } = "Off";
}
```

### API

Automatically registers a property as a REST API endpoint. Specify the data type with `EntryDataType`.

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

### Property

Injects `IProperty` to access configuration values set on the entry.

```csharp
[Property]
public IProperty Property { get; set; }

// Usage
if (Property.TryToGetValue("Unit", out string unit))
{
    // unit == "C" or "F"
}
```

### Logger

Injects `ILogger` for writing log messages.

```csharp
[Logger]
public ILogger Logger { get; set; }

// Usage
Logger.Write("[INFO] Operation completed");
Logger.Write("[ERROR] " + ex.Message);
```

### Valid

Defines a validation method for the package. When it returns `false`, the error message passed as argument is displayed.

```csharp
[Valid("Device not connected")]
public bool Valid()
{
    return serialPort.IsOpen;
}
```

### Comment

Adds a description to an API property.

```csharp
[API, Comment("Current temperature (Celsius)")]
public double Temperature { get; set; }
```

### EnumCode

Exposes an enum type through the API.

```csharp
[EnumCode]
public enum DeviceStatus : ushort
{
    _ = 0,
    Idle,
    Running,
    Error,
}
```

---

## Flow Attributes

Attributes used for defining and controlling workflows (process flows).

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| `[Flow]` | class | — | `typeof(T)` | Defines a workflow class |
| `[FlowController]` | class | — | — | Defines a controller containing flows |
| `[FlowStep]` | method | — | `nameof(prevStep)` | Defines a workflow step |
| `[FlowModel]` | property | `IFlowModel` | — | Injects flow data model |
| `[FlowNotify]` | property | `IFlowNotify` | — | Injects flow notification/progress control |
| `[FlowWatcherCompare]` | method | — | `entry`, `op`, `value` | Defines step execution condition |
| `[FlowWatcherAction]` | method | — | `entry`, `value` | Defines action on step completion |
| `[FlowControl]` | property | `IFlowControl` | — | Injects flow branching/jump control |
| `[StepTimer]` | property | `IStepTimer` | — | Injects step timer/scheduling |
| `[Step]` | method | — | `index`, `ceid`, `entry` | Defines package-level workflow step |
| `[Import]` | field, property | `IFunction` / `IReference` | `"packageName"`, `"key"` | Injects cross-package dependency |
| `[Timeout]` | method | — | `min`, `max` | Sets step timeout |

### FlowController + Flow

`[FlowController]` defines a controller that contains multiple flows, and `[Flow]` defines an inner workflow class.

```csharp
[FlowController]
public partial class LoadPortController
{
    [Flow]
    public class LoadFlow
    {
        [FlowModel]
        public IFlowModel model { get; set; }

        [FlowNotify]
        public IFlowNotify Notify { get; set; }

        [FlowStep]
        public void Step1()
        {
            // First step
            Notify.Next();  // Move to next step
        }

        [FlowStep(nameof(Step1))]
        public void Step2()
        {
            // Runs after Step1
            Notify.Next();
        }
    }
}
```

### FlowStep

Registers a method as a workflow step. Use `nameof()` to specify the previous step and define execution order.

```csharp
// First step (no arguments)
[FlowStep]
public void Step1() { Notify.Next(); }

// Runs after Step1
[FlowStep(nameof(Step1))]
public void Step2() { Notify.Next(); }

// Runs after Step2
[FlowStep(nameof(Step2))]
public void Step3() { Notify.Next(); }
```

### FlowWatcherCompare

Defines pre/post conditions for a step. All conditions must be met before proceeding to the next step.

```csharp
[FlowStep]
[FlowWatcherCompare("@Temp1", ">=", 50)]                           // Model binding (@)
[FlowWatcherCompare("room2.HeaterTemp4", ">=", 100)]                // Direct reference
[FlowWatcherCompare("room2.HeaterTemp5", ">=", Room2.HeaterTemp4)]  // Entry-to-entry comparison
public void Step1()
{
    Notify.Next();
}
```

**Supported operators:** `>=`, `<=`, `>`, `<`, `==`, `!=`

### FlowWatcherAction

Automatically sets a value when a step completes.

```csharp
[FlowStep]
[FlowWatcherAction("room2.BulbOnOff", "Off")]    // Sets BulbOnOff = "Off" on completion
[FlowWatcherAction(Room2.BulbOnOff, "On")]        // Using token constants
public void Step1()
{
    Notify.Next();
}
```

### FlowModel

Binds and provides Get/Set access to model data within a flow. Use the `@` prefix to reference model-bound messages.

```csharp
[FlowModel]
public IFlowModel model { get; set; }

// Usage
var value = model.Get("@OnOff");       // Read model-bound value
model.Set("@OnOff", "On");            // Write model-bound value
var data = model.Binding("@OnOff");   // Get binding data
```

### FlowNotify

Handles flow progress control and notifications.

```csharp
[FlowNotify]
public IFlowNotify Notify { get; set; }

// Usage
Notify.Next();                    // Move to next step
Notify.Alert("message");         // Raise alert notification
Notify.OccuredAlarm(3000);       // Raise alarm (Alarm ID)
Notify.ClearAlarm(3000);         // Clear alarm
```

### Step (Package Level)

Defines workflow steps within a `[Package]` class (instead of a `[Flow]` class).

```csharp
[Package(typeof(DataProcessingService))]
public class DataProcessingService
{
    [Step(1, "InputData")]
    public void ProcessInput()
    {
        // index 1 — first step
    }

    [Step(2, 1001, "ProcessData", "QualityCheck")]
    public void ProcessData()
    {
        // index 2, CEID 1001 — second step
    }

    [Step(10, "FinalizeProcess")]
    public void Finalize()
    {
        // index 10 — final step
    }
}
```

### StepTimer

Provides timing control and delayed execution within steps.

```csharp
[StepTimer]
public IStepTimer Timer { get; set; }

// Usage
Timer.Reserve("timeout", 5000, () => HandleTimeout());   // Execute after 5 seconds
Timer.Once("init", () => Initialize());                   // Execute only once
var elapsed = Timer.TotalSeconds;                          // Elapsed time
```

### FlowControl

Enables dynamic branching and jumping between steps.

```csharp
[FlowControl]
public IFlowControl FlowControl { get; set; }

// Usage
FlowControl.JumpStep(5);     // Jump to step 5
FlowControl.JumpStep(99);    // Jump to error handling step
```

### Import

References functionality from other packages via dependency injection.

```csharp
[Import("Heater", "Heater6")]
public IReference reference;

[Import("MathReferences", "Calculator")]
private IFunction calculator;

// Usage
var result = calculator.Binding("ProcessingData");
```

### Timeout

Sets a timeout for a FlowStep.

```csharp
[FlowStep]
[Timeout(0, 0)]    // min, max (0 = unlimited)
public void Step1()
{
    Notify.Next();
}
```

---

## GEM / SECS Attributes

Attributes used for configuring SECS/GEM semiconductor communication protocol.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| `[GEM]` | class | — | — | Defines a SECS/GEM handler class |
| `[GemHandler]` | property | `IGemHandler` | — | Injects GEM handler |
| `[Preset]` | method | — | — | Designates initialization/configuration method |
| `[SECS]` | property | — | `index`, `MappingRule` | Maps SECS message fields |

### GEM + GemHandler + Preset

```csharp
[GEM]
public class GemHelper
{
    [GemHandler]
    public IGemHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(Mode.Passive);         // Passive: Host initiates connection
        handler.SetAddress("127.0.0.1:6000");  // HSMS address
        handler.SetDevice("0");                // Device ID
        handler.SetT3(45);                     // T3 timeout (seconds)

        // Register SECS message handler
        handler.OnS10F1_TerminalDisplaySingle += OnTerminalDisplay;
    }

    private void OnTerminalDisplay(IGemReplier replier, ReceiveSecsMessage message)
    {
        // Handle terminal message from host
    }
}
```

### SECS

Maps SECS message fields to C# properties. Use `index` for field order and `MappingRule` for mapping rules.

```csharp
// S3F17 message structure definition
public class S3F17Message
{
    [SECS(0)]
    public U2 DATAID { set; get; }

    [SECS(1)]
    public A CARRIERACTION { set; get; }

    [SECS(2)]
    public A CARRIERSPEC { set; get; }

    [SECS(3)]
    public B PORTNUMBER { set; get; }

    [SECS(4)]
    public S3F17Items ITEMS { set; get; }
}

// Nested items with MappingRule
public class S3F17Items
{
    [SECS(0, MappingRule.ByKey)]
    public B Capacity { set; get; }

    [SECS(1, MappingRule.ByKey)]
    public B SubstrateCount { set; get; }

    [SECS(2, MappingRule.ByKey)]
    public List<ContentMap> ContentMap { set; get; }
}
```

**SECS data types:**

| Type | Description |
|------|-------------|
| `A` | ASCII string |
| `B` | Binary (1 byte) |
| `U1` / `U2` / `U4` | Unsigned integer (1/2/4 bytes) |
| `I1` / `I2` / `I4` | Signed integer (1/2/4 bytes) |
| `F4` / `F8` | Float (4/8 bytes) |
| `BOOL` | Boolean |

```csharp
// Receive and deserialize a message
private void OnS3F17(IGemReplier replier, ReceiveSecsMessage message)
{
    var msg = message.Deserialize<S3F17Message>();
    // Access msg.DATAID, msg.CARRIERACTION, etc.
}

// Send a reply
private void OnS10F5(IGemReplier replier, ReceiveSecsMessage message)
{
    replier.Reply(message.SystemBytes, new ACKC(ACKC.Code.ACCEPTED));
}
```

---

## Controller Attributes

Attributes used for application controllers and material handling (transfer) control.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| `[AppController]` | class | — | — | Defines an application-level controller |
| `[TransferController]` | class | — | — | Defines a material handling controller |
| `[TransferHandler]` | property | `ITransferHandler` | — | Injects transfer handler |
| `[Location]` | method | — | `"name"` | Defines a wafer transfer location |

### AppController

Handles application-level initialization and system logic.

```csharp
[AppController]
public class WapisController
{
    [Preset]
    public void Preset()
    {
        // System initialization logic
    }
}
```

### TransferController + Location

Controller for wafer transfer robot control. Use `[Location]` to define transfer locations.

```csharp
[TransferController]
public class TransferController
{
    [TransferHandler]
    public ITransferHandler handler { get; set; } = null!;

    [Location("LP1")]
    public int LP1() => -1;    // -1: location not ready

    [Location("LP2")]
    public int LP2() => -1;

    [Location("Upper")]
    public int Upper() => -1;

    [Location("Lower")]
    public int Lower() => -1;

    [Preset]
    public void Preset()
    {
        handler.OnFlowFinished += OnFlowFinished;
    }

    private void OnFlowFinished(ITransferReplier replier, TransferFlowArgs e)
    {
        if (e.Key == "LP1Get")
        {
            // e.Current — current location
            // e.Next — next location
            // replier.RequestMove(e.Current, e.Next)
        }
    }
}
```

---

## Document Attributes

Attributes used for extracting data from Excel/Word documents and generating `.page` files and C# constant classes.

| Attribute | Target | Injected Type | Arguments | Description |
|-----------|--------|---------------|-----------|-------------|
| `[Document]` | class | — | `"filePath"` | Specifies source Excel/Word document path |
| `[Save]` | method | — | `"pagePath"`, `"csPath"` | Specifies output file paths (.page, .cs) |
| `[ColumnHeader]` | property | — | — | Maps to Excel column header |
| `[EntryKey]` | property | — | — | Designates primary key column |
| `[EntryProperty]` | property | — | — | Designates additional property column |
| `[EntryDataType]` | property | — | — | Specifies SECS data type |

### Document + Save

Converts an Excel/Word document into a `.page` file and a C# constants class. This is the approach used in the wapis project to generate `device/io.page` from `MT-30T IO_Map Ver2.2.docx`.

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
[Document(@"D:\PORT\SampleArduinoLib\wapis\port\MT-30T IO_Map Ver2.2.docx")]
public class IODocument
{
    [Save(@"D:\PORT\SampleArduinoLib\wapis\port\device\io.page",
          @"D:\PORT\SampleArduinoLib\wapis\port\io1.cs")]
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
Port.Add<IODocument>(@"D:\PORT\SampleArduinoLib\wapis\port\MT-30T IO_Map Ver2.2.docx");
```

**Generated io.page:**
```
Main_CDA_Pressure_Switch_Check  enum.OffOn  pkg:DigitalIO.DI  property:{"Pin_No":"1","Port_NO":"X01.00","Model":"ISE40A-C6-R-F","Bit_On":"Sensing"}
Door_Lock_On_Check              enum.OffOn  pkg:DigitalIO.DI  property:{"Pin_No":"6","Port_NO":"X01.05","Model":"G7SA-2A2B","Bit_On":"Lock"}
FFU1_Normal_Status              enum.OffOn  pkg:DigitalIO.DI  property:{"Pin_No":"15","Port_NO":"X01.14","Model":"MS-FC300","Bit_On":"Normal"}
```

**Generated io1.cs:**
```csharp
// Auto-generated by Port. Do not edit manually.
namespace wapis
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

---

## Quick Reference

Summary table of all Port attributes.

| Category | Attribute | Target | Description |
|----------|-----------|--------|-------------|
| **Package** | `[Package]` | class | Register Port-managed package |
| | `[API]` | property, field | Generate REST API endpoint |
| | `[Property]` | property | Inject IProperty |
| | `[Logger]` | property | Inject ILogger |
| | `[Valid]` | method | Validation logic |
| | `[Comment]` | property | API documentation |
| | `[Mapping]` | property | Type mapping |
| | `[ModelProperty]` | field, property | Data model property |
| | `[EnumCode]` | enum | Expose enum via API |
| | `[Command]` | method | Command endpoint |
| **Flow** | `[Flow]` | class | Workflow definition |
| | `[FlowController]` | class | Flow controller |
| | `[FlowStep]` | method | Workflow step |
| | `[FlowModel]` | property | Inject IFlowModel |
| | `[FlowNotify]` | property | Inject IFlowNotify |
| | `[FlowWatcherCompare]` | method | Step condition watcher |
| | `[FlowWatcherAction]` | method | Step completion action |
| | `[FlowControl]` | property | Inject IFlowControl |
| | `[StepTimer]` | property | Inject IStepTimer |
| | `[Step]` | method | Package-level step |
| | `[Import]` | field, property | Cross-package dependency |
| | `[Timeout]` | method | Step timeout |
| **GEM/SECS** | `[GEM]` | class | GEM handler |
| | `[GemHandler]` | property | Inject IGemHandler |
| | `[Preset]` | method | Initialization config |
| | `[SECS]` | property | SECS field mapping |
| **Controller** | `[AppController]` | class | Application controller |
| | `[TransferController]` | class | Transfer controller |
| | `[TransferHandler]` | property | Inject ITransferHandler |
| | `[Location]` | method | Define transfer location |
| **Document** | `[Document]` | class | Source document path |
| | `[Save]` | method | Output file paths |
| | `[ColumnHeader]` | property | Column header mapping |
| | `[EntryKey]` | property | Key column |
| | `[EntryProperty]` | property | Property column |
| | `[EntryDataType]` | property | Data type |

---

For more detailed usage, see the [.NET Integration Guide](dotnet.md).
