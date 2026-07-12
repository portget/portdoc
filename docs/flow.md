# Flow

## Overview

PortDIC provides a **step-based workflow engine** through the `[Controller]` / `[Flow]` / `[FlowStep]` attribute system. Instead of writing state machines or polling loops, you declare the sequence of steps as methods in a nested class — the framework discovers them at startup, injects the handler, and drives execution step by step.

Key characteristics:
- Declarative step sequencing — no manual state tracking
- Conditional waiting via `[FlowWatcherCompare]` (the runtime polls live memory values)
- Per-step timeouts with `[Timeout]`
- SECS/GEM Collection Event integration per step
- Typed model binding — steps receive strongly-typed equipment data
- CACD pattern (`IFlowCACD<T>`) for standardized equipment operations

---

## Quick Setup

### 1. Define a controller with a flow

```csharp
using Portdic;

[Controller]
public class LoadPortController
{
    [AppHandler]
    public IAppHandler App { get; set; }

    [Preset]
    public void Preset()
    {
        App.OnFlowFinished += (e) =>
            Console.WriteLine($"[Flow] {e.FlowName} finished");
    }

    [Flow("Load")]
    public class LoadFlow
    {
        [Handler]
        public IModelFlowHandler<LoadPortModel> Handler { get; set; }

        [FlowStep(0)]
        [FlowWatcherCompare("lp1.MainAir", ">=", 0)]
        [Timeout(1000, "LP1", 2000)]
        public void StatusCheck(LoadPortModel m)
        {
            Handler.Next();
        }

        [FlowStep(1)]
        public void SendLoadCommand(LoadPortModel m)
        {
            // act on m.SomeEntry …
            Handler.Next();
        }

        [FlowStep(2)]
        public void Done(LoadPortModel m)
        {
            Handler.Done();   // use Done() on the last step
        }
    }
}
```

### 2. Register and run

```csharp
Port.Add<LoadPortController, LoadPortModel>("LP1");
Port.Run();
```

### 3. Trigger a flow

```csharp
// Set the flow entry to Executing
Port.Set("LP1.Load", FlowAction.Executing);
```

---

## Page → Model → Flow Binding

Flows receive equipment data through a **typed Model** — a C# class that maps live in-memory Entry values to named properties. This is the bridge between your `.page` data definitions and the step logic.

```text
.page file  (Entry definitions)
    ↓  Port.Push
Port in-memory DB  (live Entry values)
    ↕  [ModelBinding]
Model  (C# property ↔ Entry key)
    ↕  method parameter `m`
Flow step  (business logic)
```

### 1. Define Entries in a Page

Entries the flow will read or write must be registered before `Port.Run()`.

**`.page` file** (one entry per line — key, type, optional attributes):

```text
LP1_MainAir   f8             property:{"unit":"bar"}
LP1_Status    enum.LPStatus
LP2_MainAir   f8             property:{"unit":"bar"}
LP2_Status    enum.LPStatus
```

**Push at startup** so the entries exist in the in-memory DB:

```csharp
Port.Push("sample", ioDoc.NewPage("lp"));  // from a document converter
Port.Push("sample", new LpPage());          // from a [Page]-decorated class
```

> See [Quick Start](quick) for the full Page → Push/Pull workflow.

### 2. Define a Model

Decorate a class with `[Model]` and link each property to its Entry via `[ModelBinding]`:

```csharp
[Model]
public class LoadPortModel
{
    [ModelBinding("LP1", Io.LP1_MainAir)]
    [ModelBinding("LP2", Io.LP2_MainAir)]
    public Entry MainAir { get; set; }

    [ModelBinding("LP1", Io.LP1_Status)]
    [ModelBinding("LP2", Io.LP2_Status)]
    public Entry Status { get; set; }
}
```

`[ModelBinding(instanceKey, entryKey)]`:

| Argument | Role |
|----------|------|
| `instanceKey` | Matches the key passed to `Port.Add<T, M>(key)` — e.g. `"LP1"` |
| `entryKey` | Fully-qualified Entry key string — e.g. `Io.LP1_MainAir` = `"lp.LP1_MainAir"` |

Stacking multiple `[ModelBinding]` on the same property lets one Model class serve multiple instances (LP1, LP2, …). The framework selects the binding that matches the active instance key at runtime.

### 3. Read and Write Inside Steps

The Model instance arrives as method parameter `m` in every Flow step:

