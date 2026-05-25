---
slug: /
sidebar_position: 1
---

# PortDIC에 오신 것을 환영합니다

`"모든 문서는 모델이 될 수 있습니다."`
**"문서는 단순하게. 애플리케이션은 빠르게."** 라는 모토로 설계된 Port는
문서 작성만으로 OPC UA, SECS, MQTT, REST API, 스크립트 기반 플로우 제어를 구현할 수 있게 합니다.
또한 Port 패키지를 통해 다양한 프로그래밍 언어에서 재사용 가능한 라이브러리를 만들 수 있습니다.

[라이선스](license.md) 문서를 확인하세요.

---

## 문서 한 장으로 애플리케이션 완성

PORT는 전통적인 프로그래밍을 없앱니다. 문서를 작성하면 — PORT가 나머지를 처리합니다.

### 1. 문서 테이블 추출 → Page 파일 변환

`Port.Document<T>()`에 Word 또는 Excel 파일 경로를 지정하고, `IParser`를 구현하여 각 행이 어떤 키·데이터 타입·패키지로 매핑되는지만 알려주면 PORT가 `.page` 스키마와 C# 클래스를 자동으로 생성합니다.

```csharp
// Word 문서의 테이블을 읽어 타입 모델 생성
var ioDoc = Port.Document<IOModel>("eq-b01-001", @"IO.docx", new Parser());

// 키 패턴으로 데이터 타입 재정의 — 스키마 파일 편집 불필요
ioDoc.Where(v => v.Key.Contains("OnOff")).ToList()
     .ForEach(v => v.DataType = "Enum.OnOff");
ioDoc.Where(v => v.Key.Contains("Temp")).ToList()
     .ForEach(v => v.DataType = "f8");

// 문서로부터 .page 스키마와 .cs 클래스를 자동 생성
if (ioDoc.Count > 0)
{
    ioDoc.New(@"sample\.page\io.page");   // PORT 런타임 스키마
    ioDoc.New(@"sample\.net\io.cs");      // C# 모델 클래스
}

// PORT 런타임에 Push — 모든 핸들러에서 즉시 사용 가능
Port.Push("eq-b01-001", ioDoc.NewPage("Device"));
```

`IParser`를 한 번 구현하면 PORT가 각 행을 어떻게 읽을지 결정합니다:

```csharp
public class Parser : IParser
{
    public string GetKey(DataTable doc, DataRow row)
        => DocumentConverter.ConvertConstName(row[1].ToString());

    public string GetDataType(DataTable doc, DataRow row) => "Enum.OffOn";
    public string GetPackage(DataTable doc, DataRow row)  => "Device.OnOff";
    public string GetProperty(DataTable doc, DataRow row) => "";
}
```

자동 생성된 `io.page`는 PORT 런타임에서 즉시 사용할 수 있습니다:

```ini
[Device]
VacuumOnOff  = Enum.OnOff
ChamberOnOff = Enum.OnOff
HeaterTemp   = f8
CoolantTemp  = f8
```

---

### 2. IO 디바이스 바인딩 — 드라이버 코드 없이

XML 문서 하나로 물리 IO 디바이스(TCP, RS232, RS485)를 page 변수에 직접 바인딩합니다. 폴링, 재연결, 타입 변환을 PORT가 자동으로 처리합니다.

```xml
<!-- heater.device -->
<Device>
  <Connection>
    <Type>RS232</Type><Port>COM3</Port><BaudRate>9600</BaudRate>
  </Connection>

  <Message name="ReadTemp">
    <Data>{0x52}{0x54}{0x0D}</Data>        <!-- "RT\r" 명령 -->
  </Message>

  <Scenario name="PollTemperature" interval="1000">
    <Send message="ReadTemp"/>
    <Recv variable="room1.Temperature"/>   <!-- F4 타입으로 자동 파싱 -->
  </Scenario>
</Device>
```

> PORT가 디바이스를 지속적으로 폴링하여 결과를 `room1.Temperature`에 기록합니다 — 드라이버 코드가 필요 없습니다.

---

### 3. Flow 제어 — 문서로 정의하는 공정 자동화

프로세스 로직을 `.flow` 파일에 기술하면, PORT의 Flow 엔진이 각 단계를 실행하고 상태를 추적하며 진행 상황을 실시간으로 시각화합니다.

```yaml
# process.flow
name: HeaterControl
steps:
  - name: WaitForReady
    condition: room1.Status == Ready
    next: StartHeating

  - name: StartHeating
    action: set room1.HeaterOn = true
    next: MonitorTemp

  - name: MonitorTemp
    condition: room1.Temperature >= 80.0
    next: Shutdown

  - name: Shutdown
    action: set room1.HeaterOn = false
```

`.rule` 파일을 함께 사용하면 반응형 안전 로직을 추가할 수 있습니다:

```text
# safety.rule
set("room1.HeaterOn == true", "room1.Temperature >= 95.0 => room1.HeaterOn = false")
```

---

### 4. 풍부한 핸들러 생태계 — 하나의 플랫폼, 모든 프로토콜

PORT는 전송 계층이나 직렬화 코드를 작성할 필요가 없도록 핸들러를 기본 제공합니다:

| 핸들러 | 프로토콜 | 설정 방법 |
|--------|----------|-----------|
| `DeviceHandler` | TCP / RS232 / RS485 | `.device` XML 문서 |
| `HsmsHandler` | SECS/GEM (HSMS-SS) | `.svid` / `.ceid` 스프레드시트 |
| `MqttHandler` | MQTT | 브로커 주소 + 토픽 매핑 |
| `OpcUaHandler` | OPC UA | 노드 ID 바인딩 |
| `RestHandler` | HTTP REST | 엔드포인트 + 변수 매핑 |
| `FlowHandler` | 커스텀 워크플로우 | `.flow` YAML |
| `RuleHandler` | 이벤트 기반 규칙 | `.rule` DSL |

모든 핸들러는 동일한 인메모리 page 스토어를 공유하므로, 글루 코드 없이 프로토콜 간 데이터가 자유롭게 흐릅니다.

---
설치 방법 및 시스템 요구사항은 [다운로드](download.md) 페이지를 참고하세요.
