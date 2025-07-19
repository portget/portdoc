# RTSP Protocol

## Table of Contents
1. [Overview](#overview)
2. [Quick Link](#quick-link)
3. [Key Features](#key-features)
4. [Communication Model](#communication-model)
5. [RTSP Methods](#rtsp-methods)
6. [Transport Protocols](#transport-protocols)
7. [Media Types](#media-types)
8. [Session States](#session-states)
9. [Response Codes](#response-codes)
10. [Header Fields](#header-fields)
11. [Common Use Cases](#common-use-cases)

## Overview

RTSP (Real Time Streaming Protocol) is a network protocol designed for controlling and delivering real-time multimedia content. It is used for establishing and controlling media sessions between endpoints, commonly used in video streaming applications, IP cameras, and live broadcasting systems.

## **Quick link** {#quick-link}

**Related Protocols:** [SECS/GEM](secs.md) | [Modbus](modbus.md) | [EtherNet/IP](ethernetip.md) | [OPC UA](opcua.md)

### Key Features

- **Real-time Control**: Provides real-time control over media streams
- **Session Management**: Establishes and manages streaming sessions
- **Transport Independence**: Works over various transport protocols (TCP, UDP)
- **Media Control**: Supports play, pause, stop, and seek operations
- **Scalability**: Supports multiple concurrent sessions
- **Interoperability**: Standard protocol supported by various vendors

### Communication Model

| Model | Description | Use Case |
|-------|-------------|----------|
| **Client-Server** | Traditional request-response model | Media streaming control |
| **Session-based** | Maintains session state | Continuous media control |
| **Stateless** | Each request is independent | Simple control operations |

### RTSP Methods

| Method | Description | Purpose |
|--------|-------------|---------|
| **DESCRIBE** | Get media description | Retrieve stream information |
| **ANNOUNCE** | Announce media description | Server announces available streams |
| **GET_PARAMETER** | Get parameter values | Retrieve session parameters |
| **OPTIONS** | Get supported methods | Discover server capabilities |
| **PAUSE** | Pause media stream | Temporarily stop playback |
| **PLAY** | Start media stream | Begin media playback |
| **RECORD** | Start recording | Begin media recording |
| **REDIRECT** | Redirect to another server | Load balancing, failover |
| **SETUP** | Establish media session | Prepare for streaming |
| **SET_PARAMETER** | Set parameter values | Configure session parameters |
| **TEARDOWN** | End media session | Terminate streaming session |

### Transport Protocols

| Protocol | Description | Characteristics |
|----------|-------------|----------------|
| **RTP** | Real-time Transport Protocol | Media data delivery |
| **RTCP** | RTP Control Protocol | Quality feedback |
| **TCP** | Transmission Control Protocol | Reliable control channel |
| **UDP** | User Datagram Protocol | Fast data delivery |

### Media Types

| Type | Description | Format |
|------|-------------|--------|
| **Video** | Moving images | H.264, H.265, MPEG-4 |
| **Audio** | Sound data | AAC, MP3, PCM |
| **Text** | Subtitle data | SRT, VTT |
| **Metadata** | Stream information | XML, JSON |

### Session States

| State | Description | Actions |
|-------|-------------|---------|
| **INIT** | Initial state | Session creation |
| **READY** | Ready to stream | Setup complete |
| **PLAYING** | Active streaming | Media delivery |
| **PAUSED** | Temporarily stopped | Stream paused |
| **RECORDING** | Active recording | Media capture |
| **TEARDOWN** | Session ending | Cleanup |

### Response Codes

| Code | Description | Category |
|------|-------------|----------|
| **100** | Continue | Informational |
| **200** | OK | Success |
| **201** | Created | Success |
| **250** | Low on Storage Space | Success |
| **300** | Multiple Choices | Redirection |
| **301** | Moved Permanently | Redirection |
| **302** | Moved Temporarily | Redirection |
| **303** | See Other | Redirection |
| **305** | Use Proxy | Redirection |
| **400** | Bad Request | Client Error |
| **401** | Unauthorized | Client Error |
| **402** | Payment Required | Client Error |
| **403** | Forbidden | Client Error |
| **404** | Not Found | Client Error |
| **405** | Method Not Allowed | Client Error |
| **406** | Not Acceptable | Client Error |
| **407** | Proxy Authentication Required | Client Error |
| **408** | Request Timeout | Client Error |
| **410** | Gone | Client Error |
| **411** | Length Required | Client Error |
| **412** | Precondition Failed | Client Error |
| **413** | Request Entity Too Large | Client Error |
| **414** | Request-URI Too Large | Client Error |
| **415** | Unsupported Media Type | Client Error |
| **451** | Parameter Not Understood | Client Error |
| **452** | Conference Not Found | Client Error |
| **453** | Not Enough Bandwidth | Client Error |
| **454** | Session Not Found | Client Error |
| **455** | Method Not Valid in This State | Client Error |
| **456** | Header Field Not Valid for Resource | Client Error |
| **457** | Invalid Range | Client Error |
| **458** | Parameter Is Read-Only | Client Error |
| **459** | Aggregate Operation Not Allowed | Client Error |
| **460** | Only Aggregate Operation Allowed | Client Error |
| **461** | Unsupported Transport | Client Error |
| **462** | Destination Unreachable | Client Error |
| **463** | Key Management Failure | Client Error |
| **500** | Internal Server Error | Server Error |
| **501** | Not Implemented | Server Error |
| **502** | Bad Gateway | Server Error |
| **503** | Service Unavailable | Server Error |
| **504** | Gateway Timeout | Server Error |
| **505** | RTSP Version Not Supported | Server Error |
| **551** | Option Not Supported | Server Error |

### Header Fields

| Header | Description | Usage |
|--------|-------------|-------|
| **Accept** | Acceptable media types | Client preferences |
| **Accept-Encoding** | Acceptable encodings | Compression support |
| **Accept-Language** | Acceptable languages | Localization |
| **Authorization** | Authentication credentials | Security |
| **Bandwidth** | Available bandwidth | QoS control |
| **Blocksize** | Maximum block size | Data transfer |
| **Cache-Control** | Caching directives | Performance |
| **Conference** | Conference identifier | Multi-party sessions |
| **Connection** | Connection management | Transport control |
| **Content-Base** | Base URI for content | Resource location |
| **Content-Encoding** | Content encoding | Compression |
| **Content-Language** | Content language | Localization |
| **Content-Length** | Content length | Data size |
| **Content-Location** | Content location | Resource location |
| **Content-Type** | Content type | Media format |
| **CSeq** | Command sequence | Message ordering |
| **Date** | Message date | Timestamp |
| **Expires** | Expiration time | Caching |
| **From** | Request originator | Identification |
| **If-Modified-Since** | Conditional request | Caching |
| **Last-Modified** | Last modification | Caching |
| **Proxy-Authenticate** | Proxy authentication | Security |
| **Proxy-Require** | Proxy requirements | Features |
| **Public** | Supported methods | Capabilities |
| **Range** | Byte range | Partial content |
| **Referer** | Referrer URI | Navigation |
| **Require** | Required features | Capabilities |
| **Retry-After** | Retry delay | Error handling |
| **RTP-Info** | RTP information | Media control |
| **Scale** | Playback speed | Media control |
| **Session** | Session identifier | Session management |
| **Speed** | Playback speed | Media control |
| **Transport** | Transport parameters | Media delivery |
| **Unsupported** | Unsupported features | Error reporting |
| **User-Agent** | Client identifier | Identification |
| **Via** | Proxy chain | Routing |
| **WWW-Authenticate** | Authentication challenge | Security |

### Common Use Cases

| Use Case | Description | Implementation |
|----------|-------------|----------------|
| **Live Streaming** | Real-time video broadcast | RTSP + RTP |
| **Video on Demand** | Pre-recorded content delivery | RTSP + RTP |
| **IP Camera** | Security camera streaming | RTSP + RTP |
| **Video Conferencing** | Multi-party communication | RTSP + RTP |
| **Media Server** | Centralized content delivery | RTSP + RTP |
| **Mobile Streaming** | Mobile device streaming | RTSP + RTP |
