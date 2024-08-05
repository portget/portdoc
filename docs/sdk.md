
# What's PortSDK?
__________________

Port offers a Software Development Kit (SDK) for developing system applications. With this SDK, developers can create consistent software that provides APIs, libraries, and structured documentation to end users, enabling more efficient configuration management.


# Get Started
__________________

## Download
NAME | Language |Package Manager | OS | STABLE | 
------|--------|--------|--------|--------
Port.SDK |  C# | Nuget |Windows x64 | Yes | 

## Command 
Command | Key | Flags |Description  
------|--------|--------|--------
Run  | [Name] | No Need |Run application or api-object
View | [Name] | `--history` `event|count` | View the history for this api-object
Get  | [Name] [Message-Name] | No Need | Get Message Value 
Set  | [Name] [Message-Name] | No Need | Set Message Value  

## APIObject
All objects inheriting from the APIObject can invoke messages defined in the API class via the Port Application. These messages are defined through an existing API Document, and additional attributes can be defined to provide messages with extra functionalities.



### C# 
```C# 
 public class API : APIObject
 {
     public API()
     {
         this.SetLogger(new ExLogger());
     }

     public override void Dispose()
     {
     }

     protected override bool IsSetterReady()
     {
         return true;
     }


     private SerialPort serial = new SerialPort();

     [Message, Reserved(ReservedAttribute.Type.Address), Regex(RegexAttribute.ComRegex)]
     public string Address
     {
         get;
         set;
     }

     [Message]
     public int NValue { get => 3; }

     [Message]
     public double DValue { get => 2; }

     [Message]
     public string UValue { get => "on"; }

     [Message]
     public int DI
     {
         get
         {
             var v = new Random().Next(0, 3);



             return v;
         }
     }
 }
``` 




### Attributes
___


#### Message Attributes
Properties declared with Message Attributes are defined as API Messages and made available to the end-user. They apply only to properties with get and set accessors, and these getters and setters can be accessed and modified via a REST API.

```C#
    [Message]
    public int NValue { get => 3; }
```

#### Reserved Attributes

```   
    [Message, Reserved(ReservedAttribute.Type.Address), Regex(RegexAttribute.ComportRegex)]
    public string Address
    {
        get;
        set;
    }
```   
#### Regex Attributes
Properties with Regex Attributes are subjected to a regular expression check when their values are changed. If the value does not pass the validation check, it is not updated, ensuring consistency and validity of the property's value.

```  
    [Message, Regex(RegexAttribute.Ip4vRegex)]
    public string Address
    {
        get;
        set;
    }
```

#### EnumCode Attributes
EnumCode Attributes are declared, the values of the enum can be accessed via an API. The API allows for the retrieval of information about the enumeration values, enabling external systems or users to interact with and obtain details about the enum through the API interface.
```   
    [EnumCode]
    public enum TestEnum : ushort
    {
        _ = 0,
        TestEnumItem1,
        TestEnumItem2,
    }
```

#### Comment Attributes
When Comment Attributes are declared, the comments associated with the property can be exposed through the API. This allows users or external systems to access descriptive information or documentation about the property via the API, providing context and clarity on the property's purpose or usage.
```  
     [Message,Commnet("this is a numberic")]
     public int NValue { get => 3; }
```
