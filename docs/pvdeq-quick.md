# Sample Walkthrough: PVDEq (Module Framework)

**PVDEq** is a second sample app in the same family as [EqFiveStage](./eqfivestage-quick),
but it's built with a different, higher-level part of Port: the **Module framework**
(`LMC` / `PMC` / `TMC` base classes) instead of hand-written `[Controller]` +
`[Flow]` classes.

Read this page after [EqFiveStage](./eqfivestage-quick) — it assumes you already know
what a Page, Model, Controller, and Flow are. The goal here is to explain *when* and
*why* you'd reach for the Module framework instead, and how its pieces fit together.

---

## 1. What PVDEq simulates

PVDEq models a much bigger tool: an 8-chamber PVD (Physical Vapor Deposition) cluster
tool with:

- **LP1 / LP2** — two loading ports (real serial-port hardware drivers, `SinfLoadPortDevice`)
- **PMC1 – PMC8** — eight deposition process chambers, each with its own TCP-connected
  deposition controller and a Y-axis motor
- **TM1** — a single transfer robot moving substrates between load ports and chambers
- A WinForms UI with a chamber-status page (`OC1Control`, `OC2Control`, `OC3Control`)
  and a manual source→target transfer picker

Where EqFiveStage is a clean teaching example, PVDEq is closer to what a real
production-tool codebase looks like: real vendor hardware drivers (MKS, VAT, Lambda,
Solvix, Azbil, Horiba, Nova, Mitsubishi, and more live under `Device/`), and the
higher-level Module classes that most fab-equipment software actually uses.

> **Heads up:** PVDEq ships as a **skeleton**, not a finished working tool. Several
> methods you'll see (`CanProcess`, `CanTransfer`) currently `throw
> NotImplementedException` or `return false`, and some flow steps are just
> placeholder `Console.Write` calls. That's intentional — it's meant to be filled in,
> and reading it is the fastest way to learn the Module framework's shape before you
> write your own.

---

## 2. Why a "Module framework" on top of Controller/Flow?

In EqFiveStage, *you* write the state machine by hand: every `[FlowStep]`, every
`[FlowWatcherCompare]` condition, from scratch, for every station type.

Real fab equipment stations almost always fall into one of three well-known SEMI
roles, each with a state machine that's basically the same across every tool that has
one:

| Role | Base class | SEMI concept it implements |
|---|---|---|
| A port that carriers load into / unload from | `LMC` (Load Module Controller) | SEMI E87 carrier / load-port state model |
| A chamber that runs a recipe on a substrate | `PMC` (Process Module Controller) | SEMI E90/E39 process-module state model |
| A robot that moves substrates between modules | `TMC` (Transfer Module Controller) | Transfer/robot state model |

`LMC`, `PMC`, and `TMC` are abstract base classes in the `portdic` library that already
implement that shared state machine — the sequencing, the SEMI state properties, the
substrate-presence bookkeeping. You subclass one of them and fill in only the parts
that are specific to *your* hardware: what "load a carrier" actually does on your load
port, what "run the recipe" actually does in your chamber.

---

## 3. The three base classes, at a glance

All three follow the same shape: register your steps in the constructor with an
`AddXxxFlow(() => { ...; return FlowStepResult.SomeValue; })` call per step, and
override a `CanXxx(...)` guard method.

Every module also **must** declare a user-defined parameter type (`IParameter`) and a
configuration type (`IConfigure`) — the generic module bases
`ProcessModuleEntity<P, C>`, `LoadModuleEntity<P, C>`, and `TransferModuleEntity<P, C>`
enforce this. Define one small class each (they can start empty) and pass them as the
type arguments, as shown below.

### `PMC` — Process Module Controller

```csharp
public class DepoParameter : IParameter { }
public class DepoConfigure : IConfigure { }

