S17F1R	Data Report Create Req	Sent by Host Only


Format:

{L:4
DATAID
RPTID
DATASRC
{L:n
VID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F2	Data Report Create Ack	Sent by Equipment Only


Format:

{L:2
RPTID
ERRCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F3R	Data Report Delete Req	Sent by Host Only


Comment: L:0 means delete all reports
Format:


{L:n
RPTID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F4	Data Report Del Ack	Sent by Equipment Only


Format:

{L:2
ACKA
{L:m
{L:3
RPTID
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F5R	Trace Create Req	Sent by Host Only


Comment: we recommend the host always provides the L:8 values
Format:


{L:6
DATAID
TRID
CEED
{L:n
RPTID
}
{L:8*
TOTSMP
REPGSZ
EVNTSRC
CEIDSTART
EVNTSRC2
CEIDSTOP
TRAUTOD
RPTOC
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F6	Trace Create Ack	Sent by Equipment Only


Format:

{L:2
TRID
ERRCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F7R	Trace Delete Req	Sent by Host Only


Comment: Surprisingly, L:0 is not specified as a means to indicate all, but this feature has to be provided because there is no means to discover the existing traces.
Format:


{L:n
TRID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F8	Trace Delete Ack	Sent by Equipment Only


Format:

{L:2
ACKA
{L:m
{L:3
TRID
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F9R	Collection Event Link Req	Sent by Host Only


Format:

{L:4
DATAID
EVNTSRC
CEID
{L:n
RPTID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F10	Collection Event Link Ack	Sent by Equipment Only


Format:

{L:3
EVNTSRC
CEID
ERRCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F11R	Collection Event Unlink	Sent by Host Only


Format:

{L:3
EVNTSRC
CEID
RPTID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F12	Collection Event Unlink Ack	Sent by Equipment Only


Format:

{L:4
EVNTSRC
CEID
RPTID
ERRCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F13R	Trace Reset Req	Sent by Host Only


Format:

{L:n
TRID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S17F14	Trace Reset Ack	Sent by Equipment Only


Format:

{L:2
ACKA
{L:m
{L:3
TRID
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message