# What's PortDic
PortDic is a key-value pair data structure storage object provided by Port. Users can quickly look up values using keys, allowing for efficient data retrieval. This structure enables the storage and editing of multiple data structures, facilitating more stable and reliable development.

## Download  
NAME | Language |Package Manager | OS | STABLE | 
------|--------|--------|--------|--------
portdic |  C++ | not yet |Windows| No | 
portdic |  Delphi | not yet |Windows| No |
portdic |  C# | nuget |Windows| Yes | 
portdic |  Python | not yet |Windows| No | 
portdic |  Javascript | npm |Any | Yes | 

## React 

### SET / GET
```Javascript
    import { useState ,useEffect} from 'react'
    import reactLogo from './assets/react.svg'
    import viteLogo from '/vite.svg'
    import './App.css'
    import { CallPortdic } from 'portdic';

    function App() {
    const [count, setCount] = useState(0) 
    const [portdic, setPortdic] = useState(0);
    
    useEffect(() => {
        CallPortdic("localhost:5001").then(setPortdic).catch(console.error); 
    }, []);

    
    return (
        <>
        <div>
            <a href="https://vite.dev" target="_blank">
            <img src={viteLogo} className="logo" alt="Vite logo" />
            </a>
            <a href="https://react.dev" target="_blank">
            <img src={reactLogo} className="logo react" alt="React logo" />
            </a>
        </div>

        <div> 
            <button onClick={() => {
            var data =  portdic.Execute("version");

            data.then(resp => resp.json())  
            .then(data => {  
                console.log("success received:", data);
            })
            .catch(error => { 
                console.error("error occurred:", error);
            });

            }}>Version</button>
        </div> 
        <div> 
           <!-- get value from dictionary port --> 
            <button onClick={() => console.log(portdic.Get("room1","RoomTemp1"))}>Get</button>
        </div>
        <div> 
             <!-- set value to dictionary port --> 
            <button onClick={() => portdic.Set("room1","RoomTemp1","34")}>Set</button>
        </div> 
        <h1>Vite + React</h1>
        <div className="card">
            <button onClick={() => setCount((count) => count + 1)}>
            count is {count}
            </button>
            <p>
            Edit <code>src/App.jsx</code> and save to test HMR
            </p>
        </div>
        <p className="read-the-docs">
            Click on the Vite and React logos to learn more
        </p>
        </>
        )
    }

    
    export default App

```  

## .Net 

### SET/GET

```C#
    ...
    private static IPortDic port = Port.GetDictionary("sample");

    var ok = dic.Set('room1','BulbOnOff','On');
    if(ok){
        Console.WriteLine("ok");
    }

    var v = dic.Get('room1','BulbOnOff')
    // 'On'
    Console.WriteLine(v.Text()); 

    var t1 = dic.Get('room1','RoomTemp1')
    // random number unit Celsius
    Console.WriteLine(t1.Text()); 

     var t2 = dic.Get('room1','RoomTemp2')
    // random number unit Fahrenheit
    Console.WriteLine(t2.Text()); 
    ...
``` 
<!-- ### QUEUE


```C#

    //class1.cs
     private static IPortDic port = Port.GetDictionary("sample");

    dic.Create(PortDic.Structure.Queue,'TEST')

    var q1 = dic.Queque('TEST') 
    
    q1.Enqueue(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
     private static IPortDic port = Port.GetDictionary("sample");

    var q1 = dic.Queue('TEST')

    var v = q1.Dequeue();

    //Show "First Value" from class1.cs 
    Console.WriteLine(Encoding.UTF8.GetString(v));

    v = q1.Dequeue();
    //Show ""
    Console.WriteLine(Encoding.UTF8.GetString(v));
    
    ...
    
```
### STACK

```C#

    //class1.cs
     private static IPortDic port = Port.GetDictionary("sample");

    dic.Create(PortDic.Structure.Stack,'TEST')

    q1.Push(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
     private static IPortDic port = Port.GetDictionary("sample");

    var stack = Port.Stack('TEST')

    var v = stack.Pop();

    Console.WriteLine(Encoding.UTF8.GetString(v));
    
    ...
    
```
### LIST

```C#

    //class1.cs
    
     private static IPortDic port = Port.GetDictionary("sample");
    
    dic.Create(PortDic.Structure.List,'TEST')
    
    var list = Port.List('TEST')

    list.Add(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
     private static IPortDic port = Port.GetDictionary("sample");

   var list = Port.List('TEST')

    var v = list.Get(0);

    //Show "First Value" from class1.cs 
    Console.WriteLine(Encoding.UTF8.GetString(v));
    //Remove index 0
    q1.Remove(0);
    
    ...
    
```
### STORAGE

```C#

    //class1.cs
     private static IPortDic port = Port.GetDictionary("sample");

    dic.Create(PortDic.Structure.Storage,'TEST')
    
    var s = Port.Storage('TEST')

    if (s.Set('A',Encoding.UTF8.GetBytes('First Value'))){
        Console.WriteLine('Updated value')
    }

    ...


    //class2.cs
     private static IPortDic port = Port.GetDictionary("sample");

    var s = Port.Storage('TEST')

    var v = s.Get('A');

    //Show "First Value" from class1.cs 
    Console.WriteLine(Encoding.UTF8.GetString(v));
 
    ...
    
```
 -->
