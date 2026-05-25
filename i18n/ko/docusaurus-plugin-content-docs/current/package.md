# Package

## Overview

A Port package is a C# class library that exposes device or service logic as typed API endpoints. Annotate a class with `[Package]`, declare `[API]` properties for each entry point, and the framework generates REST endpoints, injects handlers, and manages the lifecycle automatically.

Port packages provide:
- Declarative API generation via attributes
- Unified logging and entry-property access through `IPackageHandler`
- Validation gate with `[Valid]`
- Seamless `.page` entry binding through `property:{...}` metadata

## NuGet

| Package | Language | Package Manager | OS |
|---------|----------|-----------------|----|
| `portdic` | C# | NuGet | Windows |

---

## Attribute Summary

| Attribute | Target | Injected Type | Description |
|-----------|--------|---------------|-------------|
| `[Package]` | class | — | Registers the class as a Port-managed package |
| `[Handler]` | property | `IPackageHandler` | Injects handler — unified access to logging and entry property |
| `[Preset]` | method | — | Called once after injection; use for initialization |
| `[API]` | property, field | — | Generates a REST API endpoint for the member |
| `[Valid]` | method | — | Validation gate — `false` blocks the call with the error message |
| `[Comment]` | property | — | Attaches documentation text to an API property |

---

## Attribute Reference

### `[Package]`

Marks a class as a Port-managed package. Register it at startup via `Port.Add<T>(name)`.

```csharp
[Package]
public class Bulb
{
    [Handler]
    public IPackageHandler Handler { get; set; }

    [Valid("Device not connected")]
    public bool Valid() => serialPort.IsOpen;

    [API(EntryDataType.Enum)]
    public string OffOn { get; set; } = "Off";
}
```

```csharp
Port.Add<Bulb>("Bulb1");
Port.Run();
```

### `[Handler]`

Injects `IPackageHandler` — the single entry point for logging and entry-property access. Call `SetLogger` in `[Preset]` to enable file output; use `Handler.Write` and `Handler.EntryProperty` anywhere inside the package.

```csharp
[Package]
public class Heater
{
    [Handler]
    public IPackageHandler Handler { get; set; }

    [Preset]
    public void Preset()
    {
        Handler.SetLogger(@"C:\Logs");   // writes to C:\Logs\Heater\
    }

    [API(EntryDataType.Num, PropertyFormat.Json, "Unit")]
    public double Temp
    {
        get
        {
            if (Handler.EntryProperty.TryToGetValue("Unit", out string unit))
            {
                Handler.Write($"[INFO] Unit={unit}");
                return unit == "F" ? 212.0 : 100.0;
            }
            return double.NaN;
        }
    }
}
```

**`IPackageHandler` members:**

| Member | Description |
|--------|-------------|
| `SetLogger(rootPath)` | Enable file logging; creates `rootPath/packageName/` |
| `SetLogger(rootPath, conf)` | Same with rotation/retention via `PortLogConfiguration` |
| `Write(message)` | Write a plain text log entry |
| `Write(code, header, dict)` | Write a structured log entry (`LogTypeCode`, header, key-value pairs) |
| `EntryProperty` | Current `IProperty` for the active Get/Set call |

**Reading entry properties (`property:{...}` in `.page`):**

```csharp
// .page:  RoomTemp  f8  property:{"Unit":"C","Max":"300"}

if (Handler.EntryProperty.TryToGetValue("Unit", out string unit))
{
    // unit == "C"
}
if (Handler.EntryProperty.TryToGetValue("Max", out string max))
{
    double limit = double.Parse(max);   // 300.0
}
```

### `[Preset]`

Called once after all injections are complete. Use it to configure the handler or subscribe to events.

```csharp
[Preset]
public void Preset()
{
    Handler.SetLogger(@"C:\Logs");
}
```

### `[API]`

Registers a property or field as a REST API endpoint.

```csharp
[API]
public string Status { get; set; }

[API(EntryDataType.Enum)]
public string OffOn { get; set; }

[API(EntryDataType.Num, PropertyFormat.Json, "Unit")]
public double Temp { get; set; }

[API(EntryDataType.Char)]
public string Power { get; set; }
```

**`EntryDataType` values:**

| Value | Description |
|-------|-------------|
| `EntryDataType.Text` | Text |
| `EntryDataType.Num` | Numeric (`double`) |
| `EntryDataType.Char` | ASCII string |
| `EntryDataType.Enum` | Enumeration |
| `EntryDataType.List` | List |

### `[Valid]`

Defines a validation gate. When the method returns `false`, the error message is surfaced and the call is blocked.

```csharp
[Valid("Device not connected")]
public bool Valid()
{
    return serialPort.IsOpen;
}
```

### `[Comment]`

Attaches a documentation string to an API property, visible through the API metadata.

```csharp
[API, Comment("Current temperature in Celsius")]
public double Temperature { get; set; }
```


---

## Creating a Package

### 1. Create a class library project

```bash
dotnet new classlib -n HeaterLib
cd HeaterLib
dotnet add package portdic
```

### 2. Implement the package class

```csharp
using Portdic;

[Package]
public class Heater
{
    [Handler]
    public IPackageHandler Handler { get; set; }

    [Preset]
    public void Preset()
    {
        Handler.SetLogger(@"C:\Logs");
    }

    [Valid("Connection not established")]
    public bool Valid() => true;

    [API]
    public string Power { get; set; }

    [API(EntryDataType.Num, PropertyFormat.Json, "Unit")]
    public double Temp
    {
        get
        {
            if (Handler.EntryProperty.TryToGetValue("Unit", out string unit))
            {
                Handler.Write($"[INFO] Unit={unit}");
                return unit == "F" ? 212.0 : 100.0;
            }
            return double.NaN;
        }
    }
}
```

### 3. Build and publish

```bash
dotnet publish -c Release -o ./publish
```

### 4. Pack for Port

```bash
cd ./publish
port pack HeaterLib.dll HeaterLib
```

Console output on success:

```text
[PACK] Packing started at 2025-01-07T21:17:19+09:00
[PACK] load complete HeaterLib.dll : heaterlib
[PACK][GET][0] Power
[PACK][GET][1] Temp
[PACK][SET][0] Power
[CREATED][PACKAGE] ...\port\pkg\HeaterLib.pkg
```

### 5. Register and run

```csharp
Port.Add<Heater>("Heater1");
Port.Add<Heater>("Heater2");   // multiple instances with independent state
Port.Run();
```

---

## Publishing

### Build commands

```bash
# Standard release
dotnet publish -c Release -o ./publish

# Platform-specific (no runtime bundled)
dotnet publish -c Release -r win-x64 --self-contained false
```

### VS Code task automation

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Publish",
            "command": "dotnet",
            "type": "process",
            "args": ["publish", "-c", "Release", "-o", "./publish"],
            "problemMatcher": "$msCompile"
        }
    ]
}
```

---

## Related

- [attribute](attribute) — Full attribute reference
- [Quick Start](quick) — End-to-end setup with `.page` files and `Port.Run()`