```csharp
[FlowStep(0)]
public void CheckMainAir(LoadPortModel m)
{
    double air = (double)m.MainAir.Value;   // read from in-memory DB
    if (air >= 1.0)
        Handler.Next();
    // if the condition is not met here, pair with [FlowWatcherCompare] to wait
}

[FlowStep(1)]
public void SetOnline(LoadPortModel m)
{
    m.Status.Set("Online");   // write to DB; fires any pkg: binding automatically
    Handler.Next();
}

[FlowStep(2)]
public void Complete(LoadPortModel m)
{
    Console.WriteLine($"Air={m.MainAir.Value}, Status={m.Status.Value}");
    Handler.Done();
}
```

| API | Direction | Description |
|-----|-----------|-------------|
| `m.Prop.Value` | Read | Current entry value as `object`; cast to `double`, `string`, etc. |
| `m.Prop.Get()` | Read | Current entry value as `EntryValue` (comparable with `string`/`double`) |
| `m.Prop.Set(v)` | Write | Writes `v` to the in-memory DB and triggers any bound `pkg:` callback |
| `m.Prop == "text"` / `!=` | Read | Shorthand for `m.Prop.Get() == "text"` — reads the live value and compares it as a string |

:::note Parameterless steps
A step's model parameter is optional. When the `[Handler]` property is a typed handler
(`IModelFlowHandler<T>`, `IModuleFlowHandler<...>`, or `ITransferFlowHandler<...>`), a step
can be declared **without** the `m` parameter and read the model from the handler instead —
`Handler.Model` (or `Handler.GetModel()` on the 3-type handlers). The instance is identical to
the one passed as a parameter, so `void CheckStatus()` with `var m = Handler.Model;` and
`void CheckStatus(MyModel m)` are equivalent.

```csharp
[FlowStep(0)]
public void CheckStatus()
{
    MyModel m = Handler.Model;   // same singleton the parameter would receive
    m.Status.Set("Loading");
    Handler.Next();
}
```
:::

### 4. Multi-instance Registration

The same Controller + Model pair can be registered under multiple instance keys:

```csharp
Port.Add<LoadPortController, LoadPortModel>("LP1");
Port.Add<LoadPortController, LoadPortModel>("LP2");
Port.Run();
```

Each instance runs an independent flow execution. `[ModelBinding]` resolves the correct Entry per instance key automatically. Triggering one instance has no effect on the other:

```csharp
Port.Set("LP1.Load", FlowAction.Executing);   // LP1 runs Load independently
Port.Set("LP2.Load", FlowAction.Executing);   // LP2 runs Load independently
```

---

## FlowStep Patterns

### Sequential index

The simplest form — steps execute in ascending index order.

```csharp
[FlowStep(0)]
public void Initialize(MyModel m) { Handler.Next(); }

[FlowStep(1)]
public void Process(MyModel m) { Handler.Next(); }

[FlowStep(2)]
public void Finish(MyModel m) { Handler.Done(); }
```

### Predecessor by name

When order is defined by step name rather than a fixed index:

```csharp
[FlowStep(0)]
public void Start(MyModel m) { Handler.Next(); }

[FlowStep("Start")]          // runs after Start
public void Validate(MyModel m) { Handler.Next(); }

[FlowStep("Validate")]       // runs after Validate
public void Complete(MyModel m) { Handler.Done(); }
```

### With SECS/GEM Collection Event

Fires a CEID when the step executes — for host-visible event reporting:

```csharp
[FlowStep(2, (ushort)CeidList.ProcessComplete, "Result", "Status")]
public void Finish(MyModel m) { Handler.Done(); }
```

| Overload | Description |
|----------|-------------|
| `[FlowStep(index)]` | Sequential by index |
| `[FlowStep(index, entry…)]` | Sequential + logically related entries |
| `[FlowStep("prevName")]` | Named predecessor dependency |
| `[FlowStep(index, ceid, entry…)]` | Sequential + SECS/GEM CEID |

---

## FlowStep Modifiers

Step modifiers are attributes applied to `[FlowStep]` methods (or to the `[Flow]` class) that add timing, measurement, or scheduling behaviour without changing the step logic.

### `[FlowDelay]` — physical settle time

`[FlowDelay(ms)]` prevents the step body from running until at least `ms` milliseconds have elapsed since the step was entered. Use it wherever the physical equipment needs time to respond to a command issued in the previous step.

