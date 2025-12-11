# PORT CLI Command Reference

This document provides a comprehensive reference for all available PORT CLI commands.

## Quick Reference

### System Commands
| Command | Arguments | Description |
|---------|-----------|-------------|
| `version` | - | Display version information |
| `env` | - | Display environment variables |
| `help` | - | Display help information |

### Project Management
| Command | Arguments | Description |
|---------|-----------|-------------|
| `new` | `<project_name>` | Create new PORT project |
| `run` | `[project_name] [flags]` | Run PORT project |
| `push` | `[project_name]` | Push project to repository |
| `pull` | `[project_name]` | Pull project from repository |

### Package Management
| Command | Arguments | Description |
|---------|-----------|-------------|
| `pack` | `<dll_file> <output_name> [flags]` | Build package from DLL |
| `save` | `<package_name> [flags]` | Save package from current directory |
| `clear` | - | Clear all loaded packages |

### Listing Commands
| Command | Arguments | Description |
|---------|-----------|-------------|
| `ls repo` | - | List repositories |
| `ls pkg` | - | List packages |
| `ls tcp` | `[address]` | List TCP addresses |
| `ls com` | - | List COM ports |
| `ls user` | - | List users |

### Script Management
| Command | Arguments | Description |
|---------|-----------|-------------|
| `script` | `<file> <function> [args]` | Execute script |
| `cancel` | `<file> <function>` | Cancel script execution |

### User Management
| Command | Arguments | Description |
|---------|-----------|-------------|
| `login` | `<username> <password>` | User login |
| `add` | `[flags]` | Add resources (user, enum, group) |

### Server Communication
| Command | Arguments | Description |
|---------|-----------|-------------|
| `get` | `<group> <key>` | Get data |
| `set` | `<group> <key> <value>` | Set data |
| `status` | - | Get server status |
| `uptime` | - | Get server uptime |
| `latency` | - | Measure server latency |
| `shutdown` | `<confirmation>` | Shutdown server |

---

## Detailed Command Reference

## System Commands

### `version` - Display Version Information
**Usage**: `version`

**Description**: Displays the current PORT version and build information.

**Output**: Version string with build details.

### `env` - Environment Information
**Usage**: `env`

**Description**: Displays environment variables and system configuration.

**Output**:
- VERSION: Current PORT version
- HOMEPATH: Executable directory path
- Other system environment variables

### `help` - Display Help
**Usage**: `help`

**Description**: Shows comprehensive help information for all available commands.

## Project Management Commands

### `new` - Create New Project
**Usage**: `new <project_name>`

**Description**: Creates a new PORT project with initial directory structure and configuration files.

**Arguments**:
- `project_name`: Name of the new project to create

**Created Structure**:
- `port/` - Main configuration directory
- `port/app/` - Application files
- `port/app/ecma5/` - ECMAScript 5 files
- `port/app/mqtt/` - MQTT configuration
- `port/app/gem/` - GEM (Generic Equipment Model) files
- `boot.js` - Boot script
- `.enum` - Enumeration definitions
- `.rule` - Rule definitions
- Various GEM configuration files (.gem, .sv, .dvv, .al, .ce, .rid, .ecv)

**Example**:
```bash
new MyProject
```

### `run` - Run Project
**Usage**: `run [project_name] [flags]`

**Description**: Starts and runs a PORT project with specified configuration.

**Arguments**:
- `project_name`: Name of project to run (optional, auto-detects from current directory)

**Flags**:
- `--address <address>`: Override listen address
- `--port <port>`: Override listen port
- `--call-process <name>`: Override call application name
- `--ng ignore`: Allow NG (Not Good) status
- `--sync <directory>`: Set sync directory
- `--ping-address <host:port>`: Enable ping-pong with endpoint
- `--in-packages <packages>`: Comma-separated package list
- `--new-msg`: Enable updated message handling

**Examples**:
```bash
run MyProject --port 8080 --address 0.0.0.0
run --ping-address localhost:9090 --sync ./sync_dir
```

### `push` - Push Project to Repository
**Usage**: `push [project_name]`

**Description**: Pushes current project changes to the repository with automatic change detection.

**Arguments**:
- `project_name`: Name of project to push (optional)

**Features**:
- Automatic change detection for multiple file types
- Changelog generation in `.port.md` file
- Supports file extensions: `.logger`, `.cctv`, `.pub`, `.js`, `.rule`, `.al`, `.ce`, `.dvv`, `.ecv`, `.sv`, `.gem`, `.msg`
- Entry collector generation
- Automatic database updates

**Example**:
```bash
push MyProject
```

### `pull` - Pull Project from Repository
**Usage**: `pull [project_name]`

**Description**: Pulls project files from repository to local directory.

**Arguments**:
- `project_name`: Name of project to pull (optional)

