# Commands

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
| `output` | `<output_dir> [-p project]` | Generate `entry.cs` from the page DB |

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

### Session Audit
| Command | Arguments | Description |
|---------|-----------|-------------|
| `session logs` | `[flags]` | List FFI call audit log entries |

### Server Communication
| Command | Arguments | Description |
|---------|-----------|-------------|
| `get` | `<group> <key>` | Get data |
| `set` | `<group> <key> <value> [--repo <repo>]` | Set data (server, or local DB with `--repo`) |
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

### `service` - Windows Service Mode (`portservice`)
**Usage**: `portservice service <install|uninstall|start|stop|status> [args]`

**Description**: Runs the port server as an always-on Windows service instead of a
`port run` child process spawned by each application. The service is managed by the
Service Control Manager: it starts at boot, keeps running after the application exits,
and is restarted by the SCM on failure. Applications attach with `Port.Connect()`
(see Library Reference) instead of letting `Port.Run()` spawn the server.

`portservice` is a separate binary built from `Source_PortEx/portservice`; `port run`
keeps working unchanged for foreground use.

**Subcommands**:
- `install [project_name] [--data-dir <path>]`: Register the auto-start service (run as
  Administrator). The optional project is opened automatically at every service start.
  Data root defaults to `%ProgramData%\port`.
- `uninstall`: Stop (if running) and remove the service.
- `start` / `stop` / `status`: Control or query the installed service.
- `open <project_name>`: Switch the service to a project. **The project it was running is
  stopped first** — one project at a time. `active` shows the running project, `close`
  stops it (the service stays up), `projects` lists what can be opened.

**Service environment** (set automatically):
- `PORT_DATA_DIR=%ProgramData%\port` — the service account's `%LOCALAPPDATA%` is not
  reachable from user sessions.
- `PORT_SHM_GLOBAL=1` — the register file is created as `Global\port.shm` with a DACL for
  authenticated users so interactive clients (`portiolib.dll`, `PortMemoryDictionary`) can
  open it; a foreground run keeps `Local\port.shm`. Clients try `Global\` first, then `Local\`.

**Examples**:
```bash
# as Administrator
portservice service install MyProject
portservice service start
portservice service status
sc failure PortService reset= 86400 actions= restart/5000   # optional: auto-restart on crash
```

**Control API** (loopback `http://127.0.0.1:50010`): `GET /control/active`, `GET /control/projects`,
`POST /control/open {"project"}`, `POST /control/close` — what `open`/`active`/`close`/`projects`
and the library's `PortClient` use.

