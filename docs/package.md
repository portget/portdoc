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

 name | arguments | description
 ------|-------- |--------
 Port   |`Class Type` | Declaring a port attribute in a class designates that class as one managed by the port system. Once declared, the class can be registered as part of a package.
 Message   |`-` |  Messages are declared, and the values defined as properties can be controlled through package calls.
 Logger   |`-` |  Specifies that the Logger field is to be injected with a logging system or service.
 Property |`Message` | Maps the property to a pre-declared Message Property.
 Regex  |`[Pattern|Type]` |  It is validated through a regular expression check. If the value matches the specified regular expression, it is accepted as valid; otherwise, an input exception is triggered.
 EnumCode   |`-` |  The Enum type is declared, allowing you to retrieve the Enum values through this declaration.
 Comment  |`-` |  A comment is declared, allowing you to retrieve the comment through this declaration.

#### Port

This annotation indicates that the Bulb class is managed within the Port Package.

```
    [Port(typeof(Bulb))]
    public class Bulb
    ...
```

#### Property
This annotation maps the property to a pre-declared Message Property named "OffOn".
```
    //Load from .msg files. yellow and red
    [Property("OffOn")]
    public IProperty OffOnArgument { set; get; } 
    
```

#### Message
Properties declared with Message Annotation are defined as API Messages and made available to the end-user. They apply only to properties with get and set accessors, and these getters and setters can be accessed and modified via a REST API.

```
    [Message]
    public string OffOn
    {
        set
        {
            if (OffOnArgument != null)
            {
                OffOnArgument.TryToGetValue("Argument", out Value v);
                if (v.String() == "yellow")
                {
                    this.SetColor(v.String());
                }
                else if (v.String() == "red")
                {
                    this.SetColor(v.String());
                }
                Logger.Write("[SET]" + v.String());
            }

            this.offon = value;
        }
        get => this.offon;
    }
```
 
#### Logger
This annotation specifies that the Logger field is to be injected with a logging system or service.
```
    [Logger]
    public ILogger Logger { get; set; }

    ...
    Logger.Write(string.Join(",", v));
    ...        
    
```


#### Regex
Properties with Regex Annotation are subjected to a regular expression check when their values are changed. If the value does not pass the validation check, it is not updated, ensuring consistency and validity of the property's value.

```  
    [Message, Regex(RegexAttribute.Ip4vRegex)]
    public string Address
    {
        get;
        set;
    }
```

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


### .net 

#### bulb package 

```C# 
 
 [Port(typeof(Bulb))]
 public class Bulb
 {
     public string offon = "Off";

     [Property("OffOn")]
     public IProperty OffOnArgument { set; get; }

     [Logger]
     public ILogger Logger { get; set; }

     private System.IO.Ports.SerialPort serialPort = new System.IO.Ports.SerialPort();
     
     private void SetColor(string color)
     {
         this.serialPort.Write("set:color:" + color + "\n");
     }

     private string comport;
     [Message]
     public string Comport
     {
         set
         {
             try
             {
                 if (this.serialPort.PortName != value)
                 {
                     this.serialPort = new System.IO.Ports.SerialPort();
                     this.serialPort.PortName = value;
                     this.serialPort.BaudRate = 9600;
                     this.serialPort.DataBits = 8;
                     this.serialPort.StopBits = System.IO.Ports.StopBits.One;
                     this.serialPort.Parity = System.IO.Ports.Parity.Even; 
                 }
             }
             catch (System.Exception ex)
             {
                 Logger.Write("[ERROR]" + ex.Message);
             }
         }
         get => comport;
     }

     [Message]
     public string OffOn
     {
         set
         {
             if (OffOnArgument != null)
             {
                 OffOnArgument.TryToGetValue("Argument", out Value v);
                 if (v.String() == "yellow")
                 {
                     this.SetColor(v.String());
                 }
                 else if (v.String() == "red")
                 {
                     this.SetColor(v.String());
                 }
                 this.offon = value;
                 this.serialPort.Write(value + "\n");
                 Logger.Write("[SET]" + v.String());
             }


         }
         get => this.offon;
     }
``` 

#### heater package 
 
```C# 
 
 [Port(typeof(Heater))]
 public class Heater
 {  
    [Message]
    public string Power
    {
         set;
         get;
    }
    // "Property" applied to the TempProperty property.
    [Property("Temp")]
    public IProperty TempProperty
    {
        set;
        get;
    }
    // "Message" applied to the Temp property.
    [Message]
    public double Temp
    {
        get
        {
            Random r = new Random(100);
            // Checks if the "Arguments" parameter of TempProperty is set to "F" for Fahrenheit. 
            if (this.TempProperty["Arguments"] == "F")
            {
                return (r.NextDouble() * 9 / 5) + 32;
            }
            // Checks if the "Arguments" parameter of TempProperty is set to "C" for Celsius.
            else if (this.TempProperty["Arguments"] == "C")
            {
                return r.NextDouble();
            }
            return 1;
        }
    } 
 }

``` 

<br/>
<br/>

#### build packages

<br/>
<div class="console">
    <div class="console-content">
        port build 'path' --o BulbLib1
        port build 'path' --o BulbLib2
    </div>
</div> 

<br>
<div class="console">
    <div class="console-content">
        port build 'path' --o HeaterLib1
        port build 'path' --o HeaterLib2
    </div>
</div>

<br>
  

 
## How to link packages
___



#### checking for package

<div class="console">
    <div class="console-content"> 
    port ls pkg 
   </div>
</div>
<br>

#### packages list

<div class="console">
    <div class="console-content"> 
    package1  [DateTime]
    package2  [DateTime]
    package3  [DateTime]
    package4  [DateTime] 
   </div>
</div>

<br>

#### Set a packages 

`[proj.toml]`
<div class="console">
    <div class="console-content">
        ...

        # packages 
        [[packages]]
        key = 'Blub1'
        load = 'BulbLib.dll'
        path = 'pkg:BulbLib1.pkg'

        [[packages]]
        key = 'Blub2'
        load = 'BulbLib.dll'
        path = 'pkg:BulbLib2.pkg'

        [[packages]]
        key = 'Heater1'
        load = 'HeaterLib.dll'
        path = 'pkg:HeaterLib1.pkg'

        [[packages]]
        key = 'Heater2'
        load = 'HeaterLib.dll'
        path = 'pkg:HeaterLib2.pkg'
    </div>
</div>
<br/> 
!!!tip
    If you see a message like `[ERROR][open ..\proj.toml: Access is denied.]`
    granting administrator privileges to the port.exe program will resolve the issue.

After linking the relations to your project, you can verify the integration using the following command



<style>

.console {
    width: 80%;
    height: 80%;
    background-color: whitesmoke;
    color: black;
    padding: 20px;
    box-sizing: border-box;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
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
</style>