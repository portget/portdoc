# 빠른 시작

Port를 사용하여 .NET 장비 애플리케이션을 만드는 단계별 가이드입니다.

---

## 1. 문서를 페이지로 변환하기

### 1.1 페이지란 무엇인가?

**페이지(Page)** 는 Port 시스템의 기본 데이터 정의 단위입니다.
하나의 `.page` 파일은 관련된 **엔트리(Entry)** 의 집합입니다.
Port 서버에 Push하면 해당 엔트리들이 인메모리 데이터 저장소에 생성됩니다.

> Page = 하나의 기능 단위(예: IO, Sensor, Motor)에 속하는 엔트리 목록

페이지는 외부 문서(`.docx`, `.xlsx`, `.csv`)로부터 자동 생성하거나,
C#에서 `[Page]` 어트리뷰트를 사용해 직접 정의할 수 있습니다.

---

### 1.2 페이지 구조와 역할

#### `.page` 파일 문법

```text
[EntryKey]  [DataType]  [pkg:PackageName]  [property:{...}]
```

| 필드 | 필수 | 설명 |
|------|------|------|
| `EntryKey` | ✅ | 엔트리의 고유 식별자 |
| `DataType` | ✅ | 데이터 타입 (`f8`, `Enum.OnOff`, `char` 등) |
| `pkg` | 선택 | 바인딩할 패키지 API |
| `property` | 선택 | 개별 엔트리 사용자 속성 (JSON) |

**예시 (`io.page`):**

```text
Bulb1OnOff  Enum.OnOff pkg:IODevice.DI property:{"IO.No":"D0.01","Model":"IODevice"}
Bulb2OnOff  Enum.OnOff pkg:IODevice.DI property:{"IO.No":"D0.02","Model":"IODevice"}
Bulb1Temp   f8         pkg:IODevice.AI property:{"IO.No":"A0.01","Model":"IODevice"}
Bulb2Temp   f8         pkg:IODevice.AI property:{"IO.No":"A0.02","Model":"IODevice"}
```

#### 엔트리 구조

**엔트리(Entry)** 는 Port 시스템의 최소 데이터 단위입니다. 각 엔트리는 다음을 가집니다:

- **Key** — 완전 한정 식별자 (`category.entryName`, 예: `Bulb1.OnOff`)
- **DataType** — 값의 타입 (숫자, enum, char 등)
- **Value** — 메모리에 저장된 현재 값 (실시간 상태)
- **Property** — 하드웨어 주소, 단위 등의 보조 설정 (JSON)

**SECS 호환 데이터 타입:**

| 타입 | 설명 |
|------|------|
| `f4` / `f8` | 부동소수점 (4 / 8 바이트) |
| `i1` ~ `i8` | 부호 있는 정수 |
| `u1` ~ `u8` | 부호 없는 정수 |
| `A(n)` | ASCII n개 문자열 |
| `string` | 가변 길이 UTF-8 문자열 (최대 255 바이트) |
| `Enum.XXX` | 미리 정의된 enum 참조 열거형 |
| `bool` | 불리언 |

#### 로컬 엔트리 정의 (카테고리 범위)

하드웨어 문서 엔트리에 대응하지 않는 논리적 설정값
(예: 목표 온도)은 카테고리 폴더 내 별도 `.page` 파일로 정의합니다:

**`bulb1/.page`:**

```text
TargetTemp  f8
```

---

### 1.3 문서를 페이지로 변환하기

프레임워크가 사양 테이블을 구조화된 데이터 모델로 변환합니다.

#### 소스 사양서

`C:\Users\admin\Documents\IO.docx`에 다음과 같은 테이블이 있다고 가정합니다:

| IO.No | Description | Model |
| --- | --- | --- |
| D0.01 | Bulb1.OnOff | IODevice |
| D0.02 | Bulb2.OnOff | IODevice |
| A0.01 | Bulb1.Temp | IODevice |
| A0.02 | Bulb2.Temp | IODevice |

