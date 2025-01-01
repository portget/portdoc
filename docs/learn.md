# Quick Start
___
Port operates by reflecting messages in the most recently updated repository. 
Try creating and editing a basic project to see how you can modify and configure projects. Follow along to understand the process better.


 
## How to create a port-project
___
Before starting a Port project, you need to create a root folder that defines your messages. The subfolders within this root folder are managed as groups by Port, allowing users to organize messages by group. The root folder contains files with the `*.enum` extension and the structure of sub-group folders. Within the sub-group folders, message definition documents with the `*.msg` extension are created.


### 1. Repository
___
The Port project is remarkably simple and straightforward. To get started, first create a project folder in the console, then type port new sample. This will quickly generate the project files. After that, create sub-group folders and add .msg files to each sub-group folder. Feel free to create messages using text, num, and enum types as you like. Once you've specified the attributes, type port push and Port will automatically store everything. Now, just run port run sample, and the server will start, allowing you to safely and easily share messages across multiple applications.
 
___

!!! tip
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.
___
   

<h4>Create a project</h4>

![poster](img/new_project.png)


### 2. Group 
A group serves as the root of messages. Within a single group, multiple message files can be stored, allowing for easy retrieval and editing. By managing several .msg files within the group folder, you can conveniently organize and abstract them for streamlined management.

___

<h4>Add a group</h4> 

![poster](img/add_group.png)


 

#### Sample Project

![poster](img/expl.png)

___
Download [sample project](file/sample.zip){:sample} 
___


## How to add messages 
___
To declare a message, you need to edit the `*.msg` file in the sub-folder you created. By defining message data types and attributes as shown below, you can later utilize various features such as automatic logging and backup. Additionally, you can define relationships using predefined relations.

### 1. Message syntax
 `[key] [datatype] [option...]`

A message is an object that allows users to specify pkg properties in a pre-provided Application Service. The message is a kv, and types and properties can be defined in that message. 
Please attach the materials attached below. 
  
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
 logging | Auto logging support for messages 

!!! tip
    message document do not using special characters. 
 
### 2. Sample
``` 

 BulbOnOff     enum.OffOn  pkg:Bulb1.OffOn     
 RoomTemp1     num         pkg:Heater1.Temp  property:{"MIN":0,"MAX":300,"Arguments":"C"}
 RoomTemp2     num         pkg:Heater1.Temp  property:{"MIN":0,"MAX":300,"Arguments":"F"}        

```




## How to add enums
___

### 1. Enum syntax

Enums are particularly useful when you have a fixed set of values that a variable can take, such as days of the week, months of the year, or status codes. They help make your code more expressive, self-documenting, and less error-prone because you're working with named constants instead of raw integer values. 

* enum item format like this`[key] [item-name:number_key] [item-name:number_key]` 
* `[key]`      - unique key in the enum message
* `[item-name]`- name by enum-item
* `[property]` - unique key in enum value




### 2. Sample
```console
TFalse      True:0      False:1
FTrue       False:0     True:1
OffOn       Off:0       On:1
OnOff       On:0       Off:1
```

___



## How to add rules
___
To declare a rule, you need to edit the `*.rule` file in the sub-folder you created. The rule script can control whether the user can modify settings through the setable function. The first parameter is the condition that triggers the rule, and the second parameter is the condition that determines whether the setting is modifiable. When the user changes the message value, the function is automatically called to check these conditions.

<br/>

### 1. SetTrigger script syntax
The set function is a conditional validation mechanism used to check and enforce logical constraints before accepting input actions. It is composed of two main parts:
 
#### Input Condition
A logical expression that specifies the input condition to be validated.

#### Validation Condition
A logical expression that must evaluate to true for the input action to be accepted.

#### Syntax
set(`<Input Condition>`, `<Validation Condition>`);

<br/>

### 2. GetTrigger script syntax
  
The GetTrigger serves as a conditional trigger mechanism for executing specific actions when defined 
conditions are met. It is composed of two main parts:

#### Trigger Condition
A logical expression that evaluates to true or false.

#### Action Script
A set of instructions executed when the trigger condition evaluates to true.

#### Syntax
get(`<Trigger Condition>`, `<Action Script>`);

<br/>

### 3. Sample
```
    set("room1.BulbOnOff==Off","(room1.RoomTemp1>=20)&&(room2.RoomTemp2>=20)")
    set("room1.RoomTemp2>=30","room2.RoomTemp2>=5") 
    get("(room1.RoomTemp1>=0)&&(room2.RoomTemp2>=0)","room1.BulbOnOff=Off;room2.BulbOnOff=Off;")
```