public abstract class DepoPMC : ProcessModuleEntity<DepoParameter, DepoConfigure>
{
    public DepoPMC(string key) : base(key)
    {
        AddProcessFlow(() => { /* step 1 */ return FlowStepResult.End; });
        AddProcessFlow(() => { /* step 2 */ return FlowStepResult.End; });
        // ...
    }

    public abstract override bool CanProcess(string recipe);
}
```

Triggered by `Port.Set("{key}.Process", FlowAction.Executing)`. `PMC` also gives you
ready-made accessors so you don't have to define your own Entries for common
process-module state: `SetState(ModuleProcessState)`, `GetState()`,
`SetProcessSeconds(double)` / `SetProcessMax(double)` (for a progress bar),
`SetRecipeName(string)`, `TryGetSubstrate(out …)`, `SetPresent(bool)`, and more —
all delegate to an internal `ProcessModuleEntity` so you can call them directly on
`this`.

### `LMC` — Load Module Controller

```csharp
public class SinfParameter : IParameter { }
public class SinfConfigure : IConfigure { }

public abstract class SinfLMC : LoadModuleEntity<SinfParameter, SinfConfigure>
{
    public SinfLMC(string key, string loadportDevice) : base(key)
    {
        AddLoadFlow(()   => FlowStepResult.WaitForEnd);
        AddLoadFlow(()   => { Flow.Delay(2000); return FlowStepResult.WaitForEnd; });
        AddLoadFlow(()   => FlowStepResult.WaitForEnd);

        AddUnloadFlow(() => FlowStepResult.WaitForEnd);
        AddUnloadFlow(() => FlowStepResult.WaitForEnd);
        AddUnloadFlow(() => FlowStepResult.WaitForEnd);
    }

    public override bool CanLoad()    => true;
    public override bool CanUnload()  => true;
    public override bool CanMapping() => true;
}
```

Three separate step sequences — `AddLoadFlow`, `AddUnloadFlow`, `AddMappingFlow` —
cover the three things a load port does: load a carrier, unload a carrier, and map
(scan) which slots are occupied. Exposes the SEMI E87 state (`E87` property) plus
carrier-state setters (`SetCarrierState`, `SetSlotMapStatus`, `SetCarrierIdStatus`, …).

### `TMC` — Transfer Module Controller

```csharp
public class TMC1Parameter : IParameter { }
public class TMC1Configure : IConfigure { }

public class TMC1 : TransferModuleEntity<TMC1Parameter, TMC1Configure>
{
    public TMC1(string key, string transferDevice) : base(key, transferDevice)
    {
        AddTransferFlow(() => { Console.Write("Hello1"); return FlowStepResult.End; });
        AddTransferFlow(() => { Console.Write("Hello2"); return FlowStepResult.End; });
    }

    public override bool CanTransfer(Location source, Location target) => false;
}
```

Triggered by `Port.Set("{key}.Transfer", FlowAction.Executing, source, target)` where
`source`/`target` are `Location` values. `CanTransfer` is your guard — return `true`
once your real logic can decide whether that source→target move is currently legal.

### `FlowStepResult` — what your step tells the framework to do next

Every step function you register returns one of these:

| Value | Meaning |
|---|---|
| `End` | This step is done — advance to the next step immediately |
| `WaitForEnd` | Pause here — the framework will **not** advance until something else (a sensor changing, a timer, an external call) triggers the next check |
| `Alarm` | Something went wrong — raise a fault instead of advancing |
| `Unknown` | Default/unset value — don't return this from real code |

**This is the single most important thing to understand before you touch PVDEq's
flow bodies.** `WaitForEnd` is *not* an error and it's not "the app is frozen" — it
means "this step is intentionally parked, waiting for a real-world condition." A
`SinfLMC` load step returning `WaitForEnd` after opening a door, for example, would
stay parked until a door-open sensor Entry confirms the door actually opened — you
write that check inside the same step function (or a `GetTrigger`/`.rule` watches it
and calls back in).

---

## 4. Devices — the layer *below* Modules

Modules contain process/business logic; **Devices** talk to physical hardware and know
nothing about Modules, Flows, or recipes. A Module holds a reference to a Device (by
key) and calls plain methods on it from inside its flow steps.

```csharp
public class DepositionDevice : TCPDevice
{
    public DepositionDevice(string key, string address) : base(key, address) { }

