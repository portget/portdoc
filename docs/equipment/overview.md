# A Tour of the Equipment Model

Port's Equipment model lets you describe a complete piece of factory equipment — its load
ports, process modules, transfer robot, devices, and simulation — as a small set of C#
classes registered through `Port.Equipment.Add`. The engine then runs the flows, drives the
transfer scheduler, tracks substrates, and mirrors everything to the web UI and GEM.

This tour walks through the model in the order you build it, one article per concept. Each
article builds on the previous one, with runnable snippets taken from the `EqFiveStage`
reference application.

---

## The pieces {#the-pieces}

| Concept | Type | You write | The engine provides |
|---|---|---|---|
| **Module** | `LoadModuleEntity<P,C,T>` | A subclass per module kind with transfer scores | Registration, state tracking, scheduler wiring |
| | `ProcessModuleEntity<P,C,T>` | | |
| | `TransferModuleEntity<P,C,T>` | | |
| **Parameter / Configure** | `IParameter` / `IConfigure` | Two (possibly empty) data classes per module | Typed access from every flow |
| **Controller** | `T : IController` | A class that owns the module's `[Flow]` classes | Flow reflection under the module key |
| **Flow** | `Flow<P, C, M>` | `[FlowStep]` methods | Step execution, an injected `Handler`, state attributes |
| **Model** | `ModelEntity` | Properties bound with `[EntryBinding]` / `[PackageBinding]` | Per-module instance with live entry values |
| **Device** | `IDevice` | A device class (e.g. TCP) registered by key | Lookup and model injection |
| **Simulation** | `[Simulation]` class | `[SetTrigger]` / `[GetTrigger]` methods | Auto-invocation while in Simulation mode |

### Generic type parameters {#generic-type-parameters}

The generic classes above share three type parameters. Every module class closes
`ModuleEntity<P, C, T>`; you define all three types yourself:

| Type parameter | Constraint | Meaning |
|---|---|---|
| `P` | `IParameter` | The module's runtime **parameter** object — values that vary while the equipment runs (setpoints, counters). Exposed to every flow as `Parameter`. |
| `C` | `IConfigure` | The module's **configuration** object — settings fixed at setup time. Exposed to every flow as `Configure`. |
| `T` | `IController` | The **controller** class that owns the module's `[Flow]` classes. Its flows are reflected into the engine under the module key. |

`P` and `C` are mandatory by design: even a module with no data yet declares empty marker
classes (`class OvenParameter : IParameter { }`), so the types already exist when data is
added later.

> **The third letter differs on the flow side.** A `[Flow]` class closes `Flow<P, C, M>`
> with the **same `P` and `C` as its module**, but there the third argument `M` is the
> flow's *model* type (a `ModelEntity` subclass with `[EntryBinding]` properties), not the
> controller `T`. See [Controllers and flows](flows.md).

---

## Hello, Module {#hello-module}

The smallest complete module is a process module: a parameter type, a configure type, a
controller with one flow, and the module class itself.

```csharp
using Portdic;
using portdic.Equipment;

public class OvenParameter : IParameter { }
public class OvenConfigure : IConfigure { }

[Controller]
public class OvenController : IController
{
    [Flow(Reserved.ProcessModule.FLOW_KEY_PROCESS)]
    public class ProcessFlow : Flow<OvenParameter, OvenConfigure, OvenModel>
    {
        [FlowStep(0), Executing]
        public void Bake() => Handler.Next();

        [FlowStep(1), Completed]
        public void Done() => Handler.Done();
    }
}

public class OvenModule : ProcessModuleEntity<OvenParameter, OvenConfigure, OvenController>
{
    public OvenModule(string key)
        : base(key, Reserved.ProcessModule.FLOW_KEY_PROCESS) { }

    // Transfer scores gate the robot: ≥1 ready, 0 not ready, <0 blocked.
    public override double GetSubstrateInScore(Portdic.Module.Location location)
        => GetExists() ? 1 : 0;   // Get (pick up) allowed when a substrate is present
    public override double GetSubstrateOutScore(Portdic.Module.Location location)
        => GetExists() ? -1 : 1;  // Put (place) allowed when empty
}
```

One registration call wires everything:

```csharp
Port.Equipment.Add(new OvenModule("Oven1"));
```

`Port.Equipment.Add` registers the module by its key, reflects the controller's flows into
the engine as `"Oven1.Process"`, marks `"Oven1"` as a process-module location for the
transfer scheduler, and publishes the module to the web UI's Module Layout.

---

## Registration order {#registration-order}

A real application registers its pieces in this order (from `EqFiveStage`'s main window),
then starts the engine:

```csharp
// 1. Data pages and packages
Port.Add<Page.LP1D>("LP1");

// 2. Devices — second argument is the communication endpoint
//    (serial COM port for LPDevice, "host:port" TCP address for StageDevice)
Port.Equipment.Add(new LPDevice("LP1Device", "COM27"));
Port.Equipment.Add(new StageDevice("Stage1Device", "192.168.100.101:9000"));

// 3. Separately-registered controllers (only for the ControllerKey pattern)
Port.Add<AlignerController>(CtrlKey.Aligner, new AlignerModel());
Port.Add<RobotController>(CtrlKey.Robot, new RobotModel());

// 4. Module entities
Port.Equipment.Add(new LPModule1(ModuleKey.LP1));
Port.Equipment.Add(new StageModule1(ModuleKey.Stage1));
Port.Equipment.Add(new AlignerModule(ModuleKey.Aligner, CtrlKey.Aligner));

// 5. The transfer module (robot) — slot count = number of arms
Port.Add<EqFiveStageTransferModule>(ModuleKey.TM1, 2, CtrlKey.Robot);

// 6. Simulation
Port.Add<Simulation>("Simulation1");

Port.Run();
```

> When a module carries a `ControllerKey` (step 3/4, Aligner above), the controller must be
> registered **before** the module so the key resolves.

---

## Tour map {#tour-map}

1. **[Modules](modules.md)** — define `LoadModuleEntity`, `ProcessModuleEntity`, and
   `TransferModuleEntity` subclasses, choose parameter/configure types, and register them.
2. **[Controllers and flows](flows.md)** — author the `[Flow]` classes that a module's
   controller owns, use the injected `Handler`, and bind models to entries and devices.
3. **[Transfer and scheduling](transfer.md)** — supply transfer scores and let the dual-arm
   scheduler move substrates between your modules.
4. **[Devices, simulation, and state](simulation.md)** — register devices, mirror hardware
   behavior with `[Simulation]` triggers, and scope them with the state machine.

Continue with [Modules](modules.md).
