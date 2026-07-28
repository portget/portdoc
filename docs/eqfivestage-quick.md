# Sample Walkthrough: EqFiveStage (WPF)

A beginner's tour through **EqFiveStage** — a WPF sample equipment app built with Port,
simulating a 5-stage wafer fab tool. This page assumes you've already read the main
[Quick Start](./quick) (Page → Model → Controller/Flow → Package). Here we apply those
same concepts to one concrete, runnable sample instead of isolated snippets.

If you haven't opened the main Quick Start yet, do that first — this page skips the
"what is a Page/Model/Controller" explanations and goes straight to "how do these pieces
fit together in a real app."

---

## 1. What EqFiveStage simulates

EqFiveStage is a small virtual fab:

- **LP1 / LP2 / LP3** — three loading ports, each holding 25 wafer slots
- **Stage1 – Stage5** — five process stages, each with a simulated 100-second process
- **Aligner** — corrects wafer position before it goes back to a loading port
- **Robot** — a dual-arm robot that picks and places wafers between all of the above

The scenario: a wafer loads from an LP, moves to a Stage for processing, moves to the
Aligner for position correction, then returns to an LP. Everything is visualized live
in a WPF window, including a GEM300 simulation panel.

Because every station is driven by the same Port concepts (Page, Model, Controller,
Flow), this one project is a good template for *any* multi-station equipment app —
swap "Stage" for "Etcher" or "CVD Chamber" and the pattern still applies.

---

## 2. Before you start

You need three things built and on your machine:

1. **`port.exe`** (the Port CLI) — used to scaffold the project's database
2. **The `portdic` .NET library** — referenced as a project reference from your `.csproj`
3. **.NET 9 SDK** with the WPF workload (EqFiveStage targets `net9.0-windows`)

You do **not** need to touch Rust, Go, or any protocol server for this sample — it's
pure C#/WPF talking to the Port in-memory database through the `portdic` library.

---

## 3. Step 1 — Scaffold the project with the Port CLI

Every Port-based app starts the same way, before you write a single line of C#:

```bash
cd EqFiveStage
port new EqFiveStage      # creates the Repo/ folder structure
port push EqFiveStage     # reads your .page/.enum files into the DB, generates Repo/.net/entry.cs
port run  EqFiveStage     # starts the Port service (only needed once you're ready to run the app)
```

**Why this order matters:** `port run` reads its data straight from the database —
it never looks at your `.page` files directly. If you skip `port push`, `port run`
has nothing to load, and the app fails to connect. Think of `push` as "compile my data
definitions into the database" and `run` as "start the server using what's already
compiled."

---

## 4. Step 2 — Describe your equipment as `.page` files

A `.page` file lists the Entries (data points) that belong to one instance of a
station. EqFiveStage keeps one folder per instance so LP1/LP2/LP3 don't collide:

```
Repo/port/
├── .enum                  ← shared enum definitions
├── LP1/LP.page
├── LP2/LP.page
├── LP3/LP.page
├── Stage1/Stage.page
├── Stage2/Stage.page  ...
├── Aligner/Aligner.page
├── Robot/Robot.page
└── Scheduler/Scheduler.page
```

`.enum` defines the named states each station can be in:

```text
# Repo/port/.enum
ONOFF          Off:0   On:1
LP_Status      Idle:0  Loading:1  Loaded:2  Unloading:3  Error:4
Stage_Status   Idle:0  Loading:1  Processing:2  Done:3  Unloading:4  Error:5
```

And a `.page` file uses those enum names to declare Entries:

```text
# Repo/port/LP1/LP.page
LP_Status       ENUM.LP_Status   property:{"MIN":0,"MAX":4,"Arguments":"Idle,Loading,Loaded,Unloading,Error"}
Ready_i         ENUM.ONOFF       property:{"MIN":0,"MAX":1,"Arguments":"Off,On"}
WaferPresent_i  ENUM.ONOFF       property:{"MIN":0,"MAX":1,"Arguments":"Off,On"}
CurrentSlot     U2
```

