# Devices, Simulation, and State

The last stop on the tour: connecting real device endpoints to your models, and replacing
them with attribute-driven simulation so the whole equipment runs without hardware.

---

## Devices {#devices}

A device class is registered by key with the same `Port.Equipment.Add` entry point used for
modules. The second constructor argument is the device's **communication endpoint** — a
serial COM port for a serial device, or a `"host:port"` TCP address for a network device:

```csharp
// Serial load-port devices
Port.Equipment.Add(new LPDevice("LP1Device", "COM27"));
Port.Equipment.Add(new LPDevice("LP2Device", "COM28"));
Port.Equipment.Add(new LPDevice("LP3Device", "COM29"));

// TCP stage devices
Port.Equipment.Add(new StageDevice("Stage1Device", "192.168.100.101:9000"));
Port.Equipment.Add(new StageDevice("Stage2Device", "192.168.100.102:9000"));
```

> Leave the endpoint empty (`""`) when the device is driven purely in
> [Simulation mode](#simulation-mode) and has no real hardware to connect to.

Models receive their device through `[PackageBinding(moduleKey, deviceKey)]` — the engine
injects the matching instance into each per-module model (see
[Controllers and flows](flows.md)):

```csharp
public class StageModel : ModelEntity
{
    [PackageBinding("Stage1", "Stage1Device")]
    [PackageBinding("Stage2", "Stage2Device")]
    public StageDevice? Device { set; get; }
}

// In a flow step:
Handler.Model.Device?.Send("MOVE");
```

---

## Simulation mode {#simulation-mode}

Simulation is a global application mode:

```csharp
Port.Set(Port.AppMode.Simulation);          // usually in a [Preset] method
bool sim = Port.Equipment.IsSimulationMode; // query anywhere
```

While the mode is active, registered simulation triggers (below) fire automatically;
outside it they are inert, so the same application binary runs against real hardware
unchanged.

---

## Simulation triggers {#triggers}

A `[Simulation]` class mirrors hardware behavior with `[SetTrigger(entryKey)]` and
`[GetTrigger(entryKey)]` methods. A `[SetTrigger]` runs whenever the entry is written; the
method receives the written value as a `Value` (use `.String()` / `.Double()`):

```csharp
[Simulation]
public class Simulation
{
    // Command → sensor feedback, as real hardware would report.
    [SetTrigger(Stage1.Gate_Open_o)]
    public void Stage1GateOpen(Value v)
    {
        if (v.String() == "On")
            Port.Set("Stage1.Gate_Status_i", "On");
    }

    // Wafer arrival starts the stage's process flow.
    [SetTrigger(Stage1.WaferPresent_i)]
    public void Stage1WaferPlaced(Value v)
    {
        if (v.String() == "On")
            Port.Set("Stage1", Reserved.ProcessModule.FLOW_KEY_PROCESS, FlowAction.Executing);
    }
}
```

Register the class once; the engine scans the assembly for every `[Simulation]` class and
subscribes all of their triggers:

```csharp
Port.Add<Simulation>("Simulation1");
```

Trigger method signatures may take a `Value`, a `string`, or no parameter. A single entry
key can carry multiple triggers.

---

## Scoping triggers with the state machine {#state-machine}

Triggers can be gated on an equipment state so different simulation behaviors apply in
different phases. Declare an enum, mark a trigger class with `[State<T>(value)]`, and drive
the current state through `Port.Equipment`:

```csharp
public enum EqState { Init, Running, Maintenance }

[Simulation]
[State<EqState>(EqState.Running)]
public class RunningSimulation
{
    // These triggers fire only while EqState is Running.
}
```

```csharp
Port.Equipment.SetState(EqState.Running);
var current = Port.Equipment.GetState<EqState>();
```

A trigger is invoked only when **both** conditions hold: the application is in Simulation
mode, and — if the class declares a `[State<T>]` — the state machine's current value for
`T` matches. Classes without a `[State<T>]` gate fire in every state.

---

## Where to go next {#next}

This concludes the Equipment tour. From here:

- [Entity Objects](../entity) — the full E87/E39/E90 state model behind the entities.
- [Flow](../flow) — the complete flow attribute reference.
- [Scheduler](../scheduler) — carrier jobs, routes, and transfer strategies.
- [Attribute](../attribute) — every Port attribute in one place.
