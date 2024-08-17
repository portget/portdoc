
# What's FRAME?
__________________

Frame refers to a set of messages designated within different groups and called from various relation objects. While the specification of frames in messages may vary from one project to another, maintaining consistent names in relation objects allows users to easily manage relation objects.




### Make frame 
_________________


#### Create a Message Document  
 
[../AZone/sample1.msg]
```TEXT 
    DevAPowerStatus    enum.DeviceAStatus   api:DeviceA.GetStatus       frame:HTS1.PowerStatus 
...
``` 


[../BZone/sample1.msg]
```TEXT
    DevAPowerStatus    enum.DeviceAStatus   api:DeviceA.GetStatus       frame:HTS2.PowerStatus
...
``` 

#### Create a RelationObject   
```C#
 public class HeatingScenario : ScenarioRelationService
 {   
    ...

     [Message, Shot(1)]
     public ShotResult EVENT_1
     {
         set
         {
             var strValue = frame.GetValue("PowerStatus");

             if (strValue == "OK")
             {
                 value.NextShot();
             }
         }
     }

    ...
 }
```

#### Command 
```
port add --scenario heating1 /HeatingLib/HeatingLib.dll
port add --scenario heating2 /HeatingLib/HeatingLib.dll
```