# MQTT

## Overview

PortDIC supports MQTT through the handler pattern.
Each `[MQTTHandler]` class gets its own independent MQTT connection, and the operating mode
(`Client` or `Broker`) is selected by calling `SetMode` in the `[Preset]` method.

| Mode | Description |
|------|-------------|
| `MqttMode.Client` | Connect to an external MQTT broker (default) |
| `MqttMode.Broker` | Start an embedded MQTT broker inside the process |

---

## Quick Start

### Client Mode (connect to a broker)

```csharp
using Portdic;
using Portdic.MQTT;

[MQTTHandler]
public class SensorClient
{
    [MQTTHandlerProp]
    public IMQTTHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(MqttMode.Client);
        handler.SetHost("192.168.1.50");
        handler.SetPort(1883);
        handler.SetClientId("sensor-client-01");
        handler.SetUsername("user");
        handler.SetPassword("pass");

        handler.OnMessageReceived += OnMessage;
        handler.OnEvent += OnEvent;
    }

    private void OnMessage(string name, string topic, string payload, int qos)
        => Console.WriteLine($"[{name}] {topic}: {payload} (QoS {qos})");

    private void OnEvent(string name, string eventType, string description)
    {
        Console.WriteLine($"[{name}] {eventType}: {description}");
        if (eventType == "CONNECTED")
        {
            handler.Subscribe("sensor/temperature/#");
            handler.Subscribe("sensor/humidity", qos: 1);
        }
    }
}
```

```csharp
Port.Add<SensorClient>("mqtt_sensor");
Port.Run();
```

### Broker Mode (embedded broker)

```csharp
[MQTTHandler]
public class EmbeddedBroker
{
    [MQTTHandlerProp]
    public IMQTTHandler handler { get; set; } = null!;

    [Preset]
    private void Preset()
    {
        handler.SetMode(MqttMode.Broker);
        handler.SetBrokerAddress("0.0.0.0:1883");
        handler.SetUsers("[{\"name\":\"admin\",\"password\":\"admin\"}]");
        handler.SetAllowRemotes("192.168.1.0/24", "10.0.0.100");
        handler.SetUseMqttProtocol(true);   // true = native MQTT/TCP, false = WebSocket

        handler.OnEvent += OnEvent;
    }

    private void OnEvent(string name, string eventType, string description)
        => Console.WriteLine($"[{name}] {eventType}: {description}");
}
```

```csharp
Port.Add<EmbeddedBroker>("mqtt_broker");
Port.Run();
```

---

## Multiple Connections

Each registration creates its own independent MQTT handler:

```csharp
Port.Add<LocalBrokerClient>("mqtt_local");
Port.Add<CloudBrokerClient>("mqtt_cloud");
Port.Run();
```

---

## Publish and Subscribe

```csharp
// Subscribe to a topic
handler.Subscribe("equipment/status");
handler.Subscribe("sensor/#", qos: 1);     // wildcard, QoS 1

// Publish a message
handler.Publish("equipment/status", "online");
handler.Publish("sensor/temp", "25.3", qos: 1, retain: true);

// Unsubscribe
handler.Unsubscribe("sensor/#");

// Disconnect
handler.Close();
```

---

## QoS Levels

