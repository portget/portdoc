# Welcome to Port

`More Easily Create an API-Server with Port App`, designed to streamline the deployment of pkgs for developers. With this tool, developers can effortlessly deploy pkgs and integrate various applications to build a unified web service. Port Application simplifies the process, enabling developers to focus on creating seamless and efficient solutions with ease.

Please see the documentation [lincense](license.md)

## The Requirements 
---
* os         : windows 7+ / windows server 2003+
* memory     : minimum 32GB
* requirements : 


!!! tip
    System Requirements [.sdk-8.0.403-windows-x64-installer](https://dotnet.microsoft.com/ko-kr/download/dotnet/thank-you/sdk-8.0.403-windows-x64-installer){:download}

## Download URL
---

VERSION | OS |STABLE | URL 
------|--------|--------|--------
v1.0.30 | Windows x64 | Yes | [v1.0.30-win-installer](https://github.com/portget/port/archive/refs/tags/v1.0.30-win-installer.zip){:download}  
v1.0.29 | Windows x64 | Yes | [v1.0.29-win-installer](https://github.com/portget/port/archive/refs/tags/v1.0.29-win-installer.zip){:download}   


## Project Layout
___
The Port project is remarkably simple and straightforward. To get started, first create a project folder in the console, then type port new sample. This will quickly generate the project files. After that, create sub-group folders and add .msg files to each sub-group folder. Feel free to create messages using text, num, and enum types as you like. Once you've specified the attributes, type port push and Port will automatically store everything. Now, just run port run sample, and the server will start, allowing you to safely and easily share messages across multiple applications.

### Repository 

<div class="console">
  <div class="console-content">
  port new [name]
  </div>
</div>



___
#### Layout 
``` 
APT/
│
├── room1/      # The group directory. 
│   ├── *.msg   # The message file 
│
├── room2/      # The group directory. 
│   ├── *.msg   # The message file 
│
└── *.enum
└── port.toml   # The configuration file.
```
___

!!! tip
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.
___

### Group 
A group serves as the root of messages. Within a single group, multiple message files can be stored, allowing for easy retrieval and editing. By managing several .msg files within the group folder, you can conveniently organize and abstract them for streamlined management.

<div class="console">
  <div class="console-content">
  port add --group [name]
  </div>
</div>

 
___

<br/>
### Message (*.msg)
A message is an object that allows users to specify pkg properties in a pre-provided Application Service. The message is a kv, and types and properties can be defined in that message. 
Please attach the materials attached below. 
___
* message item format like this `[key] [datatype] [option...]`
* `[key]`      - unique key in the message group
* `[datatype]` - text | num | enum 
* `[attribute]` - pkg,backup,rule,frame,property


#### datatype
name | range | description
 ------|--------|--------
 text | `0~255` | The length can be specified as a value from 0 to 255.
 num  | `-1.7e+308 ~` <p>`+1.7e+308`  | The floating-point type that allows for the representation of decimal numbers and is capable of representing a wide range of values, both very small and very large.
 enum | `0 ~ 65535` | The user can utilize the fixed list values specified in the .enum file, which can be used at a lower cost than text values and with stricter usage.  
 
<br/>
#### attribute
 
 name|description
 ------|--------
 pkg     | Real-time synchronization and messaging are handled within the corresponding external library. For more details, please refer to the pkg documentation.
 backup  | Changes are saved to the backup database as they occur, ensuring that values are restored upon application restart. and values are not propagated pkg messages during program execution.
 property| Can specify a custom property
 rule    | Can specify rules to manage the values of corresponding messages.  

<br/>

#### ./room1/*.msg
```console
 BulbOnOff     enum.OffOn  pkg:Blub1.Power   property:{"Arguments":"yellow"}
 BulbOnOff     enum.OffOn  pkg:Blub1.Power   property:{"Arguments":"red"}      
 RoomHeater1   enum.OffOn  pkg:Heater1.Power property:{"Arguments":"1,0"}
 RoomHeater2   enum.OffOn  pkg:Heater1.Power property:{"Arguments":"2,0"}
 RoomTemp      num         pkg:Heater1.Temp  property:{"MIN":0,"MAX":300} 
 ...
```

!!! tip
    message document do not using special characters. 


<br/>
<br/>
### Enum (*.enum)
___

Enums are particularly useful when you have a fixed set of values that a variable can take, such as days of the week, months of the year, or status codes. They help make your code more expressive, self-documenting, and less error-prone because you're working with named constants instead of raw integer values. 

* enum item format like this`[key] [item-name:number_key] [item-name:number_key]` 
* `[key]`      - unique key in the enum message
* `[item-name]`- name by enum-item
* `[property]` - unique key in enum value




#### *.enum
```console
TFalse      True:0      False:1
FTrue       False:0     True:1
OffOn       Off:0       On:1
OnOff       On:0       Off:1
```







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