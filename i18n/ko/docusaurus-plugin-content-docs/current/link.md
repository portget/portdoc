# PortLink (원격 데이터 링크)

## 개요

PortDIC은 `portlink.dll` 기반의 QUIC 산업용 원격 데이터 링크(`PortLink`)를 제공합니다. 원격지 간(공장 ↔ 본사, 설비 ↔ 설비)에 텔레메트리, 알람, 커맨드를 TLS 1.3 위에서 3단계 전달 보장으로 교환합니다.

**주요 특징:**
- QUIC over UDP + TLS 1.3 — 기본 암호화, 평문 모드 없음
- 인증서 핀(Certificate Pinning) + 사전 공유 키(PSK) 인증 — CA 없이 MITM 방어
- 3단계 QoS:

| QoS | 보장 | 전송 | 용도 |
|-----|-----|-----|-----|
| Q0 `BestEffort` | 손실 허용 | QUIC datagram | 고주기 텔레메트리 |
| Q1 `AtLeastOnce` | Ack까지 재전송 | 스트림 + 배치 ack | 알람, 중요 텔레메트리 |
| Q2 (커맨드) | Exactly-once effect | 요청별 스트림 + idempotency key | 상태 변경 커맨드 |

- 클라이언트 자동 재연결 + 미확인 Q1 메시지 재전송
- **Set 미러링** — 로컬 `Port.Set` 값을 원격지에 자동 복제
- 한 프로세스에서 다중 인스턴스 운용 가능 (서버/클라이언트 역할 공존)

`portlink.dll`은 다른 네이티브 프로토콜 라이브러리와 동일하게 `C:\Program Files\Port\PortDIC\lib\`에서 로드됩니다.

---

## 빠른 시작

### 서버 (공장 측)

```csharp
using Portdic.Protocol.Link;

var server = new PortLink("factoryA");

server.OnConnection += (name, nodeId, connected) =>
    Console.WriteLine($"[{name}] {nodeId} {(connected ? "연결" : "해제")}");

server.OnMessage += (name, nodeId, topic, qos, payload) =>
    Console.WriteLine($"[{name}] {topic} = {Encoding.UTF8.GetString(payload)}");

server.OnCommand += (name, nodeId, topic, payload, corrId) =>
{
    // 커맨드 실행 후 응답. 핸들러 안에서 동기적으로 응답해도 안전합니다.
    server.RespondCommand(corrId, 0, Encoding.UTF8.GetBytes("ok"));
};

server.StartServer(7443, "psk-secret");

// 핀 배포용 인증서 추출 (파일, USB 등으로 클라이언트에 전달)
byte[] certDer = server.GetServerCert();
```

### 클라이언트 (원격지)

```csharp
using Portdic.Protocol.Link;

PortLink.SetPinnedCert(certDer);          // MITM 방어: 서버 인증서 핀 고정

var client = new PortLink("line1");
client.Connect("203.0.113.10", 7443, "eq01", "psk-secret");

// 텔레메트리 (기본 Q1 at-least-once)
client.Publish("room1/Temp1", "41.5");

// 손실 허용 고주기 값 (Q0)
client.Publish("room1/Vibration", vibBytes, LinkQos.BestEffort, ttlMs: 2000);

// 알람
client.Publish("alarm/A100", "over-temp", LinkQos.AtLeastOnce, LinkMessageClass.Alarm);
```

`Connect`가 한 번 성공하면 이후 `Close()` 호출 전까지 엔진이 자동 재연결(backoff 최대 10초)합니다. 재연결 시 미확인 Q1 메시지는 자동 재전송됩니다.

---

## 커맨드 (Q2 — Exactly-Once Effect)

상태 변경 커맨드는 idempotency key를 사용해 재시도·재연결이 겹쳐도 효과가 최대 1회만 커밋됩니다.

```csharp
// 송신 측 — 최종 결과 또는 타임아웃까지 블로킹 (내부 재시도 포함)
int code = client.SendCommand("robot/move",
    Encoding.UTF8.GetBytes("{\"target\":120.5}"),
    out byte[] result,
    idempotencyKey: "job42-move1",     // null = 자동 생성
    timeoutMs: 30000);