```csharp
// Step 0 signals the gate to close, then advances immediately.
[FlowStep(0)]
public void CloseGate(StageModel m)
{
    m.Gate_Open_o.Set("Off");
    Handler.Next();
}

// Step 1 body is suppressed for 3 s — gate settle time — then StartProcess runs.
[FlowStep(1), FlowDelay(3000)]
public void StartProcess(StageModel m)
{
    m.Start_o.Set("On");
    m.WaferPresent_i.Set("On");
    Handler.Next();
}
```

The delay fires once per step entry. If `Handler.Next()` is not called inside the body (polling loop), the delay does not restart between polls.

### `[RecordTime]` — elapsed-time measurement

`[RecordTime(category, fullKey)]` tells the framework to write elapsed milliseconds to a Port entry on every poll tick while the step is active. Attach one attribute per controller instance; only the attribute whose `category` matches the running controller fires.

Reset the timer by writing `0.0` to the entry in the previous step:

```csharp
[FlowStep(1)]
public void StartProcess(StageModel m)
{
    m.ProcessTimer.Set(0.0);   // reset → RecordTime starts fresh next tick
    Handler.Next();
}

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

### `[TransferBlockWhenExecutingFlow]` — logistics guard

Applied to the `[Flow]` **class** (not a method). While the flow is Executing, `Port.IsTransferBlocked(tmName, location)` returns `true` and the scheduler's `isSkip()` skips any transfer targeting this location. The block releases automatically when `Handler.Done()` is called.

```csharp
[Flow(Flows.Stage_Process), TransferBlockWhenExecutingFlow("TM1")]
public class StageProcessFlow { ... }
```

See [`[TransferBlockWhenExecutingFlow]`](attribute#transferblockwhenexecutingflow) in the attribute reference for full details and the Aligner pattern.

---

## Conditional Waiting — `[FlowWatcherCompare]`

Holds the step until the live memory condition is satisfied. Multiple attributes default to **AND**; set `OR: true` for OR logic.

```csharp
// Single condition
[FlowStep(0)]
[FlowWatcherCompare("room1.Temp1", ">=", 50)]
public void WaitForTemp(MyModel m) { Handler.Next(); }

// AND conditions
[FlowStep(1)]
[FlowWatcherCompare("room1.Temp1", ">=", 50)]
[FlowWatcherCompare("room1.Pressure", "<=", 100)]
public void WaitForBoth(MyModel m) { Handler.Next(); }

// OR condition
[FlowStep(2)]
[FlowWatcherCompare("room1.Status", "==", "Ready")]
[FlowWatcherCompare("room1.Override", "==", "On", OR: true)]
public void WaitForReady(MyModel m) { Handler.Next(); }
```

Per-controller conditions (when LP1 and LP2 share the same flow class):

```csharp
[FlowStep(0)]
[FlowWatcherCompare("LP1", "lp1.MainAir", ">=", 0)]
[FlowWatcherCompare("LP2", "lp2.MainAir", ">=", 0)]
[Timeout(1000, "LP1", 2000)]
[Timeout(1000, "LP2", 2001)]
public void StatusCheck(LoadPortModel m) { Handler.Next(); }
```

**Supported operators**: `==`, `!=`, `>=`, `<=`, `>`, `<`

---

## CACD Pattern

`IFlowCACD<T>` defines the standard 4-step equipment operation lifecycle. Implement the interface to get pre-wired `[FlowStep]` indices automatically.

```csharp
[Flow("Pick")]
public class PickFlow : IFlowCACD<RobotModel>
{
    [Handler]
    public IModelFlowHandler<RobotModel> Handler { get; set; }

    public void CheckStatus(RobotModel m) { Handler.Next(); }   // Step 0
    public void Action(RobotModel m)      { Handler.Next(); }   // Step 1 (after CheckStatus)
    public void CheckAction(RobotModel m) { Handler.Next(); }   // Step 2 (after Action)
    public void Done(RobotModel m)        { Handler.Done(); }   // Step 3 (after CheckAction)
}
```

| Method | Implicit FlowStep | Description |
|--------|-------------------|-------------|
| `CheckStatus` | `[FlowStep(0)]` | Verify equipment state before acting |
| `Action` | `[FlowStep("CheckStatus")]` | Perform the main operation |
| `CheckAction` | `[FlowStep("Action")]` | Validate action result |
| `Done` | `[FlowStep("CheckAction")]` | Finalize and signal completion |

---

## Jump Control — `IFlowControl`

For non-linear branching within a flow:

```csharp
[Flow("Process")]
public class ProcessFlow
{
    [Handler]
    public IFlowHandler Handler { get; set; }

