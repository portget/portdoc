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
 Port   |class|-| `Class Type`| Declaring a port attribute in a class designates that class as one managed by the port system. Once declared, the class can be registered as part of a package.
 Message   |property|Cache |`-` |  Messages are declared, and the values defined as properties can be controlled through package calls.
 Logger   |property|ILogger|`-` |  Specifies that the Logger field is to be injected with a logging system or service.
 Property |property|IProperty|`Message name` | Maps the property to a pre-declared Message Property.
 Vaild |method<p>property|bool|`invalid comment` | Maps the property to a pre-declared Message Property.

#### Port

This annotation indicates that the Bulb class is managed within the Port Package.

```
    [Port(typeof(Bulb))]
    public class Bulb
    ...
```

#### Property
This annotation maps the property to a pre-declared Message Property.
```
    //if you want to use property for message
    [Message(PortDataType.Enum), Property] 
    public Cache OffOn
    {
           set
           {
               var prop = MessageProperty.Get();
               try
               {
                   if (prop != null)
                   {
                       Logger.Write("[Arguments]" + prop.Arguments[0]);
                       this.offon = value.String();
                   }
               }
               catch (Exception ex)
               {
                   Logger.Write("[ERROR]" + ex.Message);
               }
           }
           get
           {
               return new Cache(this.offon);
           }
    }
    
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
       public Cache Comport
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
               return new Cache(comport);
           }
       }
       private string offon = string.Empty;
       [Message(PortDataType.Enum), Property]
       public Cache OffOn
       {
           set
           {
               var prop = MessageProperty.Get();
               try
               {
                   if (prop != null)
                   {
                       Logger.Write("[Arguments]" + prop.Arguments[0]);
                       this.offon = value.String();
                   }
               }
               catch (Exception ex)
               {
                   Logger.Write("[ERROR]" + ex.Message);
               }
           }
           get
           {
               return new Cache(this.offon);
           }
       }
   }
``` 

#### heater package 
 
```C# 
 
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
    [Message(PortDataType.Num), Property]
    public Cache Temp
    {
        get
        {
            var prop = MessageProperty.Get();
            if (prop != null)
            {
                if (prop["Arguments"] == "F")
                {
                    return new Cache((r.NextDouble() * 9 / 5) + 32);
                }
                else if (prop["Arguments"] == "C")
                {
                    return new Cache(r.NextDouble());
                }
            }
            return new Cache(1);
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