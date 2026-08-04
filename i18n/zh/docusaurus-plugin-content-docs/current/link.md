# PortLink (远程数据链路)

## 概述

PortDIC 提供基于 `portlink.dll` 的 QUIC 工业远程数据链路 (`PortLink`)。它在远程站点之间（工厂 ↔ 总部、设备 ↔ 设备）通过 TLS 1.3 以三级投递保证交换遥测、报警和命令。

**主要特性:**
- QUIC over UDP + TLS 1.3 — 默认加密，无明文模式
- 证书固定 (Certificate Pinning) + 预共享密钥 (PSK) 认证 — 无需 CA 即可防御 MITM
- 三级 QoS:

| QoS | 保证 | 传输 | 用途 |
|-----|-----|-----|-----|
| Q0 `BestEffort` | 允许丢失 | QUIC datagram | 高频遥测 |
| Q1 `AtLeastOnce` | 重传直到确认 | 流 + 批量 ack | 报警、重要遥测 |
| Q2 (命令) | Exactly-once effect | 每请求流 + idempotency key | 状态变更命令 |

- 客户端自动重连并重发未确认的 Q1 消息
- **Set 镜像** — 本地 `Port.Set` 值自动复制到远程站点
- 一个进程可运行多个实例（服务器/客户端角色可共存）

`portlink.dll` 与其他原生协议库一样从 `C:\Program Files\Port\PortDIC\lib\` 加载。

---

## 快速开始

### 服务器（工厂侧）

```csharp
using Portdic.Protocol.Link;

var server = new PortLink("factoryA");

server.OnConnection += (name, nodeId, connected) =>
    Console.WriteLine($"[{name}] {nodeId} {(connected ? "已连接" : "已断开")}");

server.OnMessage += (name, nodeId, topic, qos, payload) =>
    Console.WriteLine($"[{name}] {topic} = {Encoding.UTF8.GetString(payload)}");

server.OnCommand += (name, nodeId, topic, payload, corrId) =>
{
    // 执行命令后应答。在处理程序内同步应答是安全的。
    server.RespondCommand(corrId, 0, Encoding.UTF8.GetBytes("ok"));
};

server.StartServer(7443, "psk-secret");

// 导出证书分发给客户端用于固定（文件、USB 等）
byte[] certDer = server.GetServerCert();
```

### 客户端（远程站点）

```csharp
using Portdic.Protocol.Link;

PortLink.SetPinnedCert(certDer);          // 防御 MITM: 固定服务器证书

var client = new PortLink("line1");
client.Connect("203.0.113.10", 7443, "eq01", "psk-secret");

// 遥测（默认 Q1 at-least-once）
client.Publish("room1/Temp1", "41.5");

// 允许丢失的高频值 (Q0)
client.Publish("room1/Vibration", vibBytes, LinkQos.BestEffort, ttlMs: 2000);

// 报警
client.Publish("alarm/A100", "over-temp", LinkQos.AtLeastOnce, LinkMessageClass.Alarm);
```

`Connect` 成功一次后，引擎会自动重连（backoff 最大 10 秒）直到调用 `Close()`。每次重连后自动重发未确认的 Q1 消息。

---

## 命令 (Q2 — Exactly-Once Effect)

状态变更命令使用 idempotency key，即使重试与重连交叠，效果也最多提交一次。

```csharp
// 发送方 — 阻塞直到最终结果或超时（含内部重试）
int code = client.SendCommand("robot/move",
    Encoding.UTF8.GetBytes("{\"target\":120.5}"),
    out byte[] result,
    idempotencyKey: "job42-move1",     // null = 自动生成
    timeoutMs: 30000);

// 不阻塞调用线程:
var (code2, result2) = await client.SendCommandAsync("robot/move", payload);
```

```csharp
// 接收方 — 在 OnCommand 内 30 秒内应答
server.OnCommand += (name, nodeId, topic, payload, corrId) =>
    server.RespondCommand(corrId, 0, resultBytes);
```

**结果码:** 应用程序代码必须 `>= 0`，负值为引擎错误 (`LinkResult`)。使用**相同 idempotency key** 的重试不会重新执行已提交的命令 — 而是重放已存储的结果。相同 key 但 *不同* payload 会被 `IdempotencyConflict` (-6) 拒绝。

| 情形 | 行为 |
|---|---|
| 重复 key、相同 payload、已提交 | 重放存储结果; 接收处理程序不会再次调用 |
| 重复 key、相同 payload、执行中 | `InProgress` (-11); 发送方在超时内持续重试 |
| 重复 key、不同 payload | `IdempotencyConflict` (-6) |
| 接收应用未应答（30 秒） | `UnknownOutcome` (-13); 之后的重试可能再次执行 |

---

## Set 镜像

`EnableMirror` 自动将本进程的 `Port.Set` 调用复制到远程对端 — 无需显式调用 `Publish`。接收到的镜像值会写入本地 entry，结构上不会产生回声环路。

```csharp
// 发送站点
var link = new PortLink("line1");
link.Connect("203.0.113.10", 7443, "eq01", "psk-secret");
link.EnableMirror("room1.*");            // 镜像 room1 组

