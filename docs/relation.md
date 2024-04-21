
# What's RELATION?
__________________

# API Refrence
__________________



# How can make realtion library
__________________

this is li
test



# .Net (>= 8.0)
__________________

```
dotnet add package PortLib
```


MODEL NAME | TODO | Description 
------|--------|--------
CommRelationModel | a | b  
CommRelationModel | a | b
CommRelationModel | a | b
CommRelationModel | a | b


* [C#]
```C#
 /// <summary>
 /// Communication Relation Object 
 /// you must be implement IsConnected, Endpoint
 /// </summary>
    

 public class Relation : CommRelationModel
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
     public string GetPower
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



