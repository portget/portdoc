# 快速入门

使用 Port 构建 .NET 设备应用程序的分步指南。

---

## 1. 将文档转换为页面

### 1.1 什么是页面？

**页面（Page）** 是 Port 系统的基本数据定义单元。
一个 `.page` 文件是相关 **条目（Entry）** 的集合。
推送到 Port 服务器后，这些条目将在内存数据存储中创建。

> Page = 属于一个功能单元的条目列表（如 IO、传感器、电机）

页面可以从外部文档（`.docx`、`.xlsx`、`.csv`）自动生成，
也可以在 C# 中使用 `[Page]` 特性直接定义。

---

### 1.2 页面结构与作用

#### `.page` 文件语法

```text
[EntryKey]  [DataType]  [pkg:PackageName]  [property:{...}]
```

| 字段 | 必填 | 说明 |
|------|------|------|
| `EntryKey` | ✅ | 条目的唯一标识符 |
| `DataType` | ✅ | 数据类型（`f8`、`Enum.OnOff`、`char` 等） |
| `pkg` | 可选 | 要绑定的包 API |
| `property` | 可选 | 条目用户属性（JSON） |

**示例 (`io.page`)：**

```text
Bulb1OnOff    Enum.OnOff  property:{"IO.No":"D0.01","Model":"IODevice"}
Bulb2OnOff    Enum.OnOff  property:{"IO.No":"D0.02","Model":"IODevice"}
Bulb1Temp     f8          property:{"IO.No":"A0.01","Model":"IODevice"}
Bulb2Temp     f8          property:{"IO.No":"A0.02","Model":"IODevice"}
```

#### 条目结构

**条目（Entry）** 是 Port 系统中最小的数据单元。每个条目包含：

- **Key** — 完全限定标识符（`category.entryName`，如 `Bulb1.OnOff`）
- **DataType** — 值的类型（数值、枚举、字符等）
- **Value** — 内存中保存的当前值（实时状态）
- **Property** — 硬件地址、单位等补充配置（JSON）

**SECS 兼容数据类型：**

| 类型 | 说明 |
|------|------|
| `f4` / `f8` | 浮点数（4 / 8 字节） |
| `i1` ~ `i8` | 有符号整数 |
| `u1` ~ `u8` | 无符号整数 |
| `char` | ASCII 字符串 |
| `string` | 可变长度 UTF-8 字符串（最大 255 字节） |
| `Enum.XXX` | 引用预定义枚举的枚举类型 |
| `bool` | 布尔值 |

---

### 1.3 将文档转换为页面

框架将规格表转换为结构化数据模型。

#### 源规格

假设 `C:\Users\admin\Documents\IO.docx` 中存在以下表格：

| IO.No | Description | Model |
| --- | --- | --- |
| D0.01 | Bulb1.OnOff | IODevice |
| D0.02 | Bulb2.OnOff | IODevice |
| A0.01 | Bulb1.Temp | IODevice |
| A0.02 | Bulb2.Temp | IODevice |

[图1：示例规格表](./file/IO.docx)

#### 定义文档模型

使用特性将表格列映射到 C# 类。

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

| 特性 | 作用 |
|------|------|
| `[ColumnHeader]` | 按名称将属性映射到 Excel/Word 列 |
| `[EntryKey]` | 将此列指定为条目名称 |
| `[EntryProperty]` | 将此列包含在 `property:{...}` JSON 中 |

#### 生成的 `.cs` 文件

```csharp
// 由 Port 自动生成。请勿手动编辑。
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

[图2：示例 .cs 文件](./file/io.cs)

---

### 1.4 使用 `[Page]` 定义内联条目

对于不来自外部文档的条目（如 EFEM I/O 信号），
在用 `[Page]` 装饰的 C# 类中直接定义。

#### 自动生成类（由 `Port.Pull` 生成）

`Port.Pull` 会写出一个 `partial` 类文件（如 `entry.cs`），
其中以 `const string` 形式包含所有被拉取的条目。
该文件在每次 Pull 时都会重新生成 — **请勿手动编辑**。

`entry.cs` 中还会自动生成包含数据库中所有枚举定义的 `Defined` 类，
与条目常量并列生成。

```csharp
// 由 Port.Pull 自动生成 — 请勿手动编辑。
namespace Portdic
{
    public partial class EFEM
    {
        public const string LP1_Main_Air_i = "EFEM.LP1_Main_Air_i";
        public const string LP2_Cont_o     = "EFEM.LP2_Cont_o";
        // ... 所有被拉取的条目 ...
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
        // ... 数据库中的所有枚举 ...
    }
}
```

#### 用户自定义扩展（`CustomEFEM`）

对于被拉取的类中尚未包含的条目和枚举类型，
通过创建单独的 `[Page]` 修饰 `partial class` 来添加。

规则：
- **字段值** 即枚举键 — `[PageEntry]` 的 `EnumName` 必须完全匹配。
- `[PageEnum]` 字段在 `[PageEntry]` 字段**之前**被推送，以确保枚举引用始终可解析。
- 枚举定义存储在 `app/.enum` 中，以便 `port pull` 将其保存到正确的文件。

```csharp
using Portdic;
using Portdic.SECS;

namespace sample.Controller
{
    [Page("EFEM")]
    public partial class CustomEFEM
    {
        // ── 枚举声明 ─────────────────────────────────────────
        [PageEnum("Unknown", "Off", "On")]
        public const string UnkOffOn = "UnkOffOn";

        // ── 条目声明 ────────────────────────────────────────
        [PageEntry(PortDataType.Char)]
        public const string LP1_Cont1_o = "EFEM.LP1_Cont1_o";

