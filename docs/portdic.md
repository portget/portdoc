# What's PortDic


## Download

### Nuget Package
NAME | Target |OS |STABLE | 
------|--------|--------|--------
Port.IO.Lib.x64 | >= NetFramework 4.8 , >= NetCore 8.0 | Windows x64 | Yes | 


### Functions 

```C#
namespace HelloWorld {

    public class HelloWorld{
        private PortDic dic = portdic.Connect("localhost",9000); 

        public HelloWorld(){

            var ok = dic.Set('AZone','SamplePower','On');
            if(ok){
                Console.WriteLine("ok");
            }

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

        }
    }
}
```