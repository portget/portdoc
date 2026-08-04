# PortLink (Remote Data Link)

## Overview

PortDIC provides a QUIC-based industrial remote-data link (`PortLink`) backed by `portlink.dll`. It exchanges telemetry, alarms, and commands between remote sites (factory ↔ headquarters, equipment ↔ equipment) over TLS 1.3 with three delivery-guarantee levels.

**Key characteristics:**
- QUIC over UDP with TLS 1.3 — encrypted by default, no plaintext mode
- Certificate Pinning + Pre-Shared Key (PSK) authentication — MITM-resistant without a CA
- Three QoS levels:

| QoS | Guarantee | Transport | Use case |
|-----|-----------|-----------|----------|
| Q0 `BestEffort` | May be lost | QUIC datagram | High-rate telemetry |
| Q1 `AtLeastOnce` | Retransmitted until acknowledged | Stream + batch ack | Alarms, important telemetry |
| Q2 (commands) | Exactly-once effect | Per-request stream + idempotency key | State-changing commands |

- Automatic client reconnect with resend of unacknowledged Q1 messages
- **Set mirroring** — local `Port.Set` values replicate to the remote site automatically
- One process can run multiple instances (server and client roles can coexist)

`portlink.dll` is loaded from `C:\Program Files\Port\PortDIC\lib\` like the other native protocol libraries.

---

## Quick Setup

### Server (factory side)

```csharp
using Portdic.Protocol.Link;

var server = new PortLink("factoryA");

server.OnConnection += (name, nodeId, connected) =>
    Console.WriteLine($"[{name}] {nodeId} {(connected ? "connected" : "disconnected")}");

server.OnMessage += (name, nodeId, topic, qos, payload) =>
    Console.WriteLine($"[{name}] {topic} = {Encoding.UTF8.GetString(payload)}");

server.OnCommand += (name, nodeId, topic, payload, corrId) =>
{
    // Execute the command, then answer. Responding synchronously inside
    // the handler is safe.
    server.RespondCommand(corrId, 0, Encoding.UTF8.GetBytes("ok"));
};

server.StartServer(7443, "psk-secret");

// Distribute the certificate to clients for pinning (file, USB, etc.)
byte[] certDer = server.GetServerCert();
```

### Client (remote site)

```csharp
using Portdic.Protocol.Link;

PortLink.SetPinnedCert(certDer);          // MITM-safe: pin the server cert

var client = new PortLink("line1");
client.Connect("203.0.113.10", 7443, "eq01", "psk-secret");

// Telemetry (Q1 at-least-once by default)
client.Publish("room1/Temp1", "41.5");

// High-rate values that may be dropped (Q0)
client.Publish("room1/Vibration", vibBytes, LinkQos.BestEffort, ttlMs: 2000);

// Alarm
client.Publish("alarm/A100", "over-temp", LinkQos.AtLeastOnce, LinkMessageClass.Alarm);
```

After `Connect` succeeds once, the engine reconnects automatically (backoff up to 10 s) until `Close()` is called. Unacknowledged Q1 messages are resent after every reconnect.

---

## Commands (Q2 — Exactly-Once Effect)

State-changing commands use an idempotency key so the effect commits at most once, even across retries and reconnects.

```csharp
// Sender — blocks until a final result or timeout (internal retry included)
int code = client.SendCommand("robot/move",
    Encoding.UTF8.GetBytes("{\"target\":120.5}"),
    out byte[] result,
    idempotencyKey: "job42-move1",     // null = auto-generated
    timeoutMs: 30000);

// Or without blocking the caller:
var (code2, result2) = await client.SendCommandAsync("robot/move", payload);
```

```csharp
// Receiver — answer inside OnCommand within 30 seconds
server.OnCommand += (name, nodeId, topic, payload, corrId) =>
    server.RespondCommand(corrId, 0, resultBytes);
```

**Result codes:** application codes must be `>= 0`; negative values are engine errors (`LinkResult`). Retrying with the **same idempotency key** never re-executes a committed command — the stored result is replayed. The same key with a *different* payload is rejected with `IdempotencyConflict` (-6).

| Situation | Behavior |
|---|---|
| Duplicate key, same payload, committed | Stored result replayed; receiver handler NOT called again |
| Duplicate key, same payload, still executing | `InProgress` (-11); sender keeps retrying within its timeout |
| Duplicate key, different payload | `IdempotencyConflict` (-6) |
| Receiver app never responds (30 s) | `UnknownOutcome` (-13); a later retry may execute again |

---

## Set Mirroring

`EnableMirror` replicates this process's `Port.Set` calls to the remote peer automatically — no explicit `Publish` calls needed. Incoming mirrored values are written to local entries (loop-safe by construction).

```csharp
// Sending site
var link = new PortLink("line1");
link.Connect("203.0.113.10", 7443, "eq01", "psk-secret");
link.EnableMirror("room1.*");            // mirror the room1 group

