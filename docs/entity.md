# Entity Objects

## Table of Contents

- [Overview](#overview)
- [Retrieving Entities](#retrieving-entities)
- [Entity Classes](#entity-classes)
  - [LoadModuleEntity — Load Port (E87)](#loadmoduleentity)
  - [ProcessModuleEntity — Process Module (E39)](#processmoduleentity)
  - [CarrierEntity — Carrier & Slot Map](#carrierentity)
  - [SubstrateEntity — Substrate State](#substrateentity)
  - [JobEntity — Active Job](#jobentity)
  - [FlowEntity — Flow Execution](#flowentity)
  - [CEIDEntity](#ceidentity)
- [Supporting Types](#supporting-types)
  - [SlotStates Enum](#slotstates-enum)
  - [SubstrateState Enum](#substratestate-enum)
  - [SlotAssignment](#slotassignment)
  - [SlotEntry Struct](#slotentry-struct)
  - [SubstrateRoute](#substrateroute)
- [Thread Safety](#thread-safety)
- [Common Patterns](#common-patterns)

---

## Overview {#overview}

Entity objects are the primary read/write interface for live equipment state in Port. Each entity class implements `IEntity` and represents a distinct hardware or logical resource — a load port, a process module, a carrier, a substrate, or a running flow.

Entities are **per-location singletons**: the first call to `Port.GetEntity<T>("LP1")` creates the instance; every subsequent call returns the same object. This means you never `new` an entity yourself — you always retrieve it through the Port API.

| Entity Class | SEMI Standard | Represents |
|---|---|---|
| `LoadModuleEntity` | E87 | Load-port transfer and carrier lifecycle state |
| `ProcessModuleEntity` | E39 | Process-module execution state and timer |
| `CarrierEntity` | E87 | Carrier identity and per-slot occupancy |
| `SubstrateEntity` | E90 | Substrate identity, reservation, and route |
| `JobEntity` | — | The currently active job and its route progress |
| `FlowEntity` | — | Flow execution state of a named controller |
| `CEIDEntity` | E30 | Collection Event ID holder |

---

## Retrieving Entities {#retrieving-entities}

Use `Port.GetEntity<T>` to obtain an entity singleton. Pass the **location name** that matches the `[LMC]`, `[PMC]`, or `[TMC]` declaration in your Port document.

```csharp
// Load port entities (location = LMC name)
LoadModuleEntity lp1     = Port.GetEntity<LoadModuleEntity>("LP1");
CarrierEntity    carrier = Port.GetEntity<CarrierEntity>("LP1");

// Process module entities (location = PMC name)
ProcessModuleEntity stage1 = Port.GetEntity<ProcessModuleEntity>("Stage1");
SubstrateEntity     sub1   = Port.GetEntity<SubstrateEntity>("Stage1");

// Active job singleton (location = Equipment/TM name)
JobEntity job = Port.GetEntity<JobEntity>("TM1");

// Flow state per controller
FlowEntity flow = Port.GetEntity<FlowEntity>("Scheduler");
```

:::tip Per-location Singleton
Calling `Port.GetEntity<LoadModuleEntity>("LP1")` multiple times always returns the exact same C# object. You can safely cache the reference or call `Port.GetEntity` on every access — both patterns have the same cost after the first call.
:::

---

## Entity Classes {#entity-classes}

### LoadModuleEntity — Load Port (E87) {#loadmoduleentity}

Holds the five independent SEMI E87 state machines for a single load-port location.

```csharp
LoadModuleEntity lp1 = Port.GetEntity<LoadModuleEntity>("LP1");
```

#### Properties

| Property | Type | Description |
|---|---|---|
| `Location` | `string` | Location name this instance is bound to (e.g. `"LP1"`) |
| `TransferState` | `LoadPortTransferState` | Top-level E87 transfer state |
| `InServiceState` | `LoadPortInServiceState` | E87 in-service sub-state (meaningful only when `TransferState` is `InService`) |
| `CarrierState` | `CarrierState` | E87 carrier lifecycle state |
| `CarrierIdStatus` | `CarrierIDStatus` | E87 carrier ID recognition status |
| `SlotMapStatus` | `SlotMapStatus` | E87 slot map verification status |

#### State Text Helpers

| Method | Returns | Description |
|---|---|---|
| `GetStateText()` | `string` | `"OutOfService"` or the current in-service sub-state name |
| `GetCarrierStateText()` | `string` | Human-readable name of the current `CarrierState` |

#### Example

```csharp
var lp1 = Port.GetEntity<LoadModuleEntity>("LP1");
Console.WriteLine(lp1.GetStateText());        // "ReadyToLoad"
Console.WriteLine(lp1.GetCarrierStateText()); // "NotAccessed"
Console.WriteLine(lp1.TransferState);         // LoadPortTransferState.InService
```

---

### ProcessModuleEntity — Process Module (E39) {#processmoduleentity}

Tracks the SEMI E39 process state and recipe-timer data for a single equipment module.

```csharp
ProcessModuleEntity stage1 = Port.GetEntity<ProcessModuleEntity>("Stage1");
```

#### Properties

| Property | Type | Description |
|---|---|---|
| `Location` | `string` | Location name (e.g. `"Stage1"`) |
| `State` | `ModuleProcessState` | Current SEMI E39 process state |
| `ProcessValue` | `double` | Elapsed process time in seconds (atomic read) |
| `ProcessMax` | `double` | Total recipe step duration in seconds (atomic read) |

#### Methods

| Method | Returns | Description |
|---|---|---|
| `SetState(ModuleProcessState)` | `ProcessModuleEntity` | Atomically sets process state and raises `Port.ModuleStateChanged` |
| `SetState(string)` | `ProcessModuleEntity` | Parses and sets process state by name (case-insensitive) |
| `SetProcessSeconds(double)` | `ProcessModuleEntity` | Sets elapsed process time |
| `SetProcessMax(double)` | `ProcessModuleEntity` | Sets total recipe step duration |
| `SetRecipeName(string)` | `ProcessModuleEntity` | Stores the recipe name for the current step |
| `GetStateText()` | `string` | Human-readable name of `State` |
| `GetProcessValue()` | `double` | Alias for `ProcessValue` property |
| `GetProcessMax()` | `double` | Alias for `ProcessMax` property |
| `GetRecipeName()` | `string` | Returns the recipe name set via `SetRecipeName` |

#### ModuleProcessState Values

| State | Description |
|---|---|
| `Init` | Module has not started |
| `Idle` | Module is idle and ready |
| `Setup` | Module is being prepared |
| `Executing` | Module is processing a substrate |
| `Pause` | Processing is paused |
| `Complete` | Processing has completed |

#### Example

```csharp
ProcessModuleEntity stage = Port.GetEntity<ProcessModuleEntity>("Stage1");

// Start processing
stage.SetState(portdic.GEM.E39.ModuleProcessState.Executing)
     .SetRecipeName("Oxide_90s")
     .SetProcessMax(90.0)
     .SetProcessSeconds(0.0);

// Tick the timer each second
stage.SetProcessSeconds(stage.ProcessValue + 1.0);

// Display progress
Console.WriteLine($"Recipe: {stage.GetRecipeName()}");
Console.WriteLine($"Progress: {stage.ProcessValue:F0}/{stage.ProcessMax:F0}s");
Console.WriteLine($"State: {stage.GetStateText()}");

// Complete processing
stage.SetState("Complete");
```

:::info Event on State Change
`SetState` automatically calls `Port.RaiseModuleStateChanged`, which fires `Port.ModuleStateChanged`. Subscribe to this event to get notified whenever any module state changes.
:::

---

### CarrierEntity — Carrier & Slot Map {#carrierentity}

Holds carrier identity, per-slot occupancy state, and lot-selection state for a load-port location.

```csharp
CarrierEntity carrier = Port.GetEntity<CarrierEntity>("LP1");
```

#### Properties

| Property | Type | Description |
|---|---|---|
| `SlotCount` | `int` | Total number of substrate slots (from `[LMC(n)]` declaration) |

#### Methods

| Method | Returns | Description |
|---|---|---|
| `GetCarrierID()` | `string` | Carrier ID string for this location |
| `SetSlot(int slot, SlotStates state)` | `void` | Sets occupancy state of the specified slot (1-based) |
| `GetSlot(int slot)` | `SlotStates` | Returns occupancy state; `Empty` when not set |
| `GetAllSlots()` | `IReadOnlyDictionary<int, SlotStates>` | Snapshot of all set slot states |
| `SetReturned(int slot, bool returned)` | `void` | Marks whether the substrate in this slot has been returned after processing |
| `GetReturned(int slot)` | `bool` | Returns `true` when the slot is marked as returned |
| `GetSelected(int slot)` | `bool` | Returns `true` when the slot belongs to the currently active lot |
| `GetSlots()` | `IReadOnlyList<SlotEntry>` | Full 25-element slot view for UI binding |

#### Example

```csharp
CarrierEntity carrier = Port.GetEntity<CarrierEntity>("LP1");

// Read carrier ID
Console.WriteLine($"Carrier: {carrier.GetCarrierID()}");

// Set slot occupancy after slot mapping
carrier.SetSlot(1, SlotStates.CorrectlyOccupied);
carrier.SetSlot(2, SlotStates.Empty);
carrier.SetSlot(3, SlotStates.DoubleSlotted);

// Check a specific slot
SlotStates s1 = carrier.GetSlot(1); // CorrectlyOccupied

// Mark slot as returned after processing
carrier.SetReturned(1, true);

// Get full slot view for WPF binding
IReadOnlyList<SlotEntry> slots = carrier.GetSlots();
foreach (SlotEntry entry in slots)
{
    Console.WriteLine(
        $"Slot {entry.SlotNo}: Present={entry.IsPresent}, " +
        $"Returned={entry.IsReturned}, Selected={entry.IsSelected}, " +
        $"ID={entry.SubstrateId}");
}
```

---

### SubstrateEntity — Substrate State {#substrateentity}

Provides substrate identity, reservation state, and route access for a named equipment location.

```csharp
SubstrateEntity sub = Port.GetEntity<SubstrateEntity>("Stage1");
```

#### Methods

| Method | Returns | Description |
|---|---|---|
| `GetSubstrateID()` | `string` | Substrate ID at this location, or empty string if none |
| `GetExists()` | `bool` | `true` when a substrate is present |
| `GetReserved()` | `bool` | `true` when the location is reserved (substrate placed but not yet complete) |
| `SetReserved(bool)` | `void` | Sets the reservation flag — `true` after a Put, `false` after processing completes |
| `GetState()` | `SubstrateState` | Current SEMI E90 processing state |
| `SetState(SubstrateState)` | `void` | Sets the SEMI E90 processing state |
| `GetRoute()` | `SubstrateRoute` | Route plan and step progress for the current substrate |

#### Example

```csharp
SubstrateEntity sub = Port.GetEntity<SubstrateEntity>("Stage1");

// Check whether a substrate is present
if (sub.GetExists())
{
    Console.WriteLine($"Substrate: {sub.GetSubstrateID()}");
    Console.WriteLine($"Reserved: {sub.GetReserved()}");
    Console.WriteLine($"State: {sub.GetState()}");
}

// Reserve the location when a Put command completes
sub.SetReserved(true);
sub.SetState(SubstrateState.Unprocessed);

// After processing finishes
sub.SetState(SubstrateState.Processed);
sub.SetReserved(false);

// Inspect the route for this substrate
SubstrateRoute route = sub.GetRoute();
foreach (RouteInfo info in route.GetAll())
{
    Console.WriteLine($"Key: {info.Key}, LastCompleted: {info.LastCompletedStep}");
}
```

---

### JobEntity — Active Job {#jobentity}

Holds the identity and slot assignments of the currently active job, and exposes live route-tracking data. Retrieved per Equipment/TM location — there is one `JobEntity` singleton per location.

```csharp
JobEntity job = Port.GetEntity<JobEntity>("TM1");
```

#### Properties

| Property | Type | Description |
|---|---|---|
| `ID` | `string` | Unique job identifier (empty when no job is active) |
| `Name` | `string` | Human-readable job name |
| `SourceLp` | `string` | Source load-port name (e.g. `"LP1"`) |
| `SlotAssignments` | `List<SlotAssignment>` | Per-slot route assignments |
| `CycleCount` | `int` | Number of times the job repeats after completion (`0` = run once) |
| `CreatedAt` | `DateTime` | Timestamp when the job was created |
| `IsActive` | `bool` | `true` when `ID` is non-empty |
| `LotCompletedCount` | `int` | Number of job cycles completed so far |

#### Methods

| Method | Returns | Description |
|---|---|---|
| `Queued(JobEntity source)` | `ResultCode` | Copies job data from `source` and marks it as queued — call when a job enters the queue |
| `Processing(JobEntity source)` | `ResultCode` | Copies job data from `source` and marks it as actively processing |
| `Clear()` | `void` | Resets all fields — marks the job as inactive |
| `GetAllRoute()` | `IEnumerable<RouteInfo>` | Snapshot of every registered substrate route and step progress |

#### Example

```csharp
JobEntity job = Port.GetEntity<JobEntity>("TM1");

// Check if a job is active
if (!job.IsActive)
{
    Console.WriteLine("No active job.");
    return;
}

Console.WriteLine($"Job: {job.Name} (ID: {job.ID})");
Console.WriteLine($"Source: {job.SourceLp}");
Console.WriteLine($"Slots: {job.SlotAssignments.Count}");
Console.WriteLine($"Completed cycles: {job.LotCompletedCount}");

// Print route progress for all substrates
foreach (RouteInfo info in job.GetAllRoute())
{
    Console.WriteLine($"  [{info.Key}] last step: {info.LastCompletedStep}");
}

// Queue a new job built from persistent storage
var newJob = new JobEntity(
    id:              "A1B2C3D4",
    name:            "TestJob",
    sourceLp:        "LP1",
    slotAssignments: assignments,
    cycleCount:      0,
    createdAt:       DateTime.Now);

job.Queued(newJob);      // job entered the queue
job.Processing(newJob);  // job started executing

// Clear when the job finishes
job.Clear();
```

---

### FlowEntity — Flow Execution {#flowentity}

Provides read-only access to the execution state of a controller's named flows.

```csharp
FlowEntity flow = Port.GetEntity<FlowEntity>("Scheduler");
```

#### Methods

| Method | Returns | Description |
|---|---|---|
| `GetAction(string flowName = "Queued")` | `FlowAction` | Current `FlowAction` for the named flow |
| `GetCurrentStep(string flowName = "Queued")` | `string` | Name of the step currently executing, or `null` if not started |
| `IsRunning(string flowName = "Queued")` | `bool` | `true` when the flow is actively executing |

#### FlowAction Values

| Value | Description |
|---|---|
| `Queued` | Flow is queued and waiting to execute |
| `Executing` | Flow is actively running a step |
| `Done` | Flow has finished all steps |
| `Paused` | Flow execution is paused |

#### Example

```csharp
FlowEntity flow = Port.GetEntity<FlowEntity>("Scheduler");

// Check default "Queued" flow
Console.WriteLine($"Running: {flow.IsRunning()}");
Console.WriteLine($"Step: {flow.GetCurrentStep()}");
Console.WriteLine($"Action: {flow.GetAction()}");

// Check a specific named flow
Console.WriteLine($"Transfer running: {flow.IsRunning("Transfer")}");
Console.WriteLine($"Transfer step: {flow.GetCurrentStep("Transfer")}");
```

---

### CEIDEntity {#ceidentity}

A Collection Event ID entity used to hold SEMI E30 CEID-related data.

```csharp
CEIDEntity ceid = Port.GetEntity<CEIDEntity>("category");
IImmutableList<int> list = ceid.GetList(); // Returns associated int list
```

---

## Supporting Types {#supporting-types}

### SlotStates Enum {#slotstates-enum}

SEMI E87 slot occupancy state reported by the load-port mapping sensor.

| Value | Integer | Description |
|---|---|---|
| `Empty` | 0 | Slot contains no wafer |
| `NotEmpty` | 1 | Slot contains a wafer but position has not been verified |
| `CorrectlyOccupied` | 2 | Wafer is correctly seated within slot boundaries |
| `DoubleSlotted` | 3 | A single wafer spans two adjacent slots |
| `CrossSlotted` | 4 | A wafer is tilted or misaligned across the slot boundary |

```csharp
var state = carrier.GetSlot(3);
if (state == SlotStates.DoubleSlotted || state == SlotStates.CrossSlotted)
{
    Console.WriteLine("Slot 3: mapping error detected");
}
```

---

### SubstrateState Enum {#substratestate-enum}

SEMI E90 substrate processing state.

| Value | Description |
|---|---|
| `Unknown` | State before slot mapping is performed |
| `Aliased` | Substrate ID is duplicated or cannot be uniquely identified |
| `Processed` | Substrate has already completed processing |
| `Unprocessed` | Substrate is waiting and has not yet been processed |
| `Skipped` | Substrate has been excluded from the process sequence |

```csharp
sub.SetState(SubstrateState.Unprocessed); // before processing
sub.SetState(SubstrateState.Processed);   // after processing
sub.SetState(SubstrateState.Skipped);     // excluded slot
```

---

### SlotAssignment {#slotassignment}

Associates a load-port slot number with a saved route name.

| Property | Type | Description |
|---|---|---|
| `SlotIndex` | `int` | 1-based slot index within the load-port carrier |
| `RouteName` | `string` | Name of the route assigned to this slot |

```csharp
var assignments = new List<SlotAssignment>
{
    new SlotAssignment { SlotIndex = 1, RouteName = "RouteA" },
    new SlotAssignment { SlotIndex = 2, RouteName = "RouteB" },
    new SlotAssignment { SlotIndex = 3, RouteName = "RouteA" },
};
```

---

### SlotEntry Struct {#slotentry-struct}

An immutable view of a single slot's state within a `CarrierEntity`. Property names match the WPF `SlotCellTemplate` data-trigger bindings.

| Property | Type | Description |
|---|---|---|
| `IsPresent` | `bool` | `true` when the slot has a substrate in the carrier map |
| `IsReturned` | `bool` | `true` when the substrate has been returned after processing |
| `IsSelected` | `bool` | `true` when this slot is part of the currently active lot |
| `SlotNo` | `int` | 1-based slot number (1–25 for a standard FOUP) |
| `SubstrateId` | `string` | Substrate identity key (e.g. `"LP1#3"`); empty when `IsPresent` is `false` |

```csharp
// Typically obtained from CarrierEntity.GetSlots()
IReadOnlyList<SlotEntry> slots = carrier.GetSlots();

// Bind to WPF ItemsControl — each SlotEntry exposes the correct property names
slotListView.ItemsSource = slots;

// Or iterate manually
foreach (SlotEntry slot in slots)
{
    if (slot.IsPresent && !slot.IsReturned)
        Console.WriteLine($"Slot {slot.SlotNo}: {slot.SubstrateId} — in progress");
}
```

---

### SubstrateRoute {#substrateroute}

Provides read-only access to the route plan and step-completion progress for a single substrate. Obtained from `SubstrateEntity.GetRoute()`.

| Method | Returns | Description |
|---|---|---|
| `GetAll()` | `IEnumerable<RouteInfo>` | Route entry for this substrate, or an empty sequence if no route is registered |

```csharp
SubstrateRoute route = Port.GetEntity<SubstrateEntity>("Stage1").GetRoute();

foreach (RouteInfo info in route.GetAll())
{
    Console.WriteLine($"Route key: {info.Key}");
    Console.WriteLine($"Last completed step: {info.LastCompletedStep}");
    foreach (var step in info.Steps)
        Console.WriteLine($"  Step: {step.Name}");
}
```

---

## Thread Safety {#thread-safety}

All entity property setters are **thread-safe**:

| Mechanism | Used For |
|---|---|
| `System.Threading.Interlocked.Exchange` | All `int`-backed state fields (`TransferState`, `InServiceState`, etc.) |
| `Interlocked.Exchange` on `long` bit patterns | `double` fields (`ProcessValue`, `ProcessMax`) — safe on 32-bit runtimes |
| `volatile` on reference types | `string` fields (e.g. `_recipeName`) — guarantees cross-thread visibility |

You can safely read and write entity properties from multiple threads simultaneously without additional locking.

```csharp
// Safe to call from background threads, timer callbacks, or async handlers
Task.Run(() =>
{
    Port.GetEntity<ProcessModuleEntity>("Stage1")
        .SetProcessSeconds(elapsed)
        .SetState(ModuleProcessState.Executing);
});
```

:::warning Dictionary reads are not locked
`GetAllSlots()` and `GetSlots()` read from internal `Dictionary<int, SlotStates>` fields.
If you write to a `CarrierEntity` from one thread while iterating `GetAllSlots()` on another,
add your own synchronization around the iteration.
:::

---

## Common Patterns {#common-patterns}

### Conditional State Update

```csharp
var lp = Port.GetEntity<LoadModuleEntity>("LP1");

if (lp.TransferState == LoadPortTransferState.InService
    && lp.InServiceState == LoadPortInServiceState.ReadyToLoad)
{
    // Issue transfer command
}
```

### Monitoring Job Progress

```csharp
JobEntity job = Port.GetEntity<JobEntity>("TM1");

if (job.IsActive)
{
    int total     = job.SlotAssignments.Count;
    int completed = 0;

    foreach (RouteInfo info in job.GetAllRoute())
    {
        if (info.LastCompletedStep >= info.Steps.Length - 1)
            completed++;
    }

    Console.WriteLine($"Job {job.Name}: {completed}/{total} substrates complete");
    Console.WriteLine($"Completed cycles: {job.LotCompletedCount}");
}
```

### Carrier Slot Map Update

```csharp
// Typically called from the slot-map-received event handler
CarrierEntity carrier = Port.GetEntity<CarrierEntity>("LP1");

for (int slot = 1; slot <= carrier.SlotCount; slot++)
{
    SlotStates state = ReadSensorState(slot); // your hardware read
    carrier.SetSlot(slot, state);
}
```

### Checking Flow Before Transfer

```csharp
FlowEntity scheduler = Port.GetEntity<FlowEntity>("Scheduler");

if (!scheduler.IsRunning("Transfer"))
{
    Console.WriteLine("Scheduler is idle — safe to start new transfer");
}
else
{
    Console.WriteLine($"Transfer running at step: {scheduler.GetCurrentStep("Transfer")}");
}
```

---

*See also: [Scheduler](scheduler.md) for substrate transfer configuration, [Flow](flow.md) for flow step authoring, [Attribute Reference](attribute.md) for `[LMC]`, `[PMC]`, and `[TMC]` declarations.*
