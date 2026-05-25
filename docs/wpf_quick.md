
MainWindow.xaml.cs 설명

[Portdic("EqFiveStage")] 선언 후 



순서대로 선언

`Port.App<T>()` 또는 `Port.App<T>(Action onReady)` 를 가장 먼저 호출한다.

`onReady` 콜백을 전달하면 Port가 Synchronized 상태에 도달했을 때 자동으로 호출되므로,
`Port.OnReady += ...` 를 별도로 구독할 필요가 없다.

```csharp
[Portdic("EqFiveStage")]
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        var vm = new VmMainWindow();
        DataContext = vm;

        try
        {
            // onReady 콜백은 Port가 준비되면 자동 호출됨 — OnReady 수동 구독 불필요
            Port.App<MainWindow>(() => Dispatcher.Invoke(() =>
            {
                if (DataContext is not VmMainWindow vm) return;
                vm.PropertyChanged += OnVmPropertyChanged;
                vm.StartPolling();
                UpdateRailWidth();
                PositionRobot(vm.RobotTargetLocation, animate: false);
            }));

            // Controller는 대응하는 Model이 필요
            // ── Loading ports ────────────────────────────────────────────
            Port.Add<LPController, LPModel>(Cat.LP1);
            Port.Add<LPController, LPModel>(Cat.LP2);
            Port.Add<LPController, LPModel>(Cat.LP3);

            // ── Process stages ───────────────────────────────────────────
            Port.Add<StageController, StageModel>(Cat.Stage1);
            Port.Add<StageController, StageModel>(Cat.Stage2);
            Port.Add<StageController, StageModel>(Cat.Stage3);
            Port.Add<StageController, StageModel>(Cat.Stage4);
            Port.Add<StageController, StageModel>(Cat.Stage5);

            // ── Aligner ──────────────────────────────────────────────────
            Port.Add<AlignerController, AlignerModel>(Cat.Aligner);

            // ── Robot ────────────────────────────────────────────────────
            Port.Add<RobotController, RobotModel>(Cat.Robot);

            // Helper는 Model이 불필요
            // ── Auth / GEM ───────────────────────────────────────────────
            Port.Add<AuthHelper>("Auth");
            Port.Add<GemHelper>("GEM");

            // 설비 이름 등록
            // ── Equipment ────────────────────────────────────────────────
            Port.Add<Equipment>("EqFiveStage");

            // Port 실행 — Synchronized 상태가 되면 위의 onReady가 자동 호출됨
            Port.Run();
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "EqFiveStage — Startup Error",
                MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}
```

> **`Port.App<T>()` vs `Port.App<T>(Action onReady)`**
>
> | 형태 | 설명 |
> |------|------|
> | `Port.App<T>()` | Port 초기화만 수행. `Port.OnReady += ...` 를 별도로 구독해야 함. |
> | `Port.App<T>(Action onReady)` | 초기화 + OnReady 자동 구독. 콜백만 전달하면 화면 갱신까지 처리됨. |