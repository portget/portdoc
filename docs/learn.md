# Quick Start
___
Port operates by reflecting messages in the most recently updated repository. 
Try creating and editing a basic project to see how you can modify and configure projects. Follow along to understand the process better.
___

## How to create a repository
Before starting a Port project, you need to create a root folder that defines your messages. The subfolders within this root folder are managed as groups by Port, allowing users to organize messages by group. The root folder contains files with the `*.enum` extension and the structure of sub-group folders. Within the sub-group folders, message definition documents with the `*.msg` extension are created.

#### Here's an example 
```Console
C:\Users\...>cd C:\Users\Demo

C:\Users\Demo>port new Demo

C:\Users\Demo>port add --gruop stage,efem

```
#### Here is an example of the structure of the generated repository
``` 
root_folder/
├── group1/
│   ├── *.msg
├── group2/
│   ├── *.msg 
└── *.enum
```

## How to add messages 
To declare a message, you need to edit the `*.msg` file in the sub-folder you created. By defining message data types and attributes as shown below, you can later utilize various features such as automatic logging and backup. Additionally, you can define relationships using predefined relations.

#### Here's an example of message file
```Text
STAGE_ACCELATOR             num                                                                                                                                                   
STAGE_DECELATOR             num                                                                                                                                                   
STAGE_HOME_SENSOR           enum.NonHome   RELATION:IOBoardLib.DigtalInput PROPERTY:{"Argument":"1,0"}                                                                                                                                           
STAGE_LOAD_MOVE_TIMEOUT     num                                                                                                                                                   
STAGE_LOAD_POSITION         num                                                                                                                                                   
STAGE_POSITION              enum.CHUCKPOS                                                                                                                                         
STAGE_POSITION_RATIO        num                                                                                                                                                   
STAGE_SPEED                 num                                                                                                                                                   
```
## How to push a repository

```Console 
C:\Users\Demo>port push

```

## How to add relation
```Console
C:\Users\...>cd C:\Users\Demo

C:\Users\Demo>port add --relation IOBoard1 IOBoardLib
 
```


!!!tip
    If you see a message like `[ERROR][open ..\proj.toml: Access is denied.]`
    granting administrator privileges to the port.exe program will resolve the issue.


[port.toml]
```Text
    [[relations]]
    key = 'IOBoard1'
    path = 'IOBoardLib\IOBoardLib.dll'
```



## How to start project