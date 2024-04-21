
# What's RELATION?
__________________

This object is designed to efficiently manage libraries that serve as common denominators across multiple projects. Tailored for each language, these libraries facilitate seamless integration with the object and handle memory synchronization with ports. Users can conveniently utilize these libraries by inheriting or implementing the respective classes, ensuring ease of use.

# Get Started
__________________

### Add reference

NAME | Version | Path 
------|--------|-------
.net  | >8.0   |../port/lib/net/portlib.dll



### Support objects
NAME | Description 
------|--------
ScenarioRelationService| write a scenario where you inherit the object to control all message values and share messages across the system.   
IntervalRelationService | this is an object designed for managing a set of periodically called messages, allowing control over the values by periodically invoking messages to the system.
CommRelationService | this object is designed for a set of messages requiring network endpoints. When inheriting this object, implementation of endpoint and connection status check functions is necessary. Through implementation of the required messages upon connection, it can be provided to the port application.

### .Net (>= 8.0)
__________________


!!! tip
    [Properties] ->  [Application] -> [General] -> [Traget OS] -> check for windows


#### ScenarioRelationService
```C#

```

#### IntervalRelationService
```C#

```

#### CommRelationService

```C#
 /// <summary>
 /// Communication Relation Object 
 /// you must be implement IsConnected, Endpoint
 /// </summary>
 public class Relation : CommRelationService
 {
     private SerialPort serialPort = new SerialPort();
     
     public Relation()
     {

     }

     // Just use here
     public string Name;

     // Check for connected
     protected override bool IsConnected()
     {
         return ((this.serialPort != null) && (this.serialPort.IsOpen));
     }

     // port relation set Endpoint like COM13,9600,8,1,0,0 / TCP 
     [Message]
     public override IEndpoint Endpoint
     {
         set
         {
             if (value.Binding(this.serialPort))
             {
                 this.serialPort.Open();
             }
         }
         get
         {
             return this.address;
         }
     }

     [Message]
     public string GetPowerStatus
     {
         get
         {
             var message = Encoding.ASCII.GetBytes("power?\r\n");

             this.serialPort.Write(message, 0, message.Length);

             Thread.Sleep(300);

             var recv = new byte[0xff];

             var n = this.serialPort.Read(recv, 0, recv.Length);

             if (n != 0)
             { 
                 return Encoding.ASCII.GetString(recv);
             } 

             return "Unknown";
         }
     }
  
     [Message]
     public string PowerOn
     {
         set
         {
            var message = Encoding.ASCII.GetBytes("powerOn\r\n");
            this.serialPort.Write(message, 0, message.Length);
         }
     }
 }
```



#### Debugging 
```

```
