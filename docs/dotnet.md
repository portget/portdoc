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

- **Efficient Lookup**: Fast key-value pair retrieval
- **Multi-platform Support**: Available across different programming languages
- **Real-time Updates**: Live data synchronization
- **Event-driven Architecture**: Responsive to system changes
- **Test Mode Support**: Package testing and validation
- **Type Safety**: Proper data type handling and conversion

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
- **Automatic Creation**: Logs generated automatically during operations
- **Categorized Storage**: Separate folders for different log types
- **Troubleshooting**: Comprehensive information for issue diagnosis
- **System Analysis**: Performance and behavior tracking

### SSH Log Access {#ssh-log-access}

Retrieve logs remotely using SSH commands:

```bash
get sample.log
```