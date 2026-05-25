# クイックスタート

Port を使用して .NET 機器アプリケーションを構築するためのステップバイステップガイドです。

---

## 1. ドキュメントをページに変換する

### 1.1 ページとは？

**ページ（Page）** は Port システムの基本データ定義単位です。
1 つの `.page` ファイルは、関連する **エントリ（Entry）** の集合です。
Port サーバーにプッシュすると、それらのエントリがインメモリデータストアに作成されます。

> Page = 1 つの機能単位に属するエントリのリスト（例：IO、センサー、モーター）

ページは外部ドキュメント（`.docx`、`.xlsx`、`.csv`）から自動生成することも、
C# の `[Page]` 属性を使って直接定義することもできます。

---

### 1.2 ページの構造と役割

#### `.page` ファイルの構文

```text
[EntryKey]  [DataType]  [pkg:PackageName]  [property:{...}]
```

| フィールド | 必須 | 説明 |
|-----------|------|------|
| `EntryKey` | ✅ | エントリの一意識別子 |
| `DataType` | ✅ | データ型（`f8`、`Enum.OnOff`、`char` など） |
| `pkg` | 任意 | バインドするパッケージ API |
| `property` | 任意 | エントリのユーザー属性（JSON） |

**例 (`io.page`)：**

```text
Bulb1OnOff    Enum.OnOff  property:{"IO.No":"D0.01","Model":"IODevice"}
Bulb2OnOff    Enum.OnOff  property:{"IO.No":"D0.02","Model":"IODevice"}
Bulb1Temp     f8          property:{"IO.No":"A0.01","Model":"IODevice"}
Bulb2Temp     f8          property:{"IO.No":"A0.02","Model":"IODevice"}
```

#### エントリの構造

**エントリ（Entry）** は Port システムにおける最小データ単位です。各エントリには以下が含まれます：

- **Key** — 完全修飾識別子（`category.entryName`、例：`Bulb1.OnOff`）
- **DataType** — 値の型（数値、列挙型、char など）
- **Value** — メモリ上に保持されている現在値（リアルタイム状態）
- **Property** — ハードウェアアドレスや単位などの補足設定（JSON）

**SECS 互換データ型：**

| 型 | 説明 |
|----|------|
| `f4` / `f8` | 浮動小数点数（4 / 8 バイト） |
| `i1` ～ `i8` | 符号付き整数 |
| `u1` ～ `u8` | 符号なし整数 |
| `char` | ASCII 文字列 |
| `string` | 可変長 UTF-8 文字列（最大 255 バイト） |
| `Enum.XXX` | 事前定義された列挙型を参照する列挙型 |
| `bool` | ブール値 |

#### ローカルエントリ定義（カテゴリスコープ）

対応するハードウェアドキュメントエントリを持たない論理的なセットポイント
（例：目標温度）は、カテゴリフォルダ内の別の `.page` ファイルで定義します：

**`bulb1/.page`：**

```text
TargetTemp  f8
```

---

### 1.3 ドキュメントをページに変換する

フレームワークは仕様書のテーブルを構造化データモデルに変換します。

#### ソース仕様書

`C:\Users\admin\Documents\IO.docx` に以下のテーブルが存在すると仮定します：

| IO.No | Description | Model |
| --- | --- | --- |
| D0.01 | Bulb1.OnOff | IODevice |
| D0.02 | Bulb2.OnOff | IODevice |
| A0.01 | Bulb1.Temp | IODevice |
| A0.02 | Bulb2.Temp | IODevice |

[図1：仕様書テーブルのサンプル](./file/IO.docx)

#### ドキュメントモデルを定義する

属性を使用してテーブルの列を C# クラスにマッピングします。

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

| 属性 | 役割 |
|------|------|
| `[ColumnHeader]` | 名前でプロパティを Excel/Word 列にマッピング |
| `[EntryKey]` | この列をエントリ名として指定 |
| `[EntryProperty]` | この列を `property:{...}` JSON に含める |