**Current limits**: `port push` while the service holds the project DB is rejected by the
exclusive redb lock — `service close` (or open another project), push, then `service open`
again (runtime entries can still be added through the library's gRPC fallback).

### `prop` - Entry Properties (incl. GEM annotations)
**Usage**: `port prop <set|get|all|clear> <domain.entry> [...] [--repo <repository>]`

**Description**: Reads or writes the properties of a page entry — `unit`, `min`, `max`,
`property`, `pkg`, and the GEM annotations `svid`, `dvid`, `ecvid`, `ceid`, `alid`.
Without `--repo` the command goes to the running server; with `--repo` it edits the
repository's local DB.

**Subcommands**:
- `set <domain.entry> field:value ...`: `port prop set room1.Temp1 unit:C min:0 max:300`
- `get <domain.entry> <field>` / `all <domain.entry>`: read one or every property
- `clear <domain.entry> <field> ...` or `--all`: remove properties

**GEM annotations**: `port prop set LP1.E87Phase svid:9101` (or `dvid:` / `ceid:` / `alid:`)
registers the entry in the HSMS engine on the **next `port run`** — the command reports
`deferred: next run + hsms resync`. After the restart the ID appears in the GEM dictionary
(web **SECS → Dictionary**, MCP `gem_dictionary`, REST `/api/v1/secs/gem/dictionary/...`),
the host can read it with S1F3 / receive it in S6F11, and a CEID becomes sendable once the
host enables it with S2F37. `port prop clear LP1.E87Phase svid` + restart removes it. GEM IDs
must be unique within the project; a duplicate is rejected.

This also works for entries the application created at runtime (`Port.Equipment.Add`
entities, `Port.Set` on a new key): those live under `domain/__runtime.entry` and keep
their annotations across `port push` and re-registration.

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
- Runtime-created entries (`domain/__runtime.*`, from `set --create` or application entities) and
  their `prop` annotations are preserved; only `.page`-sourced entries are replaced

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

### `output` - Generate entry.cs from Page Database
**Usage**: `output <output_dir> [-p/--project-name <project_name>]`

**Description**: Generates an `entry.cs` C# source file from the project's page database into the
specified directory. Produces the same output as the C# `Port.Output()` API.

**Arguments**:
- `output_dir`: Target directory for `entry.cs` (created when missing; an existing `entry.cs` is overwritten)
- `-p, --project-name`: Project name (optional; resolved from `*.port.md` in the current directory when omitted)

**Features**:
- One `[PageDocument]` class per page category
- Constants carry `[PageEntry]` metadata (data type, enum name, package, property JSON, GEM IDs)
- Includes the `Category`, `Defined` (enums), and GEM ID helper classes
- Generated classes can be passed back to `Port.Push()` to rebuild the page DB

**Notes**:
- Requires a page database created by `push` — run `push <project_name>` first.
- While the port server is running, the page database is locked and generation may fail;
  run this command before `run` or stop the server first.

**Example**:
```bash
output D:\MyApp\Entry -p MyProject
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
**Usage**: `set <group> <key> <value> [--repo <repository>]`

**Description**: Sets data on the server including message values, system configurations, and executes various operations.

**Arguments**:
- `group`: Group name, package name, or operation context
- `key`: Key, message name, or operation type
- `value`: Value to set or operation parameters

**Flags**:
- `--repo <repository>`: Set the value directly in the repository's local DB
  (`%LOCALAPPDATA%\port\DB\{repository}`) instead of the running server. Use this before
  starting the server; the next `port run` starts with the value. Prints an error and
  exits when the repository has no local DB (run `port push` first).
  - Example: `port set --repo myproject room1 Temp1 42.5`
- `--create`: Register the entry at runtime when it does not exist yet, then set it. The
  data type is inferred from the value unless `--type` is given. Works against the running
  server (gRPC) and with `--repo`. Runtime entries are persisted as `domain/__runtime.entry`,
  are rebuilt by the next `port run`, and **survive `port push`**; their value is not
  persisted unless the entry carries the `backup` property.
  - Example: `port set room1 RuntimeTemp 42.5 --create --type F4`
- `--type <SECS type>`: Data type for `--create` (`F4`, `U2`, `A(32)`, `enum.Name`, ...).

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

# Set a value directly in a repository's local DB (offline, before the server runs)
port set --repo myproject room1 Temp1 42.5
port set --repo myproject room1 BulbState ON

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

## Session Audit Commands

### `session logs` - List FFI Call Audit Log

**Usage**: `session logs [flags]`

**Description**: Reads the FFI call audit log stored in `{project}_auth.db` and displays a timestamped record of every session-related FFI function call made by the running application. All password arguments are stored AES-256-GCM encrypted and are never shown in plaintext.

**Flags**:

| Flag | Default | Description |
|------|---------|-------------|
| `-p`, `--project-name <name>` | auto-detect | Project name (searches for `*.port.md` if omitted) |
| `-l`, `--limit <n>` | `50` | Maximum number of entries to display (newest first) |
| `-o`, `--offset <n>` | `0` | Skip this many entries from the newest end (paging) |
| `--ffi <name>` | all | Filter by FFI function name (case-insensitive) |
| `-f`, `--format <fmt>` | `table` | Output format: `table` or `json` |
| `--date <YYYY-MM-DD>` | today | Show entries for a specific date only |
| `--start <YYYY-MM-DD>` | — | Range start date (inclusive). Use with `--end`. |
| `--end <YYYY-MM-DD>` | — | Range end date (inclusive). Use with `--start`. |

**Date flag precedence**: `--start`/`--end` takes priority over `--date`. If neither is given, defaults to today.

**Logged FFI Functions**:

| FFI Name | Recorded Arguments |
|----------|--------------------|
| `Login` | `user_id`, `password`*(encrypted)*, `success` |
| `Signup` | `user_id`, `password`*(encrypted)*, `name`, `role_level` |
| `ChangePassword` | `user_id`, `current_password`*(encrypted)*, `new_password`*(encrypted)* |
| `DeleteUser` | `user_id` |
| `Logout` | `user_id` |
| `ReassignControlState` | `user_id`, `target_state`, `success`, `reason` |

**Password Security**:

Passwords are encrypted with **AES-256-GCM** using a randomly generated 32-byte key (`audit.key`) stored alongside the database:

```
%LOCALAPPDATA%\port\DB\{project}\{project}_auth.db   ← audit log table
%LOCALAPPDATA%\port\DB\{project}\audit.key            ← encryption key
```

The encrypted password field appears as a base64-encoded string (nonce + ciphertext). Without the `audit.key` file the ciphertext cannot be decrypted.

**Table Output Example**:

```
Session audit log for project 'myproject' [2026-03-31]

CALL_DATE             FFI_NAME                ARGS
--------------------------------------------------------------------
2026-03-31 10:25:42   Login                   {"user_id":"admin","password":"YWJj...","success":true}
2026-03-31 10:24:10   ChangePassword          {"user_id":"operator","current_password":"eHl6...","new_password":"cGFz..."}
2026-03-31 10:23:05   Signup                  {"user_id":"operator","password":"cGFz...","name":"Op1","role_level":1}
2026-03-31 09:55:00   Logout                  {"user_id":"admin"}

4 entry(ies)
```

**Examples**:

```bash
# Show today's entries (default)
port session logs

# Show today's entries for a specific project
port session logs -p myproject

# Show entries for a specific date
port session logs -p myproject --date 2026-03-28

# Show entries for a date range
port session logs -p myproject --start 2026-03-01 --end 2026-03-31

# Show last 100 entries for today
port session logs -p myproject --limit 100

# Show only Login attempts today
port session logs -p myproject --ffi Login

# Show Login attempts for a specific date range
port session logs -p myproject --ffi Login --start 2026-03-25 --end 2026-03-31

# Paginate: entries 51-100
port session logs -p myproject --limit 50 --offset 50

# Output as JSON
port session logs -p myproject --format json
```

**JSON Output Example**:

```json
[
  {
    "call_date": 1743416742,
    "ffi_name": "Login",
    "args": "{\"user_id\":\"admin\",\"password\":\"YWJj...\",\"success\":true}"
  },
  {
    "call_date": 1743416050,
    "ffi_name": "Logout",
    "args": "{\"user_id\":\"admin\"}"
  }
]
```

> **Note**: The `port session logs` command queries the port server via gRPC and requires the server to be running (`port run <project>`). The server owns the audit DB and serves all queries.

---

## Remote Packet Test (Serial/TCP Service Layer)

`port run` exposes a packet-test service layer: a remote caller — an LLM agent, `curl`, or the
`commtest` client — opens a serial port or TCP socket **on the machine where a `port connection`
agent runs**, exchanges raw bytes with the device, and closes it again. Every call is plain JSON over
the port server's REST API (`:8000`), so no gRPC client is needed on the caller side.

### Topology

```
LLM service / curl / commtest client
        │  HTTP JSON   POST /api/v1/packet/...
        ▼
port run            (REST :8000 — service layer, tracks sessions)
        │  gRPC CommunicationService
        ▼
port connection     (agent, :50002 — owns the serial port / TCP socket; may run on another host)
        │  serial / TCP
        ▼
device              (or the commtest Go simulator)
```

### 1. Start an agent on the device host

```bash
port connection                          # gRPC agent on 0.0.0.0:50002, no device opened yet
port connection 127.0.0.1:9600           # ...or pre-open a TCP device
port connection COM3 9600 8 0 0 None     # ...or a serial device
```

`port send "VER\r"` and `port recv --timeout 1000` talk to the local agent directly; the REST
service layer below does the same thing for remote callers and can address several agents.

### 2. Endpoints

| Method | Path | Body | Description |
|--------|------|------|-------------|
| `GET` | `/api/v1/packet/serial-ports` | – | Serial ports on the port-server host |
| `GET` | `/api/v1/packet/sessions` | – | Open sessions |
| `POST` | `/api/v1/packet/sessions` | `{agent?, connection}` | Open a device through an agent → session |
| `DELETE` | `/api/v1/packet/sessions` | – | Close every session |
| `POST` | `/api/v1/packet/sessions/{id}/send` | `{data \| hex}` | Send bytes |
| `POST` | `/api/v1/packet/sessions/{id}/recv` | `{timeout_ms?}` | Wait for bytes |
| `POST` | `/api/v1/packet/sessions/{id}/transact` | `{data \| hex, timeout_ms?}` | Send, then wait for the reply |
| `DELETE` | `/api/v1/packet/sessions/{id}` | – | Close one session |
| `POST` | `/api/v1/packet/run` | `{agent?, connection, steps[], stop_on_error?}` | One-shot: open → steps → close |

**Fields**

| Field | Meaning |
|-------|---------|
| `agent` | `host:port` of a `port connection` agent as seen from the port server. Default `127.0.0.1:50002`. |
| `connection` | Device to open, in `port connection` syntax: `host:port` (TCP) or `COM3 9600 8 0 0 None` (serial: port baud databits parity stopbits split). The port name `DUMMY` opens an in-process dummy serial port (see below). |
| `data` | Text payload; `\r`, `\n`, `\t`, `\\`, `\xHH` escapes are expanded (same as `port send`). |
| `hex` | Hex payload (`02 41 03`, `024103`, `02:41:03`). Wins over `data` when both are given. |
| `timeout_ms` | Receive wait, default `1000`. |
| `expect` / `expect_hex` | (run steps) pass when the reply text / hex **contains** this. A step without an expectation passes when it ran without an agent error. A step with neither `data` nor `hex` only receives. |

Replies carry the bytes both ways: `{"data": "PONG\r\n", "hex": "504f4e470d0a", "length": 6,
"timed_out": false}`. `timed_out: true` with `length: 0` means nothing arrived within `timeout_ms`.
Errors are JSON `{"error": "..."}` with `400` (bad payload), `404` (unknown session) or `502`
(agent unreachable or device open/send failed).

### 3. One-shot scenario (recommended for LLM services)

```bash
curl -s -X POST http://portserver:8000/api/v1/packet/run \
  -H 'Content-Type: application/json' \
  -d '{
    "agent": "devicehost:50002",
    "connection": "127.0.0.1:9600",
    "steps": [
      { "name": "ping",  "data": "PING\r",      "expect": "PONG" },
      { "name": "frame", "hex": "02 41 42 03",  "expect_hex": "06" },
      { "name": "temp",  "data": "GET TEMP\r",  "expect": "TEMP=", "timeout_ms": 500 }
    ]
  }'