## How to import packages
A port package, in the context of software development, is a collection of pre-written code or modules that provide specific functionality, designed to be reused across different projects. By incorporating port packages into your application, you can save time and effort by leveraging existing solutions instead of building everything from scratch. Port packages typically include libraries, utilities, or tools that handle common tasks, such as data manipulation, network communication, or file handling.

The main advantage of using port packages is that they promote reusability, allowing developers to share and reuse code, which improves efficiency and reduces redundancy. Additionally, port packages help to organize your code in a modular way, making it easier to maintain and update. it becomes much easier to install, update, and track dependencies, ensuring your application is always running with the right set of tools.

In summary, port packages:

1. Increase reusability by enabling the sharing of commonly used code.
2. Enhance efficiency by reducing the need to write code from scratch.
3. Improve maintainability by organizing code into smaller, manageable components.
4. Simplify management through package managers that handle installation, updates, and dependency tracking.



#### 1. Check packages list

![poster](img/lsPkg.png)



<br>

#### 2. Manual for boot.js in Port Application

<br>
Overview
<br>
The boot.js file is a critical component of the Port Application. It initializes the system by importing and validating the necessary packages. If any package fails validation, the application stops booting and logs an error.

<br>
Location
<br>
The boot.js file is located in the app folder of the Port Application project. Ensure all edits are made directly in this file to modify the initialization process.

<br>
Structure of boot.js
<br>
Below is the typical structure of the boot.js file:
<br>

<div class="code-box">
  <pre>
  <code id="code-snippet" class="language-javascript"> 
  import Bulb1 from `BulbLib1`
  import Bulb2 from `BulbLib2`
  import Heater1 from `HeaterLib1`
  import Heater2 from `HeaterLib2`

  function boot(){ 
    if (!Bulb1.Valid()){
        console.log("invalid Bubl1");
        return false;
    }
    if (!Bulb2.Valid()){
        console.log("invalid Bubl2");
        return false;
    }
    if (!Heater1.Valid()){
        console.log("invalid Heater1");
        return false;
    }
    if (!Heater2.Valid()){
        console.log("invalid Heater2");
        return false;
    }

    return true;
  } 
  </code></pre>
  <button class="copy-button" onclick="copyCode('code-snippet')">
    <img src="/img/copy.svg">
  </button>
</div> 



<br>



After linking the relations to your project, you can verify the integration using the following command


## How to start project 

### a. With console
Once all message definitions are complete, you can start the message server based on these definitions. Before running the server, upload all updated content to the local repository by entering `port push` in the console. Then, run the server with the command `port run [project-name]`.

![poster](img/start project.png)

![poster](img/start project2.png)

!!!tip
    When running the server, if you include `--ng ignore` in the command, it will summarize only the points where errors (NG) occur. For detailed information on these NG points, you can visit the following URL to view the NG point table: 
    <p><a href="http://localhost:5001/api/app/ng/?view=table">http://localhost:5001/api/app/ng/?view=table</a></p>


### b. With application(WPF)


![poster](img/start project with wpf netCore.png)


##   Good Job!

![poster](img/mqtt_view.gif)

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

.code-box {
  position: relative;
  background: #f5f5f5;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 15px;
  margin: 20px 0;
  overflow: auto;
  font-family: "Courier New", Courier, monospace;
}

/* Code Styling */
.code-box pre {
  margin: 0;
  overflow-x: auto;
  white-space: pre-wrap;
  word-wrap: break-word;
  background: none;
  padding: 0;
}

/* Copy Button */
.copy-button {
  position: absolute;
  top: 30px;
  right: 30px;  
  color: white;
  border: none;
  border-radius: 3px;
  padding: 5px 5px;
  font-size: 14px;
  cursor: pointer;
  transition: background-color 0.3s;

}

.copy-button:hover {
  background-color: #e5e5e5;
}
</style>

<script>
  function copyCode(elementId) {
  const codeElement = document.getElementById(elementId);
  const codeText = codeElement.innerText || codeElement.textContent;

  navigator.clipboard.writeText(codeText).then(() => {
    alert("Code copied to clipboard!");
  }).catch((error) => {
    console.error("Failed to copy code: ", error);
  });
}
</script>
<!-- Prism.js CSS (for syntax highlighting) -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css" rel="stylesheet" />

<!-- Prism.js JavaScript (for syntax highlighting functionality) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>