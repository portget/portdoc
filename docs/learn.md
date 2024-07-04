# Quick Start

Welcome to the Port World!

----------------------------------------------------------------
You will learn
How to create and nest components
How to add markup and styles
How to display data
How to render conditions and lists
How to respond to events and update the screen
How to share data between components
----------------------------------------------------------------


## How to create a repository
```Console
C:\Users\...>cd C:\Users\Demo

C:\Users\Demo>port new Demo

C:\Users\Demo>port add --gruop stage,efem

```
## How to add messages 
[..\\stage\\.msg]
```Text
STAGE_ACCELATOR             num                                                                                                                                                   
STAGE_DECELATOR             num                                                                                                                                                   
STAGE_HOME_SENSOR           enum.NonHome    RELATION:IOBoardLib.DigtalInput PROPERTY:{"Argument":"1,0"}                                                                                                                                           
STAGE_LOAD_MOVE_TIMEOUT     num                                                                                                                                                   
STAGE_LOAD_POSITION         num                                                                                                                                                   
STAGE_POSITION              enum.CHUCKPOS                                                                                                                                         
STAGE_POSITION_RATIO        num                                                                                                                                                   
STAGE_SPEED                 num                                                                                                                                                   
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