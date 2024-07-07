# Quick Start
___
Port operates by reflecting messages in the most recently updated repository. 
Try creating and editing a basic project to see how you can modify and configure projects. Follow along to understand the process better.



<br>

## How to create a repository
___
Before starting a Port project, you need to create a root folder that defines your messages. The subfolders within this root folder are managed as groups by Port, allowing users to organize messages by group. The root folder contains files with the `*.enum` extension and the structure of sub-group folders. Within the sub-group folders, message definition documents with the `*.msg` extension are created.

#### Here's an example 
<div class="console">
    <div class="console-content">
    C:\Users\...>cd C:\Users\Demo
    C:\Users\Demo>port new Demo
    C:\Users\Demo>port add --gruop stage,efem
  </div>
</div>

#### Here is an example of the structure of the generated repository
``` 
root_folder/
├── stage/
│   ├── *.msg
├── efem/
│   ├── *.msg 
└── *.enum
```

## How to add messages 
___
To declare a message, you need to edit the `*.msg` file in the sub-folder you created. By defining message data types and attributes as shown below, you can later utilize various features such as automatic logging and backup. Additionally, you can define relationships using predefined relations.

#### Here's an example of message file
```
STAGE_ACCELATOR          num                                                                                                                                             
STAGE_DECELATOR          num                                                                                                                                             
STAGE_HOME_SENSOR        enum.NonHome   RELATION:IOBoardLib.DigtalInput PROPERTY:{"Argument":"1,0"}                                                                                                                                
STAGE_LOAD_MOVE_TIMEOUT  num                                                                                                                                            
STAGE_LOAD_POSITION      num                                                                                                                                            
STAGE_POSITION           enum.CHUCKPOS                                                                                                                                     
STAGE_POSITION_RATIO     num                                                                                                                                                 
STAGE_SPEED              num                                                                                                                                               
```


## How to link relation
___
To link the declared relations in your messages, you need to add them to the project. This process involves entering the call key and the library name to complete the addition of the relation.

#### How to link the library
<div class="console">
    <div class="console-content">
    C:\Users\...>cd C:\Users\Demo
    C:\Users\Demo>port add --relation IOBoard1 IOBoardLib
   </div>
</div>

!!!tip
    If you see a message like `[ERROR][open ..\proj.toml: Access is denied.]`
    granting administrator privileges to the port.exe program will resolve the issue.

After linking the relations to your project, you can verify the integration using the following command

#### How to check link library
<div class="console">
    <div class="console-content"> 
    C:\Users\Demo>port show --relation
    C:\Users\Demo>[IOBoard1]IOBoardLib\IOBoardLib.dll
   </div>
</div>

## How to start project
Once all message definitions are complete, you can start the message server based on these definitions. Before running the server, upload all updated content to the local repository by entering `port push` in the console. Then, run the server with the command `port run [project-name]`.

<div class="console">
    <div class="console-content">
       C:\Users\Demo>port push
       
       C:\Users\Demo>port run Demo --ng ignore 

       [localhost:5001]Port Running ... OK
       Access point count [4]
       Relation count [2]
       NG point [CATEGORY_MSG_POINT_RELATION][4]
       NG point [CATEGORY_RELATION_MESSAGE][1]
       NG point [CATEGORY_MEMORY][2]
       NG point [CATEGORY_LIBRARY][3]
       NG point [CATEGORY_MSG_POINT_ENUM][136]
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
    background-color: black;
    color: #00ff00;
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