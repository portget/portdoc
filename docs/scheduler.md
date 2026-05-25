# Scheduler

## Overview

PortDIC provides a **substrate transfer scheduler** (`ISchedulerHandler<T>`) for semiconductor equipment that automates robot arm movement between locations (Load Ports, Process Chambers, Transfer Modules). It implements a pipeline dual-arm scheduling algorithm with shortest-path routing and SEMI E90-aligned substrate state tracking.

`ISchedulerHandler<T>` is generic over the arm-action args type — use `DualArmActionArgs` for dual-arm robots or `SingleArmActionArgs` for single-arm robots.

Key characteristics:
- Pipeline scheduling — overlaps pick/place operations for higher throughput
- shortest-path routing between named locations
- Dual-arm exchange (simultaneous get + put at the same station)
- SEMI E90 substrate state model (`AtSource` → `InTransfer` → `AtDestination` → …)
- 30-second per-step transfer timeout with cancellation support
- Singleton — one `ISchedulerHandler<T>` instance shared across all `[Controller]` classes

---

## Quick Setup

### 1. Define locations and arms

```csharp
using Portdic;

[Controller]
public class TransferController
{
    [TransferHandler]
    public ISchedulerHandler<DualArmActionArgs> Scheduler { get; set; }

    [Preset]
    public void Preset()
    {
        Scheduler.SetLogger(@"C:\Logs\Equipment");
        Scheduler.OnRequestTransferAction  += OnTransferRequest;
        Scheduler.OnTransferActionCompleted += OnTransferDone;
    }

    // Score: return -1 if unavailable, >= 0 if available (higher = higher priority)
    [Location("LP1", Direction.Out)]
    public int LP1() => lpReady ? 0 : -1;

    [Location("Stage1", Direction.In)]
    public int Stage1() => stageReady ? 0 : -1;

    [Location("Stage2", Direction.In)]
    public int Stage2() => stage2Ready ? 0 : -1;

    [Arm("Upper", Direction.Unknown)]
    public int UpperArm() => upperBusy ? 1 : -1;

    [Arm("Lower", Direction.Unknown)]
    public int LowerArm() => lowerBusy ? 1 : -1;

    private void OnTransferRequest(DualArmActionArgs args)
    {
        // Equipment performs the physical action
        Console.WriteLine($"[{args.TXID}] {args.Actiontype} → {args.Target} ({args.SubstrateKey})");
        // After completion, signal back:
        Scheduler.TransferCompleted(new Entry { Value = args.Target });
    }

    private void OnTransferDone(DualArmActionArgs args)
    {
        Console.WriteLine($"[{args.TXID}] Done: {args.Actiontype} at {args.Target}");
    }
}
```

### 2. Register and run

```csharp
Port.Add<TransferController, TransferModel>("Transfer");
Port.Run();
```

### 3. Register a lot and execute

```csharp
// Define substrates with routing: LP1 → Stage1 → Stage2 → LP1
var substrates = new[]
{
    new Substrate("W1", new SingleSlotRoute("LP1"), new ProcessRoute("Stage1", "Recipe_A"), new SingleSlotRoute("LP1")),
    new Substrate("W2", new SingleSlotRoute("LP1"), new ProcessRoute("Stage1", "Recipe_A"), new SingleSlotRoute("LP1")),
};

Scheduler.Register("JOB-001", substrates);
Scheduler.Execute("JOB-001");

// Poll completion
while (!Scheduler.IsCompleted("JOB-001"))
    await Task.Delay(500);

Console.WriteLine("JOB-001 transfer complete");
```

---

## Substrate Routing

Each `Substrate` is constructed with an ordered list of `Route` objects describing where it must travel.

### Route types

| Type | Description |
|------|-------------|
| `SingleSlotRoute(location)` | Single-slot destination (e.g., Load Port, output buffer) |
| `MultiSlotRoute(location, slotNo)` | Specific slot in a multi-slot location (e.g., LP cassette slot 3) |
| `ProcessRoute(location, recipe…)` | Processing station — triggers recipe via `Port.Set` when reached |
| `MultiSlotProcessRoute(location, recipe…)` | Combines slot selection with recipe execution |

```csharp
// Simple route: LP1 → Stage1 → back to LP1
new Substrate("W1",
    new SingleSlotRoute("LP1"),
    new ProcessRoute("Stage1", "Recipe_A"),
    new SingleSlotRoute("LP1"));

// Multi-slot: cassette slot 3 → process → cassette slot 3
new Substrate("W3",
    new MultiSlotRoute("LP1", 3),
    new ProcessRoute("Stage1", "Recipe_A"),
    new MultiSlotRoute("LP1", 3));
```

---

## Transfer Completion

After the physical robot completes an action, call `TransferCompleted` to unblock the scheduler:

```csharp
// Using Entry (value is the location name)
Scheduler.TransferCompleted(locationEntry);

// Using location name directly
Scheduler.TransferCompleted("Stage1");
```

The scheduler waits up to **30 seconds** per step. If `TransferCompleted` is not called within that window, a timeout exception is raised and the lot execution stops.

---

## API Reference

### `ISchedulerHandler<T>` methods

