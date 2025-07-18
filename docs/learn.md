# Port Learning Guide

## Table of Contents
1. [Overview](#overview)
2. [Creating Port Projects](#creating-port-projects)
3. [Message System](#message-system)
4. [Enum Definitions](#enum-definitions)
5. [Rule System](#rule-system)
6. [Package Management](#package-management)
7. [Package Development](#package-development)
8. [PortDic SDK](#portdic-sdk)
9. [Project Execution](#project-execution)
10. [Logging and Monitoring](#logging-and-monitoring)
11. [Remote Access](remote.md)

## Overview

Port operates by reflecting messages in the most recently updated repository. This quick start guide will help you understand how to create, configure, and manage Port projects effectively.

Port provides a comprehensive ecosystem for:

- **Message-based Communication**: Structured data exchange between components

- **Package Integration**: Modular architecture with reusable components  

- **Real-time Monitoring**: Live project status and logging capabilities

- **Remote Management**: SSH and web-based administration

- **IoT Integration**: MQTT protocol support for device communication


## Creating Port Projects

### Project Structure Overview {#project-structure}

Port projects are organized hierarchically with a clear folder structure:

- **Root Folder**: Contains project configuration and `*.enum` files
- **Group Folders**: Organize messages by functional areas
- **Message Files**: Individual `*.msg` files defining message properties

### Repository Setup {#repository-setup}

The Port project structure is simple and straightforward. Follow these steps to create your first project:

1. **Create Project Directory**: Start with a dedicated project folder
2. **Initialize Project**: Use `port new [project-name]` to generate project files
3. **Add Groups**: Create sub-folders for message organization
4. **Define Messages**: Add `*.msg` files to group folders
5. **Configure Types**: Specify text, num, and enum data types
6. **Deploy**: Use `port push` to store project configuration

!!! tip "Repository Naming Rules"
    Repository names cannot contain special characters and must follow operating system directory naming conventions.

#### Creating a New Project {#creating-new-project}

![Create Project](img/new_project.png)

**Command:**
```bash
port new [project-name]
```

### Group Management {#group-management}

Groups serve as logical containers for related messages. Each group can contain multiple message files, enabling organized and abstracted message management.

#### Adding Groups {#adding-groups}

![Add Group](img/add_group.png)

**Benefits of Groups:**
- **Organization**: Logical separation of message types
- **Maintainability**: Easier to locate and edit related messages
- **Scalability**: Support for large projects with many messages
- **Abstraction**: Simplified management of complex message relationships

#### Sample Project Structure {#sample-project-structure}

![Project Structure](img/expl.png)

**Download Sample:**
[Download Sample Project](file/sample.zip)

## Message System

### Message Definition Syntax {#message-syntax}

Messages are the core communication units in Port. Each message is defined using a specific syntax:

```
[key] [datatype] [option...]
```

**Components:**
- **`[key]`**: Unique identifier within the message group
- **`[datatype]`**: Data type specification (text, num, enum)
- **`[option...]`**: Additional attributes and configurations

### Data Types {#data-types}

Port supports three primary data types for message definitions:

| Name | Range | Description |
|------|-------|-------------|
| **char** | `0~255` | Fixed-length string type with maximum 255 characters for text storage |
| **num** | `-1.7e+308 ~ +1.7e+308` | Floating-point type supporting wide range of decimal values |
| **enum** | `0 ~ 65535` | User-defined fixed list from `.enum` files with efficient storage |

### Message Attributes {#message-attributes}

Attributes provide additional functionality and behavior for messages:

| Attribute | Description |
|-----------|-------------|
| **pkg** | Real-time synchronization with external libraries (see package documentation) |
| **backup** | Automatic database backup with restore on application restart |
| **property** | Custom property specifications for message configuration |
| **rule** | Value validation and management rules |
| **logging** | Automatic logging support for message operations |

!!! warning "Special Characters"
    Message documents should not use special characters in identifiers.

### Message Examples {#message-examples}

```
BulbOnOff     enum.OffOn  pkg:Bulb1.OffOn
RoomTemp1     num         pkg:Heater1.Temp  property:{"MIN":0,"MAX":300,"Arguments":"C"}
RoomTemp2     num         pkg:Heater1.Temp  property:{"MIN":0,"MAX":300,"Arguments":"F"}
```

**Explanation:**
- **BulbOnOff**: Enum-based control linked to Bulb1 package
- **RoomTemp1**: Numeric temperature in Celsius with validation range
- **RoomTemp2**: Numeric temperature in Fahrenheit with validation range

## Enum Definitions

### Enum Syntax {#enum-syntax}

Enums provide a way to define fixed sets of named values, improving code readability and reducing errors.

**Format:**
```
[key] [item-name:number_key] [item-name:number_key] ...
```

**Components:**
- **`[key]`**: Unique enum identifier
- **`[item-name]`**: Descriptive name for enum value
- **`[number_key]`**: Numeric value associated with the item

### Enum Benefits {#enum-benefits}

Enums are particularly useful for:
- **Fixed Value Sets**: Days of the week, months, status codes
- **Code Clarity**: Self-documenting code with named constants
- **Error Prevention**: Type safety instead of raw numeric values
- **Maintenance**: Centralized value management

### Enum Examples {#enum-examples}

```
TFalse      True:0      False:1
FTrue       False:0     True:1
OffOn       Off:0       On:1
OnOff       On:0        Off:1
```

**Use Cases:**
- **Boolean States**: True/False, On/Off toggles
- **Status Indicators**: Active/Inactive, Enabled/Disabled
- **Mode Selection**: Manual/Automatic, Local/Remote

## Rule System

### Rule Definition {#rule-definition}

Rules provide conditional logic for message validation and automatic actions. They are defined in `*.rule` files within group folders.

### SetTrigger Rules {#settrigger-rules}

SetTrigger rules control user modification permissions through conditional validation.

#### Syntax {#settrigger-syntax}
```javascript
set("<Input Condition>", "<Validation Condition>");
```

**Components:**
- **Input Condition**: Logical expression specifying the input to validate
- **Validation Condition**: Expression that must evaluate to true for acceptance

#### SetTrigger Examples {#settrigger-examples}
```javascript
set("room1.BulbOnOff==Off", "(room1.RoomTemp1>=20)&&(room2.RoomTemp2>=20)")
set("room1.RoomTemp2>=30", "room2.RoomTemp2>=5")
```

### GetTrigger Rules {#gettrigger-rules}

GetTrigger rules execute automatic actions when specified conditions are met.

#### Syntax {#gettrigger-syntax}
```javascript
get("<Trigger Condition>", "<Action Script>");
```

**Components:**
- **Trigger Condition**: Boolean expression for condition evaluation
- **Action Script**: Instructions executed when condition is true

#### GetTrigger Examples {#gettrigger-examples}
```javascript
get("(room1.RoomTemp1>=0)&&(room2.RoomTemp2>=0)", "room1.BulbOnOff=Off;room2.BulbOnOff=Off;")
```

### Rule Benefits {#rule-benefits}

- **Validation**: Enforce business logic and data integrity
- **Automation**: Trigger actions based on system state
- **Safety**: Prevent invalid configurations
- **Efficiency**: Reduce manual intervention needs

## Package Management

### Package Overview {#package-overview}

Port packages are collections of pre-written code modules that provide specific functionality for reuse across projects.

**Package Benefits:**
1. **Reusability**: Share common code across multiple projects
2. **Efficiency**: Reduce development time by leveraging existing solutions
3. **Maintainability**: Organize code into manageable, modular components
4. **Dependency Management**: Simplified installation, updates, and tracking

### Package Discovery {#package-discovery}

#### Listing Available Packages {#listing-packages}

![Package List](img/lsPkg.png)

Use the package manager to browse and select available packages for your project.

### Boot Configuration {#boot-configuration}

#### boot.js Structure {#boot-js-structure}

The `boot.js` file initializes your application by importing and validating packages:

**Location:** `app/boot.js`

```javascript
import Bulb1 from 'BulbLib1'
import Bulb2 from 'BulbLib2'
import Heater1 from 'HeaterLib1'
import Heater2 from 'HeaterLib2'

function boot() {
    if (!Bulb1.Valid()) {
        console.log("invalid Bulb1");
        return false;
    }
    if (!Bulb2.Valid()) {
        console.log("invalid Bulb2");
        return false;
    }
    if (!Heater1.Valid()) {
        console.log("invalid Heater1");
        return false;
    }
    if (!Heater2.Valid()) {
        console.log("invalid Heater2");
        return false;
    }
    
    return true;
}
```

**Validation Process:**
1. **Import Packages**: Load required package modules
2. **Validate Each Package**: Check package integrity and dependencies
3. **Error Handling**: Stop boot process if validation fails
4. **Success Confirmation**: Return true when all packages are valid

## Package Development

### Package Development Overview {#package-development-overview}

The Port package system allows developers to create reusable libraries by inheriting from `PortObject` and linking them to Messages. This enables straightforward usage through Message calls and promotes modular development.

Port packages provide a standardized way to:
- Create reusable components
- Manage dependencies and configurations  
- Enable seamless integration with the Port ecosystem
- Facilitate API-driven interactions

### Package Downloads and Availability {#package-downloads-availability}

The following packages are available across different programming languages and platforms:

| NAME | Language | Package Manager | OS | STABLE |
|------|----------|-----------------|----| -------|
| portdic | C++ | not yet | Windows | No |
| portdic | Delphi | not yet | Windows | No |
| portdic | C# | nuget | Windows | Yes |
| portdic | Python | not yet | Windows | No |
| portdic | Javascript | npm | Any | Yes |

### Package Annotations System {#package-annotations-system}

Port packages use annotations to define behavior, configuration, and API endpoints. These annotations provide metadata that the Port system uses for:

- **Class Registration**: Identifying Port-managed classes
- **API Generation**: Creating REST endpoints automatically
- **Dependency Injection**: Managing services and resources
- **Validation**: Ensuring data integrity and business rules

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
- Applied to methods returning `bool`
- Provides custom error messages for validation failures
- Automatically called during package validation

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
- Applied to class declarations
- Registers the class with the Port system
- Enables package management and API generation

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
- Applied to `ILogger` properties
- Enables dependency injection for logging
- Provides centralized logging capabilities

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
- Applied to `IProperty` properties
- Enables access to configuration values
- Supports key-value property retrieval

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
- Applied to properties with get/set accessors
- Creates REST API endpoints automatically
- Supports various data types and formats

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
- Applied to enum declarations
- Makes enum values accessible via API
- Enables external systems to query enum information

#### Comment Annotation {#comment-annotation-detailed}

The `Comment` annotation provides documentation for properties, exposed through the API.

```csharp
[Message, Comment("this is a numeric")]
public int NValue { get => 3; }
```

**Usage:**
- Applied alongside other annotations
- Provides API documentation
- Enhances developer experience with contextual information

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

- **[.NET SDK](https://dotnet.microsoft.com/download)**: Install the latest version
- **[C# Extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)**: Install in Visual Studio Code
- **Verified Build**: Ensure your project builds and runs correctly:

```bash
dotnet build
dotnet run
```

#### Basic Publish Commands {#basic-publish-commands-detailed}

##### Standard Release Build

```bash
dotnet publish -c Release -o ./publish
```

- `-c Release`: Builds in Release mode
- `-o ./publish`: Specifies output folder

##### Platform-Specific Publishing

```bash
dotnet publish -c Release -r win-x64 --self-contained false
```

**Available Runtimes:**
- `win-x64`: Windows 64-bit
- `linux-x64`: Linux 64-bit  
- `osx-x64`: macOS 64-bit

#### Automation with VS Code Tasks {#automation-vscode-tasks}

Create `.vscode/tasks.json` to automate publishing:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Publish .NET Core",
            "command": "dotnet",
            "type": "process",
            "args": [
                "publish",
                "-c",
                "Release",
                "-o",
                "./publish"
            ],
            "problemMatcher": "$msCompile"
        }
    ]
}
```

**To run the task:**
1. Open Command Palette (`Ctrl+Shift+P`)
2. Select `Tasks: Run Task`
3. Choose `Publish .NET Core`

#### Deployment Options {#deployment-options-detailed}

##### Local Deployment
Copy published files to target server or hosting environment.

##### Docker Deployment
Create a `Dockerfile` for containerization:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
COPY ./publish .
ENTRYPOINT ["dotnet", "YourApp.dll"]
```

#### Visual Studio 2022 Publishing {#vs2022-publishing}

For GUI-based publishing with Visual Studio 2022:

![Publishing Step 1](img/package/1.png)

![Publishing Step 2](img/package/2.png)

![Publishing Step 3](img/package/3.png)

![Publishing Step 4](img/package/5.png)

![Publishing Step 5](img/package/6.png)

#### Troubleshooting Publishing {#troubleshooting-publishing}

##### Logging Output
To capture publish logs:

```bash
dotnet publish > publish_log.txt
```

##### Additional Resources
- [Official .NET Publish Documentation](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-publish)
- [Visual Studio Code Documentation](https://code.visualstudio.com/docs)

### Package Creation and Management {#package-creation-management}

#### Creating Package Files {#creating-package-files-detailed}

After publishing your library, create a Port package using the following steps:

##### 1. Navigate to Publish Directory
```bash
cd [Publish target location]
```

##### 2. Pack the Library
```bash
port pack [dllname] [pkg-name]
```

##### 3. Verify Package Creation
Check the console output for successful packaging:

```
PS C:\Users\Public\Dev\publish> port pack HeaterLib.dll HeaterLib1
[PATH]C:\Users\Public\Dev\publish\HeaterLib.dll
[ALREADY_RUN]PORT PACKAGE MANAGER
[RUN]PORT PACKAGE MANAGER
[PACK][pack] Packing started at 2025-01-07T21:17:19+09:00
[PACK]load complete C:\Users\Public\Dev\publish\HeaterLib.dll : heaterlib
[PACK][GET][0] Power
[PACK][GET][1] Temp
[PACK][SET][0] Power
[PACK]heaterlib,65025
[PACK]initialization
[CREATED][PACKAGE] ...\port\pkg\HeaterLib1.pkg
```

#### Package Structure Analysis {#package-structure-analysis}

The packaging process includes:

1. **Analysis**: Scans the DLL for Port annotations
2. **Extraction**: Identifies all Message properties and methods
3. **Validation**: Ensures package integrity
4. **Creation**: Generates `.pkg` file in the Port package directory

#### Package Distribution {#package-distribution}

Once created, packages can be:
- Loaded into Port applications
- Distributed to other environments
- Managed through the Port Package Manager
- Accessed via REST API endpoints

## PortDic SDK

### PortDic Overview {#portdic-overview}

PortDic is a key-value pair data structure storage object provided by Port. It enables users to quickly look up values using keys, allowing for efficient data retrieval. This structure supports storage and editing of multiple data structures, facilitating stable and reliable development.

### PortDic Platform Support {#portdic-platform-support}

| NAME | Language | Package Manager | OS | STABLE |
|------|----------|-----------------|----| -------|
| portdic | C++ | not yet | Windows | No |
| portdic | Delphi | not yet | Windows | No |
| portdic | C# | nuget | Windows | Yes |
| portdic | Python | not yet | Windows | No |
| portdic | Javascript | npm | Any | Yes |

### React Integration with Vite {#react-integration-vite}

#### Sample Project Setup {#react-sample-setup}

**Download Sample:**
[React Project Sample](file/react_sample_source.zip)

#### React Implementation {#react-implementation}

```javascript
import { useState, useEffect } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { CallPortdic } from 'portdic';

function App() {
  const [setValue, setSetValue] = useState("");
  const [count, setCount] = useState(0) 
  const [portdic, setPortdic] = useState(0); 
  
  useEffect(() => {
    CallPortdic("localhost:5001").then(setPortdic).catch(console.error); 
  }, []); 
  
  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <div style={{ display: "flex", gap: "20px", alignItems: "center" }}> 
        <button
          onClick={() => {
            const data = portdic.Execute("version");
            data
              .then((resp) => resp.json())
              .then((data) => {
                console.log("success received:", data);
              })
              .catch((error) => {
                console.error("error occurred:", error);
              });
          }}
        >
          Version
        </button> 
        <button
          onClick={() =>
            console.log(portdic.Get("room1", "RoomTemp3"))
          }
        >
          Get
        </button> 
        <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
          <input
            type="text"
            placeholder="Set Value"
            value={setValue}
            onChange={(e) => setSetValue(e.target.value)}
            style={{
              padding: "5px",
              fontSize: "14px",
              borderRadius: "4px",
              border: "1px solid #ccc",
            }}
          />
          <button
            onClick={() => {
              portdic.Set("room1", "RoomTemp3", setValue);
              console.log(`Set value: ${setValue}`);
            }}
          >
            Set
          </button>
        </div>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App
```

#### React Integration Demo {#react-integration-demo}

![React SET/GET Demo](img/react_set_get.gif)



![SSH Log Access](img/putty%20logs.png)

## Project Execution {#project-execution}

### Running Port Projects

Port projects can be executed in several ways:

#### Local Execution
```bash
# Start a project locally
port run [project-name]

# Run with specific configuration
port run [project-name] --config production

# Run in development mode with hot reload
port run [project-name] --dev
```

#### Background Execution
```bash
# Start project as background service
port start [project-name]

# Stop background service
port stop [project-name]

# Check service status
port status [project-name]
```

#### Production Deployment
```bash
# Deploy to production environment
port deploy [project-name] --env production

# Deploy with specific version
port deploy [project-name] --version 1.2.3

# Deploy with custom configuration
port deploy [project-name] --config custom.yml
```

### Execution Modes

Port supports different execution modes:

- **Development Mode**: Hot reload, debug logging, development tools
- **Production Mode**: Optimized performance, minimal logging, production settings
- **Testing Mode**: Test environment configuration, mock data, testing utilities

### Environment Configuration

Configure different environments using:

```yaml
# config/development.yml
environment: development
debug: true
log_level: debug
database:
  host: localhost
  port: 5432

# config/production.yml
environment: production
debug: false
log_level: info
database:
  host: prod-db.example.com
  port: 5432
```

## Logging and Monitoring {#logging-and-monitoring}

### Log Management

Port provides comprehensive logging capabilities:

#### Log Levels
- **DEBUG**: Detailed diagnostic information
- **INFO**: General operational messages
- **WARN**: Warning conditions
- **ERROR**: Error conditions
- **FATAL**: Critical system failures

#### Log Configuration
```yaml
# config/logging.yml
logging:
  level: info
  format: json
  output:
    - console
    - file
  file:
    path: logs/port.log
    max_size: 100MB
    max_files: 10
```

#### Accessing Logs
```bash
# View real-time logs
port logs [project-name]

# View logs with filtering
port logs [project-name] --level error --since 1h

# Export logs to file
port logs [project-name] --output logs.txt
```

### Monitoring and Metrics

#### System Monitoring
```bash
# Check system status
port status

# Monitor resource usage
port monitor [project-name]

# View performance metrics
port metrics [project-name]
```

#### Health Checks
    ```bash
# Check project health
port health [project-name]

# Run diagnostic tests
port diagnose [project-name]

# Validate configuration
port validate [project-name]
```

#### Alerting

Configure alerts for important events:

```yaml
# config/alerts.yml
alerts:
  email:
    enabled: true
    recipients:
      - admin@example.com
  slack:
    enabled: true
    webhook_url: https://hooks.slack.com/...
  conditions:
    - level: error
      threshold: 5
      window: 1m
    - level: fatal
      threshold: 1
      window: 1s
```

### Performance Monitoring

#### Metrics Collection
- **Message throughput**: Messages processed per second
- **Response times**: Average and percentile response times
- **Error rates**: Error frequency and patterns
- **Resource usage**: CPU, memory, and disk utilization

#### Monitoring Dashboard

Access the monitoring dashboard:
```bash
# Start monitoring dashboard
port dashboard [project-name]

# Access at http://localhost:8080
```

For detailed remote access information, see [Remote Access](remote.md).