**Features**:
- Pulls all project file types from repository
- Updates local directory structure
- Synchronizes configuration files
- Updates .NET project files

**Example**:
```bash
pull MyProject
```

## Package Management Commands

### `pack` - Build Package
**Usage**: `pack <dll_file> <output_name> [flags]`

**Description**: Builds a package from a DLL file with full initialization and testing.

**Arguments**:
- `dll_file`: Path to DLL file to package
- `output_name`: Name for the output package

**Flags**:
- `--args <arguments>`: Pass initialization arguments

**Features**:
- Loads and initializes DLL package
- Extracts message definitions (GET, SET, MAPPING)
- Sets memory data allocation
- Runs initialization with arguments
- Generates comprehensive build report

**Example**:
```bash
pack MyLibrary.dll MyPackage --args "config=production"
```

### `save` - Save Package
**Usage**: `save <package_name> [flags]`

**Description**: Creates a package (.pkg) file from DLL files in the current directory.

**Arguments**:
- `package_name`: Name for the package

**Flags**:
- `--path <directory>`: Specify source directory (default: current directory)

**Features**:
- Scans directory for .dll files
- Compresses files into .pkg format
- Automatic package directory creation

**Example**:
```bash
save MyPackage --path /path/to/dlls
```

### `clear` - Clear Packages
**Usage**: `clear`

**Description**: Clears all loaded packages from memory and terminates active processes.

## Listing Commands

### `ls` - List Resources
**Usage**: `ls <resource_type> [additional_args]`

**Description**: Lists various system resources based on the specified type.

#### `ls repo` - List Repositories
Lists all available repositories with timestamps.

**Output Format**: `repository_name                modification_time`

#### `ls pkg` - List Packages
Lists all available packages (.pkg files) with timestamps.

**Output Format**: `package_name                    modification_time`

#### `ls tcp [address]` - List TCP Addresses
Lists TCP addresses for the specified host (default: 0.0.0.0).
Performs DNS lookup to resolve host addresses.

**Arguments**:
- `address`: Host address to resolve (optional, default: 0.0.0.0)

#### `ls com` - List COM Ports
Lists all available serial communication ports.

#### `ls user` - List Users
Lists all registered usernames in the system.

## Script Management Commands

### `script` - Execute Script
**Usage**: `script <script_file> <function_name> [args...]`

**Description**: Executes JavaScript (.js) or rule (.rule) files with specified functions and arguments.

**Arguments**:
- `script_file`: Path to script file (.js or .rule)
- `function_name`: Name of function to execute
- `args`: Additional arguments to pass to function

**Flags**:
- `--timeout <milliseconds>`: Set execution timeout

**Features**:
- Supports both `.js` and `.rule` files
- Absolute and relative path resolution
- Timeout support
- Async execution with cancellation support
- Boot script support for special `boot.js` files
- Context-aware execution with server integration

**Examples**:
```bash
script ./automation.js initialize
script /path/to/boot.js startup --timeout 5000
```

### `cancel` - Cancel Script Execution
**Usage**: `cancel <script_file> <function_name>`

**Description**: Cancels a running script execution by its unique identifier.

**Arguments**:
- `script_file`: Path to script file
- `function_name`: Name of function to cancel

**Features**:
- Cancels async script execution
- Uses script file and function name as identifier
- Immediate termination of running scripts

## User Management Commands

### `login` - User Login
**Usage**: `login <username> <password>`

**Description**: Authenticates user and enters interactive command mode.

**Arguments**:
- `username`: Username for authentication
- `password`: Password for authentication

**Features**:
- User authentication
- Interactive command prompt
- Session-based command execution

### `add` - Add Resources
**Usage**: `add [flags]`

**Description**: Adds various resources to the system based on specified flags.

#### `add --user <username> <password>` - Add User
Adds a new user to the system with specified credentials.

**Arguments**:
- `username`: Username for new user
- `password`: Password for new user

#### `add --enum <enum_definitions>` - Add Enumerations
Adds enumeration definitions to the .enum file.

**Format**: `type name:value name:value` (comma-separated for multiple)

**Example**: 
```bash
add --enum "Status RUNNING:1 STOPPED:0,Mode AUTO:1 MANUAL:0"
```

#### `add --group <group_names> [message_file]` - Add Groups
Creates new groups with optional message file specification.

**Arguments**:
- `group_names`: Comma-separated list of group names
- `message_file`: Optional message file specification

**Features**:
- Creates group directories
- Generates .msg files for each group
- Supports comma-separated group names

## Server Communication Commands

### `get` - Get Server Data
**Usage**: `get <resource_identifier>`

**Description**: Retrieves specific data from the server including message values, logs, events, and system information.

**Arguments**:
- `resource_identifier`: Identifier for the resource to retrieve