Port.Set("room1.Temp1", 41.5);           // 自动到达远程站点
```

```csharp
// 接收站点（服务器）
var hub = new PortLink("hq");
hub.StartServer(7443, "psk-secret");
hub.EnableMirror("room1.*");             // 将接收值应用到本地 entry
```

| `EnableMirror` 参数 | 默认值 | 说明 |
|---|---|---|
| `pattern` | `"*"` | 逗号分隔的过滤器: 精确 `"room1.Temp1"`、组 `"room1.*"`、全部 `"*"` |
| `qos` | `AtLeastOnce` | 镜像值的投递保证 |
| `ttlMs` | `0` | 镜像值过期时间 (0 = 永不过期) |
| `applyIncoming` | `true` | 将接收值写入本地 entry |
| `targetNode` | `null` | 服务器模式: 仅镜像到指定节点 |

**注意:**
- 线路 topic 为点表示法键 (`room1.Temp1`)，payload 为值字符串。
- 仅捕获**本进程执行的** Set。在 Rust port 服务器内部写入的值（如 rule engine）不会被镜像。
- 捕获在后台泵中发布 — 应用程序的 `Set` 路径不会被网络 I/O 阻塞。
- 链路断开期间捕获的 Set 会被丢弃（每次断连仅首次丢弃触发一次 `OnError`）。

---

## 安全

1. **TLS 1.3** — 始终启用; 服务器启动时生成自签名证书。
2. **证书固定** — 在 `Connect` 前调用 `PortLink.SetPinnedCert(certDer)`。不固定证书时连接虽加密但易受 MITM 攻击（仅限内网; 输出警告日志）。
3. **PSK** — 每个客户端必须在会话 hello 中出示服务器的预共享令牌，不匹配时在任何数据交换前以 `Unauthenticated` (-3) 拒绝。

```csharp
// 服务器侧: 导出一次，通过带外方式分发
File.WriteAllBytes("factoryA.der", server.GetServerCert());

// 客户端侧: 连接前固定
PortLink.SetPinnedCert(File.ReadAllBytes("factoryA.der"));
```

---

## API 参考

### 构造函数 / 生命周期

| 成员 | 说明 |
|---|---|
| `new PortLink(string name)` | 创建实例; `name` 是回调路由键。 |
| `StartServer(int port, string psk)` | 在 `0.0.0.0:port` (UDP) 监听。 |
| `Connect(string host, int port, string nodeId, string psk)` | 连接 + 认证; 阻塞至首个会话建立，之后自动重连。 |
| `Close()` / `Dispose()` | 停止实例（客户端停止重连）。 |
| `IsDllLoaded` (static) | `portlink.dll` 导出是否已加载。 |

### 数据

| 成员 | 说明 |
|---|---|
| `Publish(topic, byte[]/string, qos, messageClass, ttlMs, targetNode)` | 以 Q0/Q1 发送遥测 (class 1) 或报警 (class 2)。 |
| `SendCommand(topic, payload, out result, idemKey, timeoutMs, targetNode)` | 阻塞式 Q2 命令; 返回应用代码 (≥0) 或 `LinkResult` (<0)。 |
| `SendCommandAsync(...)` | 线程池包装，返回 `(code, result)`。 |
| `RespondCommand(corrId, resultCode, payload)` | 应答通过 `OnCommand` 收到的命令。 |
| `EnableMirror(pattern, qos, ttlMs, applyIncoming, targetNode)` | 启动本实例的 Set 镜像。 |
| `DisableMirror()` | 停止镜像。 |

### 安全 / 诊断

| 成员 | 说明 |
|---|---|
| `GetServerCert()` | 供客户端固定的服务器证书 (DER)。 |
| `SetPinnedCert(byte[])` (static) | 固定后续 `Connect` 使用的服务器证书。 |
| `SetLogger(rootPath[, PortLogConfiguration])` | 滚动文件日志（与 TCP/Serial/FileSender 相同的配置对象）。 |
| `GetLastError()` (static) | 调用线程最近一次失败的详细消息。 |

### 事件 (named delegate)

| 事件 | 委托 | 触发时机 |
|---|---|---|
| `OnMessage` | `LinkMessageHandler(name, nodeId, topic, qos, payload)` | 收到遥测/报警。 |
| `OnCommand` | `LinkCommandHandler(name, nodeId, topic, payload, corrId)` | 收到 Q2 命令 — 通过 `RespondCommand` 应答。 |
| `OnConnection` | `LinkConnectionHandler(name, nodeId, connected)` | 对端会话建立/断开（客户端上服务器对端为 `"@server"`）。 |
| `OnError` | `LinkErrorHandler(name, code, message)` | 异步引擎错误（如队列溢出丢弃）。 |

回调在 portlink 运行时线程上到达 — 请自行调度到 UI 线程，并保持处理程序简短。

### LinkResult 代码

| 代码 | 值 | 含义 |
|---|---|---|
| `Ok` | 0 | 成功。 |
| `InvalidArgument` | -1 | 参数无效。 |
| `Unauthenticated` | -3 | PSK 不匹配。 |
| `Expired` | -4 | TTL 已过期。 |
| `IdempotencyConflict` | -6 | 相同 key、不同 payload。 |
| `RateLimited` | -7 | 等待队列已满。 |
| `Unavailable` | -8 | 无已连接对端 / 瞬时故障。 |
| `DeadlineExceeded` | -9 | 命令超时。 |
| `PayloadTooLarge` | -10 | 超过 1 MiB 帧上限/结果缓冲区。 |
| `InProgress` | -11 | 命令执行中。 |
| `UnknownOutcome` | -13 | 结果未确认 — 请查询设备状态。 |
| `NotFound` | -14 | 实例或等待中的命令不存在。 |
| `DllNotLoaded` | -98 | `portlink.dll` 未加载。 |

---

## 运行默认值

| 项目 | 默认值 |
|---|---|
| 帧上限 | 1 MiB |
| keep-alive / idle timeout | 10 秒 / 30 秒 (QUIC 级) |
| Q1 重试 backoff | 200ms ×2 上限 5 秒、±20% jitter |
| Q1 未确认队列上限 | 10,000 条 (丢弃最旧) |
| Q2 dedup 保留 | 24 小时 (内存中) |
| 命令应答窗口 (接收应用) | 30 秒 |
| 重连 backoff | 500ms ×2 上限 10 秒 |
