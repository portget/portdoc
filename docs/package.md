# What's Package
___
The Port package is a collection of reusable libraries. Users can develop packages by inheriting the `PortObject`, then link it to a Message, allowing for straightforward usage through Message calls.



## Download
NAME | Language |Package Manager | OS | STABLE | 
------|--------|--------|--------|--------
Port.SDK |  C# | Nuget |Windows x64 | Yes | 



<br>



## Package Annotation
___

 name | targets | type |arguments | description
 ------|-------- |-------- |-------- |--------
 Port   |class|`-`| `Class Type`| Declaring a port attribute in a class designates that class as one managed by the port system. Once declared, the class can be registered as part of a package.
 Vaild |method<p>property|`bool`|`invalid comment` | Maps the property to a pre-declared Message Property.
 Message   |property| `string|double` |`-` |  Messages are declared, and the values defined as properties can be controlled through package calls.
 Logger   |property|`ILogger`|`-` |  Specifies that the Logger field is to be injected with a logging system or service.
 Property |property|`IProperty`|`Message name` | Maps the property to a pre-declared Message Property.

#### Valid

<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
[Valid("Invlid for connection")]
public bool Valid()
{
    return true;
}
</code>
</pre>
</div>

#### Port

This annotation indicates that the Heater class is managed within the Port Package.

<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
[Port(typeof(Heater))]
public class Heater
...
</code>
</div>
</pre>

#### Logger
This annotation specifies that the Logger field is to be injected with a logging system or service.
<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
[Logger]
public ILogger Logger { get; set; }

...
Logger.Write(string.Join(",", v));
...
</code>
</div>
</pre>


#### Property
This annotation maps the property to a declared Message Property.

<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
[Property]
public IProperty Property { get; set; }
...
if (this.Property.TryToGetValue("Unit", out string v1)){
    ...
}
...    
</code>
</div>
</pre>


 
#### Message
Properties declared with Message Annotation are defined as API Messages and made available to the end-user. They apply only to properties with get and set accessors, and these getters and setters can be accessed and modified via a REST API.

<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
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
</code>
</div>
</pre>
 


 

#### EnumCode
EnumCode Annotation are declared, the values of the enum can be accessed via an API. The API allows for the retrieval of information about the enumeration values, enabling external systems or users to interact with and obtain details about the enum through the API interface.
```   
    [EnumCode]
    public enum TestEnum : ushort
    {
        _ = 0,
        TestEnumItem1,
        TestEnumItem2,
    }
```

#### Comment
When Comment Annotation are declared, the comments associated with the property can be exposed through the API. This allows users or external systems to access descriptive information or documentation about the property via the API, providing context and clarity on the property's purpose or usage.
```  
     [Message,Commnet("this is a numberic")]
     public int NValue { get => 3; }
```


## How to create a packages 

___
Let's develop a package. In the Port Application, all operations are grouped at the package level and function at the message level. Every operation is defined within messages, allowing users to increase code reusability through messages.
 
<br>


### Create a class library(.net) 

#### bulb package 