#### 生成された `.cs` ファイル

`Port.Document<T>` は `.page` ファイルと一緒に定数クラスを書き出します。

```csharp
// Port によって自動生成されました。手動で編集しないでください。
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

[図2：.cs ファイルのサンプル](./file/io.cs)

---

### 1.4 `[Page]` を使ったインラインエントリ定義

外部ドキュメントから来ないエントリ（例：EFEM I/O シグナル）については、
`[Page]` で修飾された C# クラスに直接定義します。

#### 自動生成クラス（`Port.Pull` によって生成）

`Port.Pull` は `partial` クラスファイル（例：`entry.cs`）を書き出し、
プルされたすべてのエントリを `const string` として含めます。
このファイルはプルのたびに再生成されます — **手動で編集しないでください**。

`entry.cs` には `Defined` クラスも含まれており、データベースに保存されているすべての
列挙型定義が、エントリ定数と並べて自動生成されます。

```csharp
// Port.Pull によって自動生成されました — 手動で編集しないでください。
namespace Portdic
{
    public partial class EFEM
    {
        public const string LP1_Main_Air_i = "EFEM.LP1_Main_Air_i";
        public const string LP2_Cont_o     = "EFEM.LP2_Cont_o";
        // ... プルされたすべてのエントリ ...
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
        // ... データベースのすべての列挙型 ...
    }
}
```

#### ユーザー定義拡張（`CustomEFEM`）

プルされたクラスにまだないエントリや列挙型を追加するには、
別の `[Page]` 修飾 `partial class` を作成します。

ルール：
- **フィールド値** が列挙型のキーです — `[PageEntry]` の `EnumName` は完全に一致する必要があります。
- `[PageEnum]` フィールドは `[PageEntry]` フィールドの**前に**プッシュされるため、列挙型参照は常に解決されます。
- 列挙型定義は `app/.enum` に配置されるため、`port pull` が正しいファイルに保持します。

```csharp
using Portdic;
using Portdic.SECS;

namespace sample.Controller
{
    [Page("EFEM")]
    public partial class CustomEFEM
    {
        // ── 列挙型宣言 ─────────────────────────────────────────
        [PageEnum("Unknown", "Off", "On")]
        public const string UnkOffOn = "UnkOffOn";

        [PageEnum("Unknown", "TurnOff", "TrunOn")]
        public const string UnkTurnOffOn = "UnkTurnOffOn";

        // ── エントリ宣言 ────────────────────────────────────────
        [PageEntry(PortDataType.Char)]
        public const string LP1_Cont1_o = "EFEM.LP1_Cont1_o";

        [PageEntry(PortDataType.Enum, EnumName = UnkTurnOffOn)]
        public const string LP1_OffOn_o = "EFEM.LP1_OffOn_o";

        // ── パッケージ & プロパティバインディング ────────────────────────────────
        // Package: "Name.PropertyName" → pkg:Name.PropertyName としてプッシュ
        // Property: 生の JSON 文字列  → property:{...} としてプッシュ
        [PageEntry(PortDataType.Enum, EnumName = "OffOn",
            Package  = "Bulb1.OffOn",
            Property = "{\"MIN\":0,\"MAX\":1}")]
        public const string LP1_BulbOnOff_o = "EFEM.LP1_BulbOnOff_o";
    }
}
```

Port サーバーを起動する前にクラスインスタンスをプッシュします：

```csharp
Port.Push("sample", new CustomEFEM());
```

---

### 1.5 ページのプッシュとプルの方法

#### Push — サーバーへのエントリ登録

エントリデータのソースに応じて 3 つのオーバーロードが利用できます：

| オーバーロード | ユースケース |
|--------------|------------|
| `Push(reponame, obj)` | `[Page]` 修飾クラスインスタンスからプッシュ |
| `Push(reponame, page)` | `Document<T>.NewPage()` が返す `Page` からプッシュ |
| `Push(repo)` | Port REST API 経由でディレクトリ全体をプッシュ（`RepositoryInfo`） |

```csharp
// [Page] 修飾クラスから（列挙型 + エントリ）
Port.Push("sample", new CustomEFEM());