```

```json
{
  "agent": "devicehost:50002",
  "connection": "127.0.0.1:9600",
  "steps": [
    { "name": "ping",  "sent_hex": "50494e470d", "received": { "data": "PONG\r\n", "hex": "504f4e470d0a", "length": 6, "timed_out": false }, "elapsed_ms": 3, "pass": true, "error": null },
    { "name": "frame", "sent_hex": "02414203",   "received": { "data": "\u0006", "hex": "06", "length": 1, "timed_out": false }, "elapsed_ms": 2, "pass": true, "error": null },
    { "name": "temp",  "sent_hex": "4745542054454d500d", "received": { "data": "TEMP=25.4\r\n", "hex": "54454d503d32352e340d0a", "length": 11, "timed_out": false }, "elapsed_ms": 2, "pass": true, "error": null }
  ],
  "passed": 3,
  "failed": 0,
  "error": null
}
```

The session opened by `run` is always closed, even when a step fails. For a serial device use
`"connection": "COM5 9600 8 0 0 None"`.

### 3a. Dummy serial port (no hardware)

The serial port name `DUMMY` (case-insensitive) opens a simulated instrument **inside the agent**
instead of a real COM port, so the whole serial code path can be exercised on a machine without
serial hardware or a virtual COM driver. Settings are validated like a real port (`DUMMY 9600 9 0 0 None`
is rejected), reads return nothing until a reply is pending, and the instrument answers the same
commands as `commtest serve`: `PING`→`PONG`, `VER`→`PORT DUMMY SERIAL 1.0`, `ECHO text`,
`GET TEMP|PRESS|STATUS`, `SET k v`/`GET k`, `STX…ETX`→`ACK` (0x06), unknown→`ERR UNKNOWN`.

```bash
curl -s -X POST http://portserver:8000/api/v1/packet/run \
  -H 'Content-Type: application/json' \
  -d '{"connection": "DUMMY 9600 8 0 0 None",
       "steps": [{"data": "PING\r", "expect": "PONG"}, {"hex": "02 41 03", "expect_hex": "06"}]}'