| Level | Guarantee | Description |
|-------|-----------|-------------|
| **QoS 0** | At most once | No delivery guarantee; possible message loss |
| **QoS 1** | At least once | Guaranteed delivery; possible duplication |
| **QoS 2** | Exactly once | Guaranteed delivery without duplication |

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[MQTTHandler]` | Class | Marks the class as an MQTT handler container |
| `[MQTTHandlerProp]` | Property | Injects the `IMQTTHandler` instance |
| `[Preset]` | Method | Called before `Open()` to configure the handler |

### Mode

| Method | Description |
|--------|-------------|
| `SetMode(MqttMode mode)` | Select `Client` (default) or `Broker` mode |

### Client Configuration

| Method | Default | Description |
|--------|---------|-------------|
| `SetHost(string host)` | `"127.0.0.1"` | Broker address |
| `SetPort(int port)` | `1883` | Broker port |
| `SetClientId(string clientId)` | registration key | MQTT client ID |
| `SetUsername(string username)` | — | Broker authentication username |
| `SetPassword(string password)` | — | Broker authentication password |
| `SetKeepAlive(int seconds)` | `60` | Keep-alive interval in seconds |
| `SetCleanSession(bool)` | `true` | Discard previous session state on connect |

### Broker Configuration

| Method | Default | Description |
|--------|---------|-------------|
| `SetBrokerAddress(string address)` | `"127.0.0.1:1883"` | Listen address in `host:port` format |
| `SetUsers(string usersJson)` | admin/admin | Authorized users as JSON array |
| `SetAllowRemotes(params string[] remotes)` | `["127.0.0.1"]` | Allowed IPs, hostnames, or CIDR ranges |
| `SetUseMqttProtocol(bool)` | `true` | `true` = native MQTT/TCP; `false` = WebSocket |

#### `SetUsers` JSON Format

```json
[{"name":"admin","password":"admin123"},{"name":"sensor01","password":"pass"}]
```

#### Transport Modes

| `SetUseMqttProtocol` | Transport | Typical Port | Use Case |
|----------------------|-----------|--------------|----------|
| `true` | Native MQTT over TCP | 1883 / 8883 | MQTT clients, edge devices |
| `false` | MQTT over WebSocket | 8080 | Browser-based clients, dashboards |

### Connection

| Method | Returns | Description |
|--------|---------|-------------|
| `Open()` | `ERROR_CODE` | Connect to the broker or start the embedded broker |
| `Close()` | `ERROR_CODE` | Disconnect or stop the embedded broker |
| `IsConnected` | `bool` | `true` if currently connected (Client mode) |

### Publish / Subscribe

| Method | Returns | Description |
|--------|---------|-------------|
| `Publish(topic, payload, qos, retain)` | `int` | Publish a message. Returns `0` on success |
| `Subscribe(topic, qos)` | `int` | Subscribe to a topic filter. Returns `0` on success |
| `Unsubscribe(topic)` | `int` | Unsubscribe from a topic. Returns `0` on success |

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated log files. Format: `mqtt_{name}_{date}_{hour}.log` |
| `WriteLog(string message)` | Write a custom entry to the log file |

---

## Events

### `OnMessageReceived`

Fired when a message arrives on a subscribed topic (Client mode).

```csharp
handler.OnMessageReceived += (string name, string topic, string payload, int qos) =>
{
    Console.WriteLine($"[{name}] {topic}: {payload}");
};
```

| Parameter | Description |
|-----------|-------------|
| `name` | Client registration key |
| `topic` | Topic the message was published on |
| `payload` | Message payload as a UTF-8 string |
| `qos` | QoS level (0, 1, or 2) |

### `OnEvent`

Fired on connection state changes and errors.

```csharp
handler.OnEvent += (string name, string eventType, string description) =>
{
    Console.WriteLine($"[{name}] {eventType}: {description}");
};
```

| `eventType` | Triggered When |
|-------------|----------------|
| `CONNECTED` | Connected to the broker / broker started |
| `DISCONNECTED` | Disconnected / broker stopped |
| `SUBSCRIBED` | Topic subscription confirmed |
| `UNSUBSCRIBED` | Topic unsubscription confirmed |
| `PUBLISHED` | Message published successfully |
| `ERROR` | Error occurred (`description` contains detail) |

---

## Error Codes

| Code | Value | Meaning |
|------|-------|---------|
| `ERR_CODE_NO_ERROR` | `1` | Success |
| `ERR_CODE_OPEN` | `-1` | Open/connect failed |
| `ERR_CODE_DLL_NOT_LOADED` | `-2` | `portmqttclient.dll` / `portmqtt.dll` not loaded |
| `ERR_CODE_PORTNAME_EMPTY` | `-3` | Name not set |
| `ERR_CODE_DLL_FUNC_NOT_CONFIRM` | `-4` | Required DLL function unavailable |
| `ERR_CODE_CONNECT_FAILED` | `-5` | Connection attempt failed |

---

## Related

- [RTSP](rtsp) — Real-time video streaming
- [SECS/GEM](secs) — Semiconductor equipment protocol
- [TCP](tcp) — Raw TCP client/server communication
