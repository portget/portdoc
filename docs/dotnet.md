# .NET Integration Guide

## Table of Contents

- [Overview](#overview)
- [.NET Integration](#dotnet-integration)
  - [Initialization and Setup](#dotnet-initialization)
  - [Event Handling](#dotnet-event-handling)
  - [Test Package Integration](#test-package-integration)
  - [SET/GET Operations](#dotnet-set-get-operations)
- [PortDic Features](#portdic-features)
- [Project Execution](#project-execution)
  - [Repository Updates](#repository-updates)
  - [Console Execution](#console-execution)
  - [GUI Application](#gui-application)
- [Logging and Monitoring](#logging-and-monitoring)
  - [Log System Overview](#log-system)
  - [Log Categories](#log-categories)
  - [File-based Logging](#file-logging)
  - [SSH Log Access](#ssh-log-access)
- [Package Development](#package-development)
  - [Package Development Overview](#package-development-overview)
  - [Package Annotations System](#package-annotations-system)
  - [Creating .NET Packages](#creating-net-packages)
  - [Publishing Libraries](#publishing-libraries)

---

## Overview

This guide provides comprehensive information for integrating .NET applications with the Port system. It covers initialization, event handling, package development, and project execution.

### .NET Integration {#dotnet-integration}

#### Initialization and Setup {#dotnet-initialization}

```csharp
private static IPortDic port = Port.GetDictionary("sample");

public Form()
{
   InitializeComponent();
   
   // Event handlers
   port.OnOccurred += Port_OnOccurred;
   port.OnStatusChanged += Port_OnStatusChanged;
   
   // Start the Port system
   port.Run(); 
}
```

#### Event Handling {#dotnet-event-handling}

##### Status Change Events

```csharp
/// <summary>
/// The OnStatusChanged event notifies when the port server status changes.
/// Provides details through PortStatusHandler.
/// </summary>
private void Port_OnStatusChanged(object sender, PortStatusArgs e)
{
    switch (e.Status)
    {
        case PortStauts.Initializing:
            break;
        case PortStauts.Running:
            OnReady = true;
            break;
        case PortStauts.Stopped:
            break;
        case PortStauts.Shutdown:
            break;
        case PortStauts.Failed:
            break;
    }
}
```

##### Occurrence Events

```csharp
/// <summary>
/// The OnOccurred event handles system events and messages.
/// Provides event details through PortEventArgs.
/// </summary>
private void Port_OnOccurred(object sender, PortEventArgs e)
{
    switch (e.EventType)
    {
        default:
            Console.WriteLine(e.Message);
            break;
    }
}
```

#### Test Package Integration {#test-package-integration}

```csharp
private static IPortDic port = Port.GetDictionary("sample");

public Form()
{
  InitializeComponent();
  
  // Test Mode: Heater Class with messages
  port.Test("Heater1", new Heater());

  port.OnOccurred += Port_OnOccurred;
  port.OnStatusChanged += Port_OnStatusChanged;
  
  port.Run();
}
```

#### SET/GET Operations {#dotnet-set-get-operations}

```csharp
// Setting values
var ok = dic.Set("room1", "BulbOnOff", "On");
if(ok){
    Console.WriteLine("ok");
} 

// Getting values - returns 'On'
Console.WriteLine(dic.Get("room1", "BulbOnOff").Text()); 

// Alternative syntax
port["room1"].Set("BulbOnOff", "Off"); 

// Getting values - returns 'Off'
Console.WriteLine(dic.Get("room1", "BulbOnOff").Text()); 

// Getting temperature values
var t1 = dic.Get("room1", "RoomTemp1");
// random number unit Celsius
Console.WriteLine(t1.Text()); 

var t2 = dic.Get("room1", "RoomTemp2");
// random number unit Fahrenheit
Console.WriteLine(t2.Text());
```

### PortDic Features {#portdic-features}

| Feature | Description |
|---------|-------------|
| **Efficient Lookup** | Fast key-value pair retrieval |
| **Multi-platform Support** | Available across different programming languages |
| **Real-time Updates** | Live data synchronization |
| **Event-driven Architecture** | Responsive to system changes |
| **Test Mode Support** | Package testing and validation |
| **Type Safety** | Proper data type handling and conversion |

## Project Execution

### Repository Updates {#repository-updates}

Before starting your project, ensure all changes are committed to the repository:

```bash
port push
```

### Console Execution {#console-execution}

#### Starting the Server {#starting-server}

![Start Project Console](img/start%20project.png)

![Start Project Console 2](img/start%20project2.png)

**Command:**
```bash
port run [project-name]
```

**Process:**
1. **Upload Changes**: Use `port push` to sync repository
2. **Start Server**: Execute `port run [project-name]`
3. **Verify Operation**: Check console output for success/error messages

#### Error Handling {#error-handling}

!!! tip "Error Summarization"
    Use `--ng ignore` flag to summarize only error points:
    ```bash
    port run [project-name] --ng ignore
    ```
    
    **Detailed Error Analysis:**
    Visit [http://localhost:5001/api/app/ng/?view=table](http://localhost:5001/api/app/ng/?view=table) for comprehensive error details.

### GUI Application {#gui-application}

#### WPF Application Execution {#wpf-execution}

![Start Project WPF](img/start%20project%20with%20wpf%20netCore.png)


## Package Development

### Package Development Overview {#package-development-overview}

The Port package system allows developers to create reusable libraries by inheriting from `PortObject` and linking them to Messages. This enables straightforward usage through Message calls and promotes modular development.

Port packages provide a standardized way to:

| Capability | Description |
|------------|-------------|
| **Create reusable components** | Build modular libraries for repeated use |
| **Manage dependencies and configurations** | Handle package dependencies and settings |
| **Enable seamless integration** | Integrate smoothly with the Port ecosystem |
| **Facilitate API-driven interactions** | Support REST API-based communication |


### Package Annotations System {#package-annotations-system}

Port packages use annotations to define behavior, configuration, and API endpoints. These annotations provide metadata that the Port system uses for:

| Feature | Description |
|---------|-------------|
| **Class Registration** | Identifying Port-managed classes |
| **API Generation** | Creating REST endpoints automatically |
| **Dependency Injection** | Managing services and resources |
| **Validation** | Ensuring data integrity and business rules |

#### Annotation Reference {#annotation-reference-detailed}

| Name | Targets | Type | Arguments | Description |
|------|---------|------|-----------|-------------|
| [Port](#port-annotation-detailed) | class | `-` | `Class Type` | Declares a class as Port-managed for package registration |
| [Valid](#valid-annotation-detailed) | method, property | `bool` | `invalid comment` | Defines validation logic with custom error messages |
| [Message](#message-annotation-detailed) | property | `string`, `double` | `-` | Creates API endpoints for property access |
| [Logger](#logger-annotation-detailed) | property | `ILogger` | `-` | Enables dependency injection for logging services |
| [Property](#property-annotation-detailed) | property | `IProperty` | `Message name` | Maps properties to pre-declared Message Properties |
| [EnumCode](#enumcode-annotation-detailed) | enum | `-` | `-` | Exposes enum values through API endpoints |
| [Comment](#comment-annotation-detailed) | property | `-` | `comment text` | Provides API documentation for properties |

### Detailed Annotation Usage {#detailed-annotation-usage}

#### Valid Annotation {#valid-annotation-detailed}

The `Valid` annotation defines validation logic for methods or properties, with custom error messages for validation failures.

```csharp
[Valid("Invalid for connection")]
public bool Valid()
{
    return true;
}
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Target** | Applied to methods returning `bool` |
| **Error Handling** | Provides custom error messages for validation failures |
| **Execution** | Automatically called during package validation |

#### Port Annotation {#port-annotation-detailed}

The `Port` annotation indicates that a class is managed within the Port Package system.

```csharp
using portpackage;
using portdatatype;

[Port(typeof(Heater))]
public class Heater
{
    // Implementation
}
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Target** | Applied to class declarations |
| **Registration** | Registers the class with the Port system |
| **Functionality** | Enables package management and API generation |

#### Logger Annotation {#logger-annotation-detailed}

The `Logger` annotation specifies that a field should be injected with a logging system or service.

```csharp
using portpackage;
using portdatatype;

[Logger]
public ILogger Logger { get; set; }

// Usage example
Logger.Write(string.Join(",", values));
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Target** | Applied to `ILogger` properties |
| **Injection** | Enables dependency injection for logging |
| **Capability** | Provides centralized logging capabilities |

#### Property Annotation {#property-annotation-detailed}

The `Property` annotation maps a property to declared Message Properties for configuration access.

```csharp
using portpackage;
using portdatatype;

[Property]
public IProperty Property { get; set; }

// Usage example
if (this.Property.TryToGetValue("Unit", out string value))
{
    // Handle configuration value
}
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Target** | Applied to `IProperty` properties |
| **Access** | Enables access to configuration values |
| **Retrieval** | Supports key-value property retrieval |

#### Message Annotation {#message-annotation-detailed}

Properties declared with `Message` annotation become API endpoints, accessible via REST API.

```csharp
using portpackage;
using portdatatype;

private static Random r = new Random(100);

[Message(PortDataType.Num, PropertyFormat.Json, "Unit")]
public double Temp
{
    get
    {
        try
        {
            if (this.Property != null)
            {
                if (this.Property.TryToGetValue("Unit", out string v1) && (v1 == "F"))
                {
                    return (r.NextDouble() * 9 / 5) + 32;
                }
                else if (this.Property.TryToGetValue("Unit", out string v2) && (v2 == "C"))
                {
                    return (r.NextDouble());
                }
                else
                {
                    return double.NaN;
                }
            }
            return double.NaN;
        }
        catch (Exception e)
        {
            if (Logger != null)
                Logger.Write(e.Message);
        }
        return double.NaN;
    }
}
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Target** | Applied to properties with get/set accessors |
| **API Generation** | Creates REST API endpoints automatically |
| **Support** | Supports various data types and formats |

#### EnumCode Annotation {#enumcode-annotation-detailed}

The `EnumCode` annotation exposes enum values through API endpoints for external access.

```csharp
[EnumCode]
public enum TestEnum : ushort
{
    _ = 0,
    TestEnumItem1,
    TestEnumItem2,
}
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Target** | Applied to enum declarations |
| **Accessibility** | Makes enum values accessible via API |
| **Integration** | Enables external systems to query enum information |

#### Comment Annotation {#comment-annotation-detailed}

The `Comment` annotation provides documentation for properties, exposed through the API.

```csharp
[Message, Comment("this is a numeric")]
public int NValue { get => 3; }
```

**Usage:**

| Aspect | Description |
|--------|-------------|
| **Application** | Applied alongside other annotations |
| **Documentation** | Provides API documentation |
| **Experience** | Enhances developer experience with contextual information |

### Creating .NET Packages {#creating-net-packages}

Port applications organize operations at the package level and functionality at the message level. All operations are defined within messages, enabling code reusability through message-based architecture.

#### Class Library Examples {#class-library-examples-detailed}

##### Bulb Package Example {#bulb-package-example-detailed}

```csharp
using portpackage;
using portdatatype;

[Port(typeof(Bulb))]
public class Bulb
{
    [Logger]
    public ILogger Logger { get; set; }

    [Property]
    public IProperty Property { get; set; }

    private SerialPortStream serialPort = new SerialPortStream();

    [Valid("")]
    public bool Valid()
    {
        return true;
    }

    private string comport;
    [Message(PortDataType.Text)]
    public string Comport
    {
        set
        {
            try
            {
                if (this.serialPort.PortName != value)
                {
                    this.serialPort = new SerialPortStream();
                    this.serialPort.PortName = value.ToString();
                    this.serialPort.BaudRate = 9600;
                    this.serialPort.DataBits = 8;
                    this.serialPort.StopBits = StopBits.One;
                    this.serialPort.Parity = Parity.Even;
                }
            }
            catch (System.Exception ex)
            {
                Logger.Write("[ERROR]" + ex.Message);
            }
        }
        get
        {
            return comport;
        }
    }

    private string offon = string.Empty;
    [Message(PortDataType.Enum, PropertyFormat.Json)]
    public string OffOn
    {
        set
        {
            var prop = this.Property;
            try
            {
                if (prop != null)
                { 
                    this.offon = value;
                }
            }
            catch (Exception ex)
            {
                Logger.Write("[ERROR]" + ex.Message);
            }
        }
        get
        {
            return this.offon;
        }
    }
}
```

##### Heater Package Example {#heater-package-example-detailed}

```csharp
using portpackage;
using portdatatype;

[Port(typeof(Heater))]
public class Heater
{
    [Logger]
    public ILogger Logger { get; set; }
    
    [Property]
    public IProperty Property { get; set; }
    
    [Message(PortDataType.Text)]
    public string Power { set; get; }
    
    [Valid("Invalid for connection")]
    public bool Valid()
    {
        return true;
    }
    
    private static Random r = new Random(100);
    
    [Message(PortDataType.Num, PropertyFormat.Json, "Unit")]
    public double Temp
    {
        get
        {
            try
            {
                if (this.Property != null)
                {
                    if (this.Property.TryToGetValue("Unit", out string v1) && (v1 == "F"))
                    {
                        var ret = (r.NextDouble() * 9 / 5) + 32;
                        return ret == 0 ? 1 : ret;
                    }
                    else if (this.Property.TryToGetValue("Unit", out string v2) && (v2 == "C"))
                    {
                        var ret = (r.NextDouble());
                        return ret == 0 ? 1 : ret;
                    }
                    else
                    {
                        return double.NaN;
                    }
                }
                return double.NaN;
            }
            catch (Exception e)
            {
                if (Logger != null)
                    Logger.Write(e.Message);
            }
            return double.NaN;
        }
    }
}
```

!!! warning "Array Declaration Warning"
    When creating a library in a .NET environment, declaring an excessively large array may result in a PrivateImplementationDetails error. It is recommended to use a List instead.

### Publishing Libraries {#publishing-libraries-detailed}

#### Prerequisites {#prerequisites-detailed}

Before publishing your .NET Core project, ensure you have the following:

| Requirement | Description |
|-------------|-------------|
| **[.NET SDK](https://dotnet.microsoft.com/download)** | Install the latest version |
| **[C# Extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)** | Install in Visual Studio Code |
| **Verified Build** | Ensure your project builds and runs correctly |

## Summary

This .NET Integration Guide provides comprehensive coverage of:

### Key Integration Points
- **Initialization**: Setting up Port system with .NET applications
- **Event Handling**: Managing status changes and system events
- **Package Development**: Creating reusable components with annotations
- **Project Execution**: Running and monitoring applications

### Best Practices
- Use proper annotation patterns for package development
- Implement comprehensive error handling
- Follow logging and monitoring guidelines
- Test packages thoroughly before deployment

### Next Steps
- Explore the [React Integration Guide](react.md) for web development
- Review [Package Management](package.md) for advanced features
- Check [SECS Protocol](secs.md) for industrial communication

---

*For additional support and examples, refer to the [Port Documentation](index.md).*