// 호출 스레드를 막지 않으려면:
var (code2, result2) = await client.SendCommandAsync("robot/move", payload);
```

```csharp
// 수신 측 — OnCommand 안에서 30초 내 응답
server.OnCommand += (name, nodeId, topic, payload, corrId) =>
    server.RespondCommand(corrId, 0, resultBytes);
```

**결과 코드:** 애플리케이션 코드는 `>= 0`이어야 하며, 음수는 엔진 오류(`LinkResult`)입니다. **동일 idempotency key** 재시도는 커밋된 커맨드를 재실행하지 않고 저장된 결과를 재응답합니다. 같은 키에 *다른* payload가 오면 `IdempotencyConflict`(-6)로 거부됩니다.

| 상황 | 동작 |
|---|---|
| 중복 키, 동일 payload, 커밋 완료 | 저장 결과 재응답; 수신 핸들러 재호출 없음 |
| 중복 키, 동일 payload, 실행 중 | `InProgress`(-11); 송신 측이 타임아웃 내 재시도 지속 |
| 중복 키, 다른 payload | `IdempotencyConflict`(-6) |
| 수신 앱 무응답 (30초) | `UnknownOutcome`(-13); 이후 재시도는 재실행될 수 있음 |

---

## Set 미러링

`EnableMirror`는 이 프로세스의 `Port.Set` 호출을 원격 피어에 자동 복제합니다 — 명시적 `Publish` 호출이 필요 없습니다. 수신된 미러 값은 로컬 entry에 기록되며, 구조적으로 에코 루프가 발생하지 않습니다.

```csharp
// 송신 사이트
var link = new PortLink("line1");
link.Connect("203.0.113.10", 7443, "eq01", "psk-secret");
link.EnableMirror("room1.*");            // room1 그룹 미러링

Port.Set("room1.Temp1", 41.5);           // 원격지에 자동 도착
```

```csharp
// 수신 사이트 (서버)
var hub = new PortLink("hq");
hub.StartServer(7443, "psk-secret");
hub.EnableMirror("room1.*");             // 수신 값을 로컬 entry에 적용
```

| `EnableMirror` 파라미터 | 기본값 | 설명 |
|---|---|---|
| `pattern` | `"*"` | 콤마 구분 필터: 정확히 `"room1.Temp1"`, 그룹 `"room1.*"`, 전체 `"*"` |
| `qos` | `AtLeastOnce` | 미러 값의 전달 보장 |
| `ttlMs` | `0` | 미러 값 만료 (0 = 무제한) |
| `applyIncoming` | `true` | 수신 값을 로컬 entry에 기록 |
| `targetNode` | `null` | 서버 모드: 특정 노드에만 미러링 |

**참고:**
- 와이어 topic은 dot-notation 키(`room1.Temp1`), payload는 값 문자열입니다.
- **이 프로세스가 수행한** Set만 캡처됩니다. Rust port 서버 내부(예: rule engine)에서 쓰인 값은 미러링되지 않습니다.
- 캡처는 백그라운드 펌프에서 발행되므로 앱의 `Set` 경로가 네트워크 I/O에 막히지 않습니다.
- 링크 단절 중 캡처된 Set은 폐기됩니다 (단절당 첫 폐기 1회만 `OnError` 발생).

---

## 보안

1. **TLS 1.3** — 항상 활성; 서버는 기동 시 자체 서명 인증서를 생성합니다.
2. **인증서 핀** — `Connect` 전에 `PortLink.SetPinnedCert(certDer)`를 호출하세요. 핀 없이 연결하면 암호화는 되지만 MITM에 취약합니다 (인트라넷 한정; 경고 로그 출력).
3. **PSK** — 모든 클라이언트는 세션 hello에서 서버의 사전 공유 토큰을 제시해야 하며, 불일치 시 데이터 교환 전에 `Unauthenticated`(-3)로 거부됩니다.

```csharp
// 서버 측: 1회 추출 후 별도 경로로 배포
File.WriteAllBytes("factoryA.der", server.GetServerCert());

