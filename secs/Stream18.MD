S18F1R	Read Attribute Req	Sent by Host Only


Format:

{L:2
TARGETID
{L:n
ATTRID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F2	Read Attribute Data	Sent by Equipment Only


Comment: E5 differs from OEM tools
Format:


{L:4
TARGETID
SSACK
{L:n
ATTRDATA
}
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F3R	Write Attribute Req	Sent by Host Only


Format:

{L:2
TARGETID
{L:n
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F4	Write Attribute Ack	Sent by Equipment Only


Comment: fixed E5 mistake
Format:


{L:3
TARGETID
SSACK
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F5R	Read Request	Sent by Host Only


Format:

{L:3
TARGETID
DATASEG
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F6	Read Data	Sent by Equipment Only


Format:

{L:4
TARGETID
SSACK
DATA
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F7R	Write Data Request	Sent by Host Only


Format:

{L:4
TARGETID
DATASEG
DATALENGTH
DATA
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F8	Write Data Ack	Sent by Equipment Only


Format:

{L:3
TARGETID
SSACK
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F9R	Read ID Req	Sent by Host Only


Format:

TARGETID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F10	Read ID Data	Sent by Equipment Only


Format:

{L:4
TARGETID
SSACK
MID
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F11R	Write ID Req	Sent by Host Only


Format:

{L:2
TARGETID
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F12	Write ID Ack	Sent by Equipment Only


Format:

{L:3
TARGETID
SSACK
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F13R	Subsystem Command	Sent by Host Only


Format:

{L:3
TARGETID
SSCMD
{L:n
CPVAL
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F14	Subsystem Command Ack	Sent by Equipment Only


Format:

{L:3
TARGETID
SSACK
{L:s
STATUS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F15R	Read 2D Code Cond Req	Sent by Host Only


Format:

TARGETID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S18F16	Read 2D Code Cond Data	Sent by Equipment Only


Format:

{L:5
TARGETID
SSACK
MID
{L:s
STATUS
}
{L:c
CONDITION
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message