commtest client -server http://portserver:8000 -connection "DUMMY 9600 8 0 0 None" -send "GET STATUS\r" -expect STATUS=IDLE
```

### 4. Session-based test

```bash
# open (201 Created)
SID=$(curl -s -X POST http://portserver:8000/api/v1/packet/sessions \
  -H 'Content-Type: application/json' \
  -d '{"connection": "COM5 9600 8 0 0 None"}' | jq -r .id)

curl -s -X POST http://portserver:8000/api/v1/packet/sessions/$SID/transact \
  -H 'Content-Type: application/json' -d '{"data": "VER\r", "timeout_ms": 1000}'

curl -s -X POST http://portserver:8000/api/v1/packet/sessions/$SID/send \
  -H 'Content-Type: application/json' -d '{"hex": "02 52 53 54 03"}'
curl -s -X POST http://portserver:8000/api/v1/packet/sessions/$SID/recv \
  -H 'Content-Type: application/json' -d '{"timeout_ms": 2000}'

curl -s -X DELETE http://portserver:8000/api/v1/packet/sessions/$SID
```

### 5. commtest — Go device simulator

`Source_PortEx/commtest` is a small Go program that stands in for a device, plus a client that
drives `/api/v1/packet/run`:

```bash
cd Source_PortEx/commtest && go build -o commtest.exe .

# device host
port connection                       # agent
commtest serve                        # TCP :9600; -mode echo, -serial COM5, -delay 1500ms

# any machine
commtest client -server http://portserver:8000 -connection 127.0.0.1:9600 -send "PING\r" -expect PONG
commtest client -server http://portserver:8000 -agent devicehost:50002 -steps steps.json
```

Device mode answers `PING`→`PONG`, `VER`→`COMMTEST 1.0`, `GET TEMP|PRESS|STATUS`, `SET k v`/`GET k`,
`ECHO text`, and an `STX…ETX` frame with a single `ACK` byte; see `Source_PortEx/commtest/README.md`.

### Notes

- The agent must be reachable from the **port server** on TCP 50002 (open it in the device host's
  firewall); the caller only needs the port server's `:8000`.
- Receive waits are bounded by `timeout_ms`; serial reads poll in 1 s slices, so a serial wait can
  overshoot by up to one second.
- Sessions live until they are closed or the port server stops. `DELETE /api/v1/packet/sessions`
  closes everything, including the agent-side connection, so a forgotten test never keeps a COM
  port busy.
- These endpoints are unauthenticated like the rest of the REST API: keep `:8000` and `:50002` on a
  trusted network.

---

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