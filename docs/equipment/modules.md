# Modules

The previous article introduced the pieces of the Equipment model. This article covers the
foundation: defining module classes and registering them with `Port.Equipment.Add`.

A **module** is any object that implements `IModule` — the engine only requires a unique
`Key`. In practice you derive from one of the three generic module bases, which add state
tracking, flow hosting, and scheduler integration on top of the key.

---

## The three module kinds {#module-kinds}

Every module base takes three type arguments — `ModuleEntity<P, C, T>`:

- **`P : IParameter`** — a user-defined runtime parameter object.
- **`C : IConfigure`** — a user-defined configuration object.
- **`T : IController`** — the controller type that owns the module's `[Flow]` classes.

`P` and `C` are mandatory by design: even when a module needs no data yet, you declare
empty marker classes so the types exist when you do need them.

```csharp
public class StageParameter : IParameter { }
public class StageConfigure : IConfigure { }
```

Each kind's constructor declares the module key plus the **flow names** the engine drives:

| Kind | Base class | Constructor | Reserved flow key |
|---|---|---|---|
| Load port (E87) | `LoadModuleEntity<P,C,T>` | `(key, loadFlowKey, unloadFlowKey, mappingFlowKey)` | `Reserved.LoadModule.FLOW_KEY_LOAD` |
| | | | `Reserved.LoadModule.FLOW_KEY_UNLOAD` |
| | | | `Reserved.LoadModule.FLOW_KEY_MAPPING` |
| Process module (E39) | `ProcessModuleEntity<P,C,T>` | `(key, processFlowKey)` | `Reserved.ProcessModule.FLOW_KEY_PROCESS` |
| Transfer module (robot) | `TransferModuleEntity<P,C,T>` | `(location, pickFlowKey, placeFlowKey)` | `Reserved.ArmRobot.FLOW_KEY_PICK` |
| | | | `Reserved.ArmRobot.FLOW_KEY_PLACE` |

Using the reserved keys lets the scheduler locate each flow automatically.

---

## Defining a process module {#process-module}

A process module declares its flow key and overrides the two transfer scores that gate the
robot at its location (covered in depth in [Transfer and scheduling](transfer.md)):

```csharp
public abstract class StageModule
    : ProcessModuleEntity<StageParameter, StageConfigure, StageController>
{
    protected StageModule(string key)
        : base(key, Reserved.ProcessModule.FLOW_KEY_PROCESS)
    {
        SlotCount = 1;
    }

    public override double GetSubstrateInScore(Portdic.Module.Location location)
    {
        var entity = Port.Entity.ProcessModule(Location);
        if (!entity.GetExists()) return 0;
        bool ready = entity.State is ModuleProcessState.Completed or ModuleProcessState.Idle;
        return ready ? 1 : -1;
    }

    public override double GetSubstrateOutScore(Portdic.Module.Location location)
        => !Port.Entity.ProcessModule(Location).GetExists() ? 1 : -1;
}
```

When the equipment has several identical modules, add one thin subclass per instance so
each has a distinct type (the `DepoPMC1 : DepoPMC` pattern):

```csharp
public class StageModule1 : StageModule { public StageModule1(string key) : base(key) { } }
public class StageModule2 : StageModule { public StageModule2(string key) : base(key) { } }
```

---

## Defining a load module {#load-module}

A load module passes the three load-port flow keys and typically sets `SlotCount` to the
carrier capacity:

```csharp
public abstract class LPModule
    : LoadModuleEntity<LPParameter, LPConfigure, LPController>
{
    protected LPModule(string key)
        : base(key,
               Reserved.LoadModule.FLOW_KEY_LOAD,
               Reserved.LoadModule.FLOW_KEY_UNLOAD,
               Reserved.LoadModule.FLOW_KEY_MAPPING)
    {
        SlotCount = 25;
    }

    public override double GetSubstrateInScore(Portdic.Module.Location location)
        => (Port.Get($"{Location}.LP_Status")?.ToString() ?? "") == "Loaded" ? 1 : 0;

    public override double GetSubstrateOutScore(Portdic.Module.Location location)
        => (Port.Get($"{Location}.LP_Status")?.ToString() ?? "") == "Loaded" ? 1 : 0;
}
```

Load modules expose the SEMI E87 state machines through their `E87` property — see
[Entity Objects](../entity) for the full state model.

---

## Registering modules {#registering}

Create the instance and hand it to the engine:

```csharp
Port.Equipment.Add(new StageModule1(ModuleKey.Stage1));
Port.Equipment.Add(new LPModule1(ModuleKey.LP1));
```

`Port.Equipment.Add(IModule)` performs, in order:

1. Registers the module in the module collection under its `Key`.
2. Records its kind (`LMC` / `PMC` / `TMC`) and publishes it to the web UI's module list,
   including a `ModuleState` report entry.
3. Pushes every flow the module hosts as `"{Key}.{FlowName}"`.
4. Reflects the controller `T`'s `[Flow]` classes into the flow engine under the module key
   (skipped when `ControllerKey` is set — see below).
5. Wires the transfer scheduler: load and process modules become scored locations; a
   transfer module becomes the scheduler's bound robot.
6. If `ControllerKey` is non-empty, registers the location with `SlotCount` slots and binds
   the module to its separately-registered controller.

---

## Two wiring patterns {#wiring-patterns}

There are two ways a module gets its flows:

**T owns the flows (recommended).** Leave `ControllerKey` empty. The `T` controller's
`[Flow]` classes are reflected under the module key, so three `StageModule` instances
sharing `StageController` each run their own `"StageN.Process"` flow. No separate
`Port.Add<StageController>` call exists.

**Separate controller (`ControllerKey`).** Register the controller first with
`Port.Add<MyController>(ctrlKey, model)`, then point the module at it:

```csharp
public class AlignerModule
    : ProcessModuleEntity<AlignerParameter, AlignerConfigure, AlignerController>
{
    public AlignerModule(string location, string controllerKey)
        : base(location, string.Empty)
    {
        ControllerKey = controllerKey;
        SlotCount = 1;
    }
    // ... scores ...
}

Port.Add<AlignerController>(CtrlKey.Aligner, new AlignerModel());
Port.Equipment.Add(new AlignerModule(ModuleKey.Aligner, CtrlKey.Aligner));
```

In this mode the flows come from the separate controller registration; the module supplies
the location, slot count, and transfer scores.

---

## Reading module state {#reading-state}

You rarely keep your own reference to a module instance. The `Port.Entity.*` accessors
return kind interfaces (`ILoadModuleEntity`, `IProcessModuleEntity`,
`ITransferModuleEntity`) for any registered key, without knowing its `<P, C, T>` arguments:

```csharp
var state  = Port.Entity.ProcessModule("Stage1").State;
var phase  = Port.Entity.LoadModule("LP1").E87.Phase;
var target = Port.Entity.TransferModule("TM1").TargetLocation;
```

---

The next article shows how the controller `T` defines the flows a module runs:
[Controllers and flows](flows.md).