[그림 1: 샘플 사양서 테이블](./file/IO.docx)

#### 문서 모델 정의

어트리뷰트를 사용하여 테이블 컬럼을 C# 클래스에 매핑합니다.

```csharp
public class IOModel
{
    [ColumnHeader("IO.No"), EntryProperty]
    public string IONo { get; set; } = null!;

    [ColumnHeader("Description"), EntryKey]
    public string Description { get; set; } = null!;

    [ColumnHeader("Model"), EntryProperty]
    public string Model { get; set; } = null!;
}
```

| 어트리뷰트 | 역할 |
|-----------|------|
| `[ColumnHeader]` | 속성을 Excel/Word 컬럼 이름에 매핑 |
| `[EntryKey]` | 이 컬럼을 엔트리 이름으로 지정 |
| `[EntryProperty]` | 이 컬럼을 `property:{...}` JSON에 포함 |

#### 생성된 `.cs` 파일

`Port.Document<T>`는 `.page` 파일과 함께 상수 클래스를 작성합니다.

```csharp
// Port에 의해 자동 생성됨. 직접 수정하지 마세요.
namespace sample
{
    public static class Io
    {
        public const string Bulb1OnOff = "Bulb1OnOff";
        public const string Bulb2OnOff = "Bulb2OnOff";
        public const string Bulb1Temp  = "Bulb1Temp";
        public const string Bulb2Temp  = "Bulb2Temp";
    }
}
```

[그림 2: 샘플 .cs 파일](./file/io.cs)

---

### 1.4 `[Page]`를 사용한 인라인 엔트리 정의

외부 문서에서 오지 않는 엔트리(예: EFEM I/O 신호)는
`[Page]`로 데코레이트된 C# 클래스에 직접 정의합니다.

#### 자동 생성 클래스 (`Port.Pull`)

`Port.Pull`은 Pull된 모든 엔트리를 `const string`으로 포함하는
`partial` 클래스 파일(예: `entry.cs`)을 작성합니다.
이 파일은 매번 Pull 시 재생성됩니다 — **직접 수정하지 마세요**.

`entry.cs`에는 데이터베이스에 저장된 모든 enum 정의를 포함하는
`Defined` 클래스도 자동 생성됩니다.

```csharp
// Port.Pull에 의해 자동 생성됨 — 직접 수정하지 마세요.
namespace Portdic
{
    public partial class EFEM
    {
        public const string LP1_Main_Air_i = "EFEM.LP1_Main_Air_i";
        public const string LP2_Cont_o     = "EFEM.LP2_Cont_o";
        // ... 모든 Pull된 엔트리 ...
    }

    public partial class Defined
    {
        public enum OffOn : int
        {
            Off = 0,
            On  = 1,
        }

        public enum UnkOffOn : int
        {
            Unknown = 0,
            Off     = 1,
            On      = 2,
        }
        // ... 데이터베이스의 모든 enum ...
    }
}
```

#### 사용자 정의 확장 (`CustomEFEM`)

Pull된 클래스에 아직 없는 엔트리와 enum 타입은
별도의 `[Page]` 데코레이트된 `partial class`로 추가합니다.

규칙:
- **필드 값**이 enum 키입니다 — `[PageEntry]`의 `EnumName`이 정확히 일치해야 합니다.
- `[PageEnum]` 필드는 `[PageEntry]` 필드보다 **먼저** Push됩니다 (enum 참조가 항상 해결되도록).
- Enum 정의는 `app/.enum`에 저장됩니다.

