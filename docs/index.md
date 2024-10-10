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
v1.0.26 | Windows x64 | Yes | [v1.0.26-win-installer](https://github.com/portget/port/archive/refs/tags/v1.0.26-win-installer.zip){:download}
v1.0.25 | Windows x64 | No | [v1.0.25-win-installer](https://github.com/portget/port/archive/refs/tags/v1.0.25-win-installer.zip){:download}



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
 
    port.toml         # The configuration file.
    .enum             # The custom enum file 
    pkg-A-Group/      # The group directory. 
        sample1.msg   # The message file
        sample2.msg   # The message file
        sample3.msg   # The message file

    pkg-B-Group/      # The group directory. 
        sample1.msg   # The message file
        sample2.msg   # The message file
        sample3.msg   # The message file
    ...               # Other files.

___

!!! tip
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.
___

### Group 

```console
port add [group-name]
```
 
___

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
 
#### attribute
 
 name|description
 ------|--------
 pkg     | Real-time synchronization and messaging are handled within the corresponding external library. For more details, please refer to the pkg documentation.
 backup  | Changes are saved to the backup database as they occur, ensuring that values are restored upon application restart. and values are not propagated pkg messages during program execution.
 property| Can specify a custom property
 rule    | Can specify rules to manage the values of corresponding messages.  
 
#### sample1.msg
```console
 DevAPowerStatus    enum.DeviceAStatus  pkg:DeviceA.GetStatus         
 DevAErrorMessage   text                pkg:DeviceA.GetErrorMessage property:{"Arguments":"1,0"}
 DevCTemperature    num                 pkg:DeviceC.GetTemperature property:{"MIN":0,"MAX":300}
 DevCOnOff          enum.OnOff          pkg:DeviceC.OnOff           
 ...
```

!!! tip
    message document do not using special characters. 


### Enum (*.enum)
___

Enums are particularly useful when you have a fixed set of values that a variable can take, such as days of the week, months of the year, or status codes. They help make your code more expressive, self-documenting, and less error-prone because you're working with named constants instead of raw integer values. 

* enum item format like this`[key] [item-name:number_key] [item-name:number_key]` 
* `[key]`      - unique key in the enum message
* `[item-name]`- name by enum-item
* `[property]` - unique key in enum value




#### custom.enum
```console
TFalse      True:0      False:1
FTrue       False:0     True:1
```



## Commands
___


### Cheat Sheet
 
 command | arguments | description
 ------|-------- |--------
 ?     |`[script]` | Runs the specified script. 
 version |`-` | Displays the version information. 
 new | `[name]`  | Can specify rules to manage the values of corresponding messages. 
 push|`-` | Push project to repository.
 pull|`-` | Pull project from repository.
 set |`[group-name|pkg-name] [message-name] [value]` | Set values in the pkg server.
 get |`[group-name|pkg-name] [message-name]`  | Get values from the pkg server.
 load  |`[pkg-name]`  | Loads the package into the currently running pkg server.
 save  |`[pkg-name]`  | Save the package.
 init  |`[pkg-name]`  | Initializes the Package.
 event |`[pkg-name]`  | Displays a events.
 run| `[name]` |  Runs the pkg server based on the specified repository. 
 ls | `[repo]`\|`[pkg]`\|`[tcp]`\|`[comm]` | Displays the specified items in a list. 
 queue|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[push] [name] [value]` <p>`[pop] [name]` | <p>  Create new queue. <p> Displays queue list. <p> Displays queue items. <p> Push a item to queue. </p> <p> Pop a item from queue. </p>
 stack|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[push] [name] [value]` <p>`[pop] [name]` | <p>  Create new stack. <p> Displays stack list. <p> Displays stack items. <p> Push a item to stack. </p> <p> Pop a item from stack. </p>
 storage|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[set] [name] [key] [value]` <p>`[get] [name] [key]` | <p>  Create new storage. <p> Displays storage list. <p> Displays storage items. <p> Push a item to storage. </p> <p> Pop a item from storage. </p>
 list|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[add] [name] [value]` <p>`[insert] [name] [index] [value]`  <p>`[remove] [name] [index] [value]` |<p>  Create new list. <p> Displays a lists. <p> Displays list items. <p> Add a item. </p> <p> Insert a item. </p> <p> Remove a item. </p>
 kill | `[kill-code]` | Shutdown pkg server.
 flow|  <p>`[load] [flow-key]`  <p>`[init] [flow-key]`   <p>`[remove] [flow-key]` <p>`[event] [flow-key]`| <p> Loads the Flow resource into the currently running pkg server. <p> Initializes the Flow resource.</p> <p> Remove Flow resource </p><p> Displays a events from the Flow resource.</p>
 env | `-`|Displays the system environment settings.  
 help| `-`|.


### Repository
* `port push` - push project to repository
* `port pull` - pull project from repository

!!!tip
    The application runs based on the values stored in the repository. The push action must precede the application startup. 
    Subsequently, users can perform a pull action at any desired moment to restore the repository.

### Server 
* `port run [repository-name]` - run server from repository
* `port kill` - terminated current server
 
### Message
* `port set [group-key] [message-key] [set-value]` - set the message value to current repository
```console
port set groupA sayHelloMessage1 Hello?
[set-ok]
```
* `port get [group-key] [message-key]` - get the message value to current repository
```console
port get groupA sayHelloMessage1
[Hello?]
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