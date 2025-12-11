# OPC UA Protocol

## Table of Contents
1. [Overview](#overview)
2. [Quick Link](#quick-link)
3. [Key Features](#key-features)
4. [Communication Models](#communication-models)
5. [Service Sets](#service-sets)
6. [Node Classes](#node-classes)
7. [Built-in Data Types](#built-in-data-types)
8. [Security Features](#security-features)
9. [Message Security Modes](#message-security-modes)
10. [User Token Types](#user-token-types)
11. [Error Codes](#error-codes)

## Overview

OPC UA (OPC Unified Architecture) is a machine-to-machine communication protocol for industrial automation. It is designed to provide a secure and reliable way to exchange data between industrial systems and devices.

## **Quick link** {#quick-link}

**Related Protocols:** [SECS/GEM](secs.md) | [Modbus](modbus.md) | [EtherNet/IP](ethernetip.md) | [RTSP](rtsp.md)

### Key Features

- **Platform Independence**: Works across different operating systems and hardware
- **Security**: Built-in security features including encryption and authentication
- **Scalability**: Supports both small and large-scale deployments
- **Extensibility**: Flexible information model that can be extended
- **Reliability**: Robust error handling and recovery mechanisms
- **Interoperability**: Standard-based protocol ensuring vendor independence

## Communication Models

| Model | Description | Use Case |
|-------|-------------|----------|
| **Client-Server** | Traditional request-response model | Configuration, monitoring, data access |
| **Pub-Sub** | Publish-subscribe model | Real-time data distribution |
| **Discovery** | Service discovery and registration | Network topology discovery |

## Service Sets

| Service Set | Description | Functions |
|-------------|-------------|-----------|
| **Discovery** | Find and connect to servers | GetEndpoints, FindServers |
| **Session** | Manage client-server sessions | CreateSession, ActivateSession |
| **Node Management** | Manage address space nodes | AddNodes, DeleteNodes |
| **View** | Browse address space | Browse, BrowseNext |
| **Query** | Query data from address space | QueryFirst, QueryNext |
| **Attribute** | Read/write node attributes | Read, Write |
| **Method** | Call methods on nodes | Call |
| **Subscription** | Manage subscriptions | CreateSubscription, DeleteSubscriptions |
| **MonitoredItem** | Monitor data changes | CreateMonitoredItems, DeleteMonitoredItems |
| **Publish** | Publish data changes | Publish |

## Node Classes

| Node Class | Description | Purpose |
|------------|-------------|---------|
| **Object** | Represents real-world objects | Physical devices, systems |
| **Variable** | Contains data values | Process values, parameters |
| **Method** | Defines callable functions | Commands, operations |
| **ObjectType** | Defines object structure | Type definitions |
| **VariableType** | Defines variable structure | Data type definitions |
| **ReferenceType** | Defines relationships | Node relationships |
| **DataType** | Defines data structures | Custom data types |
| **View** | Organizes address space | Logical grouping |

## Built-in Data Types

| Type | Description | Size |
|------|-------------|------|
| **Boolean** | True/false value | 1 bit |
| **SByte** | 8-bit signed integer | 1 byte |
| **Byte** | 8-bit unsigned integer | 1 byte |
| **Int16** | 16-bit signed integer | 2 bytes |
| **UInt16** | 16-bit unsigned integer | 2 bytes |
| **Int32** | 32-bit signed integer | 4 bytes |
| **UInt32** | 32-bit unsigned integer | 4 bytes |
| **Int64** | 64-bit signed integer | 8 bytes |
| **UInt64** | 64-bit unsigned integer | 8 bytes |
| **Float** | 32-bit floating point | 4 bytes |
| **Double** | 64-bit floating point | 8 bytes |
| **String** | Unicode string | Variable |
| **DateTime** | Date and time | 8 bytes |
| **Guid** | Globally unique identifier | 16 bytes |
| **ByteString** | Byte array | Variable |

## Security Features

| Feature | Description | Purpose |
|---------|-------------|---------|
| **Transport Security** | TLS/SSL encryption | Secure communication |
| **Application Authentication** | Certificate-based authentication | Server/client verification |
| **User Authentication** | Username/password, certificates | User identity verification |
| **Authorization** | Access control policies | Resource access control |
| **Audit Logging** | Security event logging | Compliance and monitoring |

## Message Security Modes

| Mode | Description | Security Level |
|------|-------------|----------------|
| **None** | No security | None |
| **Sign** | Message signing only | Integrity |
| **SignAndEncrypt** | Signing and encryption | Confidentiality and integrity |

## User Token Types

| Type | Description | Authentication Method |
|------|-------------|----------------------|
| **Anonymous** | No authentication | None |
| **Username** | Username/password | Basic authentication |
| **Certificate** | X.509 certificate | Certificate-based |
| **IssuedToken** | Custom token | Custom authentication |

## Error Codes

| Code | Description |
|------|-------------|
| **0x00000000** | Good |
| **0x80010000** | BadUnexpectedError |
| **0x80020000** | BadInternalError |
| **0x80030000** | BadOutOfMemory |
| **0x80040000** | BadResourceUnavailable |
| **0x80050000** | BadCommunicationError |
| **0x80060000** | BadEncodingError |
| **0x80070000** | BadDecodingError |
| **0x80080000** | BadEncodingLimitsExceeded |
| **0x80090000** | BadRequestTooLarge |
| **0x800A0000** | BadResponseTooLarge |
| **0x800B0000** | BadUnknownResponse |
| **0x800C0000** | BadTimeout |
| **0x800D0000** | BadServiceUnsupported |
| **0x800E0000** | BadShutdown |
| **0x800F0000** | BadServerNotConnected |
| **0x80100000** | BadServerHalted |
| **0x80110000** | BadNothingToDo |
| **0x80120000** | BadTooManyOperations |
| **0x80130000** | BadTooManyMonitoredItems |
| **0x80140000** | BadDataTypeIdUnknown |
| **0x80150000** | BadCertificateInvalid |
| **0x80160000** | BadSecurityChecksFailed |
| **0x80170000** | BadCertificatePolicyCheckFailed |
| **0x80180000** | BadCertificateTimeInvalid |
| **0x80190000** | BadCertificateRevoked |
| **0x801A0000** | BadCertificateIssuerTimeInvalid |
| **0x801B0000** | BadCertificateHostNameInvalid |
| **0x801C0000** | BadCertificateUriInvalid |
| **0x801D0000** | BadCertificateUseNotAllowed |
| **0x801E0000** | BadCertificateUntrusted |
| **0x801F0000** | BadCertificateRevocationUnknown |
| **0x80200000** | BadCertificateIssuerRevoked |
| **0x80210000** | BadCertificateIssuerRevocationUnknown |
| **0x80220000** | BadCertificateRevokedOrRevoked |
| **0x80230000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80240000** | BadCertificateRevokedOrRevoked |
| **0x80250000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80260000** | BadCertificateRevokedOrRevoked |
| **0x80270000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80280000** | BadCertificateRevokedOrRevoked |
| **0x80290000** | BadCertificateIssuerRevokedOrRevoked |
| **0x802A0000** | BadCertificateRevokedOrRevoked |
| **0x802B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x802C0000** | BadCertificateRevokedOrRevoked |
| **0x802D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x802E0000** | BadCertificateRevokedOrRevoked |
| **0x802F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80300000** | BadCertificateRevokedOrRevoked |
| **0x80310000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80320000** | BadCertificateRevokedOrRevoked |
| **0x80330000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80340000** | BadCertificateRevokedOrRevoked |
| **0x80350000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80360000** | BadCertificateRevokedOrRevoked |
| **0x80370000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80380000** | BadCertificateRevokedOrRevoked |
| **0x80390000** | BadCertificateIssuerRevokedOrRevoked |
| **0x803A0000** | BadCertificateRevokedOrRevoked |
| **0x803B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x803C0000** | BadCertificateRevokedOrRevoked |
| **0x803D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x803E0000** | BadCertificateRevokedOrRevoked |
| **0x803F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80400000** | BadCertificateRevokedOrRevoked |
| **0x80410000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80420000** | BadCertificateRevokedOrRevoked |
| **0x80430000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80440000** | BadCertificateRevokedOrRevoked |
| **0x80450000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80460000** | BadCertificateRevokedOrRevoked |
| **0x80470000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80480000** | BadCertificateRevokedOrRevoked |
| **0x80490000** | BadCertificateIssuerRevokedOrRevoked |
| **0x804A0000** | BadCertificateRevokedOrRevoked |
| **0x804B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x804C0000** | BadCertificateRevokedOrRevoked |
| **0x804D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x804E0000** | BadCertificateRevokedOrRevoked |
| **0x804F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80500000** | BadCertificateRevokedOrRevoked |
| **0x80510000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80520000** | BadCertificateRevokedOrRevoked |
| **0x80530000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80540000** | BadCertificateRevokedOrRevoked |
| **0x80550000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80560000** | BadCertificateRevokedOrRevoked |
| **0x80570000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80580000** | BadCertificateRevokedOrRevoked |
| **0x80590000** | BadCertificateIssuerRevokedOrRevoked |
| **0x805A0000** | BadCertificateRevokedOrRevoked |
| **0x805B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x805C0000** | BadCertificateRevokedOrRevoked |
| **0x805D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x805E0000** | BadCertificateRevokedOrRevoked |
| **0x805F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80600000** | BadCertificateRevokedOrRevoked |
| **0x80610000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80620000** | BadCertificateRevokedOrRevoked |
| **0x80630000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80640000** | BadCertificateRevokedOrRevoked |
| **0x80650000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80660000** | BadCertificateRevokedOrRevoked |
| **0x80670000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80680000** | BadCertificateRevokedOrRevoked |
| **0x80690000** | BadCertificateIssuerRevokedOrRevoked |
| **0x806A0000** | BadCertificateRevokedOrRevoked |
| **0x806B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x806C0000** | BadCertificateRevokedOrRevoked |
| **0x806D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x806E0000** | BadCertificateRevokedOrRevoked |
| **0x806F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80700000** | BadCertificateRevokedOrRevoked |
| **0x80710000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80720000** | BadCertificateRevokedOrRevoked |
| **0x80730000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80740000** | BadCertificateRevokedOrRevoked |
| **0x80750000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80760000** | BadCertificateRevokedOrRevoked |
| **0x80770000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80780000** | BadCertificateRevokedOrRevoked |
| **0x80790000** | BadCertificateIssuerRevokedOrRevoked |
| **0x807A0000** | BadCertificateRevokedOrRevoked |
| **0x807B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x807C0000** | BadCertificateRevokedOrRevoked |
| **0x807D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x807E0000** | BadCertificateRevokedOrRevoked |
| **0x807F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80800000** | BadCertificateRevokedOrRevoked |
| **0x80810000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80820000** | BadCertificateRevokedOrRevoked |
| **0x80830000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80840000** | BadCertificateRevokedOrRevoked |
| **0x80850000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80860000** | BadCertificateRevokedOrRevoked |
| **0x80870000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80880000** | BadCertificateRevokedOrRevoked |
| **0x80890000** | BadCertificateIssuerRevokedOrRevoked |
| **0x808A0000** | BadCertificateRevokedOrRevoked |
| **0x808B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x808C0000** | BadCertificateRevokedOrRevoked |
| **0x808D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x808E0000** | BadCertificateRevokedOrRevoked |
| **0x808F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80900000** | BadCertificateRevokedOrRevoked |
| **0x80910000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80920000** | BadCertificateRevokedOrRevoked |
| **0x80930000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80940000** | BadCertificateRevokedOrRevoked |
| **0x80950000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80960000** | BadCertificateRevokedOrRevoked |
| **0x80970000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80980000** | BadCertificateRevokedOrRevoked |
| **0x80990000** | BadCertificateIssuerRevokedOrRevoked |
| **0x809A0000** | BadCertificateRevokedOrRevoked |
| **0x809B0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x809C0000** | BadCertificateRevokedOrRevoked |
| **0x809D0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x809E0000** | BadCertificateRevokedOrRevoked |
| **0x809F0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80A00000** | BadCertificateRevokedOrRevoked |
| **0x80A10000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80A20000** | BadCertificateRevokedOrRevoked |
| **0x80A30000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80A40000** | BadCertificateRevokedOrRevoked |
| **0x80A50000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80A60000** | BadCertificateRevokedOrRevoked |
| **0x80A70000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80A80000** | BadCertificateRevokedOrRevoked |
| **0x80A90000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80AA0000** | BadCertificateRevokedOrRevoked |
| **0x80AB0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80AC0000** | BadCertificateRevokedOrRevoked |
| **0x80AD0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80AE0000** | BadCertificateRevokedOrRevoked |
| **0x80AF0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80B00000** | BadCertificateRevokedOrRevoked |
| **0x80B10000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80B20000** | BadCertificateRevokedOrRevoked |
| **0x80B30000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80B40000** | BadCertificateRevokedOrRevoked |
| **0x80B50000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80B60000** | BadCertificateRevokedOrRevoked |
| **0x80B70000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80B80000** | BadCertificateRevokedOrRevoked |
| **0x80B90000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80BA0000** | BadCertificateRevokedOrRevoked |
| **0x80BB0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80BC0000** | BadCertificateRevokedOrRevoked |
| **0x80BD0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80BE0000** | BadCertificateRevokedOrRevoked |
| **0x80BF0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80C00000** | BadCertificateRevokedOrRevoked |
| **0x80C10000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80C20000** | BadCertificateRevokedOrRevoked |
| **0x80C30000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80C40000** | BadCertificateRevokedOrRevoked |
| **0x80C50000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80C60000** | BadCertificateRevokedOrRevoked |
| **0x80C70000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80C80000** | BadCertificateRevokedOrRevoked |
| **0x80C90000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80CA0000** | BadCertificateRevokedOrRevoked |
| **0x80CB0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80CC0000** | BadCertificateRevokedOrRevoked |
| **0x80CD0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80CE0000** | BadCertificateRevokedOrRevoked |
| **0x80CF0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80D00000** | BadCertificateRevokedOrRevoked |
| **0x80D10000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80D20000** | BadCertificateRevokedOrRevoked |
| **0x80D30000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80D40000** | BadCertificateRevokedOrRevoked |
| **0x80D50000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80D60000** | BadCertificateRevokedOrRevoked |
| **0x80D70000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80D80000** | BadCertificateRevokedOrRevoked |
| **0x80D90000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80DA0000** | BadCertificateRevokedOrRevoked |
| **0x80DB0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80DC0000** | BadCertificateRevokedOrRevoked |
| **0x80DD0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80DE0000** | BadCertificateRevokedOrRevoked |
| **0x80DF0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80E00000** | BadCertificateRevokedOrRevoked |
| **0x80E10000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80E20000** | BadCertificateRevokedOrRevoked |
| **0x80E30000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80E40000** | BadCertificateRevokedOrRevoked |
| **0x80E50000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80E60000** | BadCertificateRevokedOrRevoked |
| **0x80E70000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80E80000** | BadCertificateRevokedOrRevoked |
| **0x80E90000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80EA0000** | BadCertificateRevokedOrRevoked |
| **0x80EB0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80EC0000** | BadCertificateRevokedOrRevoked |
| **0x80ED0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80EE0000** | BadCertificateRevokedOrRevoked |
| **0x80EF0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80F00000** | BadCertificateRevokedOrRevoked |
| **0x80F10000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80F20000** | BadCertificateRevokedOrRevoked |
| **0x80F30000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80F40000** | BadCertificateRevokedOrRevoked |
| **0x80F50000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80F60000** | BadCertificateRevokedOrRevoked |
| **0x80F70000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80F80000** | BadCertificateRevokedOrRevoked |
| **0x80F90000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80FA0000** | BadCertificateRevokedOrRevoked |
| **0x80FB0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80FC0000** | BadCertificateRevokedOrRevoked |
| **0x80FD0000** | BadCertificateIssuerRevokedOrRevoked |
| **0x80FE0000** | BadCertificateRevokedOrRevoked |
| **0x80FF0000** | BadCertificateIssuerRevokedOrRevoked |
