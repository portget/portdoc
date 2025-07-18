
S6F1[R]	Trace Data Send	Sent by Equipment Only


Format:

{L:4
TRID
SMPLN
STIME
{L:n
SV
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F2	Trace Data Ack	Sent by Host Only


Format:

ACKC6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F3[R]	Discrete Variable Data Send	Sent by Equipment Only


Comment: Discrete implies event-based such as analysis completion. Use S2F15 to choose supported events.
Format:


{L:3
DATAID
CEID
{L:n
{L:2
DSID
{L:m
{L:2
DVNAME
DVVAL
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F4	Discrete Variable Data Send Ack	Sent by Host Only


Format:

ACKC6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F5R	Multi-block Data Send Inquire	Sent by Equipment Only


Comment: for SECS-I and S6F3 F9 F11 and F13, not required for HSMS
Format:


{L:2
DATAID
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F6	Multi-block Grant	Sent by Host Only


Format:

GRANT6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F7R	Data Transfer Request	Sent by Host Only


Format:

DATAID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F8	Data Transfer Data	Sent by Equipment Only


Format:

{L:3
DATAID
CEID
{L:n
DSID
{L:m
{L:2
DVNAME
DVVAL
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F9[R]	Formatted Variable Send	Sent by Equipment Only


Comment: like S6F3 without names
Format:


{L:4
PFCD
DATAID
CEID
{L:n
{L:2
DSID
{L:m
DVVAL
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F10	Formatted Variable Ack	Sent by Host Only


Format:

ACKC6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F11R	Event Report Send	Sent by Equipment Only


Format:

{L:3
DATAID
CEID
{L:a
{L:2
RPTID
{L:b
V
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F12	Event Report Ack	Sent by Host Only


Format:

ACKC6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F13R	Annotated Event Report Send	Sent by Equipment Only


Format:

{L:3
DATAID
CEID
{L:a
{L:2
RPTID
{L:b
{L:2
VID
V
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F14	Annotated Event Report Ack	Sent by Host Only


Format:

ACKC6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F15R	Event Report Request	Sent by Host Only


Format:

CEID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F16	Event Report Data	Sent by Equipment Only


Format:

{L:3
DATAID
CEID
{L:a
{L:2
RPTID
{L:b
V
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F17R	Annotated Event Report Request	Sent by Host Only


Format:

CEID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F18	Annotated Event Report Data	Sent by Equipment Only


Format:

{L:3
DATAID
CEID
{L:a
{L:2
RPTID
{L:b
{L:2
VID
V
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F19R	Individual Report Request	Sent by Host Only


Format:

RPTID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F20	Individual Report Data	Sent by Equipment Only


Format:

{L:n
V
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F21R	Annotated Individual Report Request	Sent by Host Only


Format:

RPTID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F22	Annotated Individual Report Data	Sent by Equipment Only


Format:

{L:n
{L:2
VID
V
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F23R	Request or Purge Spooled Data	Sent by Host Only


Format:

RSDC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F24	Request or Purge Spooled Data Ack	Sent by Equipment Only


Format:

RSDA

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F25[R]	Notification Report Send	Sent by Host and Equipment


Format:

{L:7
DATAID
OPID
LINKID
RCPSPEC
RMCHGSTAT
{L:m
{L:2
RCPATTRID
RCPATTRDATA
}
}
{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F26	Notification Report Send Ack	Sent by Host and Equipment


Format:

ACKC6

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F27[R]	Trace Report Send	Sent by Equipment Only


Format:

{L:3
DATAID
TRID
{L:n
{L:p
{L:2
RPTID
{L:m
V
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F28	Trace Report Send Ack	Sent by Host Only


Format:

TRID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F29R	Trace Report Request	Sent by Host Only


Format:

TRID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S6F30	Trace Report Data	Sent by Equipment Only


Comment: ERRCODE is set to zero length when there is no error.
Format:


{L:3
TRID
{L:n
{L:2
RPTID
{L:m
V
}
}
}
ERRCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