    public string QueryStatus()                 => SendCommand("STATUS?");
    public void   SetPower(int watts)            => SendCommand($"POWER:{watts}");
    public void   SetFlow(int channel, float sccm) => SendCommand($"FLOW:{channel}:{sccm:F1}");
    public void   Start()                        => SendCommand("START");
    public void   Stop()                         => SendCommand("STOP");
}
```

Digital I/O is modeled the same way at an even lower level — an `IOAddressMap`
subclass declares `DI`/`DO`/`AI`/`AO` fields (one per physical channel), and the owning
`IODevice` wires them up automatically:

```csharp
public class DI  // Digital Input channel
{
    public DI(int slave, int index, int length = 1) { /* ... */ }
    public bool Flag  { get; }   // current boolean state
    public uint Num   { get; }   // raw bit value
}
```

Motion hardware implements `IAxisDevice` (`MoveAbs`, `MoveRef`), and robots implement
their own transfer-device interface (`Load`, `Unload`, `Mapping`, `Home`). PVDEq has
one concrete Device subclass per real vendor part it talks to — that's why
`Device/` has folders for MKS, VAT, Lambda, Solvix, Azbil, Horiba, Nova, Mitsubishi,
and more.

---

## 5. Wiring it all up in `FormMain`

Order matters here just like `MainWindow` in EqFiveStage, but with one extra layer:
**Devices first, then Modules that reference them by key.**

```csharp
[Portdic("EqFiveStage")]
public partial class FormMain : Form
{
    public FormMain()
    {
        InitializeComponent();
        Port.App<FormMain>(this, () => { /* ready callback */ });

        // 1. Devices — talk to real hardware
        Port.Add(new CrvIODevice("MAINIO", "192.168.100.1", new MAIN()));
        Port.Add(new SinfLoadPortDevice("LP1Device", "COM27"));
        Port.Add(new DepositionDevice("DepoDevice1", "192.168.70.100"));
        Port.Add(new YskMotorDevice("YMotor1", "COM31"));
        Port.Add(new TransferRobotDevice("WTR", "COM30"));
        // ... one Add call per physical device ...

        // 2. Modules — business logic, referencing devices by key string
        Port.Add(new TMC1("TM1", "WTR"));
        Port.Add(new DepoPMC1("PMC1", "DepoDevice1", "YMotor1"));
        Port.Add(new SinfLMC1("LP1", "LP1Device"));
        // ... one Add call per chamber/port/robot ...

        // 3. Optional: log completed operations
        Port.OnPMCProcessCompleted  += (_, e) => Console.WriteLine($"[PMC Process] {e.ModuleName} ...");
        Port.OnTMCTransferCompleted += (_, e) => Console.WriteLine($"[TMC Transfer] {e.ModuleName} ...");

        // 4. Kick off work
        var job = new CarrierJob("LOT01") { Location = new Location("LP1") };
        job[1] = new List<RoutePoint> { new SingleSlotRoute("LP1"), new ProcessRoute("PMC1"), new SingleSlotRoute("LP1") };
        Port.Job.Queued(job);
        Port.Job.Execute(job.ID);
    }