    [FlowControl]
    public IFlowControl FlowControl { get; set; }

    [FlowStep(0)]
    public void Validate(MyModel m)
    {
        if (dataIsInvalid)
            FlowControl.JumpStep(99);   // jump to error step
        else
            Handler.Next();
    }

    [FlowStep(1)]
    public void Process(MyModel m) { Handler.Done(); }

    [FlowStep(99)]
    public void HandleError(MyModel m) { Handler.Done(); }
}
```

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[Controller]` | Class | Marks as a flow controller; registered via `Port.Add<T, M>(name)` |
| `[Flow("key")]` | Nested class | Declares a named workflow inside a controller |
| `[FlowStep(…)]` | Method | Declares a step; see overloads above |
| `[Handler]` | Property | Injects `IFlowHandler`, `IModelFlowHandler<T>` (shorthand: `IFlowHandler<T>`), `IModuleFlowHandler<TModule,TSubstrate,TModel>`, or `ITransferFlowHandler<TTransfer,TSubstrate,TModel>`. `[FlowHandler]` is an interchangeable alias |
| `[FlowControl]` | Property | Injects `IFlowControl` for `JumpStep()` access |
| `[AppHandler]` | Property | Injects the global `IAppHandler` (for `OnFlowFinished`) |
| `[Preset]` | Method | Called once after injection; use for event subscription |
| `[FlowWatcherCompare(…)]` | Method | Conditional hold before step executes |
| `[Timeout(ms, controller, alid)]` | Method | Raises alarm if step takes longer than `ms` milliseconds |

### `IFlowHandler` methods

| Method | Description |
|--------|-------------|
| `Next()` | Advance to the next step in sequence |
| `Done()` | Complete the flow synchronously; sets state to Idle before returning |
| `Move(stepName)` | Jump to a named step |
| `OccurredAlarm(alid)` | Raise alarm by ALID |
| `ClearAlarm(alid = -9999)` | Clear alarm (`-9999` clears all) |
| `Alert(msg)` | Send an alert message from the current step |
| `SetLogger(rootPath)` | Enable hourly-rotated log files under `rootPath` |
| `WriteLog(message)` | Write a log entry (requires `SetLogger` first) |
| `WriteLog(message, rule)` | Write with `WriteRule` flags (console, trace, dedup) |
| `Stopwatch` | Built-in per-flow stopwatch for timing step phases: `Start()`/`Restart()` begin timing from zero, `TotalMilliseconds` reads the elapsed time on later step invocations |

### `IModelFlowHandler<T>` (extends `IFlowHandler`)

`IFlowHandler<T>` is an identical shorthand — declare the `[Handler]` property as either
type to receive the same injected instance.

| Member | Description |
|--------|-------------|
| `Model` | Typed model instance; entries are auto-bound via `[ModelBinding]` |
| `OnFlowOccurred` | Fired when the flow starts executing |
| `OnFlowFinished` | Fired when the flow completes successfully |
| `OnFlowIssue` | Fired when the flow is stopped, canceled, or encounters an error |

### `IModuleFlowHandler<TModule, TSubstrate, TModel>` (extends `IFlowHandler`)

Resolves the runtime objects bound to the flow before execution, so steps can access the
module, substrate, and model without `Port.Entity` lookups. Type constraints:
`TModule : ModuleEntity`, `TSubstrate : SubstrateEntity`, `TModel : ModelEntity`.

```csharp
[FlowHandler]
public IModuleFlowHandler<ModuleEntity, SubstrateEntity, StageModel> Handler { get; set; }
```

| Method | Description |
|--------|-------------|
| `GetModule()` | Module entity registered for the flow's location (e.g. the `ProcessModuleEntity` for `"Stage1"`); `null` when the location has no registered module or it is not a `TModule` |
| `GetSubstrate()` | Substrate currently present at the flow's location; `null` when the location is empty |
| `GetModel()` | Typed model singleton bound to the flow — the same instance passed to `[FlowStep]` methods as a parameter |

### `ITransferFlowHandler<TTransfer, TSubstrate, TModel>` (extends `IFlowHandler`)

For transfer-module (robot) Pick/Place flows. The scheduler assigns the transfer context
**before** each Pick/Place flow is requested, so every step can read which locations and
substrate the current action involves. Type constraints: `TTransfer : TransferEntity`,
`TSubstrate : SubstrateEntity`, `TModel : ModelEntity`.