// ドキュメントから派生したページから（エントリのみ）
Port.Push("sample", ioDoc.NewPage("Device"));
```

#### Pull — DB からファイルを再構築

`Port.Pull` は CLI 経由で `port pull {reponame}` を呼び出し、再構築された `.page`、
`.enum`、および関連ファイルを指定されたルートディレクトリ内の `port/` サブフォルダに書き出します。

```csharp
// 構文
Port.Pull(string reponame, string root);

// 例：D:\sample\Repo\pull\port\ にファイルを書き出す
Port.Pull("sample", @"D:\sample\Repo\pull\");
```

`port.exe` は最初に `%PortPath%` の親から解決されます。見つからない場合はシステムの `PATH` にフォールバックします。

#### 完全な初期化パターン（`#if DEBUG`）

`#if DEBUG` ブロックでの推奨パターンは、実行時にリポジトリを読み込む前に
DB を最新のクラス定義と同期させます：

```csharp
#if DEBUG
// 1. プロジェクトルートが存在することを確認
Port.Repository.New(@"D:\sample\Repo\pull\", "sample");

// 2. 外部ドキュメントをエントリに変換
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

// 3. インライン定義されたエントリをプッシュ（列挙型 + EFEM シグナル）
Port.Push("sample", new CustomEFEM());

// 4. ドキュメントから派生したエントリをプッシュ
Port.Push("sample", ioDoc.NewPage("Device"));

// 5. DB から .page/.enum ファイルを再構築
Port.Pull("sample", @"D:\sample\Repo\pull\");
#endif
```

---

## 2. ページをモデルにマッピングする

### 2.1 モデルとは？

**モデル（Model）** は Port エントリと C# プロパティを結びつける**データバインディング層**です。

- クラスを `[Model]` 属性で宣言します。
- 各プロパティは `[ModelBinding]` を介して特定のエントリにリンクされます。
- コントローラーとフローはモデルを通じてエントリ値を読み書きします。

---

### 2.2 モデルとページの関係

```
.page ファイル（エントリ定義）
    ↓  Push
Port インメモリ DB（エントリ値）
    ↕  ModelBinding
モデル（C# プロパティ ↔ エントリマッピング）
    ↕
コントローラー / フロー（ビジネスロジック）
```

ページは**唯一の信頼できる情報源（Single Source of Truth）**であり、
モデルはコード内のデータの**型安全なビュー**です。

---

### 2.3 モデルをページにマッピングする方法

`[ModelBinding(instanceKey, entryKey)]` 属性を使用します。

- **第 1 引数** — コントローラーインスタンスキー（例：`"Bulb1"`、`"LP1"`）
- **第 2 引数** — 自動生成された `.cs` ファイルのエントリ定数

```csharp
[Model]
public class BulbModel
{
    // "Bulb1" と "Bulb2" のインスタンスは同じプロパティ構造を共有
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

`[ModelBinding]` 属性は、自動生成クラスとユーザー定義 `[Page]` クラスのエントリを自由に混在させることができます：

```csharp
[Model]
public class LoadportModel
{
    // CustomEFEM 経由で追加されたエントリ
    [ModelBinding("LP1", CustomEFEM.LP1_Cont1_o)]
    // 自動生成された EFEM クラスのエントリ
    [ModelBinding("LP2", EFEM.LP2_Cont_o)]
    public Entry LP_Cont_o { get; set; }

    [ModelBinding("LP1", CustomEFEM.LP1_OffOn_o)]
    public Entry LP_OffOn_o { get; set; }
}
```

---

## 3. コントローラーとフローでモデルを使用する

### 3.1 コントローラーとは？

**コントローラー（Controller）** は 1 つ以上の**フロー（Flow）** を保持するロジックコンテナです。

- `[Controller]` 属性で宣言します。
- `Port.Add<TController, TModel>(instanceKey)` で登録します。
- 同じコントローラーを複数のインスタンス（例：LP1、LP2）で再利用できます。

```csharp
Port.Add<BulbController, BulbModel>("Bulb1");
Port.Add<BulbController, BulbModel>("Bulb2");
Port.Run();
```

---

### 3.2 フローとは？

**フロー（Flow）** はコントローラー内で定義される**シーケンシャルワークフロー**です。

- 内部クラスを `[Flow("FlowName")]` で宣言します。
- 各ステップを `[FlowStep(order)]` で修飾されたメソッドとして定義します。
- `Port.Set("Bulb1", FlowAction.Executing)` で外部から実行をトリガーします。

---

### 3.3 フロー内でモデルを扱う

メソッドパラメータとしてモデルを直接受け取ることでエントリ値にアクセスできます：

```csharp
[Controller]
public class BulbController
{
    [Flow("BulbOn")]
    public class BulbOn
    {
        [Handler]
        public IFlowHandler handler { get; set; } = null!;

        [FlowStep(0)] // 検証ステップ
        public void CheckInitialState(BulbModel model)
        {
            if (model.Temp.Value <= 100)
                handler?.Next();
        }

        [FlowStep(1)] // アクションステップ
        public void TurnOn(BulbModel model)
        {
            model.OnOff.Set("On");
            handler?.Next();
        }

        [FlowStep(2)] // 監視ステップ
        public void MonitorTemperature(BulbModel model)
        {
            if (model.Temp.Value >= model.TargetTemp.Value)
            {
                model.OnOff.Set("Off");
                handler?.Next(); // フローを完了としてマーク
            }
        }
    }
}
```

**フローの開始 / キャンセル：**

```csharp
Port.Set("Bulb1", FlowAction.Executing);   // BulbOn フローを開始
Port.Set("Bulb1", FlowAction.Canceled);    // キャンセル
```

---

### 3.4 アプリケーションエントリポイント（`Port.App<T>`）

`Port.App<T>()` は、`[Port]` 属性ベースの初期化スタイルを使用する際の**必須の最初の呼び出し**です。
アプリケーションクラスに `[Port]` を付けてリポジトリ名とプルパスを宣言し、
他の Port API より前に `Port.App<T>()` を呼び出してください。

```csharp
[Port("sample")]
public class SampleApp { }

// スタートアップ時（例：コンストラクタまたは Program.cs）— 最初に呼び出す必要があります
Port.App<SampleApp>();
```

`Port.App<T>()` は `T` の `[Port]` 属性を読み取り、`Port.Repository.New(pullPath, reponame)` 経由で
リポジトリを作成し、`PortDic` インスタンスを起動します。
後続のすべての `Port.Push`、`Port.Pull`、`Port.Repository.Load` 呼び出しは、
この初期化の完了に依存しています。

#### 完全なスタートアップ例

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

## 4. ハンドラー

### 4.1 ハンドラーの種類

| インターフェース | 目的 |
|---------------|------|
| `IFlowHandler` | 基本的なフロー進行制御（`Next()`） |
| `IFlowWithModelHandler<T>` | モデルを持つフローイベントサブスクリプション |
| `ISchedulerHandler<T>` | 転送完了スケジューリング |

---

### 4.2 ハンドラーの役割と使用方法

#### IFlowHandler — 基本的な進行制御

```csharp
[Handler]
public IFlowHandler handler { get; set; } = null!;

handler.Next();   // 次の FlowStep に進む
handler.Done();   // フローを Idle に同期的に強制する
```

#### IFlowWithModelHandler\<T\> — イベント駆動型モデルアクセス

`IFlowCACD<T>` は機器転送フローに推奨されるインターフェースです。
ハンドラーを `IFlowWithModelHandler<T>` として宣言することで、モデルを持つフロー
ライフサイクルイベントにアクセスできます。`[Preset]` でサブスクライブします —
サブスクリプションは同じフローキーのすべての実行にわたって維持されます。

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

        // Preset() は登録時に一度だけ実行されます。
        // ここでのイベントサブスクリプションはその後のすべての実行で保持されます。
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

#### handler.Next() と handler.Done() の違い

| メソッド | 動作 |
|---------|------|
| `handler.Next()` | 通常のステートマシン経由で次のステップに進む |
| `handler.Done()` | フローを `Idle` に**同期的に**強制してから返り、その後 `OnFlowFinished` を発火する |

`OnFlowFinished` コールバック内で兄弟フローを開始する必要がある場合は、最後のステップで
`handler.Done()` を使用します。そこで `handler.Next()` を使うと、コールバックが発火した時点で
フローがまだ `Idle` に遷移していないため `AlreadyExecutingFlowException` が発生する可能性があります。

---

### 4.3 ハンドラープロパティ一覧

#### IFlowCACD\<T\> — 標準 4 ステップフロー

機器転送フローに推奨されるインターフェースです。ステップの順序は固定されています：

| ステップ | メソッド | 説明 |
|---------|---------|------|
| 0 | `CheckStatus` | アクション前に前提条件を検証する |
| 1 | `Action` | 物理操作を実行する |
| 2 | `CheckAction` | 操作が正常に完了したことを確認する |
| 3 | `Done` | 完了 — `handler.Done()` を呼び出してフローを閉じる |

#### IFlowWithModelHandler\<T\> ライフサイクルイベント

| イベント | 発火タイミング | 引数 |
|---------|-------------|------|
| `OnFlowFinished` | フローが Done ステップに到達して完了した | `FlowFinishedWithModelArgs<T>` — モデル、タイミング、ステップ記録 |
| `OnFlowOccured` | ステップ遷移が発生した | `PortFlowOccuredWithModelArgs<T>` — モデル、ステップ状態 |
| `OnFlowIssue` | アラームによりフローが停止した | `PortFlowIssueWithModelArgs<T>` — モデル、アラームコード |

すべてのイベント引数は `Model` プロパティを公開しており、それはフローキーにバインドされた
シングルトンモデルインスタンスです。そのため `e.Model.Target.Value` は常に
現在の共有メモリ値を反映します。

---

## 5. パッケージの呼び出し

### 5.1 パッケージとは？

**パッケージ（Package）** は物理デバイス（電球、ヒーター、IO カードなど）と
Port エントリを橋渡しする**再利用可能なデバイスドライバーモジュール**です。

- `.page` ファイルで `pkg:PackageName.PropertyName` 構文を使ってパッケージをリンクします。
- C# クラスを `[Package]` 属性で宣言します。
- エントリ値が変化すると、パッケージの対応するプロパティセッターが自動的に呼び出されます。

---

### 5.2 パッケージ API の呼び出し方

#### `.page` ファイルでパッケージをリンクする

```text
Bulb1OnOff  Enum.OnOff  pkg:Bulb.OffOn  property:{"IO.No":"D0.01"}
Bulb1Temp   f8          pkg:Bulb.Temp   property:{"IO.No":"A0.01"}
```

#### `[Page]` クラスからパッケージをリンクする

`[PageEntry]` 属性の `Package` パラメータを使用します：

```csharp
[Page("EFEM")]
public partial class CustomEFEM
{
    // Package: "Name.PropertyName" → pkg:Name.PropertyName としてプッシュ
    // Property: 生の JSON 文字列  → property:{...} としてプッシュ
    [PageEntry(PortDataType.Enum, EnumName = "OffOn",
        Package  = "Bulb1.OffOn",
        Property = "{\"MIN\":0,\"MAX\":1}")]
    public const string LP1_BulbOnOff_o = "EFEM.LP1_BulbOnOff_o";
}
```

#### パッケージクラスの実装

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

    // エントリ値が変化したときにセッターが自動的に呼び出される
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

`Port.Run()` の前に `[Page]` クラスをプッシュします：

```csharp
Port.Push("sample", new CustomEFEM());
```

---

## 6. Port.Set

`Port.Set` は指定されたエントリに値を即座にインメモリ DB へ書き込みます。
そのエントリにパッケージがバインドされている場合、セッターが呼び出されて
物理操作がトリガーされます。

### 基本的な使用方法

```csharp
// エントリ値を書き込む
Port.Set("Bulb1.OnOff", "On");
Port.Set("Bulb1.TargetTemp", "85.0");

// フローをトリガー / キャンセルする
Port.Set("Bulb1", FlowAction.Executing);
Port.Set("Bulb1", FlowAction.Canceled);
```

### モデルプロパティ経由での Set

```csharp
// フロー内 — モデルパラメータを通して直接設定する
model.OnOff.Set("On");
model.TargetTemp.Set("80.0");
```

### IFlowModel 経由での Set（`@` バインディング）

```csharp
[FlowModel]
public IFlowModel model { get; set; }

model.Set("@OnOff", "On");   // @ プレフィックスは ModelBinding キーを参照する
```

---

## 7. Port.Get

`Port.Get` は指定されたエントリの現在値をインメモリ DB から読み取ります。
常に最新の値を返し、高性能なインメモリアクセスをサポートします。

### 基本的な使用方法

```csharp
// エントリ値を読み取る
string onOff = Port.Get("Bulb1.OnOff");   // → "On" または "Off"

if (Port.Get("Bulb1.OnOff") == "On")
{
    Port.Set("Bulb1.OnOff", "Off");
}
```

### モデルプロパティ経由での Get

```csharp
// Entry.Value プロパティを通じて現在値にアクセスする
double temp   = (double)model.Temp.Value;
string status = (string)model.OnOff.Value;
```

### IFlowModel 経由での Get（`@` バインディング）

```csharp
var value = model.Get("@Temp");   // ModelBinding キーにバインドされたエントリを読み取る
```

---

## 8. ルールスクリプトで Set/Get を制御する

**ルールスクリプト（Rule Script）** は `app/` ディレクトリに保存された `.rule` ファイル
（例：`app/.rule`）を使って書き込みガードと定期的な自動化を定義します。
`set` と `get` の 2 種類のルールが利用できます。

---

### 8.1 `set` ルール — 書き込みガード

`set` ルールは、対応するキーに対して `Port.Set` が呼び出されるたびに**同期的に評価**されます。
**ゲート**として機能し、許可条件が満たされない場合、書き込みは**ブロック**されてエラーが返されます。

#### 構文

```
set("書き込み条件", "許可条件")
```

| 引数 | 役割 |
|------|------|
| 第 1 引数 — 書き込み条件 | このルールをトリガーする書き込み試行を指定します。<br>ベアキー（`Bulb1.OnOff`）は任意の書き込みに一致し、<br>キー+演算子+値（`Bulb1.OnOff == Off`）はその値のみに一致します。 |
| 第 2 引数 — 許可条件 | **現在の**メモリ状態に対して評価されるブール式。<br>`true` → 書き込みが**許可**されます。`false` → 書き込みが**ブロック**されます。 |

#### 例

```text
// 温度が安全な場合（>= 80）にのみ Bulb1 をオフにすることを許可する
set("Bulb1.OnOff == Off", "Bulb1.Temp >= 80")

// Bulb1 がまだオンの間は Bulb2.OnOff への任意の書き込みをブロックする
set("Bulb2.OnOff", "Bulb1.OnOff == Off")
```

> `set` ルールは書き込みの**前の**状態に対して許可条件を評価します。
> 一致するルールの許可条件が false の場合、書き込みはブロックされます。

---

### 8.2 `get` ルール — 定期的な自動化

`get` ルールはバックグラウンドで**毎秒**実行されます。条件が `true` になると、
リストされた代入が**一度だけ**実行されます（ワンショット）。
条件が一度 `false` になってから再び `true` になるまで再トリガーされません。

#### 構文

```
get("条件", "key1=value1; key2=value2; ...")
```

| 引数 | 役割 |
|------|------|
| 第 1 引数 — 条件 | 現在のメモリ状態に対して評価されるブール式 |
| 第 2 引数 — 代入 | 条件が `true` のときに書き込むセミコロン区切りの `key=value` ペア |

#### 例

```text
// Bulb1 の温度が 80 以上に達したら自動的にオフにする
get("Bulb1.Temp >= 80", "Bulb1.OnOff=Off")

// 両方の温度が範囲内に入ったら両方の電球をリセットする
get("(Bulb1.Temp >= 0) && (Bulb2.Temp >= 0)", "Bulb1.OnOff=Off; Bulb2.OnOff=Off")
```

> 条件は再実行するために **false → true** に遷移する必要があります。
> 一度発火すると、条件がリセットされるまで代入は繰り返されません。

---

### 8.3 演算子

**比較演算子**（両方のルールタイプ）：

| 演算子 | 説明 |
|--------|------|
| `==` | 等しい（文字列または数値） |
| `>` | より大きい |
| `<` | より小さい |
| `>=` | 以上 |
| `<=` | 以下 |

**論理演算子**（括弧で条件を組み合わせる）：

| 演算子 | 説明 |
|--------|------|
| `&&` | 論理 AND |
| `\|\|` | 論理 OR |

組み合わせる際は常に各サブ条件を括弧で囲んでください：

```text
(Bulb1.Temp >= 80) && (Bulb2.Temp >= 80)
(Bulb1.OnOff == Off) || (Bulb2.OnOff == Off)
```

---

### 8.4 完全な `.rule` ファイルの例

```text
// ── SET ルール（書き込みガード）──────────────────────────────────────────
// 温度が目標に達するまで Bulb1 をオフにすることをブロックする
set("Bulb1.OnOff == Off", "Bulb1.Temp >= 80")

// 両方の電球が十分に温まるまで Bulb2 をオフにすることをブロックする
set("Bulb2.OnOff == Off", "(Bulb1.Temp >= 80) && (Bulb2.Temp >= 80)")

// ── GET ルール（定期的な自動化）──────────────────────────────────────────
// 温度が上限を超えたら自動的にオフにする
get("Bulb1.Temp >= 100", "Bulb1.OnOff=Off")

// 両方の温度が安全になったら両方の電球をリセットする
get("(Bulb1.Temp >= 0) && (Bulb2.Temp >= 0)", "Bulb1.OnOff=Off; Bulb2.OnOff=Off")
```

---

### 8.5 フロー内での条件監視

フロー状態に依存するロジックには、ルールファイルではなくフローステップ内で
直接条件を記述します：

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

### 8.6 データフロー

```
Port.Set("Bulb1.OnOff", "Off") が呼び出される
    ↓
set ルールが評価される（書き込みガード）
    ├─ 許可条件が true  → 書き込み実行 → パッケージセッター呼び出し → ハードウェアが応答
    └─ 許可条件が false → 書き込みがブロックされ、エラーが返される

毎秒（バックグラウンド）
    ↓
get ルール条件が評価される
    ├─ 条件が true（初回）→ 代入が実行される → 内部的に Port.Set が呼び出される
    └─ 条件が false またはすでに発火済み → アクションなし
```

> ルールスクリプトはフローとは独立して動作します。
> `.rule` ファイルを編集することでいつでも条件を変更できます —
> コードの再コンパイルは不要です。
