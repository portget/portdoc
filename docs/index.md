# Welcome to Port

The port application, being a time-series database, offers a flexible design ideal for industrial data collection and processing. With its capabilities, it enables efficient storage and retrieval of timestamped data, facilitating streamlined operations across various industrial sectors. 

Please see the documentation [lincense](license.md)

## The Requirements 
---
* os         : windows 7+ / windows server 2003+
* memory     : minimum 32GB
* frameworks : .Net Framework 4.5+  


## Download URL
---

VERSION | OS |STABLE | URL 
------|--------|--------|--------
v0.0.1 -BETA | Windows x64 | No | [Port.7z  v0.0.1 - BETA](https://github.com/portget/port/archive/refs/tags/v0.0.1-beta.zip){:download}







## Repository
___

### Create new repository 
```
port new [repository-name]
```

!!! tip
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.

### Create add gruop 
```
port add [group-name]
```


### Repository layout
___
    port.toml         # The configuration file.
    .enum             # The custom enum file 
    AZone/            # The group directory. 
        sample1.msg   # The message file
        sample2.msg   # The message file
        sample3.msg   # The message file

    BZone/            # The group directory. 
        sample1.msg   # The message file
        sample2.msg   # The message file
        sample3.msg   # The message file
    ...               # Other files.



### Message File
___
* message item format like this `[key] [datatype] [property...]`
* `[key]`      - unique key in the message group
* `[datatype]` - text | num 
* `[property]` - relation,backup,rule,frame

#### message property list 
 
 name|description
 ------|--------
 relation| Real-time synchronization and messaging are handled within the corresponding external library. For more details, please refer to the Relation documentation.
 backup  | Changes are saved to the backup database as they occur, ensuring that values are restored upon application restart. and values are not propagated relation messages during program execution.
 frame   | Can specify a frame key value to manage subsequent frames by their key values.
 rule    | Can specify rules to manage the values of corresponding messages. 


#### sample1.msg
``` 
 DevAPowerStatus    enum.DeviceAStatus   relation:DeviceA.GetStatus       frame:HTS.PowerStatus 
 DevAErrorMessage   text                 relation:DeviceA.GetErrorMessage frame:HTS.ErrorMessage
 DevCTemperature    num                  relation:DeviceC.GetTemperature  frame:HTS.Temperature
 DevCOnOff          enum.OnOff           relation:DeviceC.OnOff           frame:HTS.HeaterOnOff
 ...
```

!!! tip
    message document do not using special characters. 


### Enum File
___

Enums are particularly useful when you have a fixed set of values that a variable can take, such as days of the week, months of the year, or status codes. They help make your code more expressive, self-documenting, and less error-prone because you're working with named constants instead of raw integer values. 

* enum item format like this`[key] [item-name:number_key] [item-name:number_key]` 
* `[key]`      - unique key in the enum message
* `[item-name]`- name by enum-item
* `[property]` - unique key in enum value




#### custom.enum
```
TFalse      True:0      False:1
FTrue       False:0     True:1
OnOff       On:0        Off:1
OffOn       Off:1       On:1
```



## Commands
___
### Repository
* `port push` - push project to repository
* `port pull` - pull project from repository

!!!tip
    The application runs based on the values stored in the repository. The push action must precede the application startup. 
    Subsequently, users can perform a pull action at any desired moment to restore the repository.



### Application 
* `port run [repository-name]` - run application from repository
* `port kill` - terminated current application


!!! tip
    port application must be start portlib services application


### Message
* `port set [group-key] [message-key] [set-value]` - set the message value to current repository
```
port set groupA sayHelloMessage1 Hello?
[set-ok]
```
* `port get [group-key] [message-key]` - get the message value to current repository
```
port get groupA sayHelloMessage1
[Hello?]
```
 
 