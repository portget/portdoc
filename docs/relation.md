
# What's RELATION?
__________________

This object is designed to efficiently manage libraries that serve as common denominators across multiple projects. Tailored for each language, these libraries facilitate seamless integration with the object and handle memory synchronization with ports. Users can conveniently utilize these libraries by inheriting or implementing the respective classes, ensuring ease of use.

# Get Started
__________________

### Nuget Package
NAME | OS |STABLE | 
------|--------|--------
Port.Library |  Windows x64 | Yes | 

### Support objects
NAME | SETPOINT |DESCRIPTION  
------|----------|--------
ScenarioRelationService| frame | write a scenario where you inherit the object to control all message values and share messages across the system.   
IntervalRelationService | frame | this is an object designed for managing a set of periodically called messages, allowing control over the values by periodically invoking messages to the system.
CommRelationService | endpoint | this object is designed for a set of messages requiring network endpoints. When inheriting this object, implementation of endpoint and connection status check functions is necessary. Through implementation of the required messages upon connection, it can be provided to the port application.

### .Net (>= 8.0)
__________________


!!! tip
    [Properties] ->  [Application] -> [General] -> [Traget OS] -> check for windows


#### ScenarioRelationService
```C#
 public class HeatingScenario : ScenarioRelationService
 { 
     public HeatingScenario()
     {

     }

     /// <summary>
     /// start condition
     /// </summary>
     /// <returns>start : true / skip : false</returns>
     public override bool OpeningCredits()
     {
 
         var strValue = frame.GetValue("TemptureCheck");
 
         if (strValue == "Starting")
         {
             return true;
         }
 
         return false;
     }
     /// <summary>
     /// end condition
     /// </summary>
     /// <returns>start : true / skip : false</returns>
     public override bool EndingCredits()
     {
         if (this.ShotNumber > 3)
         { 
             return true;
         }
 
         return false;
     }

     [Message, Shot(1)]
     public ShotResult EVENT_1
     {
         set
         {
             var strValue = frame.GetValue("DevAPowerStatus");

             if (strValue == "OK")
             {
                 value.NextShot();
             }
         }
     }

     [Message, Shot(2)]
     public ShotResult EVENT_2
     {
         set
         {
             if (frame.GetValue("DevCOnOff") != "On")
             {
                 value.Occure("ERROR", "Did not turn on.");
             }
             else
             {
                 value.NextShot();
             }
         }
     }

     [Message, Shot(3)]
     public ShotResult EVENT_3
     {
         set
         {
             var strValue = frame.GetValue("Temperature");

             if (strValue <= 30)
             {
                 value.EndingCredits();
             }
         }
     } 
 }
```

#### IntervalRelationService
```C#
/// <summary>
/// 10ms interval serivce 
/// </summary>
public class HeatingCheck : IntervalRelationService
{ 
    public HeatingCheck()
    {

    }

    /// <summary>
    /// Min-limit = 10ms 
    /// </summary>
    public override int Interval { set; get; } = 10;

    public override void Tick()
    {
        if (frame.GetValue("Temperature") >= 30)
        {
            Occure("WARNING", "Too Hot");
        }
    }
}
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

```
port add --comm heating1 /TempLib/TempLib.dll 
port add --comm heating2 /TempLib/TempLib.dll
```
 