# Welcome to Port

The Port program operates on a real-time database approach. By using this program, users can effortlessly share messages across multiple applications, facilitating simpler and more scalable development.

Please see the documentation [lincense](license.md)

## The Requirements 
---
* os         : windows 7+ / windows server 2003+
* memory     : minimum 32GB
* frameworks : .Net Framework 4.5+  


## download rul
---
```
https://github.com/portget/port/
```


## Create new repository
___


```
port new [repository-name]
```

!!! danger
    The repository name cannot contain special characters. 
    It follows the directory naming rules provided by the operating system.


## Repository layout
___
    port.toml         # The configuration file.
    samplegroup1/     # The group directory. 
        sample1.msg   # The message file
        sample2.msg   # The message file
        sample3.msg   # The message file
        custom.enum   # The custom enum file 
    ...               # Other files.



## Message File Format
___
* message item format like this `[key] [datatype] [property...]`
* `[key]`      - escape special characters. recommnad ascii value.
* `[datatype]` - text | num 
* `[property]` - relation,backup,rule,frame
         
```
[../sample1.msg]

sayHelloMessage1 text           relation:relation1.GetArgs1 backup:true 
sayHelloMessage2 text           relation:relation1.GetArgs2 frame:1
sayTFalse        enum.TFalse 
...
```

!!! danger
    message document do not using special characters. 


## Enum File Format

* enum item format like this `[key] [item:number_key] [item:number_key]`


```
[../custom.enum]

TFalse      True:0      False:1
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
port set samplegroup1 sayHelloMessage1 Hello?
[set-ok]
```
* `port get [group-key] [message-key]` - get the message value to current repository
```
port get samplegroup1 sayHelloMessage1
[Hello?]
```
 

### API Refrence

OS | Second | Third 
------|--------|--------
Windows x64 | 2 | 3 


 