#### **Entry Data Retrieval**
- `[group-name] [message-name]`: Get group message value
  - Example: `get Equipment Status` - Gets status from Equipment group
  - Example: `get Alarms Count` - Gets alarm count from Alarms group

- `[package-name] [message-name]`: Get package message value
  - Example: `get SECS Temperature` - Gets temperature from SECS package
  - Example: `get GEM ProcessState` - Gets process state from GEM package

#### **Work and Process Information**
- `[workid]`: Get work ID information and current work status
  - Example: `get W001` - Gets information for work ID W001
  - Returns: Work status, progress, timestamps, associated data

#### **Log and Event Data**
- `[project-name].log`: Get project log entries
  - Example: `get MyProject.log` - Gets log entries for MyProject
  - Returns: Timestamped log entries, error messages, system events

- `[package-name].log`: Get package-specific log entries
  - Example: `get SECS.log` - Gets SECS package log entries
  - Returns: Package operations, message traffic, error logs

- `[package-name].event`: Get package events and notifications
  - Example: `get GEM.event` - Gets GEM package events
  - Returns: Event history, alarms, state changes, notifications

#### **Documentation and Help**
- `[package-name].doc`: Get package documentation
  - Example: `get SECS.doc` - Gets SECS package documentation
  - Returns: API documentation, message formats, usage examples

#### **System Status Information**
- `status`: Get comprehensive server status
  - Returns: Server health, active connections, resource usage, uptime
  - Example output: Server running, 5 active connections, CPU 15%, Memory 45%

- `mls`: Get MLS (Multi-Level Security) information
  - Returns: Security levels, access permissions, user contexts
  - Example: Current user level, accessible resources, security policies

**Examples**:
```bash
# Get message values
get Equipment Status
get SECS Temperature
get GEM ProcessState

# Get work information
get W001
get WORK_12345

# Get logs and events
get MyProject.log
get SECS.log
get GEM.event

# Get system information
get status
get mls

# Get documentation
get SECS.doc
get GEM.doc
```

### `set` - Set Server Data
**Usage**: `set <group> <key> <value>`

**Description**: Sets data on the server including message values, system configurations, and executes various operations.

**Arguments**:
- `group`: Group name, package name, or operation context
- `key`: Key, message name, or operation type
- `value`: Value to set or operation parameters

#### **Entry Data Operations**
- `[group-name] [message-name] [value]`: Set group message value
  - Example: `set Equipment Status RUNNING` - Sets equipment status to RUNNING
  - Example: `set Alarms Count 0` - Clears alarm count
  - Example: `set Process Temperature 150.5` - Sets process temperature

- `[package-name] [message-name] [value]`: Set package message value
  - Example: `set SECS CommState ENABLED` - Enables SECS communication
  - Example: `set GEM ControlState REMOTE` - Sets GEM control to remote
  - Example: `set Recipe ActiveRecipe R001` - Sets active recipe

#### **Script and Function Execution**
- `[*.js] [function-name] [arguments]`: Execute JavaScript function
  - Example: `set automation.js startProcess "Recipe1,Lot001"` - Executes startProcess function
  - Example: `set monitor.js checkAlarms ""` - Executes checkAlarms function
  - Example: `set control.js setParameter "temp,200"` - Executes setParameter function

#### **Publication Operations**
- `[*.pub]`: Publish operation or message
  - Example: `set alarms.pub` - Publishes alarm data
  - Example: `set events.pub` - Publishes event notifications
  - Example: `set status.pub` - Publishes status updates

#### **User Management Operations**
- `password [user-name] [old-password] [new-password]`: Change user password
  - Example: `set password admin oldpass newpass123` - Changes admin password
  - Security: Requires current password for verification

- `grant [user-name] [user-level]`: Grant user permissions
  - Example: `set grant operator 2` - Grants level 2 permissions to operator
  - Example: `set grant engineer 3` - Grants level 3 permissions to engineer
  - Levels: 1=Read, 2=Write, 3=Admin, 4=System

#### **System Operations**
- `notify [message]`: Send notification message
  - Example: `set notify "Process completed successfully"` - Sends success notification
  - Example: `set notify "Warning: High temperature detected"` - Sends warning
  - Broadcasts to all connected clients and logged

- `init [package-name]`: Initialize package
  - Example: `set init SECS` - Initializes SECS package
  - Example: `set init GEM` - Initializes GEM package
  - Reloads configuration and resets package state

#### **Advanced Operations**
- `config [parameter] [value]`: Set configuration parameter
  - Example: `set config timeout 30000` - Sets timeout to 30 seconds
  - Example: `set config loglevel DEBUG` - Sets log level to DEBUG

- `trigger [event-name] [data]`: Trigger system event
  - Example: `set trigger alarm_reset ""` - Triggers alarm reset event
  - Example: `set trigger process_start "Recipe1"` - Triggers process start

