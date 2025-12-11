# Modbus Protocol

## Table of Contents
1. [Overview](#overview)
2. [Quick Link](#quick-link)
3. [Key Features](#key-features)
4. [Supported Functions](#supported-functions)
5. [Communication Methods](#communication-methods)
6. [Data Types](#data-types)
7. [Error Codes](#error-codes)

## Overview

Modbus is a widely used communication protocol in industrial automation. It operates on a master-slave architecture and supports data exchange between various industrial equipment.

## **Quick link** {#quick-link}

**Related Protocols:** [SECS/GEM](secs.md) | [EtherNet/IP](ethernetip.md) | [OPC UA](opcua.md) | [RTSP](rtsp.md)

### Key Features

- **Simplicity**: Simple and easy-to-understand protocol structure
- **Openness**: Open standard supported by various vendors
- **Reliability**: Error detection and recovery capabilities
- **Scalability**: Usable in various network environments

### Supported Functions

| Function | Description |
|----------|-------------|
| **Read Coils** | Read digital output status |
| **Read Discrete Inputs** | Read digital input status |
| **Read Holding Registers** | Read holding registers |
| **Read Input Registers** | Read input registers |
| **Write Single Coil** | Write single coil |
| **Write Single Register** | Write single register |
| **Write Multiple Coils** | Write multiple coils |
| **Write Multiple Registers** | Write multiple registers |

### Communication Methods

| Method | Description | Characteristics |
|--------|-------------|----------------|
| **Modbus RTU** | Serial communication | Binary encoding, high efficiency |
| **Modbus ASCII** | Serial communication | ASCII encoding, easy debugging |
| **Modbus TCP** | Ethernet communication | TCP/IP based, high-speed communication |

### Data Types

| Type | Description | Range |
|------|-------------|-------|
| **Coil** | 1-bit read/write | 0 or 1 |
| **Discrete Input** | 1-bit read-only | 0 or 1 |
| **Holding Register** | 16-bit read/write | 0-65535 |
| **Input Register** | 16-bit read-only | 0-65535 |

### Error Codes

| Code | Description |
|------|-------------|
| **01** | Illegal Function |
| **02** | Illegal Data Address |
| **03** | Illegal Data Value |
| **04** | Slave Device Failure |
| **05** | Acknowledge |
| **06** | Slave Device Busy |
| **08** | Memory Parity Error |
| **0A** | Gateway Path Unavailable |
| **0B** | Gateway Target Device Failed to Respond |