```csharp
using Portdic;
using Portdic.SECS;

namespace sample.Controller
{
    [Page("EFEM")]
    public partial class CustomEFEM
    {
        // ── Enum 선언 ─────────────────────────────────────────
        [PageEnum("Unknown", "Off", "On")]
        public const string UnkOffOn = "UnkOffOn";

        [PageEnum("Unknown", "TurnOff", "TrunOn")]
        public const string UnkTurnOffOn = "UnkTurnOffOn";

        // ── Entry 선언 ────────────────────────────────────────
        [PageEntry(PortDataType.Char)]
        public const string LP1_Cont1_o = "EFEM.LP1_Cont1_o";

        [PageEntry(PortDataType.Enum, EnumName = UnkTurnOffOn)]
        public const string LP1_OffOn_o = "EFEM.LP1_OffOn_o";

        // ── Package & Property 바인딩 ────────────────────────
        [PageEntry(PortDataType.Enum, EnumName = "OffOn",
            Package  = "Bulb1.OffOn",
            Property = "{\"MIN\":0,\"MAX\":1}")]
        public const string LP1_BulbOnOff_o = "EFEM.LP1_BulbOnOff_o";
    }
}
```

Port 서버 시작 전에 클래스 인스턴스를 Push합니다:

```csharp
Port.Push("sample", new CustomEFEM());
```

---

### 1.5 페이지 Push/Pull 방법

#### Push — 서버에 엔트리 등록

엔트리 데이터 소스에 따라 세 가지 오버로드를 사용합니다:

| 오버로드 | 사용 경우 |
|----------|----------|
| `Push(reponame, obj)` | `[Page]` 데코레이트 클래스 인스턴스에서 Push |
| `Push(reponame, page)` | `Document<T>.NewPage()`가 반환한 `Page`에서 Push |
| `Push(repo)` | port REST API를 통해 전체 디렉토리 Push (`RepositoryInfo`) |

```csharp
// [Page] 데코레이트 클래스에서 Push (enum + 엔트리)
Port.Push("sample", new CustomEFEM());

// 문서에서 파생된 Page에서 Push (엔트리만)
Port.Push("sample", ioDoc.NewPage("Device"));
```

#### Pull — DB에서 파일 재구성

`Port.Pull`은 CLI를 통해 `port pull {reponame}`을 호출하고
지정된 루트 디렉토리의 `port/` 하위 폴더에 `.page`, `.enum` 등을 재작성합니다.

```csharp
// 문법
Port.Pull(string reponame, string root);

// 예시: D:\sample\Repo\pull\port\ 에 파일 작성
Port.Pull("sample", @"D:\sample\Repo\pull\");
```

#### 전체 초기화 패턴 (`#if DEBUG`)

```csharp
#if DEBUG
// 1. 프로젝트 루트 확인
Port.Repository.New(@"D:\sample\Repo\pull\", "sample");

// 2. 외부 문서를 엔트리로 변환
var ioDoc = Port.Document<IOModel>(@"C:\Users\admin\Documents\IO.docx");
ioDoc.Where(v => v.Key.Contains("OnOff")).ToList()
     .ForEach(v => v.DataType = "Enum.OnOff");
ioDoc.Where(v => v.Key.Contains("Temp")).ToList()
     .ForEach(v => v.DataType = "f8");

if (ioDoc.Count > 0)
{
    ioDoc.New(@"C:\Users\admin\Documents\sample\.page\io.page");
    ioDoc.New(@"C:\Users\admin\Documents\sample\.net\io.cs");
}

// 3. 인라인 정의 엔트리 Push (enum + EFEM 신호)
Port.Push("sample", new CustomEFEM());

// 4. 문서에서 파생된 엔트리 Push
Port.Push("sample", ioDoc.NewPage("Device"));

// 5. DB에서 .page/.enum 파일 재구성
Port.Pull("sample", @"D:\sample\Repo\pull\");
#endif
```

---

## 2. 페이지를 모델에 매핑하기

### 2.1 모델이란 무엇인가?

**모델(Model)** 은 Port 엔트리와 C# 속성을 연결하는 **데이터 바인딩 계층**입니다.

- `[Model]` 어트리뷰트로 클래스를 선언합니다.
- 각 속성은 `[ModelBinding]`으로 특정 엔트리에 연결됩니다.
- 컨트롤러와 플로우는 모델을 통해 엔트리 값을 읽고 씁니다.

---

### 2.2 모델과 페이지의 관계

