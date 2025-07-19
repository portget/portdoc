# EtherNet/IP Protocol

## Table of Contents
1. [Overview](#overview)
2. [Quick Link](#quick-link)
3. [Key Features](#key-features)
4. [Communication Methods](#communication-methods)
5. [Message Types](#message-types)
6. [Service Codes](#service-codes)
7. [Object Model](#object-model)
8. [Data Types](#data-types)
9. [Error Codes](#error-codes)

## Overview

EtherNet/IP (Ethernet Industrial Protocol) is a standard ethernet communication protocol for industrial automation. It is based on CIP (Common Industrial Protocol) and supports real-time data exchange in manufacturing environments.

## **Quick link** {#quick-link}

**Related Protocols:** [SECS/GEM](secs.md) | [Modbus](modbus.md) | [OPC UA](opcua.md) | [RTSP](rtsp.md)

### Key Features

- **Standard Ethernet**: Utilizes standard TCP/IP and ethernet technologies
- **Real-time Communication**: Real-time data exchange based on UDP
- **Scalability**: Supports large-scale network configurations
- **Interoperability**: Compatibility between various vendor equipment
- **Security**: Provides industrial security features

### Communication Methods

| Method | Description | Protocol | Purpose |
|--------|-------------|----------|---------|
| **Explicit Messaging** | Client-server communication | TCP | Configuration, diagnostics, non-real-time data |
| **Implicit Messaging** | Real-time data exchange | UDP | Real-time control data |
| **I/O Messaging** | I/O data exchange | UDP | Sensor/actuator data |

### Message Types

| Type | Description | Characteristics |
|------|-------------|----------------|
| **Request** | Request from client to server | Explicit messaging |
| **Response** | Response from server to client | Explicit messaging |
| **I/O Data** | Real-time I/O data | Implicit messaging |
| **Heartbeat** | Connection status check | Periodic messaging |

### Service Codes

| Code | Description | Purpose |
|------|-------------|---------|
| **0x01** | Get_Attribute_Single | Read single attribute |
| **0x02** | Set_Attribute_Single | Write single attribute |
| **0x03** | Get_Attribute_All | Read all attributes |
| **0x04** | Set_Attribute_All | Write all attributes |
| **0x05** | Reset | Device reset |
| **0x06** | Start | Device start |
| **0x07** | Stop | Device stop |
| **0x08** | Create | Object creation |
| **0x09** | Delete | Object deletion |
| **0x0A** | Multiple_Service_Packet | Multiple service packet |

### Object Model

| Object | Description | Function |
|--------|-------------|----------|
| **Identity Object** | Device identification information | Provides device information |
| **Message Router Object** | Message routing | Message processing |
| **Assembly Object** | Data assembly | Data packaging |
| **Connection Object** | Connection management | Communication connection management |
| **TCP/IP Object** | TCP/IP configuration | Network configuration |

### Data Types

| Type | Description | Size |
|------|-------------|------|
| **BOOL** | Boolean value | 1 bit |
| **SINT** | 8-bit integer | 1 byte |
| **INT** | 16-bit integer | 2 bytes |
| **DINT** | 32-bit integer | 4 bytes |
| **REAL** | 32-bit real number | 4 bytes |
| **STRING** | String | Variable length |
| **ARRAY** | Array | Variable length |

### Error Codes

| Code | Description |
|------|-------------|
| **0x00** | Success |
| **0x01** | Invalid Command |
| **0x02** | Insufficient Memory |
| **0x03** | Incorrect Data |
| **0x04** | Invalid Attribute Value |
| **0x05** | Invalid Attribute |
| **0x06** | Service Not Supported |
| **0x07** | Invalid Parameter |
| **0x08** | Lost Connection |
| **0x09** | Invalid Segment |
| **0x0A** | Invalid Service Request |
