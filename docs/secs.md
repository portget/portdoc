# SECS Message Format Specification

## Table of Contents
1. [Overview](#overview) 
2. [SECS-II Data Format](#secs-ii-data-format)
3. [Stream Definitions](#stream-definitions)
4. [Message Categories](#message-categories)
5. [Common Message Examples](#common-message-examples)
6. [Implementation Guidelines](#implementation-guidelines)

## Overview

**SECS/GEM** (Semiconductor Equipment Communications Standard/Generic Equipment Model) is a comprehensive communication protocol suite specifically designed for semiconductor manufacturing equipment. Developed by SEMI (Semiconductor Equipment and Materials International), it provides standardized methods for equipment communication, control, and data collection in semiconductor fabrication facilities.

### SECS-I (Physical Layer)
- **Purpose**: Defines the physical communication interface
- **Connection**: Traditional RS-232C serial communication
- **Characteristics**: Point-to-point connection between equipment and host, slower data transmission rates, primarily used in legacy systems

### SECS-II (Message Layer)
- **Purpose**: Defines message structure and data formatting
- **Data Types**: Supports various data formats including ASCII text, binary data, integers (1, 2, 4, 8 bytes, signed/unsigned), floating point numbers, and lists (nested data structures)
- **Message Structure**: Hierarchical data organization using lists and items

### HSMS (High-Speed Message Services)
- **Purpose**: Modern replacement for SECS-I physical layer
- **Connection**: TCP/IP-based Ethernet communication
- **Advantages**: Higher data transmission speeds, support for multiple simultaneous connections, better network integration capabilities, enhanced reliability and error handling

### GEM (Generic Equipment Model)
- **Purpose**: Defines standard behaviors and capabilities for equipment
- **Functionality**: Establishes common equipment states, events, and control mechanisms

## Core Communication Concepts

SECS defines a standardized communication protocol for semiconductor manufacturing equipment, enabling consistent equipment integration and automation through stream and function organization, where streams (S1-S127) categorize message types by functionality and functions (F1-F255) define specific operations within each stream.

## Stream Definitions

### Stream 1: Equipment Status
**Purpose**: Equipment state information and basic communication

| Message | Direction | Description |
|---------|-----------|-------------|
| [S1F1](#s1f1---are-you-there-request)    | → Equipment | Are You There (Request) |
| [S1F2](#s1f2---are-you-there-response)    | ← Equipment | Are You There (Response) |
| [S1F3](#s1f3---selected-equipment-status-request)    | → Equipment | Selected Equipment Status Request |
| [S1F4](#s1f4---selected-equipment-status-response)    | ← Equipment | Selected Equipment Status Response |
| [S1F11](#s1f11---status-variable-namelist-request)   | → Equipment | Status Variable Namelist Request |
| [S1F12](#s1f12---status-variable-namelist-response)   | ← Equipment | Status Variable Namelist Response |
| [S1F13](#s1f13---establish-communications-request)   | → Equipment | Establish Communications Request |
| [S1F14](#s1f14---establish-communications-response)   | ← Equipment | Establish Communications Response |
| [S1F15](#s1f15---request-offline)   | → Equipment | Request Offline |
| [S1F16](#s1f16---offline-acknowledge)   | ← Equipment | Offline Acknowledge |
| [S1F17](#s1f17---request-online)   | → Equipment | Request Online |
| [S1F18](#s1f18---online-acknowledge)   | ← Equipment | Online Acknowledge |
| [S1F19](#s1f19---recipe-name-request)   | → Equipment | Recipe Name Request |
| [S1F20](#s1f20---recipe-name-response)   | ← Equipment | Recipe Name Response |
| [S1F21](#s1f21---recipe-body-request)   | → Equipment | Recipe Body Request |
| [S1F22](#s1f22---recipe-body-response)   | ← Equipment | Recipe Body Response |
| [S1F23](#s1f23---process-program-request)   | → Equipment | Process Program Request |
| [S1F24](#s1f24---process-program-response)   | ← Equipment | Process Program Response |

#### **S1F1 - Are You There (Request)** {#s1f1---are-you-there-request}
```
Format: <none> (empty data)
```

#### **S1F2 - Are You There (Response)** {#s1f2---are-you-there-response}
```
Format: <none> (empty data) or
{L:0} (empty list)
```

#### **S1F3 - Selected Equipment Status Request** {#s1f3---selected-equipment-status-request}
```
Format: 
{L:n
  SVID_1
  SVID_2
  ...
  SVID_n
}

Where:
- SVID: Status Variable ID (U1, U2, U4, or A)
```

#### **S1F4 - Selected Equipment Status Response** {#s1f4---selected-equipment-status-response}
```
Format:
{L:n
  SV_1
  SV_2
  ...
  SV_n
}

Where:
- SV: Status Variable value (any format)
```

#### **S1F11 - Status Variable Namelist Request** {#s1f11---status-variable-namelist-request}
```
Format: <none> (empty data)
```

#### **S1F12 - Status Variable Namelist Response** {#s1f12---status-variable-namelist-response}
```
Format:
{L:n
  {L:3
    SVID
    SVNAME
    UNITS
  }
}

Where:
- SVID: Status Variable ID (U1, U2, U4, or A)
- SVNAME: Status Variable Name (A)
- UNITS: Units of Measure (A)
```

#### **S1F13 - Establish Communications Request** {#s1f13---establish-communications-request}
```
Format:
{L:2
  MDLN
  SOFTREV
}

Where:
- MDLN: Model Number (A[20])
- SOFTREV: Software Revision (A[20])

Or simply: <L:0> (empty list)
```

#### **S1F14 - Establish Communications Response** {#s1f14---establish-communications-response}
```
Format:
{L:2
  COMMACK
  {L:2
    MDLN
    SOFTREV
  }
}

Where:
- COMMACK: Communication Acknowledge (B[1])
  - 0: Accepted
  - 1: Denied, Try Again
  - 2: Denied, Permission Not Granted
- MDLN: Model Number (A[20])
- SOFTREV: Software Revision (A[20])
```

#### **S1F15 - Request Offline** {#s1f15---request-offline}
```
Format: <none> (empty data)
```

#### **S1F16 - Offline Acknowledge** {#s1f16---offline-acknowledge}
```
Format:
OFLACK

Where:
- OFLACK: Offline Acknowledge (B[1])
  - 0: Offline Accepted
  - 1: Offline Not Allowed
```

#### **S1F17 - Request Online** {#s1f17---request-online}
```
Format: <none> (empty data)
```

#### **S1F18 - Online Acknowledge** {#s1f18---online-acknowledge}
```
Format:
ONLACK

Where:
- ONLACK: Online Acknowledge (B[1])
  - 0: Online Accepted
  - 1: Online Not Allowed
```

#### **S1F19 - Recipe Name Request** {#s1f19---recipe-name-request}
```
Format: <none> (empty data)
```

#### **S1F20 - Recipe Name Response** {#s1f20---recipe-name-response}
```
Format:
{L:n
  PPID_1
  PPID_2
  ...
  PPID_n
}

Where:
- PPID: Process Program ID (A)
```

#### **S1F21 - Recipe Body Request** {#s1f21---recipe-body-request}
```
Format:
PPID

Where:
- PPID: Process Program ID (A)
```

#### **S1F22 - Recipe Body Response** {#s1f22---recipe-body-response}
```
Format:
{L:2
  PPID
  PPBODY
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
```

#### **S1F23 - Process Program Request** {#s1f23---process-program-request}
```
Format:
{L:n
  PPID_1
  PPID_2
  ...
  PPID_n
}

Where:
- PPID: Process Program ID (A)
```

#### **S1F24 - Process Program Response** {#s1f24---process-program-response}
```
Format:
{L:n
  {L:3
    PPID
    PPBODY
    PPSTATUS
  }
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
- PPSTATUS: Process Program Status (U1)
  - 0: Available
  - 1: Not Available
  - 2: In Use
  - 3: Error
```

### Stream 2: Equipment Control and Diagnostics
**Purpose**: Equipment configuration and diagnostic operations

| Message | Direction | Description |
|---------|-----------|-------------|
| [S2F1](#s2f1---equipment-status-request)    | → Equipment | Equipment Status Request |
| [S2F2](#s2f2---equipment-status-response)    | ← Equipment | Equipment Status Response |
| [S2F3](#s2f3---status-variable-value-request)    | → Equipment | Status Variable Value Request |
| [S2F4](#s2f4---status-variable-value-response)    | ← Equipment | Status Variable Value Response |
| [S2F5](#s2f5---send-equipment-status)    | ← Equipment | Send Equipment Status |
| [S2F6](#s2f6---send-equipment-status-acknowledge)    | → Equipment | Send Equipment Status Acknowledge |
| [S2F7](#s2f7---load-port-status-request)    | → Equipment | Load Port Status Request |
| [S2F8](#s2f8---load-port-status-response)    | ← Equipment | Load Port Status Response |
| [S2F9](#s2f9---equipment-status-multi-block-inquire)    | → Equipment | Equipment Status Multi-Block Inquire |
| [S2F10](#s2f10---equipment-status-multi-block-grant)   | ← Equipment | Equipment Status Multi-Block Grant |
| [S2F11](#s2f11---equipment-status-multi-block)   | ← Equipment | Equipment Status Multi-Block |
| [S2F12](#s2f12---equipment-status-multi-block-acknowledge)   | → Equipment | Equipment Status Multi-Block Acknowledge |
| [S2F13](#s2f13---equipment-constant-request)   | → Equipment | Equipment Constant Request |
| [S2F14](#s2f14---equipment-constant-response)   | ← Equipment | Equipment Constant Response |
| [S2F15](#s2f15---new-equipment-constant-send)   | → Equipment | New Equipment Constant Send |
| [S2F16](#s2f16---new-equipment-constant-acknowledge)   | ← Equipment | New Equipment Constant Acknowledge |
| [S2F17](#s2f17---date-and-time-request)   | → Equipment | Date and Time Request |
| [S2F18](#s2f18---date-and-time-response)   | ← Equipment | Date and Time Response |
| [S2F19](#s2f19---recipe-body-request)   | → Equipment | Recipe Body Request |
| [S2F20](#s2f20---recipe-body-response)   | ← Equipment | Recipe Body Response |
| [S2F21](#s2f21---recipe-body-send)   | → Equipment | Recipe Body Send |
| [S2F22](#s2f22---recipe-body-acknowledge)   | ← Equipment | Recipe Body Acknowledge |
| [S2F23](#s2f23---trace-initialize-send)   | → Equipment | Trace Initialize Send |
| [S2F24](#s2f24---trace-initialize-acknowledge)   | ← Equipment | Trace Initialize Acknowledge |
| [S2F25](#s2f25---loopback-diagnostic-request)   | → Equipment | Loopback Diagnostic Request |
| [S2F26](#s2f26---loopback-diagnostic-response)   | ← Equipment | Loopback Diagnostic Response |
| [S2F27](#s2f27---initiate-processing-request)   | → Equipment | Initiate Processing Request |
| [S2F28](#s2f28---initiate-processing-acknowledge)   | ← Equipment | Initiate Processing Acknowledge |
| [S2F29](#s2f29---equipment-constant-namelist-request)   | → Equipment | Equipment Constant Namelist Request |
| [S2F30](#s2f30---equipment-constant-namelist-response)   | ← Equipment | Equipment Constant Namelist Response |
| [S2F31](#s2f31---date-and-time-set-request)   | → Equipment | Date and Time Set Request |
| [S2F32](#s2f32---date-and-time-set-response)   | ← Equipment | Date and Time Set Response |
| [S2F33](#s2f33---define-report)   | → Equipment | Define Report |
| [S2F34](#s2f34---define-report-acknowledge)   | ← Equipment | Define Report Acknowledge |
| [S2F35](#s2f35---link-event-report)   | → Equipment | Link Event Report |
| [S2F36](#s2f36---link-event-report-acknowledge)   | ← Equipment | Link Event Report Acknowledge |
| [S2F37](#s2f37---enabledisable-event-report)   | → Equipment | Enable/Disable Event Report |
| [S2F38](#s2f38---enabledisable-event-report-acknowledge)   | ← Equipment | Enable/Disable Event Report Acknowledge |
| [S2F39](#s2f39---status-variable-namelist-request)   | → Equipment | Status Variable Namelist Request |
| [S2F40](#s2f40---status-variable-namelist-response)   | ← Equipment | Status Variable Namelist Response |
| [S2F41](#s2f41---host-command-send)   | → Equipment | Host Command Send |
| [S2F42](#s2f42---host-command-acknowledge)   | ← Equipment | Host Command Acknowledge |
| [S2F43](#s2f43---reset-spooling-streams-and-functions)   | → Equipment | Reset Spooling Streams and Functions |
| [S2F44](#s2f44---reset-spooling-acknowledge)   | ← Equipment | Reset Spooling Acknowledge |
| [S2F45](#s2f45---define-variable-limit-attributes)   | → Equipment | Define Variable Limit Attributes |
| [S2F46](#s2f46---define-variable-limit-attributes-acknowledge)   | ← Equipment | Define Variable Limit Attributes Acknowledge |
| [S2F47](#s2f47---variable-limit-attribute-request)   | → Equipment | Variable Limit Attribute Request |
| [S2F48](#s2f48---variable-limit-attribute-response)   | ← Equipment | Variable Limit Attribute Response |
| [S2F49](#s2f49---enhanced-remote-command)   | → Equipment | Enhanced Remote Command |
| [S2F50](#s2f50---enhanced-remote-command-acknowledge)   | ← Equipment | Enhanced Remote Command Acknowledge |
| [S2F51](#s2f51---automated-substrate-mapping)   | → Equipment | Automated Substrate Mapping |
| [S2F52](#s2f52---automated-substrate-mapping-acknowledge)   | ← Equipment | Automated Substrate Mapping Acknowledge |
| [S2F53](#s2f53---enhanced-define-report)   | → Equipment | Enhanced Define Report |
| [S2F54](#s2f54---enhanced-define-report-acknowledge)   | ← Equipment | Enhanced Define Report Acknowledge |
| [S2F55](#s2f55---enhanced-link-event-report)   | → Equipment | Enhanced Link Event Report |
| [S2F56](#s2f56---enhanced-link-event-report-acknowledge)   | ← Equipment | Enhanced Link Event Report Acknowledge |
| [S2F57](#s2f57---enhanced-enabledisable-event-report)   | → Equipment | Enhanced Enable/Disable Event Report |
| [S2F58](#s2f58---enhanced-enabledisable-event-report-acknowledge)   | ← Equipment | Enhanced Enable/Disable Event Report Acknowledge |
| [S2F59](#s2f59---formatted-process-program-send)   | → Equipment | Formatted Process Program Send |
| [S2F60](#s2f60---formatted-process-program-acknowledge)   | ← Equipment | Formatted Process Program Acknowledge |
| [S2F61](#s2f61---formatted-process-program-request)   | → Equipment | Formatted Process Program Request |
| [S2F62](#s2f62---formatted-process-program-response)   | ← Equipment | Formatted Process Program Response |
| [S2F63](#s2f63---define-object)   | → Equipment | Define Object |
| [S2F64](#s2f64---define-object-acknowledge)   | ← Equipment | Define Object Acknowledge |

#### **S2F1 - Equipment Status Request** {#s2f1---equipment-status-request}
```
Format:
{L:n
  SVID_1
  SVID_2
  ...
  SVID_n
}

Where:
- SVID: Status Variable ID (U1, U2, U4, or A)
```

#### **S2F2 - Equipment Status Response** {#s2f2---equipment-status-response}
```
Format:
{L:n
  SV_1
  SV_2
  ...
  SV_n
}

Where:
- SV: Status Variable value (any format)
```

#### **S2F13 - Equipment Constant Request** {#s2f13---equipment-constant-request}
```
Format:
{L:n
  ECID_1
  ECID_2
  ...
  ECID_n
}

Where:
- ECID: Equipment Constant ID (U1, U2, U4, or A)
```

#### **S2F14 - Equipment Constant Response** {#s2f14---equipment-constant-response}
```
Format:
{L:n
  ECV_1
  ECV_2
  ...
  ECV_n
}

Where:
- ECV: Equipment Constant Value (any format)
```

#### **S2F15 - New Equipment Constant Send** {#s2f15---new-equipment-constant-send}
```
Format:
{L:n
  {L:2
    ECID
    ECV
  }
}

Where:
- ECID: Equipment Constant ID (U1, U2, U4, or A)
- ECV: Equipment Constant Value (any format)
```

#### **S2F16 - New Equipment Constant Acknowledge** {#s2f16---new-equipment-constant-acknowledge}
```
Format:
EAC

Where:
- EAC: Equipment Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Denied, At least one constant does not exist
  - 2: Denied, Busy
  - 3: Denied, At least one constant out of range
```

#### **S2F17 - Date and Time Request** {#s2f17---date-and-time-request}
```
Format: <none> (empty data)
```

#### **S2F18 - Date and Time Response** {#s2f18---date-and-time-response}
```
Format:
TIME

Where:
- TIME: Current Time (A[16]) format: "YYMMDDhhmmss[cc]"
  - YY: Year (2 digits)
  - MM: Month (01-12)
  - DD: Day (01-31)
  - hh: Hour (00-23)
  - mm: Minute (00-59)
  - ss: Second (00-59)
  - cc: Centisecond (00-99) optional
```

#### **S2F31 - Date and Time Set Request** {#s2f31---date-and-time-set-request}
```
Format:
TIME

Where:
- TIME: Time to Set (A[16]) format: "YYMMDDhhmmss[cc]"
```

#### **S2F32 - Date and Time Set Response** {#s2f32---date-and-time-set-response}
```
Format:
TIACK

Where:
- TIACK: Time Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S2F33 - Define Report** {#s2f33---define-report}
```
Format:
{L:n
  {L:2
    DATAID
    {L:m
      {L:2
        RPTID
        {L:k
          VID_1
          VID_2
          ...
          VID_k
        }
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)
```

#### **S2F34 - Define Report Acknowledge** {#s2f34---define-report-acknowledge}
```
Format:
DRACK

Where:
- DRACK: Define Report Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, Insufficient space
  - 2: Denied, Invalid format
  - 3: Denied, At least one RPTID already defined
  - 4: Denied, At least one VID does not exist
```

#### **S2F35 - Link Event Report** {#s2f35---link-event-report}
```
Format:
{L:n
  {L:2
    DATAID
    {L:m
      {L:2
        CEID
        {L:k
          RPTID_1
          RPTID_2
          ...
          RPTID_k
        }
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
```

#### **S2F36 - Link Event Report Acknowledge** {#s2f36---link-event-report-acknowledge}
```
Format:
LRACK

Where:
- LRACK: Link Report Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, Insufficient space
  - 2: Denied, Invalid format
  - 3: Denied, At least one CEID already defined
  - 4: Denied, At least one CEID does not exist
  - 5: Denied, At least one RPTID does not exist
```

#### **S2F37 - Enable/Disable Event Report** {#s2f37---enabledisable-event-report}
```
Format:
{L:2
  CEED
  {L:n
    CEID_1
    CEID_2
    ...
    CEID_n
  }
}

Where:
- CEED: Collection Event Enable/Disable (BOOLEAN)
  - True: Enable
  - False: Disable
- CEID: Collection Event ID (U1, U2, U4, or A)
```

#### **S2F38 - Enable/Disable Event Report Acknowledge** {#s2f38---enabledisable-event-report-acknowledge}
```
Format:
ERACK

Where:
- ERACK: Enable/Disable Event Report Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, At least one CEID does not exist
  - 2: Denied, Busy
```

#### **S2F3 - Status Variable Value Request** {#s2f3---status-variable-value-request}
```
Format:
{L:n
  SVID_1
  SVID_2
  ...
  SVID_n
}

Where:
- SVID: Status Variable ID (U1, U2, U4, or A)
```

#### **S2F4 - Status Variable Value Response** {#s2f4---status-variable-value-response}
```
Format:
{L:n
  SV_1
  SV_2
  ...
  SV_n
}

Where:
- SV: Status Variable value (any format)
```

#### **S2F5 - Send Equipment Status** {#s2f5---send-equipment-status}
```
Format:
{L:n
  {L:2
    SVID
    SV
  }
}

Where:
- SVID: Status Variable ID (U1, U2, U4, or A)
- SV: Status Variable value (any format)
```

#### **S2F6 - Send Equipment Status Acknowledge** {#s2f6---send-equipment-status-acknowledge}
```
Format:
ACKC2

Where:
- ACKC2: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S2F7 - Load Port Status Request** {#s2f7---load-port-status-request}
```
Format:
{L:n
  PORTID_1
  PORTID_2
  ...
  PORTID_n
}

Where:
- PORTID: Port ID (U1, U2, U4, or A)
```

#### **S2F8 - Load Port Status Response** {#s2f8---load-port-status-response}
```
Format:
{L:n
  {L:3
    PORTID
    PORTSTATE
    PORTMODE
  }
}

Where:
- PORTID: Port ID (U1, U2, U4, or A)
- PORTSTATE: Port State (U1)
  - 0: Unloaded
  - 1: Transfer Blocked
  - 2: Ready to Load
  - 3: Ready to Unload
  - 4: Transfer Ready
- PORTMODE: Port Mode (U1)
  - 0: Manual
  - 1: Auto
```

#### **S2F9 - Equipment Status Multi-Block Inquire** {#s2f9---equipment-status-multi-block-inquire}
```
Format:
{L:2
  DSPER
  TOTSMP
}

Where:
- DSPER: Data Sample Period (U1, U2, U4)
- TOTSMP: Total Samples (U1, U2, U4)
```

#### **S2F10 - Equipment Status Multi-Block Grant** {#s2f10---equipment-status-multi-block-grant}
```
Format:
GRANT

Where:
- GRANT: Grant Code (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space
```

#### **S2F11 - Equipment Status Multi-Block** {#s2f11---equipment-status-multi-block}
```
Format:
{L:3
  DSID
  SMPLN
  {L:n
    SV_1
    SV_2
    ...
    SV_n
  }
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- SMPLN: Sample Number (U1, U2, U4)
- SV: Status Variable value (any format)
```

#### **S2F12 - Equipment Status Multi-Block Acknowledge** {#s2f12---equipment-status-multi-block-acknowledge}
```
Format:
ACKC2

Where:
- ACKC2: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S2F19 - Recipe Body Request** {#s2f19---recipe-body-request}
```
Format:
{L:n
  PPID_1
  PPID_2
  ...
  PPID_n
}

Where:
- PPID: Process Program ID (A)
```

#### **S2F20 - Recipe Body Response** {#s2f20---recipe-body-response}
```
Format:
{L:n
  {L:2
    PPID
    PPBODY
  }
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
```

#### **S2F21 - Recipe Body Send** {#s2f21---recipe-body-send}
```
Format:
{L:n
  {L:2
    PPID
    PPBODY
  }
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
```

#### **S2F22 - Recipe Body Acknowledge** {#s2f22---recipe-body-acknowledge}
```
Format:
ACKC2

Where:
- ACKC2: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Recipe ID already exists
  - 3: No space available
```

#### **S2F23 - Trace Initialize Send** {#s2f23---trace-initialize-send}
```
Format:
{L:2
  TRID
  {L:n
    SVID_1
    SVID_2
    ...
    SVID_n
  }
}

Where:
- TRID: Trace Request ID (U1, U2, U4, or A)
- SVID: Status Variable ID (U1, U2, U4, or A)
```

#### **S2F24 - Trace Initialize Acknowledge** {#s2f24---trace-initialize-acknowledge}
```
Format:
TIAACK

Where:
- TIAACK: Trace Initialize Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, Insufficient space
  - 2: Denied, Invalid format
  - 3: Denied, At least one SVID does not exist
  - 4: Denied, Busy
```

#### **S2F25 - Loopback Diagnostic Request** {#s2f25---loopback-diagnostic-request}
```
Format:
{L:n
  DATA_1
  DATA_2
  ...
  DATA_n
}

Where:
- DATA: Test Data (any format)
```

#### **S2F26 - Loopback Diagnostic Response** {#s2f26---loopback-diagnostic-response}
```
Format:
{L:n
  DATA_1
  DATA_2
  ...
  DATA_n
}

Where:
- DATA: Echoed Test Data (any format)
```

#### **S2F27 - Initiate Processing Request** {#s2f27---initiate-processing-request}
```
Format:
{L:2
  PPID
  {L:n
    PARAMETER_1
    PARAMETER_2
    ...
    PARAMETER_n
  }
}

Where:
- PPID: Process Program ID (A)
- PARAMETER: Process Parameters (any format)
```

#### **S2F28 - Initiate Processing Acknowledge** {#s2f28---initiate-processing-acknowledge}
```
Format:
ACKC2

Where:
- ACKC2: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Recipe not found
  - 3: Equipment busy
```

#### **S2F29 - Equipment Constant Namelist Request** {#s2f29---equipment-constant-namelist-request}
```
Format: <none> (empty data)
```

#### **S2F30 - Equipment Constant Namelist Response** {#s2f30---equipment-constant-namelist-response}
```
Format:
{L:n
  {L:6
    ECID
    ECNAME
    ECMIN
    ECMAX
    ECDEF
    UNITS
  }
}

Where:
- ECID: Equipment Constant ID (U1, U2, U4, or A)
- ECNAME: Equipment Constant Name (A)
- ECMIN: Minimum Value (any format)
- ECMAX: Maximum Value (any format)
- ECDEF: Default Value (any format)
- UNITS: Units (A)
```

#### **S2F39 - Status Variable Namelist Request** {#s2f39---status-variable-namelist-request}
```
Format: <none> (empty data)
```

#### **S2F40 - Status Variable Namelist Response** {#s2f40---status-variable-namelist-response}
```
Format:
{L:n
  {L:6
    SVID
    SVNAME
    SVMIN
    SVMAX
    SVDEF
    UNITS
  }
}

Where:
- SVID: Status Variable ID (U1, U2, U4, or A)
- SVNAME: Status Variable Name (A)
- SVMIN: Minimum Value (any format)
- SVMAX: Maximum Value (any format)
- SVDEF: Default Value (any format)
- UNITS: Units (A)
```

#### **S2F41 - Host Command Send** {#s2f41---host-command-send}
```
Format:
{L:3
  RCMD
  {L:n
    CPNAME_1
    CPNAME_2
    ...
    CPNAME_n
  }
  {L:n
    CPVAL_1
    CPVAL_2
    ...
    CPVAL_n
  }
}

Where:
- RCMD: Remote Command (A)
- CPNAME: Command Parameter Name (A)
- CPVAL: Command Parameter Value (any format)
```

#### **S2F42 - Host Command Acknowledge** {#s2f42---host-command-acknowledge}
```
Format:
{L:2
  HCACK
    {L:n
      {L:2
        CPNAME
        CPACK
      }
    }
}

Where:
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
- CPNAME: Command Parameter Name (A)
- CPACK     Format: B:1 (invariant)    
      remote command parameter acknowledge, only received if error (B[1])   
  1 - unknown CPNAME
  2 - illegal value for CPVAL
  3 - illegal format for CPVAL
```

#### **S2F43 - Reset Spooling Streams and Functions** {#s2f43---reset-spooling-streams-and-functions}
```
Format:
{L:2
  STRID
  FCNID
}

Where:
- STRID: Stream ID (B[1])
- FCNID: Function ID (B[1])
```

#### **S2F44 - Reset Spooling Acknowledge** {#s2f44---reset-spooling-acknowledge}
```
Format:
RSPACK

Where:
- RSPACK: Reset Spool Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S2F45 - Define Variable Limit Attributes** {#s2f45---define-variable-limit-attributes}
```
Format:
{L:n
  {L:8
    VID
    LIMITID
    UPPERDB
    LOWERDB
    UPPERDB
    LOWERDB
    LVID
    DVVAL
  }
}

Where:
- VID: Variable ID (U1, U2, U4, or A)
- LIMITID: Limit ID (U1, U2, U4, or A)
- UPPERDB: Upper Deadband (any format)
- LOWERDB: Lower Deadband (any format)
- LVID: Limit Variable ID (U1, U2, U4, or A)  
- DVVAL: Default Variable Value (any format)
```

#### **S2F46 - Define Variable Limit Attributes Acknowledge** {#s2f46---define-variable-limit-attributes-acknowledge}
```
Format:
ACKC2

Where:
- ACKC2: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: At least one VID does not exist
  - 3: Invalid limit specification
```

#### **S2F47 - Variable Limit Attribute Request** {#s2f47---variable-limit-attribute-request}
```
Format:
{L:n
  VID_1
  VID_2
  ...
  VID_n
}

Where:
- VID: Variable ID (U1, U2, U4, or A)
```

#### **S2F48 - Variable Limit Attribute Response** {#s2f48---variable-limit-attribute-response}
```
Format:
{L:n
  {L:8
    VID
    LIMITID
    UPPERDB
    LOWERDB
    UPPERDB
    LOWERDB
    LVID
    DVVAL
  }
}

Where:
- VID: Variable ID (U1, U2, U4, or A)
- LIMITID: Limit ID (U1, U2, U4, or A)
- UPPERDB: Upper Deadband (any format)
- LOWERDB: Lower Deadband (any format)
- LVID: Limit Variable ID (U1, U2, U4, or A)
- DVVAL: Default Variable Value (any format)
```

#### **S2F49 - Enhanced Remote Command** {#s2f49---enhanced-remote-command}
```
Format:
{L:4
  DATAID
  OBJSPEC
  RCMD
  {L:n
    {L:2
      CPNAME
      CPACK
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specifier (A)
- RCMD: Remote Command (A)
- CPNAME: Command Parameter Name (A)
- CPACK: Command Parameter Acknowledge (any format)
```

#### **S2F50 - Enhanced Remote Command Acknowledge** {#s2f50---enhanced-remote-command-acknowledge}
```
Format:
{L:3
  DATAID
  HCACK
  {L:n
    {L:2
      CPNAME
      CPACK
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
- CPNAME: Command Parameter Name (A)
- CPACK: Command Parameter Acknowledge (any format)
```

#### **S2F51 - Automated Substrate Mapping** {#s2f51---automated-substrate-mapping}
```
Format:
{L:3
  DATAID
  OBJSPEC
  {L:n
    MAPDATA_1
    MAPDATA_2
    ...
    MAPDATA_n
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- OBJSPEC: Object Specifier (A)
- MAPDATA: Mapping Data (various formats)
```

#### **S2F52 - Automated Substrate Mapping Acknowledge** {#s2f52---automated-substrate-mapping-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
```

#### **S2F53 - Enhanced Define Report** {#s2f53---enhanced-define-report}
```
Format:
{L:3
  DATAID
  OBJTYPE
  {L:n
    {L:2
      RPTID
      {L:m
        VID_1
        VID_2
        ...
        VID_m
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- OBJTYPE: Object Type (A)
- RPTID: Report ID (U1, U2, U4, or A)
- VID: Variable ID (U1, U2, U4, or A)
```

#### **S2F54 - Enhanced Define Report Acknowledge** {#s2f54---enhanced-define-report-acknowledge}
```
Format:
{L:2
  DATAID
  DRACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- DRACK: Define Report Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, Insufficient space
  - 2: Denied, Invalid format
  - 3: Denied, At least one RPTID already defined
  - 4: Denied, At least one VID does not exist
```

#### **S2F55 - Enhanced Link Event Report** {#s2f55---enhanced-link-event-report}
```
Format:
{L:3
  DATAID
  OBJTYPE
  {L:n
    {L:2
      CEID
      {L:m
        RPTID_1
        RPTID_2
        ...
        RPTID_m
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- OBJTYPE: Object Type (A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
```

#### **S2F56 - Enhanced Link Event Report Acknowledge** {#s2f56---enhanced-link-event-report-acknowledge}
```
Format:
{L:2
  DATAID
  LRACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- LRACK: Link Report Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, Insufficient space
  - 2: Denied, Invalid format
  - 3: Denied, At least one CEID already defined
  - 4: Denied, At least one CEID does not exist
  - 5: Denied, At least one RPTID does not exist
```

#### **S2F57 - Enhanced Enable/Disable Event Report** {#s2f57---enhanced-enabledisable-event-report}
```
Format:
{L:3
  DATAID
  CEED
  {L:n
    CEID_1
    CEID_2
    ...
    CEID_n
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- CEED: Collection Event Enable/Disable (BOOLEAN)
- CEID: Collection Event ID (U1, U2, U4, or A)
```

#### **S2F58 - Enhanced Enable/Disable Event Report Acknowledge** {#s2f58---enhanced-enabledisable-event-report-acknowledge}
```
Format:
{L:2
  DATAID
  ERACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- ERACK: Enable/Disable Event Report Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Denied, At least one CEID does not exist
  - 2: Denied, Busy
```

#### **S2F59 - Formatted Process Program Send** {#s2f59---formatted-process-program-send}
```
Format:
{L:3
  PPID
  PPBODY
  PPFORMAT
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
- PPFORMAT: Process Program Format (U1)
  - 0: ASCII
  - 1: Binary
  - 2: Structured
```

#### **S2F60 - Formatted Process Program Acknowledge** {#s2f60---formatted-process-program-acknowledge}
```
Format:
ACKC2

Where:
- ACKC2: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Format not supported
  - 3: PPID already exists
  - 4: No space available
```

#### **S2F61 - Formatted Process Program Request** {#s2f61---formatted-process-program-request}
```
Format:
{L:2
  PPID
  PPFORMAT
}

Where:
- PPID: Process Program ID (A)
- PPFORMAT: Process Program Format (U1)
  - 0: ASCII
  - 1: Binary
  - 2: Structured
```

#### **S2F62 - Formatted Process Program Response** {#s2f62---formatted-process-program-response}
```
Format:
{L:3
  PPID
  PPBODY
  PPFORMAT
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
- PPFORMAT: Process Program Format (U1)
  - 0: ASCII
  - 1: Binary
  - 2: Structured
```

#### **S2F63 - Define Object** {#s2f63---define-object}
```
Format:
{L:3
  DATAID
  OBJTYPE
  {L:n
    {L:3
      OBJID
      OBJNAME
      {L:m
        ATTRID_1
        ATTRID_2
        ...
        ATTRID_m
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- OBJTYPE: Object Type (A)
- OBJID: Object ID (A)
- OBJNAME: Object Name (A)
- ATTRID: Attribute ID (U1, U2, U4, or A)
```

#### **S2F64 - Define Object Acknowledge** {#s2f64---define-object-acknowledge}
```
Format:
{L:2
  DATAID
  OBJACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- OBJACK: Object Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Object type not supported
  - 3: Object already exists
  - 4: No space available
```

### Stream 3: Material Status
**Purpose**: Material and carrier tracking

| Message | Direction | Description |
|---------|-----------|-------------|
| [S3F1](#s3f1---carrier-action-request)    | → Equipment | Carrier Action Request |
| [S3F2](#s3f2---carrier-action-response)    | ← Equipment | Carrier Action Response |
| [S3F3](#s3f3---carrier-status-request)    | → Equipment | Carrier Status Request |
| [S3F4](#s3f4---carrier-status-response)    | ← Equipment | Carrier Status Response |
| [S3F5](#s3f5---carrier-status-send)    | ← Equipment | Carrier Status Send |
| [S3F6](#s3f6---carrier-status-acknowledge)    | → Equipment | Carrier Status Acknowledge |
| [S3F7](#s3f7---port-status-request)    | → Equipment | Port Status Request |
| [S3F8](#s3f8---port-status-response)    | ← Equipment | Port Status Response |
| [S3F9](#s3f9---port-status-send)    | ← Equipment | Port Status Send |
| [S3F10](#s3f10---port-status-acknowledge)   | → Equipment | Port Status Acknowledge |
| [S3F11](#s3f11---substrate-map-request)   | → Equipment | Substrate Map Request |
| [S3F12](#s3f12---substrate-map-response)   | ← Equipment | Substrate Map Response |
| [S3F13](#s3f13---substrate-map-send)   | ← Equipment | Substrate Map Send |
| [S3F14](#s3f14---substrate-map-acknowledge)   | → Equipment | Substrate Map Acknowledge |
| [S3F15](#s3f15---substrate-position-request)   | → Equipment | Substrate Position Request |
| [S3F16](#s3f16---substrate-position-response)   | ← Equipment | Substrate Position Response |
| [S3F17](#s3f17---carrier-action-request-extended)   | → Equipment | Carrier Action Request (Extended) |
| [S3F18](#s3f18---carrier-action-response-extended)   | ← Equipment | Carrier Action Response (Extended) |
| [S3F19](#s3f19---port-action-request)   | → Equipment | Port Action Request |
| [S3F20](#s3f20---port-action-response)   | ← Equipment | Port Action Response |
| [S3F21](#s3f21---port-group-request)   | → Equipment | Port Group Request |
| [S3F22](#s3f22---port-group-response)   | ← Equipment | Port Group Response |
| [S3F23](#s3f23---port-group-define)   | → Equipment | Port Group Define |
| [S3F24](#s3f24---port-group-define-acknowledge)   | ← Equipment | Port Group Define Acknowledge |
| [S3F25](#s3f25---carrier-id-request)   | → Equipment | Carrier ID Request |
| [S3F26](#s3f26---carrier-id-response)   | ← Equipment | Carrier ID Response |
| [S3F27](#s3f27---carrier-id-send)   | → Equipment | Carrier ID Send |
| [S3F28](#s3f28---carrier-id-acknowledge)   | ← Equipment | Carrier ID Acknowledge |
| [S3F29](#s3f29---substrate-location-request)   | → Equipment | Substrate Location Request |
| [S3F30](#s3f30---substrate-location-response)   | ← Equipment | Substrate Location Response |
| [S3F31](#s3f31---substrate-location-send)   | ← Equipment | Substrate Location Send |
| [S3F32](#s3f32---substrate-location-acknowledge)   | → Equipment | Substrate Location Acknowledge |
| [S3F33](#s3f33---load-lock-status-request)   | → Equipment | Load Lock Status Request |
| [S3F34](#s3f34---load-lock-status-response)   | ← Equipment | Load Lock Status Response |
| [S3F35](#s3f35---load-lock-status-send)   | ← Equipment | Load Lock Status Send |
| [S3F36](#s3f36---load-lock-status-acknowledge)   | → Equipment | Load Lock Status Acknowledge |

#### **S3F1 - Carrier Action Request** {#s3f1---carrier-action-request}
```
Format:
{L:5
  DATAID
  CARRIERACTION
  CARRIERID
  PTN
  {L:n
    {L:2
      CATTRID
      CATTRDATA
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- CARRIERACTION: Carrier Action (U1)
  - 1: Load
  - 2: Unload
  - 3: Transfer
- CARRIERID: Carrier ID (A)
- PTN: Port Number (U1)
- CATTRID: Carrier Attribute ID (U1, U2, U4, or A)
- CATTRDATA: Carrier Attribute Data (any format)
```

#### **S3F2 - Carrier Action Response** {#s3f2---carrier-action-response}
```
Format:
{L:2
  DATAID
  CAACK
}

Where:
- DATAID: Data ID (matching request)
- CAACK: Carrier Action Acknowledge (U1)
  - 0: Acknowledged
  - 1: Denied, Invalid Command
  - 2: Denied, Cannot Perform Now
```

#### **S3F3 - Carrier Status Request** {#s3f3---carrier-status-request}
```
Format:
{L:n
  CARRIERID_1
  CARRIERID_2
  ...
  CARRIERID_n
}

Where:
- CARRIERID: Carrier ID (A)
```

#### **S3F4 - Carrier Status Response**
```
Format:
{L:n
  {L:3
    CARRIERID
    CARRIERSTATUS
    {L:m
      {L:2
        CATTRID
        CATTRDATA
      }
    }
  }
}

Where:
- CARRIERID: Carrier ID (A)
- CARRIERSTATUS: Carrier Status (U1)
  - 0: No State
  - 1: Not Present
  - 2: Present
  - 3: Moving
- CATTRID: Carrier Attribute ID (U1, U2, U4, or A)
- CATTRDATA: Carrier Attribute Data (any format)
```

#### **S3F5 - Carrier Status Send**
```
Format:
{L:3
  CARRIERID
  CARRIERSTATUS
  {L:n
    {L:2
      CATTRID
      CATTRDATA
    }
  }
}

Where:
- CARRIERID: Carrier ID (A)
- CARRIERSTATUS: Carrier Status (U1)
  - 0: No State
  - 1: Not Present
  - 2: Present
  - 3: Moving
- CATTRID: Carrier Attribute ID (U1, U2, U4, or A)
- CATTRDATA: Carrier Attribute Data (any format)
```

#### **S3F6 - Carrier Status Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F7 - Port Status Request**
```
Format:
{L:n
  PTN_1
  PTN_2
  ...
  PTN_n
}

Where:
- PTN: Port Number (U1)
```

#### **S3F8 - Port Status Response**
```
Format:
{L:n
  {L:3
    PTN
    PORTSTATUS
    {L:m
      {L:2
        PATTRID
        PATTRDATA
      }
    }
  }
}

Where:
- PTN: Port Number (U1)
- PORTSTATUS: Port Status (U1)
  - 0: No State
  - 1: Unoccupied
  - 2: Occupied
  - 3: Loading
  - 4: Unloading
- PATTRID: Port Attribute ID (U1, U2, U4, or A)
- PATTRDATA: Port Attribute Data (any format)
```

#### **S3F9 - Port Status Send**
```
Format:
{L:3
  PTN
  PORTSTATUS
  {L:n
    {L:2
      PATTRID
      PATTRDATA
    }
  }
}

Where:
- PTN: Port Number (U1)
- PORTSTATUS: Port Status (U1)
- PATTRID: Port Attribute ID (U1, U2, U4, or A)
- PATTRDATA: Port Attribute Data (any format)
```

#### **S3F10 - Port Status Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F11 - Substrate Map Request**
```
Format:
{L:2
  CARRIERID
  {L:n
    SUBSTRATEID_1
    SUBSTRATEID_2
    ...
    SUBSTRATEID_n
  }
}

Where:
- CARRIERID: Carrier ID (A)
- SUBSTRATEID: Substrate ID (A)
```

#### **S3F12 - Substrate Map Response**
```
Format:
{L:n
  {L:3
    SUBSTRATEID
    SUBSTRATELOC
    {L:m
      {L:2
        SATTRID
        SATTRDATA
      }
    }
  }
}

Where:
- SUBSTRATEID: Substrate ID (A)
- SUBSTRATELOC: Substrate Location (U1)
- SATTRID: Substrate Attribute ID (U1, U2, U4, or A)
- SATTRDATA: Substrate Attribute Data (any format)
```

#### **S3F13 - Substrate Map Send**
```
Format:
{L:2
  CARRIERID
  {L:n
    {L:3
      SUBSTRATEID
      SUBSTRATELOC
      {L:m
        {L:2
          SATTRID
          SATTRDATA
        }
      }
    }
  }
}

Where:
- CARRIERID: Carrier ID (A)
- SUBSTRATEID: Substrate ID (A)
- SUBSTRATELOC: Substrate Location (U1)
- SATTRID: Substrate Attribute ID (U1, U2, U4, or A)
- SATTRDATA: Substrate Attribute Data (any format)
```

#### **S3F14 - Substrate Map Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F15 - Substrate Position Request**
```
Format:
{L:2
  CARRIERID
  SUBSTRATEID
}

Where:
- CARRIERID: Carrier ID (A)
- SUBSTRATEID: Substrate ID (A)
```

#### **S3F16 - Substrate Position Response**
```
Format:
{L:3
  SUBSTRATEID
  SUBSTRATELOC
  SUBSTRATESTATUS
}

Where:
- SUBSTRATEID: Substrate ID (A)
- SUBSTRATELOC: Substrate Location (U1)
- SUBSTRATESTATUS: Substrate Status (U1)
  - 0: No State
  - 1: Present
  - 2: Processing
  - 3: Completed
```

#### **S3F17 - Carrier Action Request (Extended)**
```
Format:
{L:5
  DATAID
  CARRIERACTION
  CARRIERID
  PTN
  {L:n
    {L:2
      CATTRID
      CATTRDATA
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- CARRIERACTION: Carrier Action (U1)
- CARRIERID: Carrier ID (A)
- PTN: Port Number (U1)
- CATTRID: Carrier Attribute ID (U1, U2, U4, or A)
- CATTRDATA: Carrier Attribute Data (any format)
```

#### **S3F18 - Carrier Action Response (Extended)**
```
Format:
{L:2
  DATAID
  CAACK
}

Where:
- DATAID: Data ID (matching request)
- CAACK: Carrier Action Acknowledge (U1)
  - 0: Acknowledged
  - 1: Denied, Invalid Command
  - 2: Denied, Cannot Perform Now
```

#### **S3F19 - Port Action Request**
```
Format:
{L:4
  DATAID
  PORTACTION
  PTN
  {L:n
    {L:2
      PATTRID
      PATTRDATA
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- PORTACTION: Port Action (U1)
  - 1: Open
  - 2: Close
  - 3: Lock
  - 4: Unlock
- PTN: Port Number (U1)
- PATTRID: Port Attribute ID (U1, U2, U4, or A)
- PATTRDATA: Port Attribute Data (any format)
```

#### **S3F20 - Port Action Response**
```
Format:
{L:2
  DATAID
  PAACK
}

Where:
- DATAID: Data ID (matching request)
- PAACK: Port Action Acknowledge (U1)
  - 0: Acknowledged
  - 1: Denied, Invalid Command
  - 2: Denied, Cannot Perform Now
```

#### **S3F21 - Port Group Request**
```
Format:
{L:n
  PORTGROUPID_1
  PORTGROUPID_2
  ...
  PORTGROUPID_n
}

Where:
- PORTGROUPID: Port Group ID (A)
```

#### **S3F22 - Port Group Response**
```
Format:
{L:n
  {L:2
    PORTGROUPID
    {L:m
      PTN_1
      PTN_2
      ...
      PTN_m
    }
  }
}

Where:
- PORTGROUPID: Port Group ID (A)
- PTN: Port Number (U1)
```

#### **S3F23 - Port Group Define**
```
Format:
{L:2
  PORTGROUPID
  {L:n
    PTN_1
    PTN_2
    ...
    PTN_n
  }
}

Where:
- PORTGROUPID: Port Group ID (A)
- PTN: Port Number (U1)
```

#### **S3F24 - Port Group Define Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F25 - Carrier ID Request**
```
Format:
PTN

Where:
- PTN: Port Number (U1)
```

#### **S3F26 - Carrier ID Response**
```
Format:
{L:2
  PTN
  CARRIERID
}

Where:
- PTN: Port Number (U1)
- CARRIERID: Carrier ID (A)
```

#### **S3F27 - Carrier ID Send**
```
Format:
{L:2
  PTN
  CARRIERID
}

Where:
- PTN: Port Number (U1)
- CARRIERID: Carrier ID (A)
```

#### **S3F28 - Carrier ID Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F29 - Substrate Location Request**
```
Format:
{L:n
  SUBSTRATEID_1
  SUBSTRATEID_2
  ...
  SUBSTRATEID_n
}

Where:
- SUBSTRATEID: Substrate ID (A)
```

#### **S3F30 - Substrate Location Response**
```
Format:
{L:n
  {L:3
    SUBSTRATEID
    CARRIERID
    SUBSTRATELOC
  }
}

Where:
- SUBSTRATEID: Substrate ID (A)
- CARRIERID: Carrier ID (A)
- SUBSTRATELOC: Substrate Location (U1)
```

#### **S3F31 - Substrate Location Send**
```
Format:
{L:3
  SUBSTRATEID
  CARRIERID
  SUBSTRATELOC
}

Where:
- SUBSTRATEID: Substrate ID (A)
- CARRIERID: Carrier ID (A)
- SUBSTRATELOC: Substrate Location (U1)
```

#### **S3F32 - Substrate Location Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S3F33 - Load Lock Status Request**
```
Format:
{L:n
  LLID_1
  LLID_2
  ...
  LLID_n
}

Where:
- LLID: Load Lock ID (A)
```

#### **S3F34 - Load Lock Status Response**
```
Format:
{L:n
  {L:3
    LLID
    LLSTATUS
    {L:m
      {L:2
        LLATTRID
        LLATTRDATA
      }
    }
  }
}

Where:
- LLID: Load Lock ID (A)
- LLSTATUS: Load Lock Status (U1)
  - 0: No State
  - 1: Open
  - 2: Closed
  - 3: Pumping
  - 4: Venting
- LLATTRID: Load Lock Attribute ID (U1, U2, U4, or A)
- LLATTRDATA: Load Lock Attribute Data (any format)
```

#### **S3F35 - Load Lock Status Send**
```
Format:
{L:3
  LLID
  LLSTATUS
  {L:n
    {L:2
      LLATTRID
      LLATTRDATA
    }
  }
}

Where:
- LLID: Load Lock ID (A)
- LLSTATUS: Load Lock Status (U1)
- LLATTRID: Load Lock Attribute ID (U1, U2, U4, or A)
- LLATTRDATA: Load Lock Attribute Data (any format)
```

#### **S3F36 - Load Lock Status Acknowledge**
```
Format:
ACKC3

Where:
- ACKC3: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

### Stream 4: Material Control
**Purpose**: Material transfer and handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S4F1](#s4f1---transfer-job-create)    | → Equipment | Transfer Job Create |
| [S4F2](#s4f2---transfer-job-create-acknowledge)    | ← Equipment | Transfer Job Create Acknowledge |
| [S4F3](#s4f3---transfer-job-cancel)    | → Equipment | Transfer Job Cancel |
| [S4F4](#s4f4---transfer-job-cancel-acknowledge)    | ← Equipment | Transfer Job Cancel Acknowledge |
| [S4F5](#s4f5---transfer-job-start)    | → Equipment | Transfer Job Start |
| [S4F6](#s4f6---transfer-job-start-acknowledge)    | ← Equipment | Transfer Job Start Acknowledge |
| [S4F7](#s4f7---transfer-job-pause)    | → Equipment | Transfer Job Pause |
| [S4F8](#s4f8---transfer-job-pause-acknowledge)    | ← Equipment | Transfer Job Pause Acknowledge |
| [S4F9](#s4f9---transfer-job-stop)    | → Equipment | Transfer Job Stop |
| [S4F10](#s4f10---transfer-job-stop-acknowledge)   | ← Equipment | Transfer Job Stop Acknowledge |
| [S4F11](#s4f11---transfer-job-abort)   | → Equipment | Transfer Job Abort |
| [S4F12](#s4f12---transfer-job-abort-acknowledge)   | ← Equipment | Transfer Job Abort Acknowledge |
| [S4F13](#s4f13---transfer-job-resume)   | → Equipment | Transfer Job Resume |
| [S4F14](#s4f14---transfer-job-resume-acknowledge)   | ← Equipment | Transfer Job Resume Acknowledge |
| [S4F15](#s4f15---transfer-job-status-request)   | → Equipment | Transfer Job Status Request |
| [S4F16](#s4f16---transfer-job-status-response)   | ← Equipment | Transfer Job Status Response |
| [S4F17](#s4f17---transfer-job-priority-update)   | → Equipment | Transfer Job Priority Update |
| [S4F18](#s4f18---transfer-job-priority-acknowledge)   | ← Equipment | Transfer Job Priority Acknowledge |
| [S4F19](#s4f19---transfer-command)   | → Equipment | Transfer Command |
| [S4F20](#s4f20---transfer-command-acknowledge)   | ← Equipment | Transfer Command Acknowledge |
| [S4F21](#s4f21---enhanced-transfer-command)   | → Equipment | Enhanced Transfer Command |
| [S4F22](#s4f22---enhanced-transfer-acknowledge)   | ← Equipment | Enhanced Transfer Acknowledge |
| [S4F23](#s4f23---transfer-status-send)   | ← Equipment | Transfer Status Send |
| [S4F24](#s4f24---transfer-status-acknowledge)   | → Equipment | Transfer Status Acknowledge |
| [S4F25](#s4f25---material-status-request)   | → Equipment | Material Status Request |
| [S4F26](#s4f26---material-status-response)   | ← Equipment | Material Status Response |

#### **S4F1 - Transfer Job Create** {#s4f1---transfer-job-create}
```
Format:
{L:5
  DATAID
  TRANSFERTYPE
  SOURCEID
  DESTID
  PRIORITY
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- TRANSFERTYPE: Transfer Type (U1)
  - 1: Material Transfer
  - 2: Carrier Transfer
  - 3: Substrate Transfer
- SOURCEID: Source Location ID (A)
- DESTID: Destination Location ID (A)
- PRIORITY: Transfer Priority (U1)
```

#### **S4F2 - Transfer Job Create Acknowledge** {#s4f2---transfer-job-create-acknowledge}
| S4F3    | → Equipment | Transfer Job Data |
| S4F4    | ← Equipment | Transfer Job Data Acknowledge |
| S4F5    | → Equipment | Transfer Command |
| S4F6    | ← Equipment | Transfer Command Acknowledge |

#### **S4F1 - Transfer Job Create**
```
Format:
{L:5
  DATAID
  JOBID
  CARRIERID
  FROMPTN
  TOPTN
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- JOBID: Job ID (A)
- CARRIERID: Carrier ID (A)
- FROMPTN: From Port Number (U1)
- TOPTN: To Port Number (U1)
```

#### **S4F2 - Transfer Job Create Acknowledge**
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F3 - Transfer Job Data**
```
Format:
{L:n
  {L:5
    JOBID
    CARRIERID
    FROMPTN
    TOPTN
    JOBST
  }
}

Where:
- JOBID: Job ID (A)
- CARRIERID: Carrier ID (A)
- FROMPTN: From Port Number (U1)
- TOPTN: To Port Number (U1)
- JOBST: Job State (U1)
  - 0: Queued
  - 1: Selected
  - 2: Executing
  - 3: Completed
  - 4: Canceled
  - 5: Aborted
  - 6: Failed
```

#### **S4F4 - Transfer Job Data Acknowledge**
```
Format:
ACKC4

Where:
- ACKC4: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S4F5 - Transfer Command**
```
Format:
{L:3
  DATAID
  COMMCODE
  {L:n
    PARAMETER_1
    PARAMETER_2
    ...
    PARAMETER_n
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- COMMCODE: Command Code (A)
  - "START": Start transfer
  - "STOP": Stop transfer
  - "PAUSE": Pause transfer
  - "RESUME": Resume transfer
  - "CANCEL": Cancel transfer
- PARAMETER: Command Parameters (various formats)
```

#### **S4F6 - Transfer Command Acknowledge**
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F7 - Transfer Job Pause** {#s4f7---transfer-job-pause}
```
Format:
{L:2
  DATAID
  JOBID
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- JOBID: Job ID (A)
```

#### **S4F8 - Transfer Job Pause Acknowledge** {#s4f8---transfer-job-pause-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F9 - Transfer Job Stop** {#s4f9---transfer-job-stop}
```
Format:
{L:2
  DATAID
  JOBID
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- JOBID: Job ID (A)
```

#### **S4F10 - Transfer Job Stop Acknowledge** {#s4f10---transfer-job-stop-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F11 - Transfer Job Abort** {#s4f11---transfer-job-abort}
```
Format:
{L:2
  DATAID
  JOBID
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- JOBID: Job ID (A)
```

#### **S4F12 - Transfer Job Abort Acknowledge** {#s4f12---transfer-job-abort-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F13 - Transfer Job Resume** {#s4f13---transfer-job-resume}
```
Format:
{L:2
  DATAID
  JOBID
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- JOBID: Job ID (A)
```

#### **S4F14 - Transfer Job Resume Acknowledge** {#s4f14---transfer-job-resume-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F15 - Transfer Job Status Request** {#s4f15---transfer-job-status-request}
```
Format:
{L:n
  JOBID_1
  JOBID_2
  ...
  JOBID_n
}

Where:
- JOBID: Job ID (A)
```

#### **S4F16 - Transfer Job Status Response** {#s4f16---transfer-job-status-response}
```
Format:
{L:n
  {L:5
    JOBID
    CARRIERID
    FROMPTN
    TOPTN
    JOBST
  }
}

Where:
- JOBID: Job ID (A)
- CARRIERID: Carrier ID (A)
- FROMPTN: From Port Number (U1)
- TOPTN: To Port Number (U1)
- JOBST: Job State (U1)
  - 0: Queued
  - 1: Selected
  - 2: Executing
  - 3: Completed
  - 4: Canceled
  - 5: Aborted
  - 6: Failed
```

#### **S4F17 - Transfer Job Priority Update** {#s4f17---transfer-job-priority-update}
```
Format:
{L:3
  DATAID
  JOBID
  PRIORITY
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- JOBID: Job ID (A)
- PRIORITY: Transfer Priority (U1)
```

#### **S4F18 - Transfer Job Priority Acknowledge** {#s4f18---transfer-job-priority-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F19 - Transfer Command** {#s4f19---transfer-command}
```
Format:
{L:4
  DATAID
  TRANSFERTYPE
  SOURCEID
  DESTID
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- TRANSFERTYPE: Transfer Type (U1)
  - 1: Material Transfer
  - 2: Carrier Transfer
  - 3: Substrate Transfer
- SOURCEID: Source Location ID (A)
- DESTID: Destination Location ID (A)
```

#### **S4F20 - Transfer Command Acknowledge** {#s4f20---transfer-command-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F21 - Enhanced Transfer Command** {#s4f21---enhanced-transfer-command}
```
Format:
{L:5
  DATAID
  TRANSFERTYPE
  SOURCEID
  DESTID
  {L:n
    {L:2
      PARAMID
      PARAMVAL
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- TRANSFERTYPE: Transfer Type (U1)
  - 1: Material Transfer
  - 2: Carrier Transfer
  - 3: Substrate Transfer
- SOURCEID: Source Location ID (A)
- DESTID: Destination Location ID (A)
- PARAMID: Parameter ID (A)
- PARAMVAL: Parameter Value (any format)
```

#### **S4F22 - Enhanced Transfer Acknowledge** {#s4f22---enhanced-transfer-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F23 - Transfer Status Send** {#s4f23---transfer-status-send}
```
Format:
{L:4
  DATAID
  TRANSFERID
  TRANSFERSTATUS
  {L:n
    {L:2
      STATID
      STATVAL
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- TRANSFERID: Transfer ID (A)
- TRANSFERSTATUS: Transfer Status (U1)
  - 0: Idle
  - 1: Executing
  - 2: Paused
  - 3: Completed
  - 4: Failed
- STATID: Status ID (A)
- STATVAL: Status Value (any format)
```

#### **S4F24 - Transfer Status Acknowledge** {#s4f24---transfer-status-acknowledge}
```
Format:
{L:2
  DATAID
  HCACK
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- HCACK: Host Command Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Invalid command
  - 2: Cannot perform now
  - 3: At least one parameter invalid
  - 4: Acknowledge after completion
  - 5: Rejected, already in desired condition
  - 6: No such object exists
```

#### **S4F25 - Material Status Request** {#s4f25---material-status-request}
```
Format:
{L:n
  MATERIALID_1
  MATERIALID_2
  ...
  MATERIALID_n
}

Where:
- MATERIALID: Material ID (A)
```

#### **S4F26 - Material Status Response** {#s4f26---material-status-response}
```
Format:
{L:n
  {L:4
    MATERIALID
    MATERIALTYPE
    LOCATION
    {L:m
      {L:2
        ATTRID
        ATTRVAL
      }
    }
  }
}

Where:
- MATERIALID: Material ID (A)
- MATERIALTYPE: Material Type (A)
- LOCATION: Current Location (A)
- ATTRID: Attribute ID (A)
- ATTRVAL: Attribute Value (any format)
```

### Stream 5: Exception Reporting
**Purpose**: Alarm and exception handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S5F1](#s5f1---alarm-report-send)    | ← Equipment | Alarm Report Send |
| [S5F2](#s5f2---alarm-report-acknowledge)    | → Equipment | Alarm Report Acknowledge |
| [S5F3](#s5f3---enabledisable-alarm-send)    | → Equipment | En/Disable Alarm Send |
| [S5F4](#s5f4---enabledisable-alarm-acknowledge)    | ← Equipment | En/Disable Alarm Acknowledge |
| [S5F5](#s5f5---list-alarms-request)    | → Equipment | List Alarms Request |
| [S5F6](#s5f6---list-alarms-response)    | ← Equipment | List Alarms Response |
| [S5F7](#s5f7---list-enabled-alarm-request)    | → Equipment | List Enabled Alarm Request |
| [S5F8](#s5f8---list-enabled-alarm-response)    | ← Equipment | List Enabled Alarm Response |

#### **S5F1 - Alarm Report Send** {#s5f1---alarm-report-send}
```
Format:
{L:3
  ALCD
  ALID
  ALTX
}

Where:
- ALCD: Alarm Code (B[1])
  - Bit 0: Alarm Set (1) or Clear (0)
  - Bit 7: Alarm (1) or Warning (0)
- ALID: Alarm ID (U1, U2, U4, or A)
- ALTX: Alarm Text (A[120])
```

#### **S5F2 - Alarm Report Acknowledge** {#s5f2---alarm-report-acknowledge}
```
Format:
ACKC5

Where:
- ACKC5: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S5F3 - Enable/Disable Alarm Send** {#s5f3---enabledisable-alarm-send}
```
Format:
{L:2
  ALED
  {L:n
    ALID_1
    ALID_2
    ...
    ALID_n
  }
}

Where:
- ALED: Alarm Enable/Disable (B[1])
  - 128 (0x80): Enable
  - 0: Disable
- ALID: Alarm ID (U1, U2, U4, or A)
```

#### **S5F4 - Enable/Disable Alarm Acknowledge** {#s5f4---enabledisable-alarm-acknowledge}
```
Format:
ACKC5

Where:
- ACKC5: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S5F5 - List Alarms Request** {#s5f5---list-alarms-request}
```
Format: <none> (empty data)
```

#### **S5F6 - List Alarms Response** {#s5f6---list-alarms-response}
```
Format:
{L:n
  ALID_1
  ALID_2
  ...
  ALID_n
}

Where:
- ALID: Alarm ID (U1, U2, U4, or A)
```

#### **S5F7 - List Enabled Alarm Request** {#s5f7---list-enabled-alarm-request}
```
Format: <none> (empty data)
```

#### **S5F8 - List Enabled Alarm Response** {#s5f8---list-enabled-alarm-response}
```
Format:
{L:n
  ALID_1
  ALID_2
  ...
  ALID_n
}

Where:
- ALID: Alarm ID (U1, U2, U4, or A) - Only enabled alarms
```

### Stream 6: Data Collection
**Purpose**: Process data collection and event reporting

| Message | Direction | Description |
|---------|-----------|-------------|
| [S6F1](#s6f1---trace-data-send)    | ← Equipment | Trace Data Send |
| [S6F2](#s6f2---trace-data-acknowledge)    | → Equipment | Trace Data Acknowledge |
| [S6F3](#s6f3---discrete-variable-data-send)    | ← Equipment | Discrete Variable Data Send |
| [S6F4](#s6f4---discrete-variable-data-acknowledge)    | → Equipment | Discrete Variable Data Acknowledge |
| [S6F5](#s6f5---multi-block-data-send)    | ← Equipment | Multi-block Data Send |
| [S6F6](#s6f6---multi-block-grant)    | → Equipment | Multi-block Grant |
| [S6F7](#s6f7---data-transfer-request)    | → Equipment | Data Transfer Request |
| [S6F8](#s6f8---data-transfer-response)    | ← Equipment | Data Transfer Response |
| [S6F11](#s6f11---event-report-send)   | ← Equipment | Event Report Send |
| [S6F12](#s6f12---event-report-acknowledge)   | → Equipment | Event Report Acknowledge |
| [S6F15](#s6f15---event-report-request)   | → Equipment | Event Report Request |
| [S6F16](#s6f16---event-report-response)   | ← Equipment | Event Report Response |
| [S6F19](#s6f19---individual-report-request)   | → Equipment | Individual Report Request |
| [S6F20](#s6f20---individual-report-response)   | ← Equipment | Individual Report Response |
| [S6F21](#s6f21---annotated-individual-report-request)   | → Equipment | Annotated Individual Report Request |
| [S6F22](#s6f22---annotated-individual-report-response)   | ← Equipment | Annotated Individual Report Response |
| [S6F23](#s6f23---request-spooled-data)   | → Equipment | Request Spooled Data |
| [S6F24](#s6f24---request-spooled-data-response)   | ← Equipment | Request Spooled Data Response |
| [S6F25](#s6f25---data-set-upload)   | → Equipment | Data Set Upload |
| [S6F26](#s6f26---data-set-upload-acknowledge)   | ← Equipment | Data Set Upload Acknowledge |
| [S6F27](#s6f27---data-set-download-request)   | → Equipment | Data Set Download Request |
| [S6F28](#s6f28---data-set-download-response)   | ← Equipment | Data Set Download Response |
| [S6F29](#s6f29---data-set-list-request)   | → Equipment | Data Set List Request |
| [S6F30](#s6f30---data-set-list-response)   | ← Equipment | Data Set List Response |

#### **S6F11 - Event Report Send** {#s6f11---event-report-send}
```
Format:
{L:3
  DATAID
  CEID
  {L:n
    {L:3
      RPTID
      {L:m
        V_1
        V_2
        ...
        V_m
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- CEID: Collection Event ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- V: Variable Value (any format)
```

#### **S6F12 - Event Report Acknowledge** {#s6f12---event-report-acknowledge}
```
Format:
ACKC6

Where:
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S6F15 - Event Report Request** {#s6f15---event-report-request}
```
Format:
CEID

Where:
- CEID: Collection Event ID (U1, U2, U4, or A)
```

#### **S6F16 - Event Report Response** {#s6f16---event-report-response}
```
Format:
{L:2
  DATAID
  {L:n
    {L:3
      RPTID
      {L:m
        V_1
        V_2
        ...
        V_m
      }
    }
  }
}

Where:
- DATAID: Data ID (U1, U2, U4, or A)
- RPTID: Report ID (U1, U2, U4, or A)
- V: Variable Value (any format)
```

#### **S6F1 - Trace Data Send** {#s6f1---trace-data-send}
```
Format:
{L:3
  TRID
  SMPLN
  {L:n
    SV_1
    SV_2
    ...
    SV_n
  }
}

Where:
- TRID: Trace Request ID (U1, U2, U4, or A)
- SMPLN: Sample Number (U1, U2, U4)
- SV: Sample Value (any format)
```

#### **S6F2 - Trace Data Acknowledge** {#s6f2---trace-data-acknowledge}
```
Format:
ACKC6

Where:
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S6F3 - Discrete Variable Data Send** {#s6f3---discrete-variable-data-send}
```
Format:
{L:2
  DVID
  DVVAL
}

Where:
- DVID: Discrete Variable ID (U1, U2, U4, or A)
- DVVAL: Discrete Variable Value (any format)
```

#### **S6F4 - Discrete Variable Data Acknowledge** {#s6f4---discrete-variable-data-acknowledge}
```
Format:
ACKC6

Where:
- ACKC6: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S6F5 - Multi-block Data Send** {#s6f5---multi-block-data-send}
```
Format:
{L:3
  MID
  IDTYP
  {L:n
    DATA_1
    DATA_2
    ...
    DATA_n
  }
}

Where:
- MID: Message ID (U1, U2, U4, or A)
- IDTYP: ID Type (B[1])
  - 0: Data ID
  - 1: Equipment ID
- DATA: Data blocks (any format)
```

#### **S6F6 - Multi-block Grant** {#s6f6---multi-block-grant}
```
Format:
GRANT

Where:
- GRANT: Grant Code (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space
```

#### **S6F7 - Data Transfer Request** {#s6f7---data-transfer-request}
```
Format:
{L:2
  DATALENGTH
  DATA
}

Where:
- DATALENGTH: Data Length (U1, U2, U4)
- DATA: Binary Data (B)
```

#### **S6F8 - Data Transfer Response** {#s6f8---data-transfer-response}
```
Format:
ACK

Where:
- ACK: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

#### **S6F19 - Individual Report Request** {#s6f19---individual-report-request}
```
Format:
RPTID

Where:
- RPTID: Report ID (U1, U2, U4, or A)
```

#### **S6F20 - Individual Report Response** {#s6f20---individual-report-response}
```
Format:
{L:n
  V_1
  V_2
  ...
  V_n
}

Where:
- V: Variable Value (any format)
```

#### **S6F21 - Annotated Individual Report Request** {#s6f21---annotated-individual-report-request}
```
Format:
RPTID

Where:
- RPTID: Report ID (U1, U2, U4, or A)
```

#### **S6F22 - Annotated Individual Report Response** {#s6f22---annotated-individual-report-response}
```
Format:
{L:n
  {L:2
    VID
    V
  }
}

Where:
- VID: Variable ID (U1, U2, U4, or A)
- V: Variable Value (any format)
```

#### **S6F23 - Request Spooled Data** {#s6f23---request-spooled-data}
```
Format:
DSID

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
```

#### **S6F24 - Request Spooled Data Response** {#s6f24---request-spooled-data-response}
```
Format:
{L:3
  DSID
  DSCOUNT
  {L:n
    DATA_1
    DATA_2
    ...
    DATA_n
  }
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSCOUNT: Data Set Count (U1, U2, U4)
- DATA: Spooled Data (any format)
```

#### **S6F25 - Data Set Upload** {#s6f25---data-set-upload}
```
Format:
{L:4
  DSID
  DSNAME
  DSTYPE
  {L:n
    DATA_1
    DATA_2
    ...
    DATA_n
  }
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSNAME: Data Set Name (A)
- DSTYPE: Data Set Type (U1)
  - 0: Process data
  - 1: Equipment data
  - 2: Alarm data
  - 3: Event data
- DATA: Data Set Content (any format)
```

#### **S6F26 - Data Set Upload Acknowledge** {#s6f26---data-set-upload-acknowledge}
```
Format:
{L:2
  DSID
  DSUPACK
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSUPACK: Data Set Upload Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Data set already exists
  - 3: No space available
```

#### **S6F27 - Data Set Download Request** {#s6f27---data-set-download-request}
```
Format:
{L:2
  DSID
  DSNAME
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSNAME: Data Set Name (A)
```

#### **S6F28 - Data Set Download Response** {#s6f28---data-set-download-response}
```
Format:
{L:4
  DSID
  DSNAME
  DSTYPE
  {L:n
    DATA_1
    DATA_2
    ...
    DATA_n
  }
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSNAME: Data Set Name (A)
- DSTYPE: Data Set Type (U1)
- DATA: Data Set Content (any format)
```

#### **S6F29 - Data Set List Request** {#s6f29---data-set-list-request}
```
Format: <none> (empty data)
```

#### **S6F30 - Data Set List Response** {#s6f30---data-set-list-response}
```
Format:
{L:n
  {L:3
    DSID
    DSNAME
    DSTYPE
  }
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSNAME: Data Set Name (A)
- DSTYPE: Data Set Type (U1)
  - 0: Process data
  - 1: Equipment data
  - 2: Alarm data
  - 3: Event data
```

### Stream 7: Process Program Management
**Purpose**: Recipe and process program handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S7F1](#s7f1---process-program-load-inquire)    | → Equipment | Process Program Load Inquire |
| [S7F2](#s7f2---process-program-load-grant)    | ← Equipment | Process Program Load Grant |
| [S7F3](#s7f3---process-program-send)    | → Equipment | Process Program Send |
| [S7F4](#s7f4---process-program-acknowledge)    | ← Equipment | Process Program Acknowledge |
| [S7F5](#s7f5---process-program-request)    | → Equipment | Process Program Request |
| [S7F6](#s7f6---process-program-data)    | ← Equipment | Process Program Data |
| [S7F17](#s7f17---delete-process-program-send)   | → Equipment | Delete Process Program Send |
| [S7F18](#s7f18---delete-process-program-acknowledge)   | ← Equipment | Delete Process Program Acknowledge |
| [S7F19](#s7f19---current-eppd-request)   | → Equipment | Current EPPD Request |
| [S7F20](#s7f20---current-eppd-data)   | ← Equipment | Current EPPD Data |
| [S7F21](#s7f21---process-program-directory-request)   | → Equipment | Process Program Directory Request |
| S7F22   | ← Equipment | Process Program Directory Response |
| S7F23   | → Equipment | Process Program Upload |
| S7F24   | ← Equipment | Process Program Upload Acknowledge |
| S7F25   | → Equipment | Process Program Status Request |
| S7F26   | ← Equipment | Process Program Status Response |
| S7F27   | → Equipment | Process Program Execute |
| S7F28   | ← Equipment | Process Program Execute Acknowledge |
| S7F29   | → Equipment | Process Program Stop |
| S7F30   | ← Equipment | Process Program Stop Acknowledge |
| S7F31   | → Equipment | Process Program Pause |
| S7F32   | ← Equipment | Process Program Pause Acknowledge |
| S7F33   | → Equipment | Process Program Resume |
| S7F34   | ← Equipment | Process Program Resume Acknowledge |
| S7F35   | → Equipment | Process Program Variable Request |
| S7F36   | ← Equipment | Process Program Variable Response |
| S7F37   | → Equipment | Process Program Variable Send |
| S7F38   | ← Equipment | Process Program Variable Acknowledge |
| S7F39   | → Equipment | Recipe Validation Request |
| S7F40   | ← Equipment | Recipe Validation Response |
| S7F41   | → Equipment | Recipe Parameter Request |
| S7F42   | ← Equipment | Recipe Parameter Response |
| S7F43   | → Equipment | Recipe Parameter Set |
| S7F44   | ← Equipment | Recipe Parameter Set Acknowledge |

#### **S7F1 - Process Program Load Inquire**
```
Format:
{L:2
  PPID
  LENGTH
}

Where:
- PPID: Process Program ID (A)
- LENGTH: Length of Process Program (U1, U2, U4)
```

#### **S7F2 - Process Program Load Grant**
```
Format:
GRANT

Where:
- GRANT: Grant Code (B[1])
  - 0: OK
  - 1: Busy, try again
  - 2: No space
  - 3: Invalid PPID
  - 4: Mode not supported
  - 5: Communication not available
  - 6: PPID already exists
```

#### **S7F3 - Process Program Send**
```
Format:
{L:2
  PPID
  PPBODY
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
```

#### **S7F4 - Process Program Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F5 - Process Program Request**
```
Format:
PPID

Where:
- PPID: Process Program ID (A)
```

#### **S7F6 - Process Program Data**
```
Format:
{L:2
  PPID
  PPBODY
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
```

#### **S7F17 - Delete Process Program Send**
```
Format:
{L:n
  PPID_1
  PPID_2
  ...
  PPID_n
}

Where:
- PPID: Process Program ID (A)
```

#### **S7F18 - Delete Process Program Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F19 - Current EPPD Request**
```
Format: <none> (empty data)
```

#### **S7F20 - Current EPPD Data**
```
Format:
{L:n
  {L:2
    PPID
    {L:m
      PARAMETER_1
      PARAMETER_2
      ...
      PARAMETER_m
    }
  }
}

Where:
- PPID: Process Program ID (A)
- PARAMETER: Process Parameter (any format)
```

#### **S7F21 - Process Program Directory Request**
```
Format: <none> (empty data)
```

#### **S7F22 - Process Program Directory Response**
```
Format:
{L:n
  PPID_1
  PPID_2
  ...
  PPID_n
}

Where:
- PPID: Process Program ID (A)
```

#### **S7F23 - Process Program Upload**
```
Format:
{L:3
  PPID
  PPBODY
  PPFORMAT
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
- PPFORMAT: Process Program Format (U1)
  - 0: ASCII
  - 1: Binary
  - 2: Structured
```

#### **S7F24 - Process Program Upload Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F25 - Process Program Status Request**
```
Format:
PPID

Where:
- PPID: Process Program ID (A)
```

#### **S7F26 - Process Program Status Response**
```
Format:
{L:3
  PPID
  PPSTATUS
  PPSIZE
}

Where:
- PPID: Process Program ID (A)
- PPSTATUS: Process Program Status (U1)
  - 0: Not exists
  - 1: Exists
  - 2: Active
  - 3: Paused
- PPSIZE: Process Program Size (U1, U2, U4)
```

#### **S7F27 - Process Program Execute**
```
Format:
{L:2
  PPID
  {L:n
    PARAMETER_1
    PARAMETER_2
    ...
    PARAMETER_n
  }
}

Where:
- PPID: Process Program ID (A)
- PARAMETER: Execution Parameters (any format)
```

#### **S7F28 - Process Program Execute Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F29 - Process Program Stop**
```
Format:
PPID

Where:
- PPID: Process Program ID (A)
```

#### **S7F30 - Process Program Stop Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F31 - Process Program Pause**
```
Format:
PPID

Where:
- PPID: Process Program ID (A)
```

#### **S7F32 - Process Program Pause Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F33 - Process Program Resume**
```
Format:
PPID

Where:
- PPID: Process Program ID (A)
```

#### **S7F34 - Process Program Resume Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F35 - Process Program Variable Request**
```
Format:
{L:2
  PPID
  {L:n
    PPVARID_1
    PPVARID_2
    ...
    PPVARID_n
  }
}

Where:
- PPID: Process Program ID (A)
- PPVARID: Process Program Variable ID (A)
```

#### **S7F36 - Process Program Variable Response**
```
Format:
{L:2
  PPID
  {L:n
    {L:2
      PPVARID
      PPVARVAL
    }
  }
}

Where:
- PPID: Process Program ID (A)
- PPVARID: Process Program Variable ID (A)
- PPVARVAL: Process Program Variable Value (any format)
```

#### **S7F37 - Process Program Variable Send**
```
Format:
{L:2
  PPID
  {L:n
    {L:2
      PPVARID
      PPVARVAL
    }
  }
}

Where:
- PPID: Process Program ID (A)
- PPVARID: Process Program Variable ID (A)
- PPVARVAL: Process Program Variable Value (any format)
```

#### **S7F38 - Process Program Variable Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

#### **S7F39 - Recipe Validation Request**
```
Format:
{L:2
  PPID
  PPBODY
}

Where:
- PPID: Process Program ID (A)
- PPBODY: Process Program Body (A or B)
```

#### **S7F40 - Recipe Validation Response**
```
Format:
{L:3
  PPID
  VALRESULT
  {L:n
    ERROR_1
    ERROR_2
    ...
    ERROR_n
  }
}

Where:
- PPID: Process Program ID (A)
- VALRESULT: Validation Result (B[1])
  - 0: Valid
  - 1: Invalid
- ERROR: Validation Error (A)
```

#### **S7F41 - Recipe Parameter Request**
```
Format:
{L:2
  PPID
  {L:n
    PARAMID_1
    PARAMID_2
    ...
    PARAMID_n
  }
}

Where:
- PPID: Process Program ID (A)
- PARAMID: Parameter ID (A)
```

#### **S7F42 - Recipe Parameter Response**
```
Format:
{L:2
  PPID
  {L:n
    {L:3
      PARAMID
      PARAMVAL
      PARAMUNIT
    }
  }
}

Where:
- PPID: Process Program ID (A)
- PARAMID: Parameter ID (A)
- PARAMVAL: Parameter Value (any format)
- PARAMUNIT: Parameter Unit (A)
```

#### **S7F43 - Recipe Parameter Set**
```
Format:
{L:2
  PPID
  {L:n
    {L:3
      PARAMID
      PARAMVAL
      PARAMUNIT
    }
  }
}

Where:
- PPID: Process Program ID (A)
- PARAMID: Parameter ID (A)
- PARAMVAL: Parameter Value (any format)
- PARAMUNIT: Parameter Unit (A)
```

#### **S7F44 - Recipe Parameter Set Acknowledge**
```
Format:
ACKC7

Where:
- ACKC7: Acknowledge Code (B[1])
  - 0: Accepted
  - 1: Permission not granted
  - 2: Length error
  - 3: Matrix overflow
  - 4: PPID not found
  - 5: Mode unsupported
  - 6: Communication not available
  - 7: Busy
```

### Stream 8: Control Program Management
**Purpose**: Control program and recipe management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S8F1](#s8f1---format-ecp)    | → Equipment | Format ECP |
| [S8F2](#s8f2---format-ecp-acknowledge)    | ← Equipment | Format ECP Acknowledge |
| [S8F3](#s8f3---ecp-data)    | → Equipment | ECP Data |
| [S8F4](#s8f4---ecp-data-acknowledge)    | ← Equipment | ECP Data Acknowledge |

#### **S8F1 - Format ECP** {#s8f1---format-ecp}
```
Format:
{L:2
  ECPID
  ECPBODY
}

Where:
- ECPID: Equipment Control Program ID (A)
- ECPBODY: Equipment Control Program Body (A or B)
```

#### **S8F2 - Format ECP Acknowledge** {#s8f2---format-ecp-acknowledge}
```
Format:
ACKC8

Where:
- ACKC8: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: ECP ID already exists
  - 3: No space available
```

#### **S8F3 - ECP Data** {#s8f3---ecp-data}
```
Format:
{L:2
  ECPID
  ECPBODY
}

Where:
- ECPID: Equipment Control Program ID (A)
- ECPBODY: Equipment Control Program Body (A or B)
```

#### **S8F4 - ECP Data Acknowledge** {#s8f4---ecp-data-acknowledge}
```
Format:
ACKC8

Where:
- ACKC8: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: ECP ID not found
  - 3: Format error
```

### Stream 9: System Errors
**Purpose**: Communication error reporting

| Message | Direction | Description |
|---------|-----------|-------------|
| [S9F1](#s9f1---unrecognized-device-id)    | ← Equipment | Unrecognized Device ID |
| [S9F3](#s9f3---unrecognized-stream-type)    | ← Equipment | Unrecognized Stream Type |
| [S9F5](#s9f5---unrecognized-function-type)    | ← Equipment | Unrecognized Function Type |
| [S9F7](#s9f7---illegal-data)    | ← Equipment | Illegal Data |
| [S9F9](#s9f9---transaction-timer-timeout)    | ← Equipment | Transaction Timer Timeout |
| [S9F11](#s9f11---data-too-long)   | ← Equipment | Data Too Long |
| [S9F13](#s9f13---conversation-timeout)   | ← Equipment | Conversation Timeout |

#### **S9F1 - Unrecognized Device ID** {#s9f1---unrecognized-device-id}
```
Format:
MHEAD

Where:
- MHEAD: Message Header (B[10])
  The complete 10-byte header of the unrecognized message
```

#### **S9F3 - Unrecognized Stream Type** {#s9f3---unrecognized-stream-type}
```
Format:
MHEAD

Where:
- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message with unrecognized stream type
```

#### **S9F5 - Unrecognized Function Type** {#s9f5---unrecognized-function-type}
```
Format:
MHEAD

Where:
- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message with unrecognized function type
```

#### **S9F7 - Illegal Data** {#s9f7---illegal-data}
```
Format:
MHEAD

Where:
- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message with illegal data
```

#### **S9F9 - Transaction Timer Timeout** {#s9f9---transaction-timer-timeout}
```
Format:
MHEAD

Where:
- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message that timed out
```

#### **S9F11 - Data Too Long** {#s9f11---data-too-long}
```
Format:
MHEAD

Where:
- MHEAD: Message Header (B[10])
  The complete 10-byte header of the message that was too long
```

#### **S9F13 - Conversation Timeout** {#s9f13---conversation-timeout}
```
Format:
{L:2
  MEXP
  EDID
}

Where:
- MEXP: Message Expected (B[1])
  - Stream and Function of the expected message
- EDID: Equipment ID (U1, U2, U4, or A)
  - ID of the equipment that timed out
```

### Stream 10: Terminal Services
**Purpose**: Operator interface communication

| Message | Direction | Description |
|---------|-----------|-------------|
| [S10F1](#s10f1---terminal-request)   | → Equipment | Terminal Request |
| [S10F2](#s10f2---terminal-response)   | ← Equipment | Terminal Response |
| [S10F3](#s10f3---terminal-display-single)   | → Equipment | Terminal Display, Single |
| [S10F5](#s10f5---terminal-display-multi-block)   | → Equipment | Terminal Display, Multi-Block |
| [S10F9](#s10f9---broadcast-display-request)   | → Equipment | Broadcast Display Request |
| [S10F10](#s10f10---broadcast-display-acknowledge)  | ← Equipment | Broadcast Display Acknowledge |

#### **S10F1 - Terminal Request** {#s10f1---terminal-request}
```
Format:
{L:2
  TID
  TEXT
}

Where:
- TID: Terminal ID (B[1])
- TEXT: Text Message (A)
```

#### **S10F2 - Terminal Response** {#s10f2---terminal-response}
```
Format:
{L:2
  TID
  TEXT
}

Where:
- TID: Terminal ID (B[1])
- TEXT: Response Text (A)
```

#### **S10F3 - Terminal Display, Single** {#s10f3---terminal-display-single}
```
Format:
{L:2
  TID
  TEXT
}

Where:
- TID: Terminal ID (B[1])
- TEXT: Display Text (A)
```

#### **S10F5 - Terminal Display, Multi-Block**
```
Format:
{L:2
  TID
  {L:n
    TEXT_1
    TEXT_2
    ...
    TEXT_n
  }
}

Where:
- TID: Terminal ID (B[1])
- TEXT: Display Text Lines (A)
```

#### **S10F9 - Broadcast Display Request**
```
Format:
TEXT

Where:
- TEXT: Broadcast Message (A)
```

#### **S10F10 - Broadcast Display Acknowledge**
```
Format:
ACKC10

Where:
- ACKC10: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

### Stream 12: Wafer Mapping
**Purpose**: Wafer map data handling

| Message | Direction | Description |
|---------|-----------|-------------|
| [S12F1](#s12f1---map-setup-data-send)   | → Equipment | Map Setup Data Send |
| [S12F2](#s12f2---map-setup-data-acknowledge)   | ← Equipment | Map Setup Data Acknowledge |
| [S12F3](#s12f3---map-setup-data-request)   | → Equipment | Map Setup Data Request |
| [S12F4](#s12f4---map-setup-data-response)   | ← Equipment | Map Setup Data Response |
| [S12F5](#s12f5---map-transmit-inquire)   | → Equipment | Map Transmit Inquire |
| [S12F6](#s12f6---map-transmit-grant)   | ← Equipment | Map Transmit Grant |
| [S12F7](#s12f7---map-data-send)   | → Equipment | Map Data Send |
| [S12F8](#s12f8---map-data-acknowledge)   | ← Equipment | Map Data Acknowledge |
| [S12F9](#s12f9---map-data-request)   | → Equipment | Map Data Request |
| [S12F10](#s12f10---map-data-response)  | ← Equipment | Map Data Response |
| [S12F11](#s12f11---map-data-request-2)  | → Equipment | Map Data Request 2 |
| [S12F12](#s12f12---map-data-response-2)  | ← Equipment | Map Data Response 2 |
| [S12F13](#s12f13---map-error-report)  | ← Equipment | Map Error Report |
| [S12F14](#s12f14---map-error-acknowledge)  | → Equipment | Map Error Acknowledge |
| [S12F15](#s12f15---map-sample-send)  | → Equipment | Map Sample Send |
| [S12F16](#s12f16---map-sample-acknowledge)  | ← Equipment | Map Sample Acknowledge |
| [S12F17](#s12f17---map-sample-request)  | → Equipment | Map Sample Request |
| [S12F18](#s12f18---map-sample-response)  | ← Equipment | Map Sample Response |
| [S12F19](#s12f19---map-update-send)  | → Equipment | Map Update Send |
| [S12F20](#s12f20---map-update-acknowledge)  | ← Equipment | Map Update Acknowledge |

#### **S12F1 - Map Setup Data Send** {#s12f1---map-setup-data-send}
```
Format:
{L:3
  MID
  IDTYP
  {L:n
    STRP_1
    STRP_2
    ...
    STRP_n
  }
}

Where:
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
  - 0: Wafer ID
  - 1: Die ID
- STRP: Map Strip Data (various formats)
```

#### **S12F2 - Map Setup Data Acknowledge**
```
Format:
ACKC12

Where:
- ACKC12: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Map ID already exists
  - 3: No space available
```

#### **S12F3 - Map Setup Data Request**
```
Format:
MID

Where:
- MID: Map ID (A)
```

#### **S12F4 - Map Setup Data Response**
```
Format:
{L:3
  MID
  IDTYP
  {L:n
    STRP_1
    STRP_2
    ...
    STRP_n
  }
}

Where:
- MID: Map ID (A)
- IDTYP: ID Type (B[1])
- STRP: Map Strip Data (various formats)
```

#### **S12F5 - Map Transmit Inquire**
```
Format:
{L:2
  MID
  DATALENGTH
}

Where:
- MID: Map ID (A)
- DATALENGTH: Expected Data Length (U1, U2, U4)
```

#### **S12F6 - Map Transmit Grant**
```
Format:
GRANT

Where:
- GRANT: Grant Code (B[1])
  - 0: Granted
  - 1: Busy, try again
  - 2: No space
  - 3: Map ID not found
```

#### **S12F7 - Map Data Send**
```
Format:
{L:2
  MID
  BINLT
}

Where:
- MID: Map ID (A)
- BINLT: Binary Map Data (B)
```

#### **S12F8 - Map Data Acknowledge**
```
Format:
ACKC12

Where:
- ACKC12: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Map ID not found
  - 3: Data format error
```

#### **S12F9 - Map Data Request**
```
Format:
MID

Where:
- MID: Map ID (A)
```

#### **S12F10 - Map Data Response**
```
Format:
{L:2
  MID
  BINLT
}

Where:
- MID: Map ID (A)
- BINLT: Binary Map Data (B)
```

#### **S12F13 - Map Error Report**
```
Format:
{L:3
  MID
  MERLOC
  MERDESCRP
}

Where:
- MID: Map ID (A)
- MERLOC: Map Error Location (U1, U2, U4)
- MERDESCRP: Map Error Description (A)
```

#### **S12F14 - Map Error Acknowledge**
```
Format:
ACKC12

Where:
- ACKC12: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
```

### Stream 13: Data Set Management
**Purpose**: Advanced data set handling and management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S13F1](#s13f1---data-set-upload-request)   | → Equipment | Data Set Upload Request |
| [S13F2](#s13f2---data-set-upload-response)   | ← Equipment | Data Set Upload Response |
| [S13F3](#s13f3---data-set-download-request)   | → Equipment | Data Set Download Request |
| [S13F4](#s13f4---data-set-download-response)   | ← Equipment | Data Set Download Response |
| [S13F5](#s13f5---data-set-directory-request)   | → Equipment | Data Set Directory Request |
| [S13F6](#s13f6---data-set-directory-response)   | ← Equipment | Data Set Directory Response |
| [S13F7](#s13f7---data-set-delete-request)   | → Equipment | Data Set Delete Request |
| [S13F8](#s13f8---data-set-delete-response)   | ← Equipment | Data Set Delete Response |

#### **S13F1 - Data Set Upload Request** {#s13f1---data-set-upload-request}
```
Format:
{L:3
  DSID
  DSNAME
  DSTYPE
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSNAME: Data Set Name (A)
- DSTYPE: Data Set Type (U1)
  - 0: Process data
  - 1: Equipment data
  - 2: Alarm data
  - 3: Event data
```

#### **S13F2 - Data Set Upload Response**
```
Format:
{L:2
  DSID
  DSACK
}

Where:
- DSID: Data Set ID (U1, U2, U4, or A)
- DSACK: Data Set Acknowledge (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Data set already exists
  - 3: No space available
```

### Stream 14: Object Services
**Purpose**: Object-oriented equipment control and management

| Message | Direction | Description |
|---------|-----------|-------------|
| [S14F1](#s14f1---object-request)   | → Equipment | Object Request |
| [S14F2](#s14f2---object-response)   | ← Equipment | Object Response |
| [S14F3](#s14f3---object-attribute-request)   | → Equipment | Object Attribute Request |
| [S14F4](#s14f4---object-attribute-response)   | ← Equipment | Object Attribute Response |
| [S14F5](#s14f5---object-attribute-set)   | → Equipment | Object Attribute Set |
| [S14F6](#s14f6---object-attribute-acknowledge)   | ← Equipment | Object Attribute Acknowledge |

#### **S14F1 - Object Request** {#s14f1---object-request}
```
Format:
{L:2
  OBJTYPE
  OBJID
}

Where:
- OBJTYPE: Object Type (A)
- OBJID: Object ID (A)
```

#### **S14F2 - Object Response**
```
Format:
{L:3
  OBJTYPE
  OBJID
  {L:n
    ATTRID_1
    ATTRID_2
    ...
    ATTRID_n
  }
}

Where:
- OBJTYPE: Object Type (A)
- OBJID: Object ID (A)
- ATTRID: Attribute ID (A)
```

### Stream 15: Recipe Management
**Purpose**: Advanced recipe handling and validation

| Message | Direction | Description |
|---------|-----------|-------------|
| [S15F1](#s15f1---recipe-upload-request)   | → Equipment | Recipe Upload Request |
| [S15F2](#s15f2---recipe-upload-response)   | ← Equipment | Recipe Upload Response |
| [S15F3](#s15f3---recipe-download-request)   | → Equipment | Recipe Download Request |
| [S15F4](#s15f4---recipe-download-response)   | ← Equipment | Recipe Download Response |
| [S15F5](#s15f5---recipe-validation-request)   | → Equipment | Recipe Validation Request |
| [S15F6](#s15f6---recipe-validation-response)   | ← Equipment | Recipe Validation Response |
| [S15F7](#s15f7---recipe-execute-request)   | → Equipment | Recipe Execute Request |
| [S15F8](#s15f8---recipe-execute-response)   | ← Equipment | Recipe Execute Response |

#### **S15F1 - Recipe Upload Request** {#s15f1---recipe-upload-request}
```
Format:
{L:3
  RECIPEID
  RECIPEBODY
  RECIPEFORMAT
}

Where:
- RECIPEID: Recipe ID (A)
- RECIPEBODY: Recipe Body (A or B)
- RECIPEFORMAT: Recipe Format (U1)
  - 0: ASCII
  - 1: Binary
  - 2: XML
```

#### **S15F2 - Recipe Upload Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Recipe already exists
  - 3: No space available
```

#### **S15F9 - Recipe Directory Request**
```
Format: <none> (empty data)
```

#### **S15F10 - Recipe Directory Response**
```
Format:
{L:n
  RECIPEID_1
  RECIPEID_2
  ...
  RECIPEID_n
}

Where:
- RECIPEID: Recipe ID (A)
```

#### **S15F11 - Recipe Delete Request**
```
Format:
{L:n
  RECIPEID_1
  RECIPEID_2
  ...
  RECIPEID_n
}

Where:
- RECIPEID: Recipe ID (A)
```

#### **S15F12 - Recipe Delete Response**
```
Format:
{L:n
  {L:2
    RECIPEID
    ACKC15
  }
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F13 - Recipe Parameter Request**
```
Format:
{L:2
  RECIPEID
  {L:n
    RCPPARNM_1
    RCPPARNM_2
    ...
    RCPPARNM_n
  }
}

Where:
- RECIPEID: Recipe ID (A)
- RCPPARNM: Recipe Parameter Name (A)
```

#### **S15F14 - Recipe Parameter Response**
```
Format:
{L:2
  RECIPEID
  {L:n
    {L:3
      RCPPARNM
      RCPPARVAL
      UNITS
    }
  }
}

Where:
- RECIPEID: Recipe ID (A)
- RCPPARNM: Recipe Parameter Name (A)
- RCPPARVAL: Recipe Parameter Value (various)
- UNITS: Units (A)
```

#### **S15F15 - Recipe Parameter Set**
```
Format:
{L:2
  RECIPEID
  {L:n
    {L:3
      RCPPARNM
      RCPPARVAL
      UNITS
    }
  }
}

Where:
- RECIPEID: Recipe ID (A)
- RCPPARNM: Recipe Parameter Name (A)
- RCPPARVAL: Recipe Parameter Value (various)
- UNITS: Units (A)
```

#### **S15F16 - Recipe Parameter Set Acknowledge**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F17 - Recipe Status Request**
```
Format:
RECIPEID

Where:
- RECIPEID: Recipe ID (A)
```

#### **S15F18 - Recipe Status Response**
```
Format:
{L:3
  RECIPEID
  RCPSTAT
  RCPVERS
}

Where:
- RECIPEID: Recipe ID (A)
- RCPSTAT: Recipe Status (U1)
  - 0: Not exists
  - 1: Available
  - 2: Active
  - 3: Paused
- RCPVERS: Recipe Version (A)
```

#### **S15F19 - Recipe Copy Request**
```
Format:
{L:2
  RECIPEID
  RCPNEWID
}

Where:
- RECIPEID: Recipe ID (A)
- RCPNEWID: Recipe New ID (A)
```

#### **S15F20 - Recipe Copy Response**
```
Format:
{L:2
  RCPNEWID
  ACKC15
}

Where:
- RCPNEWID: Recipe New ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F21 - Recipe Lock Request**
```
Format:
{L:2
  RECIPEID
  LOCKTYPE
}

Where:
- RECIPEID: Recipe ID (A)
- LOCKTYPE: Lock Type (U1)
  - 0: Unlock
  - 1: Read lock
  - 2: Write lock
  - 3: Exclusive lock
```

#### **S15F22 - Recipe Lock Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F23 - Recipe Attribute Request**
```
Format:
{L:2
  RECIPEID
  {L:n
    RCPATTRID_1
    RCPATTRID_2
    ...
    RCPATTRID_n
  }
}

Where:
- RECIPEID: Recipe ID (A)
- RCPATTRID: Recipe Attribute ID (A)
```

#### **S15F24 - Recipe Attribute Response**
```
Format:
{L:2
  RECIPEID
  {L:n
    {L:2
      RCPATTRID
      RCPATTRDATA
    }
  }
}

Where:
- RECIPEID: Recipe ID (A)
- RCPATTRID: Recipe Attribute ID (A)
- RCPATTRDATA: Recipe Attribute Data (various)
```

#### **S15F25 - Recipe Security Request**
```
Format:
{L:3
  RECIPEID
  RCPSECCODE
  ACCESSMODE
}

Where:
- RECIPEID: Recipe ID (A)
- RCPSECCODE: Recipe Security Code (A)
- ACCESSMODE: Access Mode (U1)
```

#### **S15F26 - Recipe Security Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F27 - Recipe Version Request**
```
Format:
RECIPEID

Where:
- RECIPEID: Recipe ID (A)
```

#### **S15F28 - Recipe Version Response**
```
Format:
{L:3
  RECIPEID
  RCPVERS
  {L:n
    VERSIONHISTORY_1
    VERSIONHISTORY_2
    ...
    VERSIONHISTORY_n
  }
}

Where:
- RECIPEID: Recipe ID (A)
- RCPVERS: Recipe Version (A)
- VERSIONHISTORY: Version History (A)
```

#### **S15F29 - Recipe Export Request**
```
Format:
{L:3
  RECIPEID
  EXPORTFORMAT
  EXPORTOPTIONS
}

Where:
- RECIPEID: Recipe ID (A)
- EXPORTFORMAT: Export Format (U1)
  - 0: Native
  - 1: XML
  - 2: JSON
- EXPORTOPTIONS: Export Options (various)
```

#### **S15F30 - Recipe Export Response**
```
Format:
{L:3
  RECIPEID
  EXPORTDATA
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- EXPORTDATA: Export Data (A or B)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F31 - Recipe Import Request**
```
Format:
{L:4
  RECIPEID
  IMPORTFORMAT
  IMPORTDATA
  IMPORTOPTIONS
}

Where:
- RECIPEID: Recipe ID (A)
- IMPORTFORMAT: Import Format (U1)
- IMPORTDATA: Import Data (A or B)
- IMPORTOPTIONS: Import Options (various)
```

#### **S15F32 - Recipe Import Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F33 - Recipe Template Request**
```
Format:
TEMPLATETYPE

Where:
- TEMPLATETYPE: Template Type (A)
```

#### **S15F34 - Recipe Template Response**
```
Format:
{L:3
  TEMPLATETYPE
  TEMPLATEBODY
  TEMPLATEFORMAT
}

Where:
- TEMPLATETYPE: Template Type (A)
- TEMPLATEBODY: Template Body (A or B)
- TEMPLATEFORMAT: Template Format (U1)
```

#### **S15F35 - Recipe Dependency Request**
```
Format:
RECIPEID

Where:
- RECIPEID: Recipe ID (A)
```

#### **S15F36 - Recipe Dependency Response**
```
Format:
{L:2
  RECIPEID
  {L:n
    DEPENDENCY_1
    DEPENDENCY_2
    ...
    DEPENDENCY_n
  }
}

Where:
- RECIPEID: Recipe ID (A)
- DEPENDENCY: Recipe Dependency (A)
```

#### **S15F37 - Recipe Schedule Request**
```
Format:
{L:3
  RECIPEID
  SCHEDULETIME
  SCHEDULETYPE
}

Where:
- RECIPEID: Recipe ID (A)
- SCHEDULETIME: Schedule Time (A)
- SCHEDULETYPE: Schedule Type (U1)
```

#### **S15F38 - Recipe Schedule Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F39 - Recipe Optimization Request**
```
Format:
{L:3
  RECIPEID
  OPTIMIZATIONTYPE
  OPTIMIZATIONPARAMS
}

Where:
- RECIPEID: Recipe ID (A)
- OPTIMIZATIONTYPE: Optimization Type (U1)
- OPTIMIZATIONPARAMS: Optimization Parameters (various)
```

#### **S15F40 - Recipe Optimization Response**
```
Format:
{L:3
  RECIPEID
  OPTIMIZEDRECIPE
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- OPTIMIZEDRECIPE: Optimized Recipe (A or B)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F41 - Recipe Simulation Request**
```
Format:
{L:3
  RECIPEID
  SIMULATIONPARAMS
  SIMULATIONTYPE
}

Where:
- RECIPEID: Recipe ID (A)
- SIMULATIONPARAMS: Simulation Parameters (various)
- SIMULATIONTYPE: Simulation Type (U1)
```

#### **S15F42 - Recipe Simulation Response**
```
Format:
{L:3
  RECIPEID
  SIMULATIONRESULTS
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- SIMULATIONRESULTS: Simulation Results (various)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F43 - Recipe Checkpoint Request**
```
Format:
{L:2
  RECIPEID
  CHECKPOINTNAME
}

Where:
- RECIPEID: Recipe ID (A)
- CHECKPOINTNAME: Checkpoint Name (A)
```

#### **S15F44 - Recipe Checkpoint Response**
```
Format:
{L:3
  RECIPEID
  CHECKPOINTDATA
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- CHECKPOINTDATA: Checkpoint Data (various)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F45 - Recipe Resume Request**
```
Format:
{L:2
  RECIPEID
  CHECKPOINTNAME
}

Where:
- RECIPEID: Recipe ID (A)
- CHECKPOINTNAME: Checkpoint Name (A)
```

#### **S15F46 - Recipe Resume Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F47 - Recipe Performance Request**
```
Format:
{L:2
  RECIPEID
  PERFORMANCEMETRICS
}

Where:
- RECIPEID: Recipe ID (A)
- PERFORMANCEMETRICS: Performance Metrics (various)
```

#### **S15F48 - Recipe Performance Response**
```
Format:
{L:3
  RECIPEID
  PERFORMANCEDATA
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- PERFORMANCEDATA: Performance Data (various)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F49 - Recipe Audit Request**
```
Format:
{L:3
  RECIPEID
  AUDITTYPE
  AUDITPARAMS
}

Where:
- RECIPEID: Recipe ID (A)
- AUDITTYPE: Audit Type (U1)
- AUDITPARAMS: Audit Parameters (various)
```

#### **S15F50 - Recipe Audit Response**
```
Format:
{L:3
  RECIPEID
  AUDITRESULTS
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- AUDITRESULTS: Audit Results (various)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F51 - Recipe Backup Request**
```
Format:
{L:3
  RECIPEID
  BACKUPTYPE
  BACKUPPARAMS
}

Where:
- RECIPEID: Recipe ID (A)
- BACKUPTYPE: Backup Type (U1)
- BACKUPPARAMS: Backup Parameters (various)
```

#### **S15F52 - Recipe Backup Response**
```
Format:
{L:3
  RECIPEID
  BACKUPDATA
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- BACKUPDATA: Backup Data (B)
- ACKC15: Acknowledge Code (B[1])
```

#### **S15F53 - Recipe Restore Request**
```
Format:
{L:3
  RECIPEID
  RESTOREDATA
  RESTOREOPTIONS
}

Where:
- RECIPEID: Recipe ID (A)
- RESTOREDATA: Restore Data (B)
- RESTOREOPTIONS: Restore Options (various)
```

#### **S15F54 - Recipe Restore Response**
```
Format:
{L:2
  RECIPEID
  ACKC15
}

Where:
- RECIPEID: Recipe ID (A)
- ACKC15: Acknowledge Code (B[1])
```

### Stream 16: Processing Management
**Purpose**: Process control and monitoring

| Message | Direction | Description |
|---------|-----------|-------------|
| [S16F1](#s16f1---process-start-request)   | → Equipment | Process Start Request |
| [S16F2](#s16f2---process-start-response)   | ← Equipment | Process Start Response |
| [S16F3](#s16f3---process-stop-request)   | → Equipment | Process Stop Request |
| [S16F4](#s16f4---process-stop-response)   | ← Equipment | Process Stop Response |
| [S16F5](#s16f5---process-status-request)   | → Equipment | Process Status Request |
| [S16F6](#s16f6---process-status-response)   | ← Equipment | Process Status Response |
| [S16F7](#s16f7---process-parameter-request)   | → Equipment | Process Parameter Request |
| [S16F8](#s16f8---process-parameter-response)   | ← Equipment | Process Parameter Response |
| [S16F9](#s16f9---process-job-status-request)   | → Equipment | Process Job Status Request |
| [S16F10](#s16f10---process-job-status-response)  | ← Equipment | Process Job Status Response |
| [S16F11](#s16f11---process-job-priority-request)  | → Equipment | Process Job Priority Request |
| [S16F12](#s16f12---process-job-priority-response)  | ← Equipment | Process Job Priority Response |
| [S16F13](#s16f13---process-job-queue-request)  | → Equipment | Process Job Queue Request |
| [S16F14](#s16f14---process-job-queue-response)  | ← Equipment | Process Job Queue Response |
| [S16F15](#s16f15---process-step-control-request)  | → Equipment | Process Step Control Request |
| [S16F16](#s16f16---process-step-control-response)  | ← Equipment | Process Step Control Response |
| [S16F17](#s16f17---process-data-request)  | → Equipment | Process Data Request |
| [S16F18](#s16f18---process-data-response)  | ← Equipment | Process Data Response |
| [S16F19](#s16f19---process-recipe-request)  | → Equipment | Process Recipe Request |
| [S16F20](#s16f20---process-recipe-response)  | ← Equipment | Process Recipe Response |
| [S16F21](#s16f21---process-material-request)  | → Equipment | Process Material Request |
| [S16F22](#s16f22---process-material-response)  | ← Equipment | Process Material Response |
| [S16F23](#s16f23---process-resource-request)  | → Equipment | Process Resource Request |
| [S16F24](#s16f24---process-resource-response)  | ← Equipment | Process Resource Response |
| [S16F25](#s16f25---process-event-report)  | → Equipment | Process Event Report |
| [S16F26](#s16f26---process-event-acknowledge)  | ← Equipment | Process Event Acknowledge |
| [S16F27](#s16f27---process-log-request)  | → Equipment | Process Log Request |
| [S16F28](#s16f28---process-log-response)  | ← Equipment | Process Log Response |
| [S16F29](#s16f29---process-control-request)  | → Equipment | Process Control Request |
| [S16F30](#s16f30---process-control-response)  | ← Equipment | Process Control Response |

#### **S16F1 - Process Start Request** {#s16f1---process-start-request}
```
Format:
{L:2
  PROCESSID
  {L:n
    PARAMETER_1
    PARAMETER_2
    ...
    PARAMETER_n
  }
}

Where:
- PROCESSID: Process ID (A)
- PARAMETER: Process Parameters (any format)
```

#### **S16F2 - Process Start Response**
```
Format:
{L:2
  PROCESSID
  ACKC16
}

Where:
- PROCESSID: Process ID (A)
- ACKC16: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Process not found
  - 3: Equipment busy
```

#### **S16F3 - Process Stop Request**
```
Format:
PROCESSID

Where:
- PROCESSID: Process ID (A)
```

#### **S16F4 - Process Stop Response**
```
Format:
{L:2
  PROCESSID
  ACKC16
}

Where:
- PROCESSID: Process ID (A)
- ACKC16: Acknowledge Code (B[1])
```

#### **S16F5 - Process Status Request**
```
Format:
PROCESSID

Where:
- PROCESSID: Process ID (A)
```

#### **S16F6 - Process Status Response**
```
Format:
{L:3
  PROCESSID
  PRSTAT
  PRDATA
}

Where:
- PROCESSID: Process ID (A)
- PRSTAT: Process Status (U1)
- PRDATA: Process Data (various)
```

#### **S16F7 - Process Parameter Request**
```
Format:
{L:2
  PROCESSID
  {L:n
    PRPARNM_1
    PRPARNM_2
    ...
    PRPARNM_n
  }
}

Where:
- PROCESSID: Process ID (A)
- PRPARNM: Process Parameter Name (A)
```

#### **S16F8 - Process Parameter Response**
```
Format:
{L:2
  PROCESSID
  {L:n
    {L:3
      PRPARNM
      PRPARVAL
      UNITS
    }
  }
}

Where:
- PROCESSID: Process ID (A)
- PRPARNM: Process Parameter Name (A)
- PRPARVAL: Process Parameter Value (various)
- UNITS: Units (A)
```

#### **S16F9 - Process Job Status Request**
```
Format:
PJOBID

Where:
- PJOBID: Process Job ID (A)
```

#### **S16F10 - Process Job Status Response**
```
Format:
{L:4
  PJOBID
  PJOBST
  PRPROCESSTIME
  PRREMTIME
}

Where:
- PJOBID: Process Job ID (A)
- PJOBST: Process Job State (U1)
- PRPROCESSTIME: Process Time (U4)
- PRREMTIME: Remaining Time (U4)
```

#### **S16F11 - Process Job Priority Request**
```
Format:
{L:2
  PJOBID
  PRIORITY
}

Where:
- PJOBID: Process Job ID (A)
- PRIORITY: Priority (U1)
```

#### **S16F12 - Process Job Priority Response**
Format:
{L:2
  PJOBID
  ACKC16
}

Where:
- PJOBID: Process Job ID (A)
- ACKC16: Acknowledge Code (B[1])
```

#### **S16F13 - Process Job Queue Request**
```
Format: <none> (empty data)
```

#### **S16F14 - Process Job Queue Response**
```
Format:
{L:n
  {L:3
    PJOBID
    PRIORITY
    PJOBST
  }
}

Where:
- PJOBID: Process Job ID (A)
- PRIORITY: Priority (U1)
- PJOBST: Process Job State (U1)
```

#### **S16F15 - Process Step Control Request**
```
Format:
{L:3
  PJOBID
  STEPID
  STEPCONTROL
}

Where:
- PJOBID: Process Job ID (A)
- STEPID: Step ID (A)
- STEPCONTROL: Step Control (U1)
```

#### **S16F16 - Process Step Control Response**
```
Format:
{L:3
  PJOBID
  STEPID
  ACKC16
}

Where:
- PJOBID: Process Job ID (A)
- STEPID: Step ID (A)
- ACKC16: Acknowledge Code (B[1])
```

#### **S16F17 - Process Data Request**
```
Format:
{L:2
  PJOBID
  {L:n
    DATAID_1
    DATAID_2
    ...
    DATAID_n
  }
}

Where:
- PJOBID: Process Job ID (A)
- DATAID: Data ID (A)
```

#### **S16F18 - Process Data Response**
```
Format:
{L:2
  PJOBID
  {L:n
    {L:3
      DATAID
      DATAVALUE
      UNITS
    }
  }
}

Where:
- PJOBID: Process Job ID (A)
- DATAID: Data ID (A)
- DATAVALUE: Data Value (various)
- UNITS: Units (A)
```

#### **S16F19 - Process Recipe Request**
```
Format:
{L:2
  PJOBID
  RECIPEID
}

Where:
- PJOBID: Process Job ID (A)
- RECIPEID: Recipe ID (A)
```

#### **S16F20 - Process Recipe Response**
```
Format:
{L:2
  PJOBID
  ACKC16
}

Where:
- PJOBID: Process Job ID (A)
- ACKC16: Acknowledge Code (B[1])
```

#### **S16F21 - Process Material Request**
```
Format:
{L:2
  PJOBID
  {L:n
    MATID_1
    MATID_2
    ...
    MATID_n
  }
}

Where:
- PJOBID: Process Job ID (A)
- MATID: Material ID (A)
```

#### **S16F22 - Process Material Response**
```
Format:
{L:2
  PJOBID
  {L:n
    {L:3
      MATID
      MATSTATUS
      MATDATA
    }
  }
}

Where:
- PJOBID: Process Job ID (A)
- MATID: Material ID (A)
- MATSTATUS: Material Status (U1)
- MATDATA: Material Data (various)
```

#### **S16F23 - Process Resource Request**
```
Format:
{L:2
  PJOBID
  {L:n
    RESOURCEID_1
    RESOURCEID_2
    ...
    RESOURCEID_n
  }
}

Where:
- PJOBID: Process Job ID (A)
- RESOURCEID: Resource ID (A)
```

#### **S16F24 - Process Resource Response**
```
Format:
{L:2
  PJOBID
  {L:n
    {L:3
      RESOURCEID
      RESOURCESTATUS
      RESOURCEDATA
    }
  }
}

Where:
- PJOBID: Process Job ID (A)
- RESOURCEID: Resource ID (A)
- RESOURCESTATUS: Resource Status (U1)
- RESOURCEDATA: Resource Data (various)
```

#### **S16F25 - Process Event Report**
```
Format:
{L:4
  PJOBID
  EVENTTYPE
  EVENTDATA
  TIME
}

Where:
- PJOBID: Process Job ID (A)
- EVENTTYPE: Event Type (U1)
- EVENTDATA: Event Data (various)
- TIME: Timestamp (A)
```

#### **S16F26 - Process Event Acknowledge**
```
Format:
{L:2
  PJOBID
  ACKC16
}

Where:
- PJOBID: Process Job ID (A)
- ACKC16: Acknowledge Code (B[1])
```

#### **S16F27 - Process Log Request**
```
Format:
{L:3
  PJOBID
  STARTTIME
  ENDTIME
}

Where:
- PJOBID: Process Job ID (A)
- STARTTIME: Start Time (A)
- ENDTIME: End Time (A)
```

#### **S16F28 - Process Log Response**
```
Format:
{L:2
  PJOBID
  {L:n
    {L:4
      TIME
      LOGTYPE
      LOGDATA
      SEVERITY
    }
  }
}

Where:
- PJOBID: Process Job ID (A)
- TIME: Timestamp (A)
- LOGTYPE: Log Type (U1)
- LOGDATA: Log Data (A)
- SEVERITY: Severity Level (U1)
```

#### **S16F29 - Process Control Request**
```
Format:
{L:3
  PJOBID
  CONTROLTYPE
  CONTROLDATA
}

Where:
- PJOBID: Process Job ID (A)
- CONTROLTYPE: Control Type (U1)
- CONTROLDATA: Control Data (various)
```

#### **S16F30 - Process Control Response**
```
Format:
{L:2
  PJOBID
  ACKC16
}

Where:
- PJOBID: Process Job ID (A)
- ACKC16: Acknowledge Code (B[1])
```

### Stream 17: Clock Management
**Purpose**: Time synchronization and clock control

| Message | Direction | Description |
|---------|-----------|-------------|
| [S17F1](#s17f1---clock-set-request)   | → Equipment | Clock Set Request |
| [S17F2](#s17f2---clock-set-response)   | ← Equipment | Clock Set Response |
| [S17F3](#s17f3---clock-read-request)   | → Equipment | Clock Read Request |
| [S17F4](#s17f4---clock-read-response)   | ← Equipment | Clock Read Response |
| [S17F5](#s17f5---time-zone-set-request)   | → Equipment | Time Zone Set Request |
| [S17F6](#s17f6---time-zone-set-response)   | ← Equipment | Time Zone Set Response |

#### **S17F1 - Clock Set Request** {#s17f1---clock-set-request}
```
Format:
{L:2
  CLOCK
  TIMEZONE
}

Where:
- CLOCK: Clock Time (A[19]) format: "YYYY-MM-DD HH:MM:SS"
- TIMEZONE: Time Zone (A)
```

#### **S17F2 - Clock Set Response**
```
Format:
ACKC17

Where:
- ACKC17: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid time format
```

### Stream 18: Data Collection Management
**Purpose**: Advanced data collection configuration

| Message | Direction | Description |
|---------|-----------|-------------|
| S18F1   | → Equipment | Data Collection Setup |
| S18F2   | ← Equipment | Data Collection Setup Response |
| S18F3   | → Equipment | Data Collection Start |
| S18F4   | ← Equipment | Data Collection Start Response |
| S18F5   | → Equipment | Data Collection Stop |
| S18F6   | ← Equipment | Data Collection Stop Response |

#### **S18F1 - Data Collection Setup**
```
Format:
{L:3
  DCID
  DCPLAN
  {L:n
    VID_1
    VID_2
    ...
    VID_n
  }
}

Where:
- DCID: Data Collection ID (A)
- DCPLAN: Data Collection Plan (A)
- VID: Variable ID (U1, U2, U4, or A)
```

#### **S18F2 - Data Collection Setup Response**
```
Format:
{L:2
  DCID
  ACKC18
}

Where:
- DCID: Data Collection ID (A)
- ACKC18: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid plan
```

### Stream 19: Inventory Management
**Purpose**: Equipment and material inventory tracking

| Message | Direction | Description |
|---------|-----------|-------------|
| S19F1   | → Equipment | Inventory Request |
| S19F2   | ← Equipment | Inventory Response |
| S19F3   | → Equipment | Inventory Update |
| S19F4   | ← Equipment | Inventory Update Response |
| S19F5   | → Equipment | Inventory Add Request |
| S19F6   | ← Equipment | Inventory Add Response |
| S19F7   | → Equipment | Inventory Remove Request |
| S19F8   | ← Equipment | Inventory Remove Response |
| S19F9   | → Equipment | Inventory Status Request |
| S19F10  | ← Equipment | Inventory Status Response |
| S19F11  | → Equipment | Inventory Move Request |
| S19F12  | ← Equipment | Inventory Move Response |
| S19F13  | → Equipment | Inventory Search Request |
| S19F14  | ← Equipment | Inventory Search Response |
| S19F15  | → Equipment | Inventory Lock Request |
| S19F16  | ← Equipment | Inventory Lock Response |
| S19F17  | → Equipment | Inventory History Request |
| S19F18  | ← Equipment | Inventory History Response |
| S19F19  | → Equipment | Inventory Audit Request |
| S19F20  | ← Equipment | Inventory Audit Response |

#### **S19F1 - Inventory Request**
```
Format:
{L:n
  INVTYPE_1
  INVTYPE_2
  ...
  INVTYPE_n
}

Where:
- INVTYPE: Inventory Type (A)
  - "SUBSTRATE": Substrate inventory
  - "CARRIER": Carrier inventory
  - "TOOL": Tool inventory
```

#### **S19F2 - Inventory Response**
```
Format:
{L:n
  {L:3
    INVTYPE
    INVID
    INVDATA
  }
}

Where:
- INVTYPE: Inventory Type (A)
- INVID: Inventory ID (A)
- INVDATA: Inventory Data (any format)
```

#### **S19F3 - Inventory Update**
```
Format:
{L:3
  INVTYPE
  INVID
  INVDATA
}

Where:
- INVTYPE: Inventory Type (A)
- INVID: Inventory ID (A)
- INVDATA: Inventory Data (any format)
```

#### **S19F4 - Inventory Update Response**
```
Format:
{L:2
  INVID
  ACKC19
}

Where:
- INVID: Inventory ID (A)
- ACKC19: Acknowledge Code (B[1])
```

#### **S19F5 - Inventory Add Request**
```
Format:
{L:4
  INVTYPE
  INVID
  INVDATA
  LOCATION
}

Where:
- INVTYPE: Inventory Type (A)
- INVID: Inventory ID (A)
- INVDATA: Inventory Data (any format)
- LOCATION: Location (A)
```

#### **S19F6 - Inventory Add Response**
```
Format:
{L:2
  INVID
  ACKC19
}

Where:
- INVID: Inventory ID (A)
- ACKC19: Acknowledge Code (B[1])
```

#### **S19F7 - Inventory Remove Request**
```
Format:
{L:2
  INVTYPE
  INVID
}

Where:
- INVTYPE: Inventory Type (A)
- INVID: Inventory ID (A)
```

#### **S19F8 - Inventory Remove Response**
```
Format:
{L:2
  INVID
  ACKC19
}

Where:
- INVID: Inventory ID (A)
- ACKC19: Acknowledge Code (B[1])
```

#### **S19F9 - Inventory Status Request**
```
Format:
INVID

Where:
- INVID: Inventory ID (A)
```

#### **S19F10 - Inventory Status Response**
```
Format:
{L:4
  INVID
  INVSTATUS
  LOCATION
  INVDATA
}

Where:
- INVID: Inventory ID (A)
- INVSTATUS: Inventory Status (U1)
- LOCATION: Location (A)
- INVDATA: Inventory Data (any format)
```

#### **S19F11 - Inventory Move Request**
```
Format:
{L:3
  INVID
  SRCLOCATION
  DESTLOCATION
}

Where:
- INVID: Inventory ID (A)
- SRCLOCATION: Source Location (A)
- DESTLOCATION: Destination Location (A)
```

#### **S19F12 - Inventory Move Response**
```
Format:
{L:2
  INVID
  ACKC19
}

Where:
- INVID: Inventory ID (A)
- ACKC19: Acknowledge Code (B[1])
```

#### **S19F13 - Inventory Search Request**
```
Format:
{L:3
  INVTYPE
  SEARCHCRITERIA
  SEARCHOPTIONS
}

Where:
- INVTYPE: Inventory Type (A)
- SEARCHCRITERIA: Search Criteria (any format)
- SEARCHOPTIONS: Search Options (any format)
```

#### **S19F14 - Inventory Search Response**
```
Format:
{L:n
  {L:4
    INVID
    INVTYPE
    LOCATION
    INVDATA
  }
}

Where:
- INVID: Inventory ID (A)
- INVTYPE: Inventory Type (A)
- LOCATION: Location (A)
- INVDATA: Inventory Data (any format)
```

#### **S19F15 - Inventory Lock Request**
```
Format:
{L:3
  INVID
  LOCKTYPE
  LOCKDURATION
}

Where:
- INVID: Inventory ID (A)
- LOCKTYPE: Lock Type (U1)
- LOCKDURATION: Lock Duration (U4)
```

#### **S19F16 - Inventory Lock Response**
```
Format:
{L:2
  INVID
  ACKC19
}

Where:
- INVID: Inventory ID (A)
- ACKC19: Acknowledge Code (B[1])
```

#### **S19F17 - Inventory History Request**
```
Format:
{L:3
  INVID
  STARTTIME
  ENDTIME
}

Where:
- INVID: Inventory ID (A)
- STARTTIME: Start Time (A)
- ENDTIME: End Time (A)
```

#### **S19F18 - Inventory History Response**
```
Format:
{L:2
  INVID
  {L:n
    {L:4
      TIME
      ACTION
      LOCATION
      INVDATA
    }
  }
}

Where:
- INVID: Inventory ID (A)
- TIME: Timestamp (A)
- ACTION: Action Type (A)
- LOCATION: Location (A)
- INVDATA: Inventory Data (any format)
```

#### **S19F19 - Inventory Audit Request**
```
Format:
{L:2
  INVTYPE
  AUDITTYPE
}

Where:
- INVTYPE: Inventory Type (A)
- AUDITTYPE: Audit Type (U1)
```

#### **S19F20 - Inventory Audit Response**
```
Format:
{L:3
  INVTYPE
  AUDITRESULTS
  ACKC19
}

Where:
- INVTYPE: Inventory Type (A)
- AUDITRESULTS: Audit Results (any format)
- ACKC19: Acknowledge Code (B[1])
```

### Stream 20: Substrate Transfer (SEMI-E157)
**Purpose**: Advanced substrate transfer operations

| Message | Direction | Description |
|---------|-----------|-------------|
| [S20F1](#s20f1---transfer-request)   | → Equipment | Transfer Request |
| [S20F2](#s20f2---transfer-response)   | ← Equipment | Transfer Response |
| [S20F3](#s20f3---transfer-status-request)   | → Equipment | Transfer Status Request |
| [S20F4](#s20f4---transfer-status-response)   | ← Equipment | Transfer Status Response |
| [S20F5](#s20f5---transfer-abort-request)   | → Equipment | Transfer Abort Request |
| [S20F6](#s20f6---transfer-abort-response)   | ← Equipment | Transfer Abort Response |
| [S20F7](#s20f7---transfer-pause-request)   | → Equipment | Transfer Pause Request |
| [S20F8](#s20f8---transfer-pause-response)   | ← Equipment | Transfer Pause Response |
| [S20F9](#s20f9---transfer-resume-request)   | → Equipment | Transfer Resume Request |
| [S20F10](#s20f10---transfer-resume-response)  | ← Equipment | Transfer Resume Response |
| [S20F11](#s20f11---transfer-queue-request)  | → Equipment | Transfer Queue Request |
| [S20F12](#s20f12---transfer-queue-response)  | ← Equipment | Transfer Queue Response |
| [S20F13](#s20f13---transfer-priority-request)  | → Equipment | Transfer Priority Request |
| [S20F14](#s20f14---transfer-priority-response)  | ← Equipment | Transfer Priority Response |
| [S20F15](#s20f15---transfer-route-request)  | → Equipment | Transfer Route Request |
| [S20F16](#s20f16---transfer-route-response)  | ← Equipment | Transfer Route Response |
| [S20F17](#s20f17---transfer-schedule-request)  | → Equipment | Transfer Schedule Request |
| [S20F18](#s20f18---transfer-schedule-response)  | ← Equipment | Transfer Schedule Response |
| [S20F19](#s20f19---transfer-log-request)  | → Equipment | Transfer Log Request |
| [S20F20](#s20f20---transfer-log-response)  | ← Equipment | Transfer Log Response |
| [S20F21](#s20f21---transfer-config-request)  | → Equipment | Transfer Config Request |
| [S20F22](#s20f22---transfer-config-response)  | ← Equipment | Transfer Config Response |
| [S20F23](#s20f23---transfer-monitor-request)  | → Equipment | Transfer Monitor Request |
| [S20F24](#s20f24---transfer-monitor-response)  | ← Equipment | Transfer Monitor Response |
| [S20F25](#s20f25---transfer-resource-request)  | → Equipment | Transfer Resource Request |
| [S20F26](#s20f26---transfer-resource-response)  | ← Equipment | Transfer Resource Response |
| [S20F27](#s20f27---transfer-event-report)  | → Equipment | Transfer Event Report |
| [S20F28](#s20f28---transfer-event-acknowledge)  | ← Equipment | Transfer Event Acknowledge |
| [S20F29](#s20f29---transfer-optimization-request)  | → Equipment | Transfer Optimization Request |
| [S20F30](#s20f30---transfer-optimization-response)  | ← Equipment | Transfer Optimization Response |
| [S20F31](#s20f31---transfer-history-request)  | → Equipment | Transfer History Request |
| [S20F32](#s20f32---transfer-history-response)  | ← Equipment | Transfer History Response |
| [S20F33](#s20f33---transfer-performance-request)  | → Equipment | Transfer Performance Request |
| [S20F34](#s20f34---transfer-performance-response)  | ← Equipment | Transfer Performance Response |

#### **S20F1 - Transfer Request** {#s20f1---transfer-request}
```
Format:
{L:4
  TRANSFERID
  SOURCEID
  DESTID
  TRANSFERTYPE
}

Where:
- TRANSFERID: Transfer ID (A)
- SOURCEID: Source Location ID (A)
- DESTID: Destination Location ID (A)
- TRANSFERTYPE: Transfer Type (U1)
  - 0: Move
  - 1: Copy
  - 2: Exchange
```

#### **S20F2 - Transfer Response** {#s20f2---transfer-response}
```
Format:
{L:2
  TRANSFERID
  ACKC20
}

Where:
- TRANSFERID: Transfer ID (A)
- ACKC20: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid location
  - 3: Transfer not possible
```

### Stream 21: Material Transfer Management
**Purpose**: High-level material transfer coordination

| Message | Direction | Description |
|---------|-----------|-------------|
| S21F1   | → Equipment | Material Transfer Plan |
| S21F2   | ← Equipment | Material Transfer Plan Response |
| S21F3   | → Equipment | Material Transfer Execute |
| S21F4   | ← Equipment | Material Transfer Execute Response |
| S21F5   | → Equipment | Material Tracking Request |
| S21F6   | ← Equipment | Material Tracking Response |
| S21F7   | → Equipment | Material Location Request |
| S21F8   | ← Equipment | Material Location Response |
| S21F9   | → Equipment | Material History Request |
| S21F10  | ← Equipment | Material History Response |
| S21F11  | → Equipment | Material Routing Request |
| S21F12  | ← Equipment | Material Routing Response |
| S21F13  | → Equipment | Material Processing Request |
| S21F14  | ← Equipment | Material Processing Response |
| S21F15  | → Equipment | Material Quality Request |
| S21F16  | ← Equipment | Material Quality Response |
| S21F17  | → Equipment | Material Recipe Request |
| S21F18  | ← Equipment | Material Recipe Response |
| S21F19  | → Equipment | Material Event Report |
| S21F20  | ← Equipment | Material Event Acknowledge |

#### **S21F1 - Material Transfer Plan**
```
Format:
{L:3
  PLANID
  {L:n
    {L:3
      MATERIALID
      SOURCEID
      DESTID
    }
  }
  PRIORITY
}

Where:
- PLANID: Plan ID (A)
- MATERIALID: Material ID (A)
- SOURCEID: Source Location ID (A)
- DESTID: Destination Location ID (A)
- PRIORITY: Priority Level (U1)
  - 0: Low
  - 1: Normal
  - 2: High
  - 3: Critical
```

#### **S21F2 - Material Transfer Plan Response**
```
Format:
{L:2
  PLANID
  ACKC21
}

Where:
- PLANID: Plan ID (A)
- ACKC21: Acknowledge Code (B[1])
  - 0: Acknowledged
  - 1: Error
  - 2: Invalid plan
  - 3: Resource conflict
```

## Message Categories

### Equipment Status (Stream 1)
- Basic communication establishment
- Equipment state monitoring
- Online/Offline control

### Equipment Control (Stream 2)
- Configuration management
- Time synchronization
- Event reporting setup

### Material Management (Streams 3-4)
- Carrier and substrate tracking
- Transfer job management
- Material handling control

### Exception Handling (Stream 5)
- Alarm management
- Exception reporting
- Error notification

### Data Collection (Stream 6)
- Process data gathering
- Event monitoring
- Trace data collection

### Program Management (Stream 7)
- Recipe management
- Process program control
- EPPD handling

### System Services (Streams 9-10)
- Error reporting
- Terminal communication
- System diagnostics

### Advanced Features (Streams 12+)
- Wafer mapping
- Object services
- Recipe management
- Processing control

## Common Message Examples

### S1F13 - Establish Communications Request
```
Hex Format:
Length: 00 00 00 0C (12 bytes)
Header: 00 00 81 0D 00 00 xx xx xx xx
Data:   01 00 (empty list)

SECS-II Format:
{L:0}  // Empty list
```

### S1F14 - Establish Communications Response
```
Hex Format:
Length: 00 00 00 0D (13 bytes)  
Header: 00 00 01 0E 00 00 xx xx xx xx
Data:   21 01 00 (COMMACK = 0, accepted)

SECS-II Format:
COMMACK = B[1] = 0  // Communication accepted

Or with model info:
{L:2
  COMMACK = B[1] = 0
  {L:2
    MDLN = A[20] = "EQUIPMENT_MODEL_NAME"
    SOFTREV = A[20] = "SOFTWARE_VERSION_1.0"
  }
}
```

### S1F1 - Are You There Request
```
Hex Format:
Length: 00 00 00 0A (10 bytes)
Header: 00 00 81 01 00 00 xx xx xx xx
Data:   (empty)

SECS-II Format:
<none> (no data)
```

### S1F2 - Are You There Response  
```
Hex Format:
Length: 00 00 00 0A (10 bytes)
Header: 00 00 01 02 00 00 xx xx xx xx
Data:   (empty)

SECS-II Format:
<none> (no data) or {L:0} (empty list)
```

### S5F1 - Alarm Report Example
```
Hex Format:
Length: 00 00 00 1F (31 bytes)
Header: 00 00 05 01 00 00 xx xx xx xx
Data:   01 03 81 01 81 A1 01 01 41 0F Temperature Alarm

SECS-II Format:
{L:3
  ALCD = B[1] = 129 (0x81) // Alarm Set + Alarm Type
  ALID = U1[1] = 1
  ALTX = A[15] = "Temperature Alarm"
}
```

### S6F11 - Event Report Example
```
SECS-II Format:
{L:3
  DATAID = U4[1] = 12345
  CEID = U2[1] = 1001
  {L:1
    {L:3
      RPTID = U2[1] = 2001
      {L:2
        Temperature = F4[1] = 25.5
        Pressure = F4[1] = 760.0
      }
    }
  }
}
```

### Data Type Format Examples
```
ASCII Text:    A[10] = "TEST_VALUE"
                Hex: 41 0A 54 45 53 54 5F 56 41 4C 55 45

Binary Data:   B[4] = 0x12345678
                Hex: 21 04 12 34 56 78

Unsigned Int:  U1[1] = 255
                Hex: F1 01 FF

               U2[1] = 65535
                Hex: E1 02 FF FF

               U4[1] = 4294967295

## SECS Data Item Definitions

This section provides definitions for all standard SECS data items used in message formats.

### A

**ABS** - Absolute Position (F4, F8)
- Absolute position coordinate

**ACCESSMODE** - Access Mode (U1)
- 0: Read only
- 1: Read/Write
- 2: Write only

**ACDS** - Alarm Collection Definition Send (various)
- Alarm collection definition data

**ACKA** - Acknowledge (B[1])
- General acknowledge code

**ACKC10** - Terminal Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error

**ACKC13** - Data Set Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error
- 2: Data set already exists
- 3: No space available

**ACKC15** - Recipe Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error
- 2: Recipe already exists
- 3: No space available

**ACKC3** - Carrier Acknowledge Code (B[1])
- 0: Completed successfully
- 1: Command does not exist
- 2: Cannot perform now
- 3: At least one parameter invalid
- 4: Acknowledge after completion
- 5: Rejected, already in desired condition
- 6: No such object exists

**ACKC5** - Alarm Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error

**ACKC6** - Data Collection Acknowledge Code (B[1])
- 0: Acknowledged
- 1: Error

**ACKC7** - Process Program Acknowledge Code (B[1])
- 0: Accepted
- 1: Permission not granted
- 2: Length error
- 3: Matrix overflow
- 4: PPID not found
- 5: Mode unsupported
- 6: Communication not available
- 7: Busy

**ACKC7A** - Alternative Process Program Acknowledge Code (B[1])
- Same as ACKC7 with additional codes

**AGENT** - Agent Identifier (A)
- Software agent identification

**ALCD** - Alarm Code (B[1])
- Bit 0: Alarm Set (1) or Clear (0)
- Bit 7: Alarm (1) or Warning (0)

**ALED** - Alarm Enable/Disable (B[1])
- 128 (0x80): Enable
- 0: Disable

**ALID** - Alarm ID (U1, U2, U4, or A)
- Unique identifier for alarm

**ALIDVECTOR** - Alarm ID Vector (List of ALID)
- Collection of alarm identifiers

**ALTX** - Alarm Text (A[120])
- Descriptive text for alarm

### B-C

**ASSGNID** - Assignment ID (A)
- Unique assignment identifier

**ATTRDATA** - Attribute Data (various)
- Data value for object attribute

**ATTRID** - Attribute ID (U1, U2, U4, or A)
- Identifier for object attribute

**ATTRRELN** - Attribute Relation (U1)
- Relationship type between attributes

**AUTOCLEAR_DISABLE** - Auto Clear Disable (BOOLEAN)
- Disable automatic clearing

**AUTOCLOSE** - Auto Close (BOOLEAN)
- Automatic closing flag

**AUTOPOST_DISABLE** - Auto Post Disable (BOOLEAN)
- Disable automatic posting

**BCDS** - Binary Collection Definition Send (B)
- Binary collection definition data

**BCEQU** - Binary Collection Equipment (B)
- Equipment binary collection data

**BINLT** - Binary Data (B)
- Binary data content

**BLKDEF** - Block Definition (various)
- Definition of data block structure

**BPD** - Bytes Per Die (U2)
- Number of bytes per die

**BYTMAX** - Maximum Bytes (U4)
- Maximum byte count

**CAACK** - Carrier Action Acknowledge (B[1])
- 0: Completed successfully
- 1: Command does not exist
- 2: Cannot perform now
- 3: At least one parameter invalid

**CARRIERACTION** - Carrier Action (U1)
- 1: Load
- 2: Unload
- 3: Transfer
- 4: Map
- 5: Clamp
- 6: Unclamp

**CARRIERID** - Carrier ID (A)
- Unique identifier for carrier

**CARRIERSPEC** - Carrier Specification (various)
- Carrier specification data

**CATTRDATA** - Carrier Attribute Data (various)
- Data for carrier attribute

**CATTRID** - Carrier Attribute ID (U1, U2, U4, or A)
- Identifier for carrier attribute

**CCEACK** - Collection Event Change Acknowledge (B[1])
- Collection event change response

**CCODE** - Command Code (A)
- Command identifier string

**CEED** - Collection Event Enable/Disable (BOOLEAN)
- Enable or disable collection event

**CEID** - Collection Event ID (U1, U2, U4, or A)
- Unique identifier for collection event

**CEIDSTART** - Collection Event ID Start (CEID)
- Starting collection event ID

**CEIDSTOP** - Collection Event ID Stop (CEID)
- Stopping collection event ID

**CENAME** - Collection Event Name (A)
- Name of collection event

**CEPACK** - Collection Event Parameter Acknowledge (B[1])
- Collection event parameter response

**CEPVAL** - Collection Event Parameter Value (various)
- Value of collection event parameter

**CHKINFO** - Check Information (A)
- Information for checking/validation

**CKPNT** - Checkpoint (A)
- Process checkpoint identifier

**CMDA** - Command Acknowledge (B[1])
- Command acknowledgment

**CMDMAX** - Command Maximum (U2)
- Maximum command value

**CNAME** - Collection Name (A)
- Name of data collection

**COACK** - Control Job Command Acknowledge (B[1])
- Control job command response

**COLCT** - Collection Count (U2)
- Number of items in collection

**COLHDR** - Collection Header (various)
- Header information for collection

**COMMACK** - Communication Acknowledge (B[1])
- 0: Accepted
- 1: Denied, Try Again
- 2: Denied, Permission Not Granted

**COMPARISONOPERATOR** - Comparison Operator (U1)
- 0: Equal
- 1: Not equal
- 2: Less than
- 3: Less than or equal
- 4: Greater than
- 5: Greater than or equal

**CONDITION** - Condition (A)
- Condition specification

**COPYID** - Copy ID (A)
- Identifier for copy operation

**CPACK** - Command Parameter Acknowledge (various)
- Command parameter acknowledgment

**CPNAME** - Command Parameter Name (A)
- Name of command parameter

**CPVAL** - Command Parameter Value (various)
- Value of command parameter

### D-E

**CSAACK** - Carrier Slot Assignment Acknowledge (B[1])
- Carrier slot assignment response

**CTLJOBCMD** - Control Job Command (A)
- Control job command string

**CTLJOBID** - Control Job ID (A)
- Unique identifier for control job

**DATA** - Data (various)
- Generic data field

**DATAACK** - Data Acknowledge (B[1])
- Data acknowledgment

**DATAID** - Data ID (U1, U2, U4, or A)
- Unique identifier for data

**DATALENGTH** - Data Length (U1, U2, U4)
- Length of data in bytes

**DATASEG** - Data Segment (B)
- Segment of larger data

**DATASRC** - Data Source (A)
- Source of data

**DATLC** - Data Location (A)
- Location of data

**DELRSPSTAT** - Delete Response Status (B[1])
- Status of delete operation

**DIRRSPSTAT** - Directory Response Status (B[1])
- Status of directory operation

**DRACK** - Define Report Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, Insufficient space
- 2: Denied, Invalid format
- 3: Denied, At least one RPTID already defined
- 4: Denied, At least one VID does not exist

**DRRACK** - Define Report Request Acknowledge (B[1])
- Define report request response

**DSID** - Data Set ID (U1, U2, U4, or A)
- Unique identifier for data set

**DSNAME** - Data Set Name (A)
- Name of data set

**DSPER** - Data Sample Period (U1, U2, U4)
- Sampling period for data collection

**DUTMS** - Device Under Test Milliseconds (U4)
- Time in milliseconds for device test

**DVNAME** - Discrete Variable Name (A)
- Name of discrete variable

**DVVAL** - Discrete Variable Value (various)
- Value of discrete variable

**DVVALNAME** - Discrete Variable Value Name (A)
- Name for discrete variable value

**EAC** - Equipment Acknowledge Code (B[1])
- 0: Accepted
- 1: Denied, At least one constant does not exist
- 2: Denied, Busy
- 3: Denied, At least one constant out of range

**ECDEF** - Equipment Constant Default (various)
- Default value for equipment constant

**ECID** - Equipment Constant ID (U1, U2, U4, or A)
- Unique identifier for equipment constant

**ECMAX** - Equipment Constant Maximum (various)
- Maximum value for equipment constant

**ECMIN** - Equipment Constant Minimum (various)
- Minimum value for equipment constant

**ECNAME** - Equipment Constant Name (A)
- Name of equipment constant

**ECV** - Equipment Constant Value (various)
- Value of equipment constant

**EDID** - Equipment ID (U1, U2, U4, or A)
- Unique identifier for equipment

**EMID** - Equipment Module ID (A)
- Identifier for equipment module

**EPD** - Equipment Parameter Data (various)
- Equipment parameter information

**EQID** - Equipment ID (A)
- Equipment identifier

**EQNAME** - Equipment Name (A)
- Name of equipment

**EQUSERID** - Equipment User ID (A)
- User identifier for equipment access

**ERACK** - Enable/Disable Event Report Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, At least one CEID does not exist
- 2: Denied, Busy

**ERRCODE** - Error Code (U2)
- Numeric error code

**ERRTEXT** - Error Text (A)
- Descriptive error text

**ERRW7** - Error W7 (B[1])
- W7-specific error code

**EVNTSRC** - Event Source (A)
- Source of event

**EVNTSRC2** - Event Source 2 (A)
- Secondary event source

**EXID** - Exception ID (U4)
- Exception identifier

**EXMESSAGE** - Exception Message (A)
- Exception message text

**EXRECVRA** - Exception Recovery Action (A)
- Recovery action for exception

**EXTYPE** - Exception Type (U1)
- Type of exception

### F-L

**FCNID** - Function ID (B[1])
- SECS function identifier

**FFROT** - Flat Finder Rotation (F4)
- Rotation angle for flat finder

**FILDAT** - File Data (B)
- File content data

**FNLOC** - Final Location (A)
- Final destination location

**FRMLEN** - Frame Length (U2)
- Length of data frame

**GETRSPSTAT** - Get Response Status (B[1])
- Status of get operation

**GOILACK** - Go Online Acknowledge (B[1])
- Go online response

**GRANT** - Grant Code (B[1])
- 0: Granted
- 1: Busy, try again
- 2: No space

**GRANT6** - Grant Code 6 (B[1])
- Stream 6 specific grant code

**GRNT1** - Grant 1 (B[1])
- First grant code

**GRXLACK** - Get Recipe Acknowledge (B[1])
- Recipe get acknowledgment

**HANDLE** - Handle (A)
- Object handle identifier

**HCACK** - Host Command Acknowledge (B[1])
- 0: Acknowledged
- 1: Invalid command
- 2: Cannot perform now
- 3: At least one parameter invalid
- 4: Acknowledge after completion
- 5: Rejected, already in desired condition
- 6: No such object exists

**HOACK** - Host Online Acknowledge (B[1])
- Host online acknowledgment

**HOCANCELACK** - Host Online Cancel Acknowledge (B[1])
- Host online cancel response

**HOCMDNAME** - Host Online Command Name (A)
- Name of host online command

**HOHALTACK** - Host Online Halt Acknowledge (B[1])
- Host online halt response

**IACDS** - Input Alarm Collection Definition Send (various)
- Input alarm collection definition

**IBCDS** - Input Binary Collection Definition Send (B)
- Input binary collection definition

**IDTYP** - ID Type (B[1])
- 0: Data ID
- 1: Equipment ID

**INPTN** - Input Pattern (A)
- Input pattern specification

**ITEMACK** - Item Acknowledge (B[1])
- Item operation acknowledgment

**ITEMERROR** - Item Error (A)
- Error information for item

**ITEMID** - Item ID (A)
- Unique identifier for item

**ITEMINDEX** - Item Index (U4)
- Index position of item

**ITEMLENGTH** - Item Length (U4)
- Length of item data

**ITEMPART** - Item Part (various)
- Part of larger item

**ITEMPARTCOUNT** - Item Part Count (U4)
- Number of parts in item

**ITEMPARTLENGTH** - Item Part Length (U4)
- Length of item part

**ITEMTYPE** - Item Type (U1)
- Type classification of item

**ITEMTYPESUPPORT** - Item Type Support (B[1])
- Support indicator for item type

**ITEMVERSION** - Item Version (A)
- Version of item

**JOBACTION** - Job Action (U1)
- Action to perform on job

**LENGTH** - Length (U1, U2, U4)
- Generic length value

**LIMITACK** - Limit Acknowledge (B[1])
- Limit operation acknowledgment

**LIMITID** - Limit ID (A)
- Identifier for limit

**LIMITMAX** - Limit Maximum (various)
- Maximum limit value

**LIMITMIN** - Limit Minimum (various)
- Minimum limit value

**LINKID** - Link ID (A)
- Identifier for link

**LOC** - Location (A)
- General location identifier

**LOCID** - Location ID (A)
- Specific location identifier

**LOWERDB** - Lower Deadband (various)
- Lower deadband value

**LRACK** - Link Report Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, Insufficient space
- 2: Denied, Invalid format
- 3: Denied, At least one CEID already defined
- 4: Denied, At least one CEID does not exist
- 5: Denied, At least one RPTID does not exist

**LVACK** - Limit Value Acknowledge (B[1])
- Limit value acknowledgment

### M-P

**MAPER** - Map Error (U1)
- Map operation error code

**MAPFT** - Map Format (U1)
- Format of map data

**MAXNUMBER** - Maximum Number (U4)
- Maximum numeric value

**MAXTIME** - Maximum Time (U4)
- Maximum time value

**MCINDEX** - Multi-Collection Index (U2)
- Index for multi-collection

**MDACK** - Mode Data Acknowledge (B[1])
- Mode data acknowledgment

**MDLN** - Model Number (A[20])
- Equipment model designation

**MEXP** - Message Expected (B[1])
- Expected message indicator

**MF** - Message Format (U1)
- Format of message

**MHEAD** - Message Header (B[10])
- Complete 10-byte SECS message header

**MID** - Message ID (U1, U2, U4, or A)
- Message identifier

**MIDAC** - Message ID Acknowledge (B[1])
- Message ID acknowledgment

**MIDRA** - Message ID Response Acknowledge (B[1])
- Message ID response acknowledgment

**MLCL** - Multi-Level Collection List (various)
- Multi-level collection data

**MMODE** - Machine Mode (U1)
- Current machine operating mode

**NACDS** - New Alarm Collection Definition Send (various)
- New alarm collection definition

**NBCDS** - New Binary Collection Definition Send (B)
- New binary collection definition

**NULBC** - Null Byte Count (U1)
- Count of null bytes

**OBJACK** - Object Acknowledge (B[1])
- Object operation acknowledgment

**OBJCMD** - Object Command (A)
- Command for object

**OBJID** - Object ID (A)
- Unique identifier for object

**OBJSPEC** - Object Specification (A)
- Object specification string

**OBJTOKEN** - Object Token (A)
- Token for object access

**OBJTYPE** - Object Type (A)
- Type classification of object

**OCEACK** - Object Collection Event Acknowledge (B[1])
- Object collection event response

**OFLACK** - Offline Acknowledge (B[1])
- 0: Offline Accepted
- 1: Offline Not Allowed

**ONLACK** - Online Acknowledge (B[1])
- 0: Online Accepted
- 1: Online Not Allowed

**OPEID** - Operation Event ID (A)
- Identifier for operation event

**OPETYPE** - Operation Event Type (U1)
- Type of operation event

**OPID** - Operation ID (A)
- Unique operation identifier

**ORLOC** - Origin Location (A)
- Origin location identifier

**OUTPTN** - Output Pattern (A)
- Output pattern specification

**PARAMNAME** - Parameter Name (A)
- Name of parameter

**PARAMVAL** - Parameter Value (various)
- Value of parameter

**PDEATTRIBUTE** - Process Data Element Attribute (various)
- Process data element attribute

**PDEATTRIBUTENAME** - Process Data Element Attribute Name (A)
- Name of process data element attribute

**PDEATTRIBUTEVALUE** - Process Data Element Attribute Value (various)
- Value of process data element attribute

**PDEREF** - Process Data Element Reference (A)
- Reference to process data element

**PECEACK** - Process Event Collection Enable Acknowledge (B[1])
- Process event collection enable response

**PECRSLT** - Process Event Collection Result (various)
- Result of process event collection

**PFCD** - Process Function Code (U1)
- Function code for process

**PGRPACTION** - Port Group Action (U1)
- Action for port group

**PODID** - Point of Delivery ID (A)
- Identifier for delivery point

**PORTACTION** - Port Action (U1)
- Action for port

**PORTGRPNAME** - Port Group Name (A)
- Name of port group

**PPARM** - Process Parameter (various)
- Process parameter value

**PPBODY** - Process Program Body (A or B)
- Content of process program

**PPGNT** - Process Program Grant (B[1])
- Process program grant response

**PPID** - Process Program ID (A)
- Unique identifier for process program

**PRAXI** - Process Axis (A)
- Process axis identifier

**PRCMDNAME** - Process Command Name (A)
- Name of process command

**PRCPREEXECHK** - Process Pre-Execution Check (B[1])
- Pre-execution check flag

**PRDCT** - Product (A)
- Product identifier

**PREACK** - Process Recipe Acknowledge (B[1])
- Process recipe acknowledgment

**PREVENTID** - Process Event ID (A)
- Process event identifier

**PRJOBID** - Process Job ID (A)
- Process job identifier

**PRJOBMILESTONE** - Process Job Milestone (A)
- Process job milestone

**PRJOBSPACE** - Process Job Space (A)
- Process job space allocation

**PRMTRLORDER** - Process Material Order (U2)
- Order of process material

**PRPAUSEEVENTID** - Process Pause Event ID (A)
- Event ID for process pause

**PRPROCESSSTART** - Process Process Start (A)
- Process start identifier

**PRRECIPEMETHOD** - Process Recipe Method (A)
- Process recipe method

**PRSTATE** - Process State (U1)
- Current state of process

**PSRACK** - Process Start Request Acknowledge (B[1])
- Process start request response

**PSREACK** - Process State Request Acknowledge (B[1])
- Process state request response

**PTN** - Port Number (U1)
- Port identification number

### Q-Z

**QPRKEACK** - Query Process Recipe Key Acknowledge (B[1])
- Query process recipe key response

**QREACK** - Query Recipe Acknowledge (B[1])
- Query recipe response

**QRXLEACK** - Query Recipe Exclude Acknowledge (B[1])
- Query recipe exclude response

**QUA** - Quality (U1)
- Quality indicator

**RAC** - Report Acknowledge (B[1])
- Report acknowledgment

**RCMD** - Remote Command (A)
- Remote command string

**RCPATTRDATA** - Recipe Attribute Data (various)
- Recipe attribute data

**RCPATTRID** - Recipe Attribute ID (A)
- Recipe attribute identifier

**RCPBODY** - Recipe Body (A or B)
- Recipe content

**RCPBODYA** - Recipe Body A (A)
- Recipe body in ASCII format

**RCPCLASS** - Recipe Class (A)
- Classification of recipe

**RCPCMD** - Recipe Command (A)
- Recipe command

**RCPDEL** - Recipe Delete (A)
- Recipe deletion identifier

**RCPDESCLTH** - Recipe Description Length (U2)
- Length of recipe description

**RCPDESCNM** - Recipe Description Name (A)
- Recipe description name

**RCPDESCTIME** - Recipe Description Time (A)
- Recipe description timestamp

**RCPID** - Recipe ID (A)
- Unique recipe identifier

**RCPNAME** - Recipe Name (A)
- Name of recipe

**RCPNEWID** - Recipe New ID (A)
- New recipe identifier

**RCPOWCODE** - Recipe Owner Code (A)
- Recipe ownership code

**RCPPARNM** - Recipe Parameter Name (A)
- Name of recipe parameter

**RCPPARRULE** - Recipe Parameter Rule (A)
- Rule for recipe parameter

**RCPPARVAL** - Recipe Parameter Value (various)
- Value of recipe parameter

**RCPRENAME** - Recipe Rename (A)
- New name for recipe

**RCPSECCODE** - Recipe Security Code (A)
- Security code for recipe

**RCPSECNM** - Recipe Section Name (A)
- Name of recipe section

**RCPSPEC** - Recipe Specification (A)
- Recipe specification

**RCPSTAT** - Recipe Status (U1)
- Status of recipe

**RCPUPDT** - Recipe Update (A)
- Recipe update identifier

**RCPVERS** - Recipe Version (A)
- Version of recipe

**READLN** - Read Length (U4)
- Length to read

**REAPER** - Report Error (U1)
- Report error code

**RECLEN** - Record Length (U2)
- Length of record

**REFP** - Reference Point (F4, F8)
- Reference coordinate point

**REPGSZ** - Report Group Size (U2)
- Size of report group

**RESOLUTION** - Resolution (F4)
- Measurement resolution

**RESPDESTAT** - Response Delete Status (B[1])
- Status of response deletion

**RESPEC** - Request Specification (A)
- Request specification string

**RETAINRECIPE_DISABLE** - Retain Recipe Disable (BOOLEAN)
- Disable recipe retention

**RETICLEID** - Reticle ID (A)
- Reticle identifier

**RETICLEID2** - Reticle ID 2 (A)
- Secondary reticle identifier

**RETPLACEINSTR** - Reticle Place Instruction (A)
- Instruction for reticle placement

**RETREMOVEINSTR** - Reticle Remove Instruction (A)
- Instruction for reticle removal

**REVID** - Revision ID (A)
- Revision identifier

**RIC** - Report Item Count (U2)
- Count of items in report

**RMACK** - Resource Manager Acknowledge (B[1])
- Resource manager acknowledgment

**RMCHGSTAT** - Resource Manager Change Status (B[1])
- Resource manager change status

**RMCHGTYPE** - Resource Manager Change Type (U1)
- Type of resource manager change

**RMDATASIZE** - Resource Manager Data Size (U4)
- Size of resource manager data

**RMGRNT** - Resource Manager Grant (B[1])
- Resource manager grant

**RMNEWNS** - Resource Manager New Namespace (A)
- New namespace for resource manager

**RMNSCMD** - Resource Manager Namespace Command (A)
- Resource manager namespace command

**RMNSSPEC** - Resource Manager Namespace Specification (A)
- Resource manager namespace specification

**RMRECSPEC** - Resource Manager Record Specification (A)
- Resource manager record specification

**RMREQUESTOR** - Resource Manager Requestor (A)
- Resource manager requestor identifier

**RMSEGSPEC** - Resource Manager Segment Specification (A)
- Resource manager segment specification

**RMSPACE** - Resource Manager Space (A)
- Resource manager space identifier

**RMSPWD** - Resource Manager Space Password (A)
- Password for resource manager space

**RMSUSERID** - Resource Manager Space User ID (A)
- User ID for resource manager space

**ROWCT** - Row Count (U2)
- Number of rows

**RPMACK** - Report Parameter Acknowledge (B[1])
- Report parameter acknowledgment

**RPSEL** - Report Selection (U1)
- Report selection criteria

**RPTID** - Report ID (U1, U2, U4, or A)
- Unique identifier for report

**RPTOC** - Report Occurrence (U2)
- Report occurrence count

**RQCMD** - Request Command (A)
- Request command string

**RRACK** - Recipe Request Acknowledge (B[1])
- Recipe request acknowledgment

**RRACK_S20** - Recipe Request Acknowledge S20 (B[1])
- S20 specific recipe request acknowledgment

**RSACK** - Recipe Send Acknowledge (B[1])
- Recipe send acknowledgment

**RSDA** - Recipe Send Data A (A)
- Recipe send data in ASCII

**RSDC** - Recipe Send Data C (various)
- Recipe send data compressed

**RSINF** - Recipe Send Information (A)
- Recipe send information

**RSPACK** - Reset Spool Acknowledge (B[1])
- Reset spool acknowledgment

**RTSRSPSTAT** - Real Time Status Response Status (B[1])
- Real time status response

**RTYPE** - Report Type (U1)
- Type of report

**RecID** - Record ID (A)
- Record identifier

**SDACK** - Send Data Acknowledge (B[1])
- Send data acknowledgment

**SDBIN** - Send Data Binary (B)
- Binary data to send

**SENDRSPSTAT** - Send Response Status (B[1])
- Status of send response

**SEQNUM** - Sequence Number (U4)
- Sequence number

**SFCD** - Stream Function Code (U2)
- SECS stream and function code

**SHEAD** - Stream Header (B[4])
- Stream header information

**SLOTID** - Slot ID (U1, U2)
- Slot identifier

**SMPLN** - Sample Number (U1, U2, U4)
- Sample identification number

**SOFTREV** - Software Revision (A[20])
- Software revision string

**SPAACK** - Substrate Position Acknowledge (B[1])
- Substrate position acknowledgment

**SPD** - Substrate Position Data (various)
- Substrate position information

**SPID** - Substrate Position ID (A)
- Substrate position identifier

**SPNAME** - Substrate Position Name (A)
- Name of substrate position

**SPR** - Substrate Position Reference (A)
- Reference for substrate position

**SPVAL** - Substrate Position Value (various)
- Value of substrate position

**SSAACK** - Substrate Status Acknowledge (B[1])
- Substrate status acknowledgment

**SSACK** - Substrate Send Acknowledge (B[1])
- Substrate send acknowledgment

**SSCMD** - Substrate Send Command (A)
- Substrate send command

**STATUS** - Status (U1)
- General status indicator

**STATUSTXT** - Status Text (A)
- Status description text

**STIME** - Start Time (A)
- Start time stamp

**STRACK** - Substrate Track (A)
- Substrate tracking identifier

**STRID** - Stream ID (B[1])
- SECS stream identifier

**STRP** - Map Strip Data (various)
- Wafer map strip data

**SV** - Status Variable (various)
- Status variable value

**SV0** - Status Variable 0 (various)
- First status variable

**SVCACK** - Service Acknowledge (B[1])
- Service acknowledgment

**SVCNAME** - Service Name (A)
- Name of service

**SVID** - Status Variable ID (U1, U2, U4, or A)
- Status variable identifier

**SVNAME** - Status Variable Name (A)
- Name of status variable

**TARGETID** - Target ID (A)
- Target identifier

**TARGETPDE** - Target Process Data Element (A)
- Target process data element

**TARGETSPEC** - Target Specification (A)
- Target specification

**TBLACK** - Table Acknowledge (B[1])
- Table operation acknowledgment

**TBLCMD** - Table Command (A)
- Table command

**TBLELT** - Table Element (various)
- Table element data

**TBLID** - Table ID (A)
- Table identifier

**TBLTYP** - Table Type (U1)
- Type of table

**TCID** - Transaction Control ID (A)
- Transaction control identifier

**TEXT** - Text (A)
- Text data

**TIAACK** - Trace Initialize Acknowledge (B[1])
- 0: Acknowledged
- 1: Denied, Insufficient space
- 2: Denied, Invalid format
- 3: Denied, At least one SVID does not exist
- 4: Denied, Busy

**TIACK** - Time Acknowledge (B[1])
- 0: Acknowledged
- 1: Error

**TID** - Terminal ID (B[1])
- Terminal identifier

**TIME** - Time (A[16])
- Time stamp in format "YYMMDDhhmmss[cc]"

**TIMESTAMP** - Time Stamp (A)
- General timestamp

**TOTSMP** - Total Samples (U1, U2, U4)
- Total number of samples

**TRACK** - Track (A)
- Track identifier

**TRANSFERSIZE** - Transfer Size (U4)
- Size of data transfer

**TRATOMCID** - Transaction Atomic ID (A)
- Atomic transaction identifier

**TRAUTOD** - Transaction Auto Delete (BOOLEAN)
- Auto delete transaction flag

**TRAUTOSTART** - Transaction Auto Start (BOOLEAN)
- Auto start transaction flag

**TRCMDNAME** - Transaction Command Name (A)
- Name of transaction command

**TRDIR** - Transfer Direction (U1)
- Direction of transfer

**TRID** - Trace Request ID (U1, U2, U4, or A)
- Trace request identifier

**TRJOBID** - Transaction Job ID (A)
- Transaction job identifier

**TRJOBMS** - Transaction Job Milestone (A)
- Transaction job milestone

**TRJOBNAME** - Transaction Job Name (A)
- Name of transaction job

**TRLINK** - Transaction Link (A)
- Transaction link identifier

**TRLOCATION** - Transaction Location (A)
- Transaction location

**TROBJNAME** - Transaction Object Name (A)
- Name of transaction object

**TROBJTYPE** - Transaction Object Type (A)
- Type of transaction object

**TRPORT** - Transfer Port (U1)
- Transfer port number

**TRPTNR** - Transfer Partner (A)
- Transfer partner identifier

**TRPTPORT** - Transfer Point Port (U1)
- Transfer point port

**TRRCP** - Transaction Recipe (A)
- Transaction recipe

**TRROLE** - Transaction Role (A)
- Role in transaction

**TRTYPE** - Transfer Type (U1)
- Type of transfer

**TSIP** - Time Stamp Input (A)
- Input timestamp

**TSOP** - Time Stamp Output (A)
- Output timestamp

**TTC** - Total Transfer Count (U4)
- Total count of transfers

**TYPEID** - Type ID (A)
- Type identifier

**UID** - User ID (A)
- User identifier

**UNFLEN** - Unformatted Length (U4)
- Length of unformatted data

**UNITS** - Units (A)
- Measurement units

**UPPERDB** - Upper Deadband (various)
- Upper deadband value

**V** - Variable Value (various)
- Generic variable value

**VERID** - Version ID (A)
- Version identifier

**VERIFYDEPTH** - Verify Depth (U1)
- Depth of verification

**VERIFYRSPSTAT** - Verify Response Status (B[1])
- Verification response status

**VERIFYSUCCESS** - Verify Success (BOOLEAN)
- Verification success flag

**VERIFYTYPE** - Verify Type (U1)
- Type of verification

**VID** - Variable ID (U1, U2, U4, or A)
- Variable identifier

**VLAACK** - Variable Limit Attribute Acknowledge (B[1])
- Variable limit attribute acknowledgment

**WRACK** - Write Acknowledge (B[1])
- Write operation acknowledgment

**XDIES** - X Dies (U2)
- Number of dies in X direction

**XYPOS** - XY Position (F4, F8)
- X,Y coordinate position

**YDIES** - Y Dies (U2)
- Number of dies in Y direction
                Hex: D1 04 FF FF FF FF

Signed Int:    I1[1] = -128
                Hex: 81 01 80

               I2[1] = -32768
                Hex: 71 01 80 00

Float:         F4[1] = 3.14159
                Hex: B1 04 40 49 0F D0

List:          {L:2 item1 item2}
                Hex: 01 02 ... ...

Empty List:    {L:0}
                Hex: 01 00
```

## Implementation Guidelines

### 1. Message Validation
- Verify message length consistency
- Validate stream/function combinations
- Check wait bit appropriateness
- Ensure proper system bytes uniqueness

### 2. Response Handling
- Always respond to messages with wait bit set
- Use same system bytes in response
- Implement proper timeout handling
- Handle transaction aborts gracefully

### 3. State Management
- Track connection state (Not Connected, Selected, Online)
- Implement proper state transitions
- Handle communication establishment sequence
- Manage heartbeat and linktest mechanisms

### 4. Error Handling
- Implement S9 error messages for invalid requests
- Use proper reject codes
- Log communication errors appropriately
- Provide meaningful error descriptions

### 5. Data Encoding
- Use appropriate SECS-II data types
- Handle endianness correctly
- Validate data item structure
- Support multi-byte length fields when needed

## References

- SEMI E5 Specification
- SEMI E37 HSMS Generic Services
- SEMI E30 GEM (Generic Equipment Model)

--- 