# Quick Start
___
Port operates by reflecting messages in the most recently updated repository. 
Try creating and editing a basic project to see how you can modify and configure projects. Follow along to understand the process better.



<br>

## How to create a packages 

___
Let's develop a package. In the Port Application, all operations are grouped at the package level and function at the message level. Every operation is defined within messages, allowing users to increase code reusability through messages.

<br/>
<br/>

### Attributes
___

 name | arguments | description
 ------|-------- |--------
 Message   |`-` |  Messages are declared, and the values defined as properties can be controlled through package calls.
 Regex  |`[Pattern|Type]` |  It is validated through a regular expression check. If the value matches the specified regular expression, it is accepted as valid; otherwise, an input exception is triggered.
 EnumCode   |`-` |  The Enum type is declared, allowing you to retrieve the Enum values through this declaration.
 Comment  |`-` |  A comment is declared, allowing you to retrieve the comment through this declaration.

#### Message Attributes
Properties declared with Message Attributes are defined as API Messages and made available to the end-user. They apply only to properties with get and set accessors, and these getters and setters can be accessed and modified via a REST API.

```
    [Message]
    public int NValue { get => 3; }
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





### Download
NAME | Language |Package Manager | OS | STABLE | 
------|--------|--------|--------|--------
Port.SDK |  C# | Nuget |Windows x64 | Yes | 




<br>


### Sample code (.net)

***
!!! important  "The class name must be declared as `Port`"
***

#### bulb package 

```C# 
 
 public class Port : PortObject
 {
     public Port()
     {
        
     }
     
     public override bool Init()
     {
        // initialized method
     }
     
     public override void Dispose()
     {
        
     } 
     
     private string status = "On";
     
     [Message]
     public string OnOff { get => { return status == "On" ? "Off" : "On"; }} 
 
 }
 
``` 

#### heater package 
 
```C# 
 
 public class Port : PortObject
 {
     public Port()
     {
        
     }
     
     public override bool Init()
     {
        // initialized method
     }
     
     public override void Dispose()
     {
        
     } 

     [Message]
     public double GetTemperature { get => { var rand = new Random(); return rand.Next(); }
 
 }

``` 



<br/>
<br/>

#### Here's an example 

<br/>
<div class="console">
    <div class="console-content">
        port save bulb [package-release-path]
    </div>
</div> 

<br>
<div class="console">
    <div class="console-content">
       port save heater [package-release-path]
    </div>
</div>

<br>

## How to create a port-project
___
Before starting a Port project, you need to create a root folder that defines your messages. The subfolders within this root folder are managed as groups by Port, allowing users to organize messages by group. The root folder contains files with the `*.enum` extension and the structure of sub-group folders. Within the sub-group folders, message definition documents with the `*.msg` extension are created.

#### Here's an example 

<br/>
<div class="console">
    <div class="console-content">
    cd C:\Users\sample
  </div>
</div>
<br/>
 
<div class="console">
    <div class="console-content">
    port new sample
  </div>
</div>
<br/>

<div class="console">
   <div class="console-content">
    port add --group subgroup1,subgroup2
  </div>
</div>

 

#### Project Layouts
``` 
sample/
│
├── subgroup1/
│   ├── *.msg
│
├── subgroup2/
│   ├── *.msg 
│
└── *.enum
```

## How to add messages 
___
To declare a message, you need to edit the `*.msg` file in the sub-folder you created. By defining message data types and attributes as shown below, you can later utilize various features such as automatic logging and backup. Additionally, you can define relationships using predefined relations.

#### Sample message files
```
 
 bulb1          enum.OnOff   pkg:bulb1.PowerOnOff         
 bulb2          enum.OnOff   pkg:bulb2.PowerOnOff       property:{"Arguments":"1,0"}
 heater1temp    num          pkg:heater1.GetTemperature property:{"MIN":0,"MAX":300}
 heater2temp    num          pkg:heater2.GetTemperature property:{"MIN":200,"MAX":500}          

```


## How to link packages
___


#### Check packages

<div class="console">
    <div class="console-content"> 
    port ls pkg 
   </div>
</div>
<br>
<div class="console">
    <div class="console-content"> 
    package1  [DateTime]
    package2  [DateTime]
    package3  [DateTime]
    package4  [DateTime] 
   </div>
</div>

<br>
#### Add packages
<br>
<div class="console">
    <div class="console-content">
    cd C:\Users\Demo
   </div>
</div>
<br/>
<div class="console">
    <div class="console-content">
    port add --pkg bulb1 bulb
   </div>
</div>
<div class="console">
    <div class="console-content">
    port add --pkg bulb2 bulb
   </div>
</div>
<div class="console">
    <div class="console-content">
    port add --pkg heater1 bulb
   </div>
</div>
<div class="console">
    <div class="console-content">
    port add --pkg heater2 bulb
   </div>
</div>
    
!!!tip
    If you see a message like `[ERROR][open ..\proj.toml: Access is denied.]`
    granting administrator privileges to the port.exe program will resolve the issue.

After linking the relations to your project, you can verify the integration using the following command


## How to start project
Once all message definitions are complete, you can start the message server based on these definitions. Before running the server, upload all updated content to the local repository by entering `port push` in the console. Then, run the server with the command `port run [project-name]`.

<div class="console">
    <div class="console-content">
       port push 
    </div>
</div>

<br>
<div class="console">
    <div class="console-content">
       port run sample  
    </div>
</div>
<br>
<div class="console">
    <div class="console-content">
      [localhost:5001]Port Running ... OK
       Access point count [4]
       Package count [2]
       Pressing 'CTRL + C' will initiate server shutdown.
       Please wait for all processes to safely terminate before closing the application.
    </div>
</div>
      

!!!tip
    When running the server, if you include `--ng ignore` in the command, it will summarize only the points where errors (NG) occur. For detailed information on these NG points, you can visit the following URL to view the NG point table: 
    <p><a href="http://localhost:5001/api/app/ng/?view=table">http://localhost:5001/api/app/ng/?view=table</a></p>

####   Good luck!

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