> **The #1 beginner mistake here:** the `ENUM.Name` in a `.page` file must spell out
> the same enum name declared in `.enum` — matching is case-insensitive but not
> typo-tolerant. `ONOFF` in `.enum` and `ENUM.OFFON` in a `.page` file are two
> *different* strings and will silently fail to link.

---

## 5. Step 3 — Let `entry.cs` be generated for you

After `port push`, Port writes `Repo/.net/entry.cs` automatically — a `namespace
Portdic` file with a `const string` for every Entry you just declared:

```csharp
// Auto-generated. Do not edit by hand — it's overwritten on the next `port push`.
namespace Portdic
{
    public class LP1 {
        public const string LP_Status      = "LP1.LP_Status";
        public const string Ready_i        = "LP1.Ready_i";
        public const string WaferPresent_i = "LP1.WaferPresent_i";
    }
    public class Stage1 {
        public const string Stage_Status  = "Stage1.Stage_Status";
        public const string ProcessTimer  = "Stage1.ProcessTimer";
    }
    // ... one class per instance folder ...
}
```

Add it to your `.csproj` so it compiles as part of the app:

```xml
<ItemGroup>
  <ProjectReference Include="..\SampleArduinoLib\portdic\portdic.csproj" />
  <Compile Include="Repo/.net/entry.cs" />
</ItemGroup>
```

From here on, **every** `Port.Get`/`Port.Set`/`[EntryBinding]` call in your C# code
should reference `Portdic.LP1.Ready_i`, never a hand-typed string like
`"LP1.Ready_i"`. The generated constant is your single source of truth — if a typo
sneaks into a hand-typed string it won't be caught until runtime; a typo in
`Portdic.LP1.Ready_i` won't compile at all.

---

## 6. Step 4 — Bind Entries to a Model

`EqFiveStage/Model/LPModel.cs` maps the same property to all three loading-port
instances with one `[EntryBinding]` attribute per instance:

```csharp
[Model]
public class LPModel
{
    [EntryBinding("LP1", Portdic.LP1.LP_Status)]
    [EntryBinding("LP2", Portdic.LP2.LP_Status)]
    [EntryBinding("LP3", Portdic.LP3.LP_Status)]
    public Entry LP_Status { get; set; }

    [EntryBinding("LP1", Portdic.LP1.Ready_i)]
    [EntryBinding("LP2", Portdic.LP2.Ready_i)]
    [EntryBinding("LP3", Portdic.LP3.Ready_i)]
    public Entry Ready_i { get; set; }
}
```

A single-instance station (Aligner, Robot) only needs one `[EntryBinding]` line —
there's nothing to duplicate.

---

## 7. Step 5 — Write the Controller logic

Controllers hold Flows, and each Flow is a numbered sequence of steps. The important
detail for a multi-instance station like LP1/LP2/LP3 is the **4-argument form** of
`[FlowWatcherCompare]`: it scopes the condition to one specific instance, so the same
`LPController` class correctly drives three independent loading ports without any
`if (instanceName == "LP1")` branching in your code.

```csharp
[Controller]
public class LPController
{
    [Flow(Flows.LP_Load)]
    public class LPLoadFlow
    {
        [FlowHandler]
        public IFlowHandler Handler { get; set; } = null!;

        // 4-arg form: (instanceName, fullKey, op, value) — applies only to that instance
        [FlowStep(0)]
        [FlowWatcherCompare("LP1", Portdic.LP1.Ready_i, "==", "On")]
        [FlowWatcherCompare("LP2", Portdic.LP2.Ready_i, "==", "On")]
        [FlowWatcherCompare("LP3", Portdic.LP3.Ready_i, "==", "On")]
        public void CheckStatus(LPModel m)
        {
            m.LP_Status.Set("Loading");
            Handler.Next();
        }
    }
}
```

For a single-instance station, drop the instance name and use the 3-argument form
(`[FlowWatcherCompare(key, op, value)]`) — it applies globally since there's only one
instance to apply to.

---

## 8. Step 6 — Wire everything up in `MainWindow`

