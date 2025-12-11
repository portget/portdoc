
S10F1[R]	Terminal Request	Sent by Equipment Only


Format:

{L:2
TID
TEXT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F2	Terminal Request Acknowledge	Sent by Host Only


Format:

ACKC10

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F3[R]	Terminal Display, Single	Sent by Host Only


Format:

{L:2
TID
TEXT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F4	Terminal Display, Single Acknowledge	Sent by Equipment Only


Format:

ACKC10

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F5[R]	Terminal Display, Multi-Block	Sent by Host Only


Format:

{L:2
TID
{L:n
TEXT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F6	Terminal Display, Multi-Block Acknowledge	Sent by Equipment Only


Format:

ACKC10

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F7	Multi-block Not Allowed	Sent by Equipment Only


Format:

TID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F9	Broadcast	Sent by Host Only


Format:

TEXT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S10F10	Broadcast Acknowledge	Sent by Equipment Only


Format:

ACKC10

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message