```
.page 파일 (엔트리 정의)
    ↓  Push
Port 인메모리 DB (엔트리 값)
    ↕  ModelBinding
모델 (C# 속성 ↔ 엔트리 매핑)
    ↕
컨트롤러 / 플로우 (비즈니스 로직)
```

페이지는 **단일 진실 공급원(Single Source of Truth)**이며,
모델은 해당 데이터의 **타입 안전 뷰**입니다.

---

### 2.3 모델을 페이지에 매핑하는 방법

`[ModelBinding(instanceKey, entryKey)]` 어트리뷰트를 사용합니다.

- **첫 번째 인수** — 컨트롤러 인스턴스 키 (예: `"Bulb1"`, `"LP1"`)
- **두 번째 인수** — 자동 생성된 `.cs` 파일의 엔트리 상수

```csharp
[Model]
public class BulbModel
{
    [ModelBinding("Bulb1", Io.Bulb1OnOff)]
    [ModelBinding("Bulb2", Io.Bulb2OnOff)]
    public Entry OnOff { get; set; }

    [ModelBinding("Bulb1", Io.Bulb1Temp)]
    [ModelBinding("Bulb2", Io.Bulb2Temp)]
    public Entry Temp { get; set; }

    [ModelBinding("Bulb1", Io.Bulb1TargetTemp)]
    [ModelBinding("Bulb2", Io.Bulb2TargetTemp)]
    public Entry TargetTemp { get; set; }
}
```

---

## 3. 컨트롤러와 플로우에서 모델 사용하기

### 3.1 컨트롤러란 무엇인가?

**컨트롤러(Controller)** 는 하나 이상의 **플로우(Flow)** 를 담는 로직 컨테이너입니다.

- `[Controller]` 어트리뷰트로 선언합니다.
- `Port.Add<TController, TModel>(instanceKey)`로 등록합니다.
- 같은 컨트롤러를 여러 인스턴스에 재사용할 수 있습니다 (예: LP1, LP2).

```csharp
Port.Add<BulbController, BulbModel>("Bulb1");
Port.Add<BulbController, BulbModel>("Bulb2");
Port.Run();
```

---

### 3.2 플로우란 무엇인가?

**플로우(Flow)** 는 컨트롤러 내부에 정의된 **순차적 워크플로우**입니다.

- `[Flow("FlowName")]`으로 내부 클래스를 선언합니다.
- 각 단계는 `[FlowStep(order)]`으로 데코레이트된 메서드로 정의합니다.
- `Port.Set("Bulb1", FlowAction.Executing)`으로 외부에서 실행을 트리거합니다.

---

### 3.3 플로우 안에서 모델 처리하기

메서드 파라미터로 모델을 직접 받아 엔트리 값에 접근합니다:

```csharp
[Controller]
public class BulbController
{
    [Flow("BulbOn")]
    public class BulbOn
    {
        [Handler]
        public IFlowHandler handler { get; set; } = null!;

        [FlowStep(0)] // 검증 단계
        public void CheckInitialState(BulbModel model)
        {
            if (model.Temp.Value <= 100)
                handler?.Next();
        }

        [FlowStep(1)] // 동작 단계
        public void TurnOn(BulbModel model)
        {
            model.OnOff.Set("On");
            handler?.Next();
        }

        [FlowStep(2)] // 모니터링 단계
        public void MonitorTemperature(BulbModel model)
        {
            if (model.Temp.Value >= model.TargetTemp.Value)
            {
                model.OnOff.Set("Off");
                handler?.Next(); // 플로우 완료로 표시
            }
        }
    }
}
```

**플로우 시작 / 취소:**

```csharp
Port.Set("Bulb1", FlowAction.Executing);   // BulbOn 플로우 시작
Port.Set("Bulb1", FlowAction.Canceled);    // 취소
```

---

### 3.4 애플리케이션 진입점 (`Port.App<T>`)

