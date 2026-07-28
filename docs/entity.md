# Entity Objects

## Table of Contents

- [Overview](#overview)
- [Retrieving Entities](#retrieving-entities)
- [Entity Classes](#entity-classes)
  - [LoadModuleEntity — Load Port (E87)](#loadmoduleentity)
  - [ProcessModuleEntity — Process Module (E39)](#processmoduleentity)
  - [TransferModuleEntity — Transfer Module & Robot Position](#transfermoduleentity)
  - [LocationEntity — Location & Slot Capacity](#locationentity)
  - [CarrierEntity — Carrier & Slot Map](#carrierentity)
  - [SubstrateEntity — Substrate State](#substrateentity)
  - [CarrierJob — Job Definition & Active Job](#carrierjob)
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
| `TransferModuleEntity` | — | Transfer (robot) state and current/target position |
| `LocationEntity` | — | Registered location and its slot capacity |
| `CarrierEntity` | E87 | Carrier identity and per-slot occupancy |
| `SubstrateEntity` | E90 | Substrate identity, reservation, and route |
| `FlowEntity` | — | Flow execution state of a named controller |
| `CEIDEntity` | E30 | Collection Event ID holder |

> **Module classes are generic `<P, C, T>`.** The module classes are `LoadModuleEntity<P, C, T>`,
> `ProcessModuleEntity<P, C, T>`, and `TransferModuleEntity<P, C, T>` — every module declares a
> user-defined parameter type `P` (`IParameter`), configuration type `C` (`IConfigure`), and a
> controller type `T` (`IController`) that owns the module's flows. When you **author your own
> module** you derive from the matching generic class, e.g.
> `class MyPmc : ProcessModuleEntity<MyParameter, MyConfigure, MyController>`.
>
> A custom module supplies its transfer scores by overriding **`GetSubstrateInScore(Location)`**
> (gates a robot Get from this location) and **`GetSubstrateOutScore(Location)`** (gates a robot
> Put to it). Return `≥1` = ready, `0` = not ready, `<0` = blocked. These replace the former
> `[TransferScore]` location methods; the transfer module now keeps only its own arm scores.
>
> Register a custom module **instance** with `Port.Equipment.Add(new MyPmc(...))`. There are two
> ways the module's flows are supplied:
>
> - **T owns the flows (recommended, DepoPMC-style).** Leave `ControllerKey` empty. The module's
>   `T` controller declares the `[Flow]` classes directly, and they are reflected into the engine
>   **under the module key** (e.g. flow `"Stage1.Process"`). Model bindings in the `[Model]` class
>   are keyed by the **module key** (`[EntryBinding("Stage1", …)]`). Per-instance subclasses
>   follow the `class Stage1Module : StageModule` (⊂ `DepoPMC1 : DepoPMC`) pattern, and there is
>   **no** separate `Port.Add<Controller>` registration.
> - **Separate controller (ControllerKey).** Set `ControllerKey` to the key of a `[Controller]`
>   registered separately via `Port.Add<MyController>(ctrlKey, model)`. `Port.Equipment.Add` then
>   wires the slot count, the controller↔module mapping, and process/load auto-start — the same
>   wiring the legacy `Port.Add<IProcessModuleEntity>(key, slot, ctrlKey)` overload performed. The
>   module's `T` flows are **not** re-reflected in this mode (they come from the separate controller).
>
> The `Port.Entity.*` accessors return the parameter-type-agnostic interfaces
> `ILoadModuleEntity` / `IProcessModuleEntity` / `ITransferModuleEntity` (all deriving from
> `IModuleEntity`), so you can read a module's state without knowing its `<P, C, T>` arguments —
> e.g. `Port.Entity.ProcessModule("Stage1").SetState(...)`. The engine's own default modules
> (registered via `Port.Add<IProcessModuleEntity>(key, …)`) are closed over the built-in
> `EmptyParameter`/`EmptyConfigure`/`IController` types. See
> [the attribute reference](attribute.md) for the custom-module authoring convention.

---

## Retrieving Entities {#retrieving-entities}

Use `Port.GetEntity<T>` to obtain an entity singleton. Pass the **location name** that matches the `[LMC]`, `[PMC]`, or `[TMC]` declaration in your Port document.

```csharp
// Load port entities (location = LMC name)
ILoadModuleEntity lp1    = Port.GetEntity<ILoadModuleEntity>("LP1");
CarrierEntity    carrier = Port.GetEntity<CarrierEntity>("LP1");

// Process module entities (location = PMC name)
IProcessModuleEntity stage1 = Port.GetEntity<IProcessModuleEntity>("Stage1");
SubstrateEntity     sub1   = Port.GetEntity<SubstrateEntity>("Stage1");

// Flow state per controller
FlowEntity flow = Port.GetEntity<FlowEntity>("Scheduler");
```

> The active job is **not** an entity — query it with `Port.Job.GetActiveJob("TM1")`. See [CarrierJob](#carrierjob).

```csharp
CarrierJob active = Port.Job.GetActiveJob("TM1");
```

:::tip Per-location Singleton
Calling `Port.GetEntity<ILoadModuleEntity>("LP1")` multiple times always returns the exact same C# object. You can safely cache the reference or call `Port.GetEntity` on every access — both patterns have the same cost after the first call.
:::

---

## Entity → Port Server Mirror {#entity-report-mirror}

Entity singletons are the source of truth for their state, but every state change is also
**mirrored to the port server** as report-only shared-memory entries, so the web UI's
register view displays live entity state without any `.page` declaration. Mirror entries
are registered at runtime when the service reaches the Synchronized state and re-registered
automatically after a server restart.

| Entity state | Mirrored entry | Written by |
|---|---|---|
| `LocationEntity.SlotCount` | `{loc}.SlotCount` | `Port.Add<T>(key, slotMaxCount, ...)` registration |
| Module state text (PMC/LMC/TMC) | `{loc}.ModuleState` | `SetState(...)` on the module entity |
| `TransferModuleEntity.CurrentLocation` | `{tm}.CurrentLocation` | `SetCurrentLocation(...)` |
| `TransferModuleEntity.TargetLocation` | `{tm}.TargetLocation` | `SetTargetLocation(...)` |
| `LoadModuleEntity.E87` (all six state machines) | `{lp}.E87TransferState`, `{lp}.E87InServiceState`, `{lp}.E87CarrierState`, `{lp}.E87CarrierIdStatus`, `{lp}.E87SlotMapStatus`, `{lp}.E87Phase` | every `E87` setter |
| `ProcessModuleEntity` recipe | `{pm}.RecipeName` | `SetRecipeName(...)` |
| Active `CarrierJob` | `{tm}.ActiveJobId`, `{tm}.ActiveJobSource` | `Port.Job.Execute(...)` / `Port.Job.ClearActiveJob(...)` |

Substrate presence, carrier slot contents, and transfer scores reach the web Module Layout
through the separate `PushModuleScore` channel. `ProcessValue`/`ProcessMax` are intentionally
**not** mirrored (per-tick update frequency); declare page entries for process progress as before.

:::warning Report-only
Never read or write mirror entries from application logic — they are display mirrors,
overwritten by the entity on every change. Read the entity instead.
:::

---

## Entity Classes {#entity-classes}

### LoadModuleEntity — Load Port (E87) {#loadmoduleentity}

Holds the five independent SEMI E87 state machines for a single load-port location.

```csharp
ILoadModuleEntity lp1 = Port.GetEntity<ILoadModuleEntity>("LP1");
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
var lp1 = Port.GetEntity<ILoadModuleEntity>("LP1");
Console.WriteLine(lp1.GetStateText());        // "ReadyToLoad"
Console.WriteLine(lp1.GetCarrierStateText()); // "NotAccessed"
Console.WriteLine(lp1.TransferState);         // LoadPortTransferState.InService
```

---

### ProcessModuleEntity — Process Module (E39) {#processmoduleentity}

Tracks the SEMI E39 process state and recipe-timer data for a single equipment module.

```csharp
IProcessModuleEntity stage1 = Port.GetEntity<IProcessModuleEntity>("Stage1");
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
| `SetPresent(bool)` | `void` | Places or removes the substrate at this location in `SubstrateTracker` (inherited from `ModuleEntity`) |
| `GetExists()` | `bool` | Returns `true` when a substrate is present at this location (inherited from `ModuleEntity`) |
| `TryGetSubstrate(out SubstrateEntity)` | `bool` | Returns the `SubstrateEntity` currently at this location (inherited from `ModuleEntity`) |
| `Process()` | `void` | Starts this module's registered primary `[Flow]` (the controller bound via `Port.Add<IProcessModuleEntity>(moduleKey, controllerKey)`) |

::::note Presence and process start are automatic during scheduled transfers
When the transfer scheduler completes a Put or Get at a location registered via
`Port.Add<IProcessModuleEntity>(moduleKey, controllerKey)`, it calls `SetPresent(true)` /
`SetPresent(false)` on that location's entity and auto-starts the process flow after a Put.
Call `SetPresent`/`Process()` manually only for substrates that move outside the scheduler
(e.g. manual load scenarios).
::::

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
IProcessModuleEntity stage = Port.GetEntity<IProcessModuleEntity>("Stage1");

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

### TransferModuleEntity — Transfer Module & Robot Position {#transfermoduleentity}

Holds the transfer (robot) state and current/target position for a transfer-module location.
Equipment classes subclass it and are registered via
`Port.Add<T>(moduleKey, slotMaxCount, controllerKey)` — the registered instance **is** the
entity singleton, so `Port.Entity.TransferModule("TM1")` returns the same object.

```csharp
ITransferModuleEntity tm1 = Port.Entity.TransferModule("TM1");
```

| Member | Type | Description |
|---|---|---|
| `State` | `TransferModuleState` | Current transfer state (`Idle`, `Moving`, `Picking`, `Placing`, ...) |
| `SetState(state)` | fluent | Atomically sets `State` and reports it to the module-state pipeline |
| `GetStateText()` | `string` | String form of `State` |
| `CurrentLocation` | `string` | Location the robot arm is currently at (empty until the first move) |
| `TargetLocation` | `string` | Location the robot arm is heading to for the pending Pick/Place |
| `SetCurrentLocation(loc)` | fluent | Atomically sets `CurrentLocation`; `null` clears it |
| `SetTargetLocation(loc)` | fluent | Atomically sets `TargetLocation`; `null` clears it |

```csharp
// Transfer request handler: record the destination before starting the robot flow
tm1.SetTargetLocation(args.Target.Name);

// Robot flow: mark arrival
tm1.SetCurrentLocation(tm1.TargetLocation);
```

:::info Replaces entry-based robot position
`CurrentLocation`/`TargetLocation` replace the app-level `"Robot.CurrentLocation"` /
`"Robot.TargetLocation"` page entries. The entity is the source of truth; every setter
call is also mirrored to the port server as the report-only entries
`{moduleKey}.CurrentLocation` / `{moduleKey}.TargetLocation` (e.g. `TM1.CurrentLocation`),
so the web UI keeps displaying the robot position. Never write these entries directly —
they are display mirrors.
:::

---

### LocationEntity — Location & Slot Capacity {#locationentity}

Describes a registered equipment location and its slot capacity. Seeded by the slot-count
`Port.Add` overload; the single source of truth for slot counts (the `CarrierEntity`
factory reads it to size the slot map).

```csharp
Port.Add<ILoadModuleEntity>("LP1", 25, "LP1Controller");

LocationEntity loc = Port.Entity.Location("LP1");
Console.WriteLine($"{loc.LocationKey}: {loc.SlotCount} slots");   // LP1: 25 slots
```

| Member | Type | Description |
|---|---|---|
| `LocationKey` | `string` | Location name (e.g. `"LP1"`, `"Stage1"`, `"TM1"`) |
| `SlotCount` | `int` | Slot capacity declared at registration |
| `ID` | `string` | Singleton cache key; equals `LocationKey` |

Both properties are immutable after construction, so reads are thread-safe.
Locations registered through overloads without a slot count default to 25 for load
ports and 1 for process/transfer modules.

The slot count is also mirrored to the port server as the report-only entry
`{locationKey}.SlotCount` (e.g. `LP1.SlotCount` = 25), so the web UI's register view
keeps displaying it. The mirror is registered at runtime when the service reaches the
Synchronized state — no `.page` declaration is needed.

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
    Console.WriteLine($"Key: {info.Key}, Progress: {info.Progress}");
}
```

---

### CarrierJob — Job Definition & Active Job {#carrierjob}

A **`CarrierJob`** is the single job currency for the scheduler. It is **not** an `IEntity` — it is a plain, mutable definition you build yourself and hand to the engine. It inherits `ConcurrentDictionary<int, List<RoutePoint>>`, so each 1-based slot number maps (via the indexer) to the ordered `RoutePoint` sequence its substrate travels (source LP → process stations → return LP).

:::info Replaces JobEntity
The former `JobEntity` singleton was removed. Job definitions are now `CarrierJob` objects; the active job per transfer module is tracked internally and read back with `Port.Job.GetActiveJob("TM1")`. Applications that persist job definitions keep their own DTO and convert it to a `CarrierJob` at execution time.
:::

#### Building a job

```csharp
var job = new CarrierJob("CARRIER01")      // ID is set once at construction (read-only)
{
    Location = new Location("LP1"),        // source load port
    Name     = "TestJob",                  // informational only
    RepeatCount = 0,                       // 0 = run once
};

job[1] = new List<RoutePoint>
{
    new SingleSlotRoute("LP1"),            // pick from source LP
    new ProcessRoute("Stage1", "Recipe_A"),// process at Stage1
    new SingleSlotRoute("LP1"),            // return to LP
};
```

#### Key members

| Member | Type | Description |
|---|---|---|
| `ID` | `readonly string` | Unique job identifier — set once via the constructor. Queue-registry key, and the substrate-key prefix (`"{ID}.{slot}"`) on the pipeline path |
| `Location` | `Location` | Source load port; `Port.Job.Execute` resolves the target LMC from `Location.ID` |
| `Name` | `string` | Human-readable job name (informational; shown in the active-job display) |
| `RepeatCount` | `int` | Cycles the full sequence repeats (`0` = run once) |
| `CompletedCycles` | `int` | Cycles completed so far for the active run (reset on activation) |
| `LotID` | `string` | Legacy per-slot `Scheduler` path only — substrate-key prefix and `ExecuteLotID` key |
| `Mode` | `TransferMode` | Reserved; not read by current execution paths (the scheduler rule is set via `SetRule`) |
| `this[int slot]` | `List<RoutePoint>` | Indexer — the route for a slot |

#### Running & querying via `Port.Job`

| Method | Returns | Description |
|---|---|---|
| `Port.Job.Queued(CarrierJob job)` | `bool` | Registers the job in the queue under its `ID` (does not start it) |
| `Port.Job.Execute(string jobID, int repeatCount = 0)` | `bool` | Starts a queued job; resolves the load port from `Location`, converts slot routes to scheduler recipes, and begins execution. `repeatCount` overrides `RepeatCount` when > 0 |
| `Port.Job.Execute(CarrierJob job)` | `bool` | One-call register + start when the carrier `ID` is already docked |
| `Port.Job.GetActiveJob(string moduleKey)` | `CarrierJob` | The active job on that transfer module, or `null` |
| `Port.Job.ClearActiveJob(string moduleKey)` | `void` | Clears the active job (e.g. after a manual cancel) |
| `Port.Job.GetAllRoutes()` | `IEnumerable<RouteInfo>` | Snapshot of every substrate route and its step progress |

#### Example

```csharp
// Queue and start (run the sequence twice)
Port.Job.Queued(job);
Port.Job.Execute(job.ID, 2);

// Read the active job on TM1
CarrierJob active = Port.Job.GetActiveJob("TM1");
if (active == null)
{
    Console.WriteLine("No active job.");
    return;
}

Console.WriteLine($"Job: {active.Name} (ID: {active.ID})");
Console.WriteLine($"Source: {active.Location?.ID}");
Console.WriteLine($"Slots: {active.Count}");
Console.WriteLine($"Completed cycles: {active.CompletedCycles} / {active.RepeatCount}");

// Print route progress for all substrates (no active-job reference needed)
foreach (RouteInfo info in Port.Job.GetAllRoutes())
    Console.WriteLine($"  [{info.Key}] progress: {info.Progress}");

// Clear when done / cancelled
Port.Job.ClearActiveJob("TM1");
```

:::tip Refresh on progress, don't poll
Subscribe to `Port.OnSubstrateUpdated` to refresh route displays only when progress actually advances, instead of calling `Port.Job.GetAllRoutes()` every tick.
:::

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

:::warning Application-level type
`SlotAssignment` (slot number → saved route **name**) is no longer defined by the library. A `CarrierJob` maps slots directly to resolved `RoutePoint` lists through its indexer, so persistence formats that store route *names* per slot are an application concern. Build the runtime job by assigning route lists to slots:

```csharp
var job = new CarrierJob("JOB01") { Location = new Location("LP1") };
job[1] = new List<RoutePoint> { new SingleSlotRoute("LP1"), new ProcessRoute("Stage1", "Recipe_A"), new SingleSlotRoute("LP1") };
job[2] = new List<RoutePoint> { new SingleSlotRoute("LP1"), new ProcessRoute("Stage2", "Recipe_B"), new SingleSlotRoute("LP1") };
```
:::

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
    Console.WriteLine($"Last completed step: {info.Progress}");
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
    Port.GetEntity<IProcessModuleEntity>("Stage1")
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
var lp = Port.GetEntity<ILoadModuleEntity>("LP1");

if (lp.TransferState == LoadPortTransferState.InService
    && lp.InServiceState == LoadPortInServiceState.ReadyToLoad)
{
    // Issue transfer command
}
```

### Monitoring Job Progress

```csharp
CarrierJob job = Port.Job.GetActiveJob("TM1");

if (job != null)
{
    int total     = job.Count;
    int completed = 0;

    foreach (RouteInfo info in Port.Job.GetAllRoutes())
    {
        if (info.Progress >= info.Steps.Length - 1)
            completed++;
    }

    Console.WriteLine($"Job {job.Name}: {completed}/{total} substrates complete");
    Console.WriteLine($"Completed cycles: {job.CompletedCycles} / {job.RepeatCount}");
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
