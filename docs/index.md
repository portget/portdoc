# Welcome to Port

The Port program operates on a real-time database approach. By using this program, users can effortlessly share messages across multiple applications, facilitating simpler and more scalable development.

Please see the documentation [lincense](license.md)

## The Requirements 
---
* os         : windows 7+ / windows server 2003+
* memory     : minimum 32GB
* frameworks : .Net Framework 4.5+  


## Download URL
---

VERSION | STABLE | URL 
------|--------|--------
v0.0.1 -BETA | No | [Port.7z  v0.0.1 - BETA](https://github.com/portget/port/archive/refs/tags/v0.0.1-beta.zip){:download}







## Repository
___

### Create new repository 
```
port new [repository-name]
```

!!! tip
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.

### repository layout
___
    port.toml         # The configuration file.
    groupA/     # The group directory. 
        sample1.msg   # The message file
        sample2.msg   # The message file
        sample3.msg   # The message file
        custom.enum   # The custom enum file 
    ...               # Other files.



### Message File
___
* message item format like this `[key] [datatype] [property...]`
* `[key]`      - unique key in the message group
* `[datatype]` - text | num 
* `[property]` - relation,backup,rule,frame
         
```
[../sample1.msg]

sayHelloMessage1 text           relation:relation1.GetArgs1 backup:true 
sayHelloMessage2 text           relation:relation1.GetArgs2 frame:1
sayTFalse        enum.TFalse 
...
```

!!! tip
    message document do not using special characters. 


### Enum File

* enum item format like this `[key] [item:number_key] [item:number_key]`


```
[../custom.enum]
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
 
 