Port.Set("room1.Temp1", 41.5);           // arrives at the remote site automatically
```

```csharp
// Receiving site (server)
var hub = new PortLink("hq");
hub.StartServer(7443, "psk-secret");
hub.EnableMirror("room1.*");             // applies incoming values to local entries
```

| `EnableMirror` parameter | Default | Description |
|---|---|---|
| `pattern` | `"*"` | Comma-separated filters: exact `"room1.Temp1"`, group `"room1.*"`, or `"*"` |
| `qos` | `AtLeastOnce` | Delivery guarantee for mirrored values |
| `ttlMs` | `0` | Expiry for mirrored values (0 = never) |
| `applyIncoming` | `true` | Write received values to local entries |
| `targetNode` | `null` | Server mode: mirror to one node only |

**Notes:**
- The wire topic is the dot-notation key (`room1.Temp1`); the payload is the value string.
- Only Sets performed **by this process** are captured. Values written inside the Rust port server (e.g. by the rule engine) are not mirrored.
- Capture runs on a background pump — the application's `Set` path is never blocked by network I/O.
- While the link is down, captured Sets are dropped (first drop raises `OnError` once per outage).

---

## Security

1. **TLS 1.3** — always on; the server generates a self-signed certificate at startup.
2. **Certificate Pinning** — call `PortLink.SetPinnedCert(certDer)` before `Connect`. Without a pin, the connection is encrypted but MITM-vulnerable (intranet only; a warning is logged).
3. **PSK** — every client must present the server's pre-shared token during the session hello; a mismatch is rejected with `Unauthenticated` (-3) before any data flows.

```csharp
// Server side: export once, distribute out-of-band
File.WriteAllBytes("factoryA.der", server.GetServerCert());

// Client side: pin before connecting
PortLink.SetPinnedCert(File.ReadAllBytes("factoryA.der"));
```

---

## API Reference

### Constructor / Lifecycle

| Member | Description |
|---|---|
| `new PortLink(string name)` | Creates an instance; `name` is the routing key for callbacks. |
| `StartServer(int port, string psk)` | Listen on `0.0.0.0:port` (UDP). |
| `Connect(string host, int port, string nodeId, string psk)` | Connect + authenticate; blocks until the first session, then auto-reconnects. |
| `Close()` / `Dispose()` | Stop the instance (client stops reconnecting). |
| `IsDllLoaded` (static) | True when `portlink.dll` exports are loaded. |

### Data

| Member | Description |
|---|---|
| `Publish(topic, byte[]/string, qos, messageClass, ttlMs, targetNode)` | Send telemetry (class 1) or an alarm (class 2) with Q0/Q1. |
| `SendCommand(topic, payload, out result, idemKey, timeoutMs, targetNode)` | Blocking Q2 command; returns app code (≥0) or `LinkResult` (<0). |
| `SendCommandAsync(...)` | Thread-pool wrapper returning `(code, result)`. |
| `RespondCommand(corrId, resultCode, payload)` | Answer a command delivered via `OnCommand`. |
| `EnableMirror(pattern, qos, ttlMs, applyIncoming, targetNode)` | Start Set mirroring on this instance. |
| `DisableMirror()` | Stop mirroring. |

### Security / Diagnostics

| Member | Description |
|---|---|
| `GetServerCert()` | Server certificate (DER) for client pinning. |
| `SetPinnedCert(byte[])` (static) | Pin the server certificate for subsequent `Connect` calls. |
| `SetLogger(rootPath[, PortLogConfiguration])` | Rotating file logs (same config object as TCP/Serial/FileSender). |
| `GetLastError()` (static) | Detail message for the calling thread's last failed call. |

### Events (named delegates)

| Event | Delegate | Fired when |
|---|---|---|
| `OnMessage` | `LinkMessageHandler(name, nodeId, topic, qos, payload)` | Telemetry/alarm arrives. |
| `OnCommand` | `LinkCommandHandler(name, nodeId, topic, payload, corrId)` | Q2 command arrives — answer via `RespondCommand`. |
| `OnConnection` | `LinkConnectionHandler(name, nodeId, connected)` | Peer session opens/closes (`"@server"` = the server peer on clients). |
| `OnError` | `LinkErrorHandler(name, code, message)` | Asynchronous engine error (e.g. queue overflow drop). |

Callbacks arrive on portlink runtime threads — marshal to the UI thread yourself and keep handlers fast.

### LinkResult Codes

| Code | Value | Meaning |
|---|---|---|
| `Ok` | 0 | Success. |
| `InvalidArgument` | -1 | Bad argument. |
| `Unauthenticated` | -3 | PSK mismatch. |
| `Expired` | -4 | TTL elapsed. |
| `IdempotencyConflict` | -6 | Same key, different payload. |
| `RateLimited` | -7 | Pending queue full. |
| `Unavailable` | -8 | No connected peer / transient failure. |
| `DeadlineExceeded` | -9 | Command timeout. |
| `PayloadTooLarge` | -10 | Over the 1 MiB frame limit / result buffer. |
| `InProgress` | -11 | Command still executing. |
| `UnknownOutcome` | -13 | Result unconfirmed — query device state. |
| `NotFound` | -14 | Instance or pending command missing. |
| `DllNotLoaded` | -98 | `portlink.dll` not loaded. |

---

## Operational Defaults

| Item | Default |
|---|---|
| Frame limit | 1 MiB |
| Keep-alive / idle timeout | 10 s / 30 s (QUIC-level) |
| Q1 retry backoff | 200 ms ×2 up to 5 s, ±20% jitter |
| Q1 unacked queue cap | 10,000 (oldest dropped) |
| Q2 dedup retention | 24 h (in-memory) |
| Command response window (receiver app) | 30 s |
| Reconnect backoff | 500 ms ×2 up to 10 s |
