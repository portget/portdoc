# What's PortDic


## Download

### Nuget Package
NAME | Target |OS |STABLE | 
------|--------|--------|--------
PortDic.Lib.x64 | >= NetFramework 4.8 , >= NetCore 8.0 | Windows x64 | Yes | 


## Functions 

### SET

```C#
    ...
    PortDic dic = portdic.Connect("localhost",9000); 

    var ok = dic.Set('AZone','SamplePower','On');
    if(ok){
        Console.WriteLine("ok");
    }
    ...
```
### GET

```C#
    ...
    PortDic dic = portdic.Connect("localhost",9000); 

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
    PortDic dic = portdic.Connect("localhost",9000); 

    var q1 = Port.NewQueue('TEST')

    q1.Enqueue(Encoding.UTF8.GetBytes('First Value'));

    ...


    //class2.cs
    PortDic dic = portdic.Connect("localhost",9000); 

    var q = Port.Queue('TEST')

    var v = q1.Dequeue();

    //Show "First Value" from class1.cs 
    Console.WriteLine(Encoding.UTF8.GetString(v));

    v = q1.Dequeue();
    //Show ""
    Console.WriteLine(Encoding.UTF8.GetString(v));
    
    ...
    
```
### STACK

### LIST

### STORAGE


### Code 

 

  