        [PageEntry(PortDataType.Enum, EnumName = "OffOn",
            Package  = "Bulb1.OffOn",
            Property = "{\"MIN\":0,\"MAX\":1}")]
        public const string LP1_BulbOnOff_o = "EFEM.LP1_BulbOnOff_o";
    }
}
```

在启动 Port 服务器之前推送类实例：

```csharp
Port.Push("sample", new CustomEFEM());
```

---

### 1.5 推送和拉取页面

#### Push — 向服务器注册条目

```csharp
// 从 [Page] 装饰类推送（枚举 + 条目）
Port.Push("sample", new CustomEFEM());

// 从文档派生的 Page 推送（仅条目）
Port.Push("sample", ioDoc.NewPage("Device"));
```

#### Pull — 从数据库重建文件

```csharp
// 将文件写入 D:\sample\Repo\pull\port\
Port.Pull("sample", @"D:\sample\Repo\pull\");
```

#### 完整初始化模式 (`#if DEBUG`)

```csharp
#if DEBUG
Port.Repository.New(@"D:\sample\Repo\pull\", "sample");

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
Port.Pull("sample", @"D:\sample\Repo\pull\");
#endif
```

---

## 2. 将页面映射到模型

### 2.1 什么是模型？

**模型（Model）** 是将 Port 条目与 C# 属性连接的**数据绑定层**。

使用 `[ModelBinding(instanceKey, entryKey)]` 特性进行映射：

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

## 3. 在控制器和流程中使用模型

### 3.1 控制器与流程

**控制器（Controller）** 是包含一个或多个**流程（Flow）** 的逻辑容器。

```csharp
Port.Add<BulbController, BulbModel>("Bulb1");
Port.Add<BulbController, BulbModel>("Bulb2");
Port.Run();
```

**流程（Flow）** 是在控制器内部定义的**顺序工作流**。

```csharp
[Controller]
public class BulbController
{
    [Flow("BulbOn")]
    public class BulbOn
    {
        [Handler]
        public IFlowHandler handler { get; set; } = null!;

        [FlowStep(0)] // 验证步骤
        public void CheckInitialState(BulbModel model)
        {
            if (model.Temp.Value <= 100)
                handler?.Next();
        }

        [FlowStep(1)] // 动作步骤
        public void TurnOn(BulbModel model)
        {
            model.OnOff.Set("On");
            handler?.Next();
        }

        [FlowStep(2)] // 监控步骤
        public void MonitorTemperature(BulbModel model)
        {
            if (model.Temp.Value >= model.TargetTemp.Value)
            {
                model.OnOff.Set("Off");
                handler?.Next();
            }
        }
    }
}
```

**启动 / 取消流程：**

```csharp
Port.Set("Bulb1", FlowAction.Executing);   // 启动
Port.Set("Bulb1", FlowAction.Canceled);    // 取消
```

---

## 4. 处理器

### 4.1 处理器类型

| 接口 | 用途 |
|------|------|
| `IFlowHandler` | 基本流程推进控制（`Next()`） |
| `IFlowWithModelHandler<T>` | 携带模型的流程事件订阅 |
| `ISchedulerHandler<T>` | 传输完成调度 |

### 4.2 IFlowCACD\<T\> — 标准4步流程

| 步骤 | 方法 | 说明 |
|------|------|------|
| 0 | `CheckStatus` | 动作前验证前提条件 |
| 1 | `Action` | 执行物理操作 |
| 2 | `CheckAction` | 确认操作正确完成 |
| 3 | `Done` | 完成 — 调用 `handler.Done()` 关闭流程 |

---

## 5. 调用包

**包（Package）** 是连接物理设备与 Port 条目的**可复用设备驱动模块**。

```csharp
[Package]
public class Bulb
{
    [Logger]
    public ILogger Logger { get; set; }

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

`Port.Set` 立即将值写入内存数据库中的指定条目。

```csharp
Port.Set("Bulb1.OnOff", "On");
Port.Set("Bulb1", FlowAction.Executing);

// 通过模型
model.OnOff.Set("On");
```

---

## 7. Port.Get

`Port.Get` 从内存数据库读取指定条目的当前值。

```csharp
string onOff = Port.Get("Bulb1.OnOff");

// 通过模型
double temp = (double)model.Temp.Value;
```

---

## 8. 使用规则脚本控制 Set/Get

**规则脚本（Rule Script）** 使用存储在 `app/` 目录的 `.rule` 文件定义写入守卫和周期性自动化。

### 8.1 `set` 规则 — 写入守卫

```
set("写入条件", "允许条件")
```

```text
// 仅当温度安全时（>= 80）才允许关闭 Bulb1
set("Bulb1.OnOff == Off", "Bulb1.Temp >= 80")
```

### 8.2 `get` 规则 — 周期性自动化

每秒在后台运行一次。条件变为 `true` 时执行一次赋值。

```
get("条件", "key1=value1; key2=value2; ...")
```

```text
// Bulb1 温度达到 80 以上时自动关闭
get("Bulb1.Temp >= 80", "Bulb1.OnOff=Off")
```

### 8.3 完整 `.rule` 文件示例

```text
set("Bulb1.OnOff == Off", "Bulb1.Temp >= 80")
set("Bulb2.OnOff == Off", "(Bulb1.Temp >= 80) && (Bulb2.Temp >= 80)")

get("Bulb1.Temp >= 100", "Bulb1.OnOff=Off")
get("(Bulb1.Temp >= 0) && (Bulb2.Temp >= 0)", "Bulb1.OnOff=Off; Bulb2.OnOff=Off")
```

> 规则脚本独立于流程运行。
> 编辑 `.rule` 文件即可随时修改条件，无需重新编译代码。
