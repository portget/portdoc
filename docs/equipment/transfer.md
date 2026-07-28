# Transfer and Scheduling

So far the tour has defined stationary modules and their flows. This article adds movement:
the transfer module (robot), the scores that gate every pick and place, and how the
built-in dual-arm scheduler uses them.

---

## The transfer module {#transfer-module}

The transfer module is a `TransferModuleEntity<P, C, T>` subclass whose constructor names
its pick and place flow keys. Its `T` controller owns the `Pick` / `Place` flows the
scheduler drives (`Reserved.ArmRobot.FLOW_KEY_PICK` / `FLOW_KEY_PLACE`):

```csharp
public class EqFiveStageTransferModule
    : TransferModuleEntity<EqFiveStageTransferParameter,
                           EqFiveStageTransferConfigure,
                           RobotController>
{
    public EqFiveStageTransferModule(string location)
        : base(location, "Pick", "Place") { }

    // Arm scores: the transfer module scores only its own arms.
    [TransferScore("Upper", Direction.In)]  public int InUpper()  => 1;
    [TransferScore("Upper", Direction.Out)] public int OutUpper() => 1;
    [TransferScore("Lower", Direction.In)]  public int InLower()  => 1;
    [TransferScore("Lower", Direction.Out)] public int OutLower() => 1;
}
```

Register it with the module key, the **number of arms**, and its controller key:

```csharp
Port.Add<RobotController>(CtrlKey.Robot, new RobotModel());
Port.Add<EqFiveStageTransferModule>(ModuleKey.TM1, 2, CtrlKey.Robot);
```

This binds the module to the scheduler: the scheduler drives `"TM1.Pick"` / `"TM1.Place"`
directly and resolves each transfer when the flow completes.

---

## Transfer scores {#scores}

Every candidate move is gated by two score sources:

- **Location scores** — each load/process module's `GetSubstrateInScore(Location)` and
  `GetSubstrateOutScore(Location)` overrides (see [Modules](modules.md)).
- **Arm scores** — the transfer module's `[TransferScore(armName, Direction)]` methods.

Score values share one convention:

| Value | Meaning |
|---|---|
| `>= 1` | Ready — the move may proceed |
| `0` | Not ready — keep waiting |
| `< 0` | Blocked |

> **Direction is about the substrate, not the module.** For a *location*, `Direction.In` is
> evaluated for a **Get** (robot picks the substrate up *from* the location) and
> `Direction.Out` for a **Put** (robot places *to* it). For an *arm* the convention
> inverts: `Direction.In` gates a Put onto the arm, `Direction.Out` a Get off it.

A typical Get gate combines "gate open", "substrate present", "module finished", and
"substrate actually processed":

```csharp
public override double GetSubstrateInScore(Portdic.Module.Location location)
{
    if (!GateOpen(Location)) return -1;
    var entity = Port.Entity.ProcessModule(Location);
    if (!entity.GetExists()) return 0;
    bool ready = entity.State is ModuleProcessState.Completed or ModuleProcessState.Idle;
    return ready && Processed(Location) ? 1 : -1;
}
```

---

## How the scheduler uses scores {#scheduler}

1. The scheduler picks the next step (a Get or Put at a location, on a specific arm) from
   route topology alone — scores play no part in *choosing* the step.
2. It then polls the step's arm score and location score every ~50 ms until **both are
   `>= 1`**, and only then executes the transfer.

Because readiness is verified immediately before execution, scores are a *live gate*, not a
one-shot check — do not re-validate scores inside transfer event handlers. If conditions
change, simply return `0` (wait) or a negative value (block) from the score method; the
poll loop handles the rest.

On completion the engine also keeps process-module bookkeeping for you:

- **Put** at a process-module location → substrate marked present, and the module's primary
  flow is auto-started (duplicate starts are guarded).
- **Get** → substrate marked absent.

For carrier-level job routing (which substrate goes where, in what order), see the
[Scheduler](../scheduler) reference; for E87/E90 state details, see
[Entity Objects](../entity).

---

The final article covers the layer that makes all of this runnable without hardware:
[Devices, simulation, and state](simulation.md).