    private void BtnTransfer_Click(object sender, EventArgs e)
    {
        var source = new Location("LP1")  { TeachingPoint = "LP1" };
        var target = new Location("PMC1") { TeachingPoint = "PMC1" };
        Port.Set("TM1.Transfer", FlowAction.Executing, source, target);
    }
}
```

Notice a device is referenced purely by the string key you gave it in `Port.Add` — a
`DepoPMC1("PMC1", "DepoDevice1", "YMotor1")` doesn't hold a C# reference to the device
object, it looks it up by name. Register the device **before** the module that needs
it, in the same order they appear above.

---

## 6. Filling in a stub yourself

This is the exercise that makes the framework click. Take one of PVDEq's
`NotImplementedException` stubs and make it real:

```csharp
public class DepoPMC1 : DepoPMC
{
    public DepoPMC1(string key, string depoDevice, string t_motor) : base(key)
    {
        // stash the device keys so CanProcess / flow steps can reach the real hardware
    }

    public override bool CanProcess(string recipe)
    {
        // was: throw new NotImplementedException();
        return recipe == "StandardDepo";   // accept only recipes this chamber supports
    }
}
```

Then, in the base `DepoPMC` constructor, replace an empty `return FlowStepResult.End`
step with something that actually drives the chamber and only advances once the
hardware confirms it:

```csharp
AddProcessFlow(() =>
{
    SetState(ModuleProcessState.Executing);
    SetRecipeName("StandardDepo");
    depositionDevice.Start();
    return FlowStepResult.WaitForEnd;   // stay parked — see the next step
});
AddProcessFlow(() =>
{
    if (depositionDevice.QueryStatus() != "DONE")
        return FlowStepResult.WaitForEnd;   // keep waiting, re-checked automatically
    SetState(ModuleProcessState.Idle);
    return FlowStepResult.End;              // hardware confirmed — advance
});
```

---

## 7. Mistakes beginners actually hit here

| Symptom | Cause | Fix |
|---|---|---|
| `NullReferenceException` when a module tries to use its device | Module `Add`ed before its Device was `Add`ed | Always register every `Device` before any `Module` that references its key |
| Flow seems "stuck" on one step forever | Step correctly returned `WaitForEnd`, but nothing ever re-evaluates the wait condition | `WaitForEnd` needs *something* — a poll inside the same step, a `GetTrigger`, or a `.rule` — to eventually flip it to `End` |
| `Port.Set("TM1.Transfer", …)` returns `false` and nothing happens | `CanTransfer(source, target)` returned `false` (the PVDEq skeleton's default) | Implement real transfer-legality logic in `CanTransfer` before wiring up real moves |
| Recipe never starts | `CanProcess(recipe)` still throws (unmodified skeleton) | Override it with real accept/reject logic, as in Step 6 |

---

## 8. Checklist for building your own Module-based tool

```
[ ] Identify each station's SEMI role: load port → LMC, process chamber → PMC, robot → TMC
[ ] Write one Device subclass per physical piece of hardware (TCPDevice/SerialDevice/IOAddressMap-based)
[ ] Subclass LMC/PMC/TMC, registering steps with AddLoadFlow/AddUnloadFlow/AddMappingFlow/
    AddProcessFlow/AddTransferFlow — each step returns FlowStepResult.End/WaitForEnd/Alarm
[ ] Implement the CanXxx guard (CanLoad/CanUnload/CanMapping/CanProcess/CanTransfer) for real
[ ] FormMain/MainWindow: Port.Add every Device, THEN Port.Add every Module referencing device keys
[ ] Trigger work with Port.Job.Queued(job) + Port.Job.Execute(job.ID) or Port.Set("{key}.{Flow}", FlowAction.Executing, ...)
[ ] Subscribe to OnLMCLoadCompleted / OnPMCProcessCompleted / OnTMCTransferCompleted for logging
```

---

## Where to go next

- [Sample Walkthrough: EqFiveStage](./eqfivestage-quick) — the lower-level
  Controller/Flow pattern this framework is built on top of
- [Quick Start](./quick) — Page/Model/Controller/Flow/Package fundamentals
- [flow.md](./flow) — Flow lifecycle in depth
- [package.md](./package) — how Package classes bridge Entries to hardware setters
