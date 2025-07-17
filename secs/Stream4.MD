S4F1R	Ready to Send Materials	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F2	Ready to Send Ack	Sent by Host and Equipment


Format:

RSACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F3	Send Material	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F5	Handshake Complete	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F7	Not Ready to Send	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F9	Stuck in Sender	Sent by Host and Equipment


Comment: standard does not show as bidirectional
Format:


{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F11	Stuck in Receiver	Sent by Host and Equipment


Comment: standard does not show as bidirectional
Format:


{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F13	Send Incomplete Timeout	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F15	Material Received	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F17R	Request to Receive	Sent by Host and Equipment


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F18	Request to Receive Ack	Sent by Host and Equipment


Format:

RRACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F19R	Transfer Job Create	Sent by Host Only


Format:

{L:2
DATAID
{L:2
TRJOBNAME
{L:n
{L:12
TRLINK
TRPORT
TROBJNAME
TROBJTYPE
TRROLE
TRRCP
TRPTNR
TRPTPORT
TRDIR
TRTYPE
TRLOCATION
TRAUTOSTART
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F20	Transfer Job Acknowledge	Sent by Equipment Only


Format:

{L:3
TRJOBID
{L:m
TRATOMCID
}
{L:2
TRACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F21R	Transfer Job Command	Sent by Host Only


Format:

{L:3
TRJOBID
TRCMDNAME
{L:n
{L:2
CPNAME
CPVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F22	Transfer Job Command Ack	Sent by Equipment Only


Format:

{L:2
TRACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F23[R]	Transfer Command Alert	Sent by Equipment Only


Format:

{L:4
TRJOBID
TRJOBNAME
TRJOBMS
{L:2
TRACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F24	Transfer Alert Ack	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F25R	Multi-block Inquire	Sent by Host Only


Comment: for SECS-I, not required for HSMS
Format:


{L:2
DATAID
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F26	Multi-block Grant	Sent by Equipment Only


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F27	Handoff Ready	Sent by Host and Equipment


Format:

{L:2
EQNAME
{L:11
TRLINK
TRPORT
TROBJNAME
TROBJTYPE
TRROLE
TRPTNR
TRPTPORT
TRDIR
TRTYPE
TRLOCATION
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F29	Handoff Command	Sent by Host and Equipment


Format:

{L:4
TRLINK
MCINDEX
HOCMDNAME
{L:n
{L:2
CPNAME
CPVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F31	Handoff Command Complete	Sent by Host and Equipment


Format:

{L:3
TRLINK
MCINDEX
{L:2
HOACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F33	Handoff Verified	Sent by Host and Equipment


Format:

{L:2
TRLINK
{L:2
HOACK
{L:n
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F35	Handoff Cancel Ready	Sent by Host and Equipment


Format:

TRLINK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F37	Handoff Cancel Ready Ack	Sent by Host and Equipment


Format:

{L:2
TRLINK
HOCANCELACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F39	Handoff Halt	Sent by Host and Equipment


Format:

TRLINK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S4F41	Handoff Halt Ack	Sent by Host and Equipment


Format:

{L:2
TRLINK
HOHALTACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message