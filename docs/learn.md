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

| Feature | Description |
|---------|-------------|
| **Message-based Communication** | Structured data exchange between components |
| **Package Integration** | Modular architecture with reusable components |
| **Real-time Monitoring** | Live project status and logging capabilities |
| **Remote Management** | SSH and web-based administration |
| **IoT Integration** | MQTT protocol support for device communication |


## Creating Port Projects

### Project Structure Overview {#project-structure}

Port projects are organized hierarchically with a clear folder structure:

| Component | Description |
|-----------|-------------|
| **Root Folder** | Contains project configuration and `*.enum` files |
| **Group Folders** | Organize messages by functional areas |
| **Message Files** | Individual `*.msg` files defining message properties |

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

| Benefit | Description |
|---------|-------------|
| **Organization** | Logical separation of message types |
| **Maintainability** | Easier to locate and edit related messages |
| **Scalability** | Support for large projects with many messages |
| **Abstraction** | Simplified management of complex message relationships |

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

| Component | Description |
|-----------|-------------|
| **`[key]`** | Unique identifier within the message group |
| **`[datatype]`** | Data type specification (text, num, enum) |
| **`[option...]`** | Additional attributes and configurations |

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

| Variable | Type | Description |
|----------|------|-------------|
| **BulbOnOff** | Enum | Enum-based control linked to Bulb1 package |
| **RoomTemp1** | Numeric | Numeric temperature in Celsius with validation range |
| **RoomTemp2** | Numeric | Numeric temperature in Fahrenheit with validation range |

## Enum Definitions

### Enum Syntax {#enum-syntax}

Enums provide a way to define fixed sets of named values, improving code readability and reducing errors.

**Format:**
```
[key] [item-name:number_key] [item-name:number_key] ...
```

**Components:**

| Component | Description |
|-----------|-------------|
| **`[key]`** | Unique enum identifier |
| **`[item-name]`** | Descriptive name for enum value |
| **`[number_key]`** | Numeric value associated with the item |

### Enum Benefits {#enum-benefits}

Enums are particularly useful for:

| Use Case | Description |
|----------|-------------|
| **Fixed Value Sets** | Days of the week, months, status codes |
| **Code Clarity** | Self-documenting code with named constants |
| **Error Prevention** | Type safety instead of raw numeric values |
| **Maintenance** | Centralized value management |

### Enum Examples {#enum-examples}

```
TFalse      True:0      False:1
FTrue       False:0     True:1
OffOn       Off:0       On:1
OnOff       On:0        Off:1
```

**Use Cases:**

| Use Case | Description |
|----------|-------------|
| **Boolean States** | True/False, On/Off toggles |
| **Status Indicators** | Active/Inactive, Enabled/Disabled |
| **Mode Selection** | Manual/Automatic, Local/Remote |

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

| Component | Description |
|-----------|-------------|
| **Input Condition** | Logical expression specifying the input to validate |
| **Validation Condition** | Expression that must evaluate to true for acceptance |

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

| Component | Description |
|-----------|-------------|
| **Trigger Condition** | Boolean expression for condition evaluation |
| **Action Script** | Instructions executed when condition is true |

#### GetTrigger Examples {#gettrigger-examples}
```javascript
get("(room1.RoomTemp1>=0)&&(room2.RoomTemp2>=0)", "room1.BulbOnOff=Off;room2.BulbOnOff=Off;")
```

### Rule Benefits {#rule-benefits}

| Benefit | Description |
|---------|-------------|
| **Validation** | Enforce business logic and data integrity |
| **Automation** | Trigger actions based on system state |
| **Safety** | Prevent invalid configurations |
| **Efficiency** | Reduce manual intervention needs |

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



Use the graphical interface for easier project management and monitoring.

## Logging and Monitoring

### Log System Overview {#log-system}

Port Application maintains comprehensive logs for troubleshooting and system analysis across multiple categories.

### Log Categories {#log-categories}

**Log Directory:** `.../documents/port/logs`

| Folder | Purpose | Content |
|--------|---------|---------|
| **Pkg** | Package operations | Package loading events and activities |
| **Boot** | Resource loading | Project initialization and startup logs |
| **Console** | Command execution | Console commands and their outputs |
| **Service** | Port Package Manager | Service-related activities and status |
| **Project** | Project operations | Set/get operations and project-wide events |

### File-based Logging {#file-logging}

![Log Directory Structure](img/log%20dir.png)

**Log Management:**

| Feature | Description |
|---------|-------------|
| **Automatic Creation** | Logs generated automatically during operations |
| **Categorized Storage** | Separate folders for different log types |
| **Troubleshooting** | Comprehensive information for issue diagnosis |
| **System Analysis** | Performance and behavior tracking |

### SSH Log Access {#ssh-log-access}

Retrieve logs remotely using SSH commands:

```bash
get sample.log
```

