
# Commands
___


## Cheat Sheet


### System
 command | arguments | description
 ------|-------- |-------- 
 ?     |`[script|../something.js]` | Run the specified script. 
 version |`-` | Displays the version information. 
 new | `[name]`  | Can specify rules to manage the values of corresponding messages. 
 push|`-` | Push project to repository.
 pull|`-` | Pull project from repository.
 pack  |`[--path <project-path>] [--o <output package-name>]`  | Pack port-package-files. 
 run| `[name]` |  Runs the pkg server based on the specified repository. 
 ls | `[repo]`\|`[pkg]`\|`[tcp]`\|`[comm]` | Displays the specified items in a list. 
 kill | `[kill-code]` | Shutdown pkg server.
 env | `-`|Displays the system environment settings.  
 help| `-`|.

### Server
 command | arguments | description
 ------|-------- |--------
 set |<p>`[group-name] [message-name] [value]`<p>`[package-name] [message-name] [value]`<p>`[script-name] [function-name] [arguments]` | Set values in the pkg server.
 get |<p>`[group-name] [message-name]` <p>`[group-name] [message-name]` <p>`[workid]`  <p> `[project-name].log` <p> `[package-name].log`  <p> `[package-name].event` <p> `status`  | Get values from the pkg server.
 init  |`[pkg-name]`  | Initializes the Package.
 event |`[event-name] [--alert] [message]`  | Displays events or alert event message. 
 <!-- queue|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[push] [name] [value]` <p>`[pop] [name]` | <p>  Create new queue. <p> Displays queue list. <p> Displays queue items. <p> Push a item to queue. </p> <p> Pop a item from queue. </p>
 stack|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[push] [name] [value]` <p>`[pop] [name]` | <p>  Create new stack. <p> Displays stack list. <p> Displays stack items. <p> Push a item to stack. </p> <p> Pop a item from stack. </p>
 storage|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[set] [name] [key] [value]` <p>`[get] [name] [key]` | <p>  Create new storage. <p> Displays storage list. <p> Displays storage items. <p> Push a item to storage. </p> <p> Pop a item from storage. </p>
 list|<p>`[new] [name]` <p>`[ls]` <p>`[view] [name]` <p>`[add] [name] [value]` <p>`[insert] [name] [index] [value]`  <p>`[remove] [name] [index] [value]` |<p>  Create new list. <p> Displays a lists. <p> Displays list items. <p> Add a item. </p> <p> Insert a item. </p> <p> Remove a item. </p>
 flow|  <p>`[load] [flow-key]`  <p>`[init] [flow-key]`   <p>`[remove] [flow-key]` <p>`[event] [flow-key]`| <p> Loads the Flow resource into the currently running pkg server. <p> Initializes the Flow resource.</p> <p> Remove Flow resource </p><p> Displays a events from the Flow resource.</p> -->

## System
 
### `script`
-Support for ECMAScript5  

[ecmascript](https://ecma-international.org/ecmascript-development-archive/2009-ecmascript-archives/)

[js_es5](https://www.w3schools.com/js/js_es5.asp)

### `port push` 
- push project to repository

### `port pull` 
- pull project from repository

!!!tip
    The application runs based on the values stored in the repository. The push action must precede the application startup. 
    Subsequently, users can perform a pull action at any desired moment to restore the repository.
 
### `port set [group] [message] [value]` 

- set the message value to current repository

```console
port set groupA sayHelloMessage1 Hello?
[set-ok]
```

### `port get [group] [message]` 

- get the message value to current repository

```console
port get groupA sayHelloMessage1
[Hello?]
```

## Server 

### `port run [repository-name]` 
- run server from repository

### `port shutdown` 
- terminated current server
 
