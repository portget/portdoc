# Welcome to Port

The Port program operates on a real-time database approach. By using this program, users can effortlessly share messages across multiple applications, facilitating simpler and more scalable development.

Please see the documentation [lincense](license.md)

## The Requirements 
---
* os         : windows 7+ / windows server 2003+
* memory     : minimum 32GB
* frameworks : .Net Framework 4.5+  


## Getting Started

---
Installation
To install port, run the folliwing command from the commnad line


```
choco install port
```


## Create new repository
___


```
port new [repository-name]
```

!!! danger
    did not write 레파지토리 이름은 특수문자를 작성 할 수 없습니다. 이름 작성 규칙은 OS에서 제공되는 디렉토리 명명 규칙을 
    따릅니다.


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
    포트는 레파지토리에 저장된 값을 기준으로 어필리케이션이 가동 됩니다. 어플리케이션 구동전 push 동작은 필수 적이며
    사용자는 원하는 시점으로 pull 동작을 하여 해당 레파지토리를 복구 할 수 있습니다.



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

____
title: Mydocuments
summary: A brief descritpiton of mydocuments
____

```
this is code blocks
```



First | Second | Third 
------|--------|--------
1 | 2 | 3 


* [Python]
```python
def fn():
    pass
```

* [C#]
```C#
private void Sample(){

}
```

* [C++]
```c++
int Sum(){

}
```

!!! tip
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.