# Welcome to Port

Port is a message-based library management database. It allows users to quickly redevelop and reconfigure applications by calling pre-written libraries. This feature simplifies the application development process, enabling users to create applications more easily and efficiently.

Please see the documentation [lincense](license.md)

## The Requirements 
---
* os         : windows 7+ / windows server 2003+
* memory     : minimum 32GB
* frameworks : .Net 8.0+


## Download URL
---

VERSION | OS |STABLE | URL 
------|--------|--------|--------
v1.0.16 | Windows x64 | No | [v1.0.16-win-installer](https://github.com/portget/port/archive/refs/tags/v1.0.16-win-installer.zip){:download}

## Repository
___

### Creates a repository 
```console
port new [repository-name]
```

!!! tip
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.

### Creates a group 

```console
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
* message item format like this `[key] [datatype] [option...]`
* `[key]`      - unique key in the message group
* `[datatype]` - text | num 
* `[option]` - api,backup,rule,frame

#### message option
 
 name|description
 ------|--------
 api     | Real-time synchronization and messaging are handled within the corresponding external library. For more details, please refer to the api documentation.
 backup  | Changes are saved to the backup database as they occur, ensuring that values are restored upon application restart. and values are not propagated api messages during program execution.
 property| Can specify a custom property
 rule    | Can specify rules to manage the values of corresponding messages.  
 
#### sample1.msg
```console
 DevAPowerStatus    enum.DeviceAStatus  api:DeviceA.GetStatus         
 DevAErrorMessage   text                api:DeviceA.GetErrorMessage property:{"Arguments":"1,0"}
 DevCTemperature    num                 api:DeviceC.GetTemperature property:{"MIN":0,"MAX":300}
 DevCOnOff          enum.OnOff          api:DeviceC.OnOff           
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
```console
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
```console
port set groupA sayHelloMessage1 Hello?
[set-ok]
```
* `port get [group-key] [message-key]` - get the message value to current repository
```console
port get groupA sayHelloMessage1
[Hello?]
```
