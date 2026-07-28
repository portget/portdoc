# Controllers and Flows

The previous article defined module classes. This article covers the `T` type argument: the
**controller** that owns a module's flows, the `[Flow]` classes themselves, and the models
they operate on.

---

## The controller {#controller}

A controller is a `[Controller]`-decorated class implementing the `IController` marker.
It contains one nested `[Flow]` class per named flow:

```csharp
[Controller]
public class StageController : IController
{
    [Flow(Reserved.ProcessModule.FLOW_KEY_PROCESS)]
    public class StageProcessFlow : Flow<StageParameter, StageConfigure, StageModel>
    {
        // steps ...
    }
}
```

Because `StageController` is the `T` of `StageModule` (see [Modules](modules.md)),
`Port.Equipment.Add(new StageModule1("Stage1"))` reflects `StageProcessFlow` into the
engine as the flow `"Stage1.Process"`. Five stage modules sharing one controller type get
five independent flow instances, one per module key.

---

## The Flow base class {#flow-base}

A `[Flow]` class inherits `Flow<P, C, M>` — the module's parameter type, configure type,
and the flow's model type. The base class carries an engine-injected `Handler` and typed
convenience accessors, so the flow needs no `[FlowHandler]` declaration of its own:

| Member | Type | Meaning |
|---|---|---|
| `Handler` | `IControllerHandler<M>` | Step control: `Next()`, `Done()`, `Move(n)`, alarms, logging |
| `Model` | `M` | The model instance bound to this flow |
| `Parameter` | `P` | The owning module's parameter object |
| `Configure` | `C` | The owning module's configuration object |
| `Module` | `ModuleEntity` | The module entity registered at this flow's location |
| `Substrate` | `SubstrateEntity` | The substrate currently at this location, or `null` |

---

## Steps {#steps}

Flow bodies are ordinary methods decorated with `[FlowStep(n)]`, executed in index order.
Each step advances explicitly with `Handler.Next()` and the last step finishes with
`Handler.Done()`. A condensed version of the EqFiveStage stage flow:

```csharp
[Flow(Reserved.ProcessModule.FLOW_KEY_PROCESS)]
public class StageProcessFlow : Flow<StageParameter, StageConfigure, StageModel>
{
    private string StageName => Port.GetModuleKey(Handler.GetControllerName());

    [CheckPoint]
    public bool CheckOpenGate() => Handler.Model.Gate_Open_o == "Off";

    [FlowStep(0), SettingUp]
    public void CheckStatus()
    {
        Handler.Model.Gate_Open_o.Set("Off");
        Handler.Next();
    }

    [FlowStep(1), Executing]
    public void StartProcess() => Handler.Next();

    [FlowStep(2), Completed]
    public void OpenGateForPickup()
    {
        Port.Entity.ProcessModule(StageName).SetState(ModuleProcessState.Completed);
        Handler.Model.Gate_Close_o.Set("Off");
        Handler.Next();
    }

    [FlowStep(3), FlowDelay(3000), Idle]
    public void Finish()
    {
        Handler.Model.Gate_Open_o.Set("On");
        Handler.Done();
    }
}
```

Attributes used alongside `[FlowStep]`:

- **`[CheckPoint]`** — a boolean precondition evaluated before the flow starts.
- **`[SettingUp]` / `[Executing]` / `[Completed]` / `[Idle]`** — set the module's
  `ModuleProcessState` when the step runs.
- **`[FlowDelay(ms)]`** — delays the step.
- **`[FlowWatcher(entryKey)]`** — surfaces the entry's value in the web UI's flow and
  timeline views (see the [Flow](../flow) reference).

---

## Models {#models}

The `M` type argument is a model class whose properties bind to Port entries. Bindings are
declared **per module key**, so one model class serves every module that shares the
controller — the engine creates a separate instance per module and wires the right entries:

```csharp
public class StageModel : ModelEntity
{
    // Device injection: pick the device whose module key matches this instance.
    [PackageBinding("Stage1", "Stage1Device")]
    [PackageBinding("Stage2", "Stage2Device")]
    public StageDevice? Device { set; get; }

    // Entry binding: this instance's Gate_Open_o follows its own stage.
    [EntryBinding("Stage1", Stage1.Gate_Open_o)]
    [EntryBinding("Stage2", Stage2.Gate_Open_o)]
    public Entry Gate_Open_o { get; set; }
}
```

Inside a flow, `Handler.Model` (or the `Model` shortcut) is the instance for the current
module: reading `Model.Gate_Open_o` on the `"Stage2.Process"` flow reads
`Stage2.Gate_Open_o`.

> With the **T-owned** wiring pattern, `[EntryBinding]` keys are **module keys**
> (`"Stage1"`). With the **separate-controller** pattern they are controller keys.

---

## Starting a flow {#starting}

A module flow is addressed as `"{ModuleKey}.{FlowName}"` and started through `Port.Set`:

```csharp
Port.Set("Stage1", Reserved.ProcessModule.FLOW_KEY_PROCESS, FlowAction.Executing);
```

You usually don't call this yourself for process modules: when the scheduler completes a
Put at a process-module location, the engine sets the substrate present and auto-starts the
module's primary flow (guarded against duplicate starts). Load-module flows run when the
carrier actions (Load / Unload / Mapping) are requested, and transfer flows are driven by
the scheduler — the subject of the next article.

---

Continue with [Transfer and scheduling](transfer.md).