// 클라이언트 측: 연결 전 핀 고정
PortLink.SetPinnedCert(File.ReadAllBytes("factoryA.der"));
```

---

## API 레퍼런스

### 생성자 / 수명주기

| 멤버 | 설명 |
|---|---|
| `new PortLink(string name)` | 인스턴스 생성; `name`은 콜백 라우팅 키. |
| `StartServer(int port, string psk)` | `0.0.0.0:port`(UDP)에서 수신 대기. |
| `Connect(string host, int port, string nodeId, string psk)` | 연결 + 인증; 최초 세션까지 블로킹, 이후 자동 재연결. |
| `Close()` / `Dispose()` | 인스턴스 종료 (클라이언트는 재연결 중단). |
| `IsDllLoaded` (static) | `portlink.dll` export 로드 여부. |

### 데이터

| 멤버 | 설명 |
|---|---|
| `Publish(topic, byte[]/string, qos, messageClass, ttlMs, targetNode)` | 텔레메트리(class 1)/알람(class 2)을 Q0/Q1로 전송. |
| `SendCommand(topic, payload, out result, idemKey, timeoutMs, targetNode)` | 블로킹 Q2 커맨드; 앱 코드(≥0) 또는 `LinkResult`(<0) 반환. |
| `SendCommandAsync(...)` | 스레드풀 래퍼, `(code, result)` 반환. |
| `RespondCommand(corrId, resultCode, payload)` | `OnCommand`로 받은 커맨드에 응답. |
| `EnableMirror(pattern, qos, ttlMs, applyIncoming, targetNode)` | 이 인스턴스의 Set 미러링 시작. |
| `DisableMirror()` | 미러링 중지. |

### 보안 / 진단

| 멤버 | 설명 |
|---|---|
| `GetServerCert()` | 클라이언트 핀 고정용 서버 인증서(DER). |
| `SetPinnedCert(byte[])` (static) | 이후 `Connect`에 사용할 서버 인증서 핀. |
| `SetLogger(rootPath[, PortLogConfiguration])` | 회전 파일 로그 (TCP/Serial/FileSender와 동일 설정 객체). |
| `GetLastError()` (static) | 호출 스레드의 마지막 실패 상세 메시지. |

### 이벤트 (named delegate)

| 이벤트 | 델리게이트 | 발생 시점 |
|---|---|---|
| `OnMessage` | `LinkMessageHandler(name, nodeId, topic, qos, payload)` | 텔레메트리/알람 수신. |
| `OnCommand` | `LinkCommandHandler(name, nodeId, topic, payload, corrId)` | Q2 커맨드 수신 — `RespondCommand`로 응답. |
| `OnConnection` | `LinkConnectionHandler(name, nodeId, connected)` | 피어 세션 연결/해제 (클라이언트에서 서버 피어는 `"@server"`). |
| `OnError` | `LinkErrorHandler(name, code, message)` | 비동기 엔진 오류 (예: 큐 초과 drop). |

콜백은 portlink 런타임 스레드에서 도착합니다 — UI 스레드 마샬링은 직접 처리하고 핸들러는 짧게 유지하세요.

### LinkResult 코드

| 코드 | 값 | 의미 |
|---|---|---|
| `Ok` | 0 | 성공. |
| `InvalidArgument` | -1 | 잘못된 인자. |
| `Unauthenticated` | -3 | PSK 불일치. |
| `Expired` | -4 | TTL 초과. |
| `IdempotencyConflict` | -6 | 동일 키, 다른 payload. |
| `RateLimited` | -7 | 대기 큐 가득 참. |
| `Unavailable` | -8 | 연결된 피어 없음 / 일시 장애. |
| `DeadlineExceeded` | -9 | 커맨드 타임아웃. |
| `PayloadTooLarge` | -10 | 1 MiB 프레임 한도/결과 버퍼 초과. |
| `InProgress` | -11 | 커맨드 실행 중. |
| `UnknownOutcome` | -13 | 결과 미확인 — 장비 상태를 조회하세요. |
| `NotFound` | -14 | 인스턴스 또는 대기 커맨드 없음. |
| `DllNotLoaded` | -98 | `portlink.dll` 미로드. |

---

## 운영 기본값

| 항목 | 기본값 |
|---|---|
| 프레임 한도 | 1 MiB |
| keep-alive / idle timeout | 10초 / 30초 (QUIC 레벨) |
| Q1 재시도 backoff | 200ms ×2 상한 5초, ±20% jitter |
| Q1 미확인 큐 상한 | 10,000건 (oldest drop) |
| Q2 dedup 보존 | 24시간 (인메모리) |
| 커맨드 응답 창 (수신 앱) | 30초 |
| 재연결 backoff | 500ms ×2 상한 10초 |
