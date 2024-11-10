# Quick Start
___
Port operates by reflecting messages in the most recently updated repository. 
Try creating and editing a basic project to see how you can modify and configure projects. Follow along to understand the process better.


 
## How to create a port-project
___
Before starting a Port project, you need to create a root folder that defines your messages. The subfolders within this root folder are managed as groups by Port, allowing users to organize messages by group. The root folder contains files with the `*.enum` extension and the structure of sub-group folders. Within the sub-group folders, message definition documents with the `*.msg` extension are created.

### Here's an example 

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
    port add --group room1,room2
  </div>
</div>

 

#### Project Layouts
``` 
APT/
│
├── room1/
│   ├── *.msg
│
├── room2/
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
 RoomTemp1    num          pkg:heater1.GetTemperature property:{"MIN":0,"MAX":300}
 RoomTemp2    num          pkg:heater2.GetTemperature property:{"MIN":200,"MAX":500}          

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

### Add packages

<br>

#### move directory

<div class="console">
    <div class="console-content">
    cd C:\Users\Demo
   </div>
</div>
<br/>

#### Add the package to the current project under the name "bulb1"

<div class="console">
    <div class="console-content">
    port add --pkg bulb1 bulb
   </div>
</div>
<br/>

#### Add the package to the current project under the name "bulb2"

<div class="console">
    <div class="console-content">
    port add --pkg bulb2 bulb
   </div>
</div>
<br/>

#### Add the package to the current project under the name "heater1"

<div class="console">
    <div class="console-content">
    port add --pkg heater1 heater
   </div>
</div>
<br/>

#### Add the package to the current project under the name "heater2"

<div class="console">
    <div class="console-content">
    port add --pkg heater2 heater
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