
S5F1[R]	Alarm Report Send	Sent by Equipment Only


Format:

{L:3
ALCD
ALID
ALTX
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F2	Alarm Report Ack	Sent by Host Only


Format:

ACKC5

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F3[R]	Enable/Disable Alarm Send	Sent by Host Only


Format:

{L:2
ALED
ALID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F4	Enable/Disable Alarm Ack	Sent by Equipment Only


Format:

ACKC5

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F5R	List Alarms Request	Sent by Host Only


Comment: Host sends zero length item for all, otherwise ALID vector
Format:


ALIDVECTOR

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F6	List Alarm Data	Sent by Equipment Only


Format:

{L:n
{L:3
ALCD
ALID
ALTX
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F7R	List Enabled Alarm Request	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F8	List Enabled Alarm Data	Sent by Equipment Only


Format:

{L:n
{L:3
ALCD
ALID
ALTX
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F9[R]	Exception Post Notify	Sent by Equipment Only


Comment: see E41
Format:


{L:5
TIMESTAMP
EXID
EXTYPE
EXMESSAGE
{L:n
EXRECVRA
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F10	Exception Post Confirm	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F11[R]	Exception Clear Notify	Sent by Equipment Only


Comment: see E41
Format:


{L:4
TIMESTAMP
EXID
EXTYPE
EXMESSAGE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F12	Exception Clear Confirm	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F13R	Exception Recover Request	Sent by Host Only


Comment: see E41
Format:


{L:2
EXID
EXRECVRA
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F14	Exception Recover Acknowledge	Sent by Equipment Only


Comment: L:2* can be L:2 or L:0
Format:


{L:2
EXID
{L:2
ACKA
{L:2*
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F15[R]	Exception Recovery Complete Notify	Sent by Equipment Only


Comment: L:2* can be L:2 or L:0; see E41
Format:


{L:3
TIMESTAMP
EXID
{L:2
ACKA
{L:2*
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F16	Exception Recovery Complete Confirm	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F17R	Exception Recovery Abort Request	Sent by Host Only


Comment: see E41
Format:


EXID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S5F18	Exception Recovery Abort Ack	Sent by Equipment Only


Comment: L:2* can be L:2 or L:0
Format:


{L:2
EXID
{L:2
ACKA
{L:2*
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message