| Method | Returns | Description |
|--------|---------|-------------|
| `Register(lotid, substrates…)` | `bool` | Register a lot with its substrate list for scheduling |
| `Execute(lotid)` | `bool` | Start (or restart) transfer execution for the given lot |
| `IsCompleted(lotid)` | `bool` | `true` when all steps for the lot have finished |
| `TransferCompleted(location)` | — | Signal that the equipment completed the current transfer step |
| `SetLogger(rootPath)` | — | Enable file logging under `{rootPath}\Scheduler\` |

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[TransferHandler]` | Property | Injects the `ISchedulerHandler<T>` singleton |
| `[Location(name, direction)]` | Method | Declares a named transfer location; return value = availability score |
| `[Arm(name, direction)]` | Method | Declares a robot arm; return value = availability score (-1 = free) |

### Action Args (`T` type parameter)

`ISchedulerHandler<T>` is generic over the arm-action args type. Choose `T` based on your robot configuration:

| `T` | Robot type |
|-----|------------|
| `DualArmActionArgs` | Dual-arm robot (upper + lower blade) |
| `SingleArmActionArgs` | Single-arm robot (one blade) |

Both implement `IArmActionArgs`. Fields passed to `OnRequestTransferAction` and `OnTransferActionCompleted`:

| Field | Type | Description |
|-------|------|-------------|
| `TXID` | `string` | Unique transaction ID for this transfer step |
| `Actiontype` | `DualArmActionType` / `SingleArmActionType` | The action to perform |
| `Target` | `string` | Location name where the action occurs |
| `SubstrateKey` | `string` | Key of the substrate being transferred |

### `DualArmActionType` enum

| Value | Description |
|-------|-------------|
| `Move` | Robot arm moves to a location (no pick/place) |
| `UpperGet` | Upper arm picks up a substrate |
| `UpperPut` | Upper arm places a substrate |
| `LowerGet` | Lower arm picks up a substrate |
| `LowerPut` | Lower arm places a substrate |

### `SingleArmActionType` enum

| Value | Description |
|-------|-------------|
| `Move` | Robot arm moves to a location |
| `Get` | Arm picks up a substrate |
| `Put` | Arm places a substrate |

### `Direction` enum

| Value | Description |
|-------|-------------|
| `Unknown` | Direction not determined (typical for arms) |
| `In` | Substrate moves into the location (pick) |
| `Out` | Substrate moves out of the location (place) |

---

## SEMI E90 Substrate States

`SubstrateStatus` tracks each substrate through the SEMI E90 state model:

```text
None → AtSource → Queued → Selected → InTransfer → AtDestination
                                                         │
                                                  NeedsProcessing → InProcess → Processed → Completed
                                                         │                                        │
                                                      Rejected                                    │
                                                                                                  ▼
                                              Any state → Aborted / Lost / Stopped / Skipped
```

| Status | Description |
|--------|-------------|
| `None` | Not yet registered |
| `AtSource` | At source location, awaiting scheduling |
| `Queued` | Enqueued by the scheduler |
| `Selected` | Selected for the next transfer |
| `InTransfer` | Currently being transported |
| `AtDestination` | Arrived at destination |
| `NeedsProcessing` | At a process station, awaiting recipe |
| `InProcess` | Recipe executing |
| `Processed` | Processing complete |
| `Completed` | All route steps done |
| `Rejected` | Rejected during processing |
| `Aborted` | Transfer aborted by operator or system |
| `Lost` | Location unknown |
| `Stopped` | Paused, may be resumed |
| `Skipped` | Intentionally skipped in the sequence |

---

## Events

### `OnRequestTransferAction`

Raised when the scheduler needs the equipment to perform a transfer step. The handler **must** call `Scheduler.TransferCompleted(…)` when the physical action is complete.

```csharp
Scheduler.OnRequestTransferAction += (DualArmActionArgs args) =>
{
    switch (args.Actiontype)
    {
        case DualArmActionType.UpperGet:
            Robot.Pick("Upper", args.Target);
            break;
        case DualArmActionType.UpperPut:
            Robot.Place("Upper", args.Target);
            break;
        case DualArmActionType.Move:
            Robot.MoveTo(args.Target);
            Scheduler.TransferCompleted(args.Target);  // Move steps complete immediately
            break;
    }
};
```

### `OnTransferActionCompleted`

Raised after the scheduler acknowledges that a transfer step is complete (after `TransferCompleted` is called).

```csharp
Scheduler.OnTransferActionCompleted += (DualArmActionArgs args) =>
{
    Console.WriteLine($"[{args.TXID}] Completed: {args.Actiontype} at {args.Target}");
};
```

---

## Logging

```csharp
[Preset]
public void Preset()
{
    Scheduler.SetLogger(@"C:\Logs\Equipment");
    // Creates: C:\Logs\Equipment\Scheduler\
}
```

Log files are created and rotated by the Rust backend. Entries include TXID, action type, target location, and timestamps.

---

## Related

- [Flow Handler](flow) — Step-based workflow engine used to implement individual transfer actions
- [attribute](attribute) — Full attribute reference (`[Controller]`, `[Preset]`, `[ModelBinding]`, etc.)
- [SECS/GEM](secs) — SEMI E90 substrate state integration
