# What's PortDic
PortDic is a key-value pair data structure storage object provided by Port. Users can quickly look up values using keys, allowing for efficient data retrieval. This structure enables the storage and editing of multiple data structures, facilitating more stable and reliable development.

## Download  
NAME | Language |Package Manager | OS | STABLE | 
------|--------|--------|--------|--------
Port.Library |  C# | Nuget |Windows x64 | Yes | 

## Functions 

### SET

```C#
    ...
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    var ok = dic.Set('AZone','SamplePower','On');
    if(ok){
        Console.WriteLine("ok");
    }
    ...
```
### GET

```C#
    ...
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    var v = dic.Get('AZone','SamplePower')
    // 'On'
    Console.WriteLine(v.Text());

    var ok2 = dic.Set('AZone','SampleTemp',90);
    if(ok2){
        Console.WriteLine("ok");
    }

    var t = dic.Get('AZone','SampleTemp')
    // '90'
    Console.WriteLine(t.Text());

    if (t >= 90){
        Console.WriteLine('[Warning]Over Tempature');
    }
    ...
```
### QUEUE


```C#

    //class1.cs
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    dic.Create(PortDic.Structure.Queue,'TEST')

    var q1 = dic.Queque('TEST') 
    
    q1.Enqueue(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

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
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    dic.Create(PortDic.Structure.Stack,'TEST')

    q1.Push(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    var stack = Port.Stack('TEST')

    var v = stack.Pop();

    Console.WriteLine(Encoding.UTF8.GetString(v));
    
    ...
    
```
### LIST

```C#

    //class1.cs
    
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");
    
    dic.Create(PortDic.Structure.List,'TEST')
    
    var list = Port.List('TEST')

    list.Add(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

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
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    dic.Create(PortDic.Structure.Storage,'TEST')
    
    var s = Port.Storage('TEST')

    if (s.Set('A',Encoding.UTF8.GetBytes('First Value'))){
        Console.WriteLine('Updated value')
    }

    ...


    //class2.cs
    PortDic dic = PortDic.GetDictionary("http://localhost:5001");

    var s = Port.Storage('TEST')

    var v = s.Get('A');

    //Show "First Value" from class1.cs 
    Console.WriteLine(Encoding.UTF8.GetString(v));
 
    ...
    
```