This is where the pieces you just wrote come together. Order matters:

```csharp
[Portdic("EqFiveStage")]           // project name — must match what you used in `port new`
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        var vm = new VmMainWindow();
        DataContext = vm;

        Port.App<MainWindow>();    // 1. initialize Port — always first

        // 2. register every station instance: Port.Add<Controller, Model>(instanceName)
        Port.Add<LPController,    LPModel>   (Cat.LP1);
        Port.Add<LPController,    LPModel>   (Cat.LP2);
        Port.Add<LPController,    LPModel>   (Cat.LP3);
        Port.Add<StageController, StageModel>(Cat.Stage1);
        // ... one Add call per instance ...
        Port.Add<JobController,   JobModel>  (Cat.Scheduler);

        // 3. start polling once Port is ready
        Port.OnReady += (s, e) => Dispatcher.Invoke(() => vm.StartPolling());
        Closed       += (s, e) => vm.StopPolling();

        Port.Run();                // 4. connect — always last
    }
}
```

`Cat` and `Flows` are just two small `static class`es you write yourself
(`EqFiveStage/Entry/Entry.cs`), holding nothing but the instance names and flow names
as `const string`. Everything else — the actual data keys — comes from the generated
`entry.cs` you saw in Step 3.

---

## 9. Step 7 — Run it

```bash
port run EqFiveStage
```

Then launch the WPF app (F5 in Visual Studio, or `dotnet run`). The `VmMainWindow`
ViewModel polls Port every 200ms with a `DispatcherTimer` and updates bound WPF
properties, so wafer movement and stage progress appear live in the window. A second
100ms timer simulates each Stage's "100-second process" at 10x speed for a fast,
watchable demo — real hardware would instead update `ProcessTimer` from a real
sensor or PLC.

---

## 10. Mistakes beginners actually hit here

| Symptom | Cause | Fix |
|---|---|---|
| `port run` fails / equipment doesn't load | Forgot `port push` after editing `.page`/`.enum` files | Always `push` before `run` |
| `ArgumentException` when calling `Port.Add` | Used `[AppHandler]` / `IAppHandler` on a Controller | `PortDic` doesn't implement `IAppHandler` — do state cleanup in the flow's last step, or subscribe to the static `Port.OnFlowFinished` event instead |
| An Entry never updates, no error shown | `.enum` name and `.page`'s `ENUM.Name` don't match exactly (see Step 2) | Rename one so both spellings are identical |
| `AlreadyExecutingFlowException` when starting a sibling flow inside a completion callback | Called `handler.Next()` in the last step instead of `handler.Done()` | Use `handler.Done()` on the final step when another flow needs to start from inside its `OnFlowFinished` handler |

---

## 11. Building your own equipment app from this template

```
[ ] port new <ProjectName>
[ ] Write .page files — one folder per instance (LP1/, LP2/, LP3/)
[ ] Add any custom enums to .enum
[ ] port push <ProjectName>   → confirm Repo/.net/entry.cs was (re)generated
[ ] Add <Compile Include="Repo/.net/entry.cs" /> to the .csproj
[ ] Entry.cs — just Cat (instance names) + Flows (flow names), nothing else
[ ] Model — one [EntryBinding("instanceName", Portdic.X.Y)] per instance, per property
[ ] Controller — 4-arg [FlowWatcherCompare] for multi-instance stations, 3-arg for singles
[ ] MainWindow — [Portdic("Name")] → Port.App<T>() → Port.Add × N → Port.Run()
[ ] port run <ProjectName>   → launch the app
```

---

## Where to go next

- [Quick Start](./quick) — the underlying Page/Model/Controller/Flow/Package concepts
- [entity.md](./entity) — more on the Entry/Model binding layer
- [flow.md](./flow) — Flow lifecycle and step semantics in depth
- [scheduler.md](./scheduler) — how the scheduler-driven `JobController` pattern works
- [Sample Walkthrough: PVDEq](./pvdeq-quick) — a more advanced sample using Port's
  higher-level Module (LMC/PMC/TMC) framework instead of hand-written Controllers