**Examples**:
```bash
# Set message values
set Equipment Status RUNNING
set SECS CommState ENABLED
set Process Temperature 150.5

# Execute JavaScript functions
set automation.js startProcess "Recipe1,Lot001"
set monitor.js checkAlarms ""

# User management
set password admin oldpass newpass123
set grant operator 2

# System operations
set notify "Process completed successfully"
set init SECS

# Configuration
set config timeout 30000
set config loglevel DEBUG

# Publish operations
set alarms.pub
set events.pub

# Trigger events
set trigger alarm_reset ""
set trigger process_start "Recipe1"
```

**Return Values**:
- **Success**: Operation completed successfully
- **Error**: Error message with details
- **Data**: Retrieved or set data value
- **Status**: Current operation status

### `status` - Server Status
**Usage**: `status`

**Description**: Gets comprehensive server status information.

### `uptime` - Server Uptime
**Usage**: `uptime`

**Description**: Gets server uptime information.

### `latency` - Measure Latency
**Usage**: `latency`

**Description**: Measures network latency to the server using timestamp-based calculation.

### `shutdown` - Server Shutdown
**Usage**: `shutdown <confirmation>`

**Description**: Initiates server shutdown sequence.

**Arguments**:
- `confirmation`: Confirmation code for shutdown

## Repository Management Commands

### `repo` - Repository Operations
**Usage**: `repo <file_path> [flags]`

**Description**: Manages repository operations with upload capabilities.

**Arguments**:
- `file_path`: Path to file for repository operations

**Flags**:
- `--upload local`: Upload files from local directory to package repository
- `--upload remote`: Handle remote repository upload operations

## Additional Utility Commands

### `date` - Server Date
**Usage**: `date`

**Description**: Retrieves current server date and time.

### `flow` - Flow Status
**Usage**: `flow`

**Description**: Retrieves current flow status from the server.

### `queue` - Queue Management
**Usage**: `queue <operation>`

**Description**: Manages server message queues.

### `stack` - Stack Management
**Usage**: `stack <operation>`

**Description**: Manages server stack operations.

### `storage` - Storage Management
**Usage**: `storage <operation>`

**Description**: Manages server storage operations.

### `list` - List Server Resources
**Usage**: `list <resource_type>`

**Description**: Lists various server resources.

### `request-app` - Request Application
**Usage**: `request-app [parameters]`

**Description**: Sends application request to the server.

### `sleep` - Sleep/Wait
**Usage**: `sleep`

**Description**: Pauses execution (utility command for scripting).

## Global Flags Reference

- `--timeout <milliseconds>`: Set execution timeout
- `--address <address>`: Override listen address
- `--port <port>`: Override listen port
- `--path <path>`: Specify file path
- `--args <arguments>`: Pass initialization arguments
- `--ng ignore`: Allow NG status
- `--sync <directory>`: Set sync directory
- `--ping-address <host:port>`: Enable ping-pong
- `--in-packages <packages>`: Specify package list
- `--new-msg`: Enable updated message handling
- `--upload <local|remote>`: Upload mode
- `--user <username> <password>`: User operations
- `--enum <definitions>`: Enumeration definitions
- `--group <names>`: Group operations

## Common Usage Examples

### Basic Project Workflow
```bash
# Create new project
new MyProject

# Run project with custom port
run MyProject --port 8080

# Make changes and push to repository
push MyProject

# Pull updates from repository
pull MyProject
```

### Package Development
```bash
# Build package from DLL
pack MyLibrary.dll MyPackage --args "config=test"

# Save package from current directory
save MyPackage --path ./output

# Clear all loaded packages
clear
```

### System Administration
```bash
# Add new user
add --user admin password123

# Check server status
status

# Measure network latency
latency

# List available repositories
ls repo
```

### Script Execution
```bash
# Execute JavaScript function
script ./automation.js initialize

# Execute with timeout
script ./boot.js startup --timeout 5000

# Cancel running script
cancel ./automation.js initialize
```

### Server Data Operations
```bash
# Get server data
get Equipment Status
get SECS Temperature
get MyProject.log
get status

# Set server data
set Equipment Status RUNNING
set SECS CommState ENABLED
set Process Temperature 150.5

# Execute JavaScript functions
set automation.js startProcess "Recipe1,Lot001"
set monitor.js checkAlarms ""

# User management
set password admin oldpass newpass123
set grant operator 2

# System notifications
set notify "Process completed successfully"
set init SECS

# Configuration management
set config timeout 30000
set config loglevel DEBUG
```

## Error Handling

The PORT CLI provides comprehensive error handling for:
- Invalid command syntax
- Missing required arguments
- File system errors
- Network communication errors
- Authentication failures
- Resource not found errors
- Permission errors
- Timeout errors
- Package loading errors