<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
[Port(typeof(Bulb))]
public class Bulb
{ 
    [Logger]
    public ILogger Logger { get; set; }

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
   [Message(PortDataType.Enum), Property(PropertyFormat.Json)]
   public string OffOn
   {
       set
       {
           var prop = MessageProperty.Get();
           try
           {
               if (prop != null)
               {
                   //prop.Arguments[0]
                   //Logger.Write("[Arguments]" + prop.Arguments[0]);
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
</code>
</pre>
</div>


#### heater package 

<div class="code-box">
<pre>
<code id="code-snippet" class="language-csharp">  
 [Port(typeof(Heater))]
 public class Heater
 {

    [Message(PortDataType.Text)]
    public string Power
    {
        set;
        get;
    }

    [Valid("Invlid for connection")]
    public bool Valid()
    {
       return true;
    }

    private static Random r = new Random(100);
    [Message(PortDataType.Num), Property(PropertyFormat.Json)]
    public double Temp
    {
         get
         {
             var prop = MessageProperty.Get();
             if (prop != null)
             {
                 if (prop.TryToGetValue("Arguments", out object value) && value.ToString() == "F")
                 {
                     return ((r.NextDouble() * 9 / 5) + 32);
                 }
                 else if (prop.TryToGetValue("Arguments", out object v2) && v2.ToString() == "C")
                 {
                     return (r.NextDouble());
                 }
             }
             return (1);
         }
    }
}
</code>
</pre>
</div>

<br/>
<br/>

### How to publish a library (.NET)

<div> 
    <p>This manual provides step-by-step instructions on how to publish a .NET Core project using Visual Studio Code.</p>
    <h4> 1. Prerequisites </h4>
    <ul>
        <li><strong>Install .NET SDK:</strong> Make sure you have the latest version of the .NET SDK installed. <a href="https://dotnet.microsoft.com/download" target="_blank">Download here</a>.</li>
        <li><strong>Install C# Extension:</strong> Install the C# extension in Visual Studio Code from the <a href="https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp" target="_blank">Marketplace</a>.</li>
        <li><strong>Verify the Build:</strong> Ensure your project builds and runs correctly:
            <pre><code>dotnet build
            dotnet run</code></pre>
        </li>
    </ul>
    <h4>2. Publish Command</h4>
    <h4>Basic Publish Command</h4>
    <p>Run the following command to publish your project:</p>
    <pre><code>dotnet publish -c Release -o ./publish</code></pre>
    <ul>
        <li><code>-c Release</code>: Builds the project in Release mode.</li>
        <li><code>-o ./publish</code>: Specifies the output folder for the published files.</li>
    </ul>
    <h4>Publishing for Specific Runtime</h4>
    <p>To target a specific runtime (e.g., Windows, Linux, macOS), use the following command:</p>
    <pre><code>dotnet publish -c Release -r win-x64 --self-contained false</code></pre>
    <ul>
        <li><code>-r win-x64</code>: Targets Windows 64-bit. Examples for other platforms:</li>
        <ul>
            <li><code>linux-x64</code>: Linux 64-bit</li>
            <li><code>osx-x64</code>: macOS 64-bit</li>
        </ul>
        <li><code>--self-contained false</code>: Requires .NET runtime to be installed on the target environment.</li>
    </ul>
    <h4>3. Automating Publish with Tasks in VS Code</h4>
    <p>Set up a task in VS Code to automate the publish process:</p>
    <ol>
        <li>Open the <code>.vscode/tasks.json</code> file. If it doesn’t exist, create it.</li>
        <li>Add the following configuration:</li>
    </ol>
    <pre><code>{
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
}</code></pre>
    <p>Run the task in VS Code:</p>
    <ol>
        <li>Open the Command Palette (<code>Ctrl+Shift+P</code>).</li>
        <li>Select <code>Tasks: Run Task</code>.</li>
        <li>Choose <code>Publish .NET Core</code>.</li>
    </ol>
    <h4>4. Deployment</h4>
    <p>The published files will be available in the <code>./publish</code> folder. Copy these files to the desired deployment location:</p>
    <ul>
        <li><strong>Local Deployment:</strong> Copy files to a server or hosting environment.</li>
        <li><strong>Docker Deployment:</strong> Use a <code>Dockerfile</code> to containerize your application:
            <pre><code>FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
COPY ./publish .
ENTRYPOINT ["dotnet", "YourApp.dll"]</code></pre>
        </li>
    </ul>
    <h4>5. Logging and Debugging</h4>
    <p>To log publish output to a file, use:</p>
    <pre><code>dotnet publish > publish_log.txt</code></pre>
    <p>Check the logs for any errors and resolve them before deployment.</p>
    <h4>6. Additional Resources</h4>
    <ul>
        <li><a href="https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-publish" target="_blank">Official .NET Publish Documentation</a></li>
        <li><a href="https://code.visualstudio.com/docs" target="_blank">Visual Studio Code Documentation</a></li>
    </ul>
</div>

### Packing packages



1. `cd [Publish target location]`


2. `port pack [dllname] [pkg-name]`

3. check logs
<br>
<div class="console">
    <div class="console-content">
        PS C:\Users\Public\Dev\publish> port pack HeaterLib.dll HeaterLib1
        [PATH]C:\Users\Public\Dev\publish\HeaterLib.dll
        [ALREADY_RUN]PORT PACKAGE MANAGER
        [RUN]PORT PACKAGE MANAGER
        [PACK][pack] Packing started at 2025-01-07T21:17:19+09:00
        [PACK]load compelete C:\Users\Public\Dev\publish\HeaterLib.dll : heaterlib
        [PACK][GET][0] Power
        [PACK][GET][1] Temp
        [PACK][SET][0] Power
        [PACK]heaterlib,65025
        [PACK]initialization
        [CREATED][PACKAGE] ...\port\pkg\HeaterLib1.pkg
    </div>
</div>

<br>
  
 
<style>
 
 
    

.console {
    width: 80%;
    height: 80%;
    background-color: whitesmoke;
    color: black;
    padding: 0px;
    box-sizing: border-box;
    border-radius: 8px;
    overflow-y: auto;
}
.yellow{
    color:yellow;
}
.console-content {
    white-space: pre-wrap;
}

.console-content p {
    margin: 0;
}


.notepad {
    width: 100%;
    height: 80%;
    background-color: white;
    color: black;
    padding: 20px;
    box-sizing: border-box;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
    overflow-y: auto;
}

.notepad:before {
    content: '';
    position: absolute;
    top: 10px;
    left: 20px;
    right: 20px;
    height: 2px;
    background-color: #ccc;
}

.notepad:after {
    content: '';
    position: absolute;
    top: 30px;
    left: 20px;
    right: 20px;
    height: 2px;
    background-color: #ccc;
}

.notepad-content {
    margin-top: 40px;
}

.notepad-content p {
    margin: 0 0 10px;
    line-height: 1.5;
}

 pre {
            color: #f8f8f2;
            border-radius: 5px;
          padding:0px;
          overflow-x: auto;
        }
        code {
            font-family: monospace;
            background-color: #f4f4f4;
            padding: 2px 4px;
            border-radius: 4px;
        }
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-csharp.min.js"></script>