`Port.App<T>()`는 `[Port]` 어트리뷰트 기반 초기화 방식 사용 시 **반드시 첫 번째로 호출**해야 합니다.

```csharp
[Port("sample")]
public class SampleApp { }

// 시작 시 (예: 생성자 또는 Program.cs) — 반드시 먼저 호출
Port.App<SampleApp>();
```

#### 전체 시작 예시

```csharp
[Port("sample")]
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        try
        {
            Port.App<MainWindow>();

#if DEBUG
            var ioDoc = Port.Document<IOModel>(@"C:\Users\admin\Documents\IO.docx");

            ioDoc.Where(v => v.Key.Contains("OnOff")).ToList()
                 .ForEach(v => v.DataType = "Enum.OnOff");
            ioDoc.Where(v => v.Key.Contains("Temp")).ToList()
                 .ForEach(v => v.DataType = "f8");

            if (ioDoc.Count > 0)
            {
                ioDoc.New(@"C:\Users\admin\Documents\sample\.page\io.page");
                ioDoc.New(@"C:\Users\admin\Documents\sample\.net\io.cs");
            }

            Port.Push("sample", new CustomEFEM());
            Port.Push("sample", ioDoc.NewPage("Device"));
            Port.Pull("sample", @"D:\PORT\SampleArduinoLib\sample\Repo\pull\");
#endif

            Port.Add<LoadportController, LoadportModel>("LP1");
            Port.Add<LoadportController, LoadportModel>("LP2");

            Port.OnReady += Port_OnReady;
            Port.Run();
        }
        catch (Exception ex)
        {
            MessageBox.Show(
                $"{ex.Message}\n\nInner: {ex.InnerException?.Message}\n\nStack: {ex.StackTrace}");
        }
    }
}
```

---

## 4. 핸들러

### 4.1 핸들러 타입

| 인터페이스 | 목적 |
|-----------|------|
| `IFlowHandler` | 기본 플로우 진행 제어 (`Next()`) |
| `IFlowWithModelHandler<T>` | 모델을 전달하는 플로우 이벤트 구독 |
| `ISchedulerHandler<T>` | 이송 완료 스케줄링 |

---

### 4.2 핸들러 역할과 사용법

#### IFlowHandler — 기본 진행 제어

```csharp
[Handler]
public IFlowHandler handler { get; set; } = null!;

handler.Next();   // 다음 FlowStep으로 진행
handler.Done();   // 플로우를 동기적으로 Idle 강제 전환
```

#### IFlowWithModelHandler\<T\> — 이벤트 기반 모델 접근

```csharp
[Controller]
internal class WTRController
{
    [Flow("Pick")]
    public class Pick : IFlowCACD<WTRCommModel>
    {
        [Handler]
        public IFlowWithModelHandler<WTRCommModel> handler { set; get; } = null!;

        [Handler]
        public ISchedulerHandler<DualArmActionArgs> scheduler { set; get; } = null!;

        [Preset]
        public void Preset()
        {
            handler.SetLogger(@"D:\log");
            handler.OnFlowFinished += (s, e) =>
                scheduler.TransferCompleted(e.Model.SelectedArm);
        }

        public void CheckStatus(WTRCommModel m) { Task.Delay(300).Wait(); handler.Next(); }
        public void Action(WTRCommModel m)      { handler.Next(); }
        public void CheckAction(WTRCommModel m) { handler.Next(); }
        public void Done(WTRCommModel m)        { handler.Done(); }
    }
}
```

#### handler.Next() vs handler.Done()

| 메서드 | 동작 |
|--------|------|
| `handler.Next()` | 정상 상태 머신을 통해 다음 단계로 진행 |
| `handler.Done()` | 반환 전 플로우를 `Idle`로 **동기적으로** 강제 전환 후 `OnFlowFinished` 발생 |

---

### 4.3 핸들러 속성 표

#### IFlowCACD\<T\> — 표준 4단계 플로우

| 단계 | 메서드 | 설명 |
|------|--------|------|
| 0 | `CheckStatus` | 동작 전 사전 조건 검증 |
| 1 | `Action` | 물리적 동작 실행 |
| 2 | `CheckAction` | 동작 완료 확인 |
| 3 | `Done` | 완료 처리 — `handler.Done()` 호출로 플로우 종료 |

#### IFlowWithModelHandler\<T\> 생명주기 이벤트

| 이벤트 | 발생 시점 | 인수 |
|--------|-----------|------|
| `OnFlowFinished` | 플로우가 Done 단계 완료 | `FlowFinishedWithModelArgs<T>` — 모델, 타이밍, 단계 기록 |
| `OnFlowOccured` | 단계 전환 발생 | `PortFlowOccuredWithModelArgs<T>` — 모델, 단계 상태 |
| `OnFlowIssue` | 알람으로 플로우 중지 | `PortFlowIssueWithModelArgs<T>` — 모델, 알람 코드 |

---

## 5. 패키지 호출

### 5.1 패키지란 무엇인가?

**패키지(Package)** 는 물리적 디바이스(전구, 히터, IO 카드 등)와
Port 엔트리를 연결하는 **재사용 가능한 디바이스 드라이버 모듈**입니다.

- `.page` 파일에서 `pkg:PackageName.PropertyName` 문법으로 패키지를 연결합니다.
- C# 클래스에 `[Package]` 어트리뷰트를 선언합니다.
- 엔트리 값이 변경되면 패키지의 해당 속성 setter가 자동으로 호출됩니다.

---

### 5.2 패키지 API 호출 방법

#### `.page` 파일에서 패키지 연결

```text
Bulb1OnOff  Enum.OnOff  pkg:Bulb.OffOn  property:{"IO.No":"D0.01"}
Bulb1Temp   f8          pkg:Bulb.Temp   property:{"IO.No":"A0.01"}
```

#### 패키지 클래스 구현

```csharp
[Package]
public class Bulb
{
    [Logger]
    public ILogger Logger { get; set; }

    [Property]
    public IProperty Property { get; set; }

    [Valid("Device not connected")]
    public bool Valid() => serialPort.IsOpen;

    [API(EntryDataType.Enum)]
    public string OffOn
    {
        set { Logger.Write($"[INFO] Bulb OffOn → {value}"); }
        get => _offOn;
    }

    private string _offOn = "Off";
    private SerialPort serialPort = new SerialPort();
}
```

---

## 6. Port.Set

`Port.Set`은 즉시 인메모리 DB의 지정된 엔트리에 값을 씁니다.
패키지가 해당 엔트리에 바인딩되어 있으면 setter가 호출되어 물리 동작이 실행됩니다.

### 기본 사용법

```csharp
Port.Set("Bulb1.OnOff", "On");
Port.Set("Bulb1.TargetTemp", "85.0");

Port.Set("Bulb1", FlowAction.Executing);
Port.Set("Bulb1", FlowAction.Canceled);
```

### 모델 속성을 통한 Set

```csharp
model.OnOff.Set("On");
model.TargetTemp.Set("80.0");
```

### IFlowModel을 통한 Set (`@` 바인딩)

```csharp
[FlowModel]
public IFlowModel model { get; set; }

model.Set("@OnOff", "On");
```

---

## 7. Port.Get

`Port.Get`은 인메모리 DB에서 지정된 엔트리의 현재 값을 읽습니다.

### 기본 사용법

```csharp
string onOff = Port.Get("Bulb1.OnOff");   // → "On" 또는 "Off"

if (Port.Get("Bulb1.OnOff") == "On")
{
    Port.Set("Bulb1.OnOff", "Off");
}
```

### 모델 속성을 통한 Get

```csharp
double temp   = (double)model.Temp.Value;
string status = (string)model.OnOff.Value;
```

### IFlowModel을 통한 Get (`@` 바인딩)

```csharp
var value = model.Get("@Temp");
```

---

## 8. 룰 스크립트로 Set/Get 제어하기

**룰 스크립트(Rule Script)** 는 `app/` 디렉토리의 `.rule` 파일을 사용하여
쓰기 가드와 주기적 자동화를 정의합니다.
`set`과 `get` 두 가지 룰 타입이 있습니다.

---

### 8.1 `set` 룰 — 쓰기 가드

`set` 룰은 매칭 키에 `Port.Set`이 호출될 때마다 **동기적으로 평가**됩니다.
허용 조건이 충족되지 않으면 쓰기가 **차단**되고 오류가 반환됩니다.

#### 문법

```
set("쓰기 조건", "허용 조건")
```

#### 예시

```text
// 온도가 안전할 때(>= 80)만 Bulb1 끄기 허용
set("Bulb1.OnOff == Off", "Bulb1.Temp >= 80")

// Bulb1이 켜져 있는 동안 Bulb2.OnOff 쓰기 차단
set("Bulb2.OnOff", "Bulb1.OnOff == Off")
```

---

### 8.2 `get` 룰 — 주기적 자동화

`get` 룰은 **매 1초**마다 백그라운드에서 실행됩니다.
조건이 `true`가 되면 나열된 대입이 **한 번** 실행됩니다.

#### 문법

```
get("조건", "key1=value1; key2=value2; ...")
```

#### 예시

```text
// Bulb1 온도가 80 이상이면 자동으로 끄기
get("Bulb1.Temp >= 80", "Bulb1.OnOff=Off")

// 두 온도가 모두 정상 범위이면 두 전구 모두 리셋
get("(Bulb1.Temp >= 0) && (Bulb2.Temp >= 0)", "Bulb1.OnOff=Off; Bulb2.OnOff=Off")
```

---

### 8.3 연산자

**비교 연산자:**

| 연산자 | 설명 |
|--------|------|
| `==` | 같음 (문자열 또는 숫자) |
| `>` | 초과 |
| `<` | 미만 |
| `>=` | 이상 |
| `<=` | 이하 |

**논리 연산자:**

| 연산자 | 설명 |
|--------|------|
| `&&` | 논리 AND |
| `\|\|` | 논리 OR |

---

### 8.4 완전한 `.rule` 파일 예시

```text
// ── SET 룰 (쓰기 가드) ──────────────────────────────────────────
set("Bulb1.OnOff == Off", "Bulb1.Temp >= 80")
set("Bulb2.OnOff == Off", "(Bulb1.Temp >= 80) && (Bulb2.Temp >= 80)")

// ── GET 룰 (주기적 자동화) ──────────────────────────────────────
get("Bulb1.Temp >= 100", "Bulb1.OnOff=Off")
get("(Bulb1.Temp >= 0) && (Bulb2.Temp >= 0)", "Bulb1.OnOff=Off; Bulb2.OnOff=Off")
```

---

### 8.5 플로우 내부 조건 모니터링

플로우 상태에 따른 로직은 룰 파일 대신 플로우 단계 내부에 직접 표현합니다:

```csharp
[FlowStep(2)]
public void MonitorTemperature(BulbModel model)
{
    if (model.Temp.Value >= model.TargetTemp.Value)
    {
        model.OnOff.Set("Off");
        handler?.Next();
    }
}
```

---

### 8.6 데이터 흐름

```
Port.Set("Bulb1.OnOff", "Off") 호출
    ↓
set 룰 평가 (쓰기 가드)
    ├─ 허용 조건 true  → 쓰기 진행 → 패키지 setter 호출 → 하드웨어 응답
    └─ 허용 조건 false → 쓰기 차단, 오류 반환

매 1초 (백그라운드)
    ↓
get 룰 조건 평가
    ├─ 조건 true (최초) → 대입 실행 → Port.Set 내부 호출
    └─ 조건 false 또는 이미 실행됨 → 동작 없음
```

> 룰 스크립트는 플로우와 독립적으로 동작합니다.
> `.rule` 파일을 편집하면 언제든 조건을 수정할 수 있습니다 —
> 코드 재컴파일이 필요 없습니다.