```csharp
[Handler]
public ITransferFlowHandler<TransferEntity, SubstrateEntity, RobotModel> Handler { get; set; }
```

| Method | Description |
|--------|-------------|
| `GetTransfer()` | Active `TransferEntity` — `Source` (pick origin) and `Target` (location of the current action) as `Location` values, plus `SubstrateID` |
| `GetSubstrate()` | Substrate involved in the active transfer, resolved by its substrate key |
| `GetModel()` | Typed model singleton bound to the flow — the same instance passed to `[FlowStep]` methods as a parameter |
| `GetTargetName()` | Location name the robot is acting on (shorthand for `GetTransfer().Target.Key`) |
| `GetSourceName()` | Location name the substrate was picked from (shorthand for `GetTransfer().Source.Key`) |

During a Pick (Get), `Source` equals `Target` — the location the substrate is picked from.
During a Place (Put), `Source` is the arm's recorded pick origin and `Target` is the
destination, so a Place step can tell where the substrate came from.

### `FlowAction` enum

| Value | Description |
|-------|-------------|
| `Idle` | Flow is idle, not executing |
| `Initialization` | Flow is in initialization state |
| `Executing` | Flow is actively running steps |
| `Stopped` | Flow was manually stopped |
| `Canceled` | Flow was canceled before completion |
| `Issue` | Flow terminated due to an unhandled exception |

### `IFlowControl`

| Method | Description |
|--------|-------------|
| `JumpStep(index)` | Skip to the step with the given index |

### `IAppHandler` (global)

| Event | Signature | Description |
|-------|-----------|-------------|
| `OnFlowFinished` | `FlowFinishedHandler` | Fires when any flow in the application finishes |

---

## Events

### Per-flow `OnFlowFinished`

```csharp
[Preset]
public void Preset()
{
    Handler.OnFlowFinished += (model, args) =>
    {
        Console.WriteLine($"Flow finished: step={args.LastStep}, elapsed={args.Elapsed}ms");
    };
}
```

### Global `OnFlowFinished` (via `IAppHandler`)

```csharp
[AppHandler]
public IAppHandler App { get; set; }

[Preset]
public void Preset()
{
    App.OnFlowFinished += (e) =>
        Console.WriteLine($"[Global] {e.FlowName} finished");
}
```

---

## Logging

```csharp
[Preset]
public void Preset()
{
    Handler.SetLogger(@"C:\Logs\Equipment");
    // Creates: C:\Logs\Equipment\flow_Load_20250425_14.log
}

[FlowStep(1)]
public void Process(MyModel m)
{
    Handler.WriteLog("Processing started");
    Handler.WriteLog("Retry attempt", WriteRule.WithConsole | WriteRule.NoDuplicate);
    Handler.Next();
}
```

| `WriteRule` flag | Description |
|-----------------|-------------|
| `None` | File log only (default) |
| `WithConsole` | Also print to console |
| `WithTrace` | Also write to `Trace` listeners |
| `NoDuplicate` | Suppress consecutive duplicate messages |

---

## Project Timeline Tracking

Every flow run is reported to the port server automatically and rendered on the
web frontend's **Project Timeline** (Gantt) view — no user code required.

- Each run gets a unique `TaskID`; the timeline groups all steps of a run under it.
- Each step produces an `Occurred` event when it starts executing and a `Finished`
  event when the flow advances past it (`Next()`, `MoveToStep`, `Done()`), so every
  step appears as one bar with its real start/end times.
- If a flow stops abnormally (Stopped / Canceled / Failed), the interrupted step
  stays open and the timeline marks it with a missing-Finished warning.
- The timeline shows one **fixed row per registered flow** and one bar per run with
  its recorded start/end. Events are stored per day in the server database, so any
  past date can be reviewed with the day navigation. View resolution ranges from
  1 hour down to **1 second**, and clicking a run bar opens a detail panel with
  per-step start/end times and durations.

Reporting is enabled by default. To turn it off (e.g. for high-frequency test
loops):

```csharp
FlowTracker.Enabled = false;
```

---

## Related

- [attribute](attribute) — Full attribute reference (`[Package]`, `[ModelBinding]`, `[Binding]`, etc.)
- [SchedulerHandler](scheduler) — Substrate transfer scheduler built on top of flows
- [SECS/GEM](secs) — Collection Event integration (`[FlowStep(index, ceid)]`)
