
# API reference

## Introduction
____

This page explains how the Port client calls the Port backend API.

!!!tip
    Before making any API calls, please ensure that the server is running properly. 
    If the server is not functioning correctly, API calls may fail. 
    Therefore, verify the server's operational status before initiating any API calls.

## Authentication
____
When authentication functionality is activated within the HOST application, service-calling applications are required to request a key from the HOST before making 
API calls to ensure proper authentication and access to services. This security feature remains disabled by default.

## GET

### Application
URL | Description 
------|--------
/api/app/ |  show up application information 
/api/ng/ | show up ng-list  
/api/download/ | download somthing...  
/api/enum | enum list   


### Group
____
URL | Description 
------|--------
/api/{group-name}/ | accessor data  
/api/{group-name}/keys | key list  
/api/{group-name}/kv | key-value list  
/api/{group-name}/datatype | key-datatype list  
/api/{group-name}/enumid | enumid list   

 
### API
____
URL | Description 
------|--------
/api/{name}/ | api information 
/api/{name}/keys | key list  
/api/{name}/kv | key-value list  
/api/{name}/set | set-message list  
/api/{name}/get | get-message list   



## POST
____
### Application
URL | Description 
------|--------
/api/enum/{enum} | key list  

### Group
URL | Description 
------|--------
/api/{group-name}/ | relation information 
/api/{group-name}/message/{[key]}?{[datatype] [property...]} | add message  

 

## PUT
___

### Group 
URL | Description 
------|--------
/api/{group-name}/{[key]}?{[set-value]} | set value to group-message 

### Relation
URL | Description 
------|--------
/api/{relation-name}/{[key]}?{[set-value]}  | set value to relation-message

 
## DELETE
___

### Group 
URL | Description 
------|--------
/api/{group-name}/message/{[key]}

 