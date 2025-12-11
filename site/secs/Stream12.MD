S12F1R	Map Setup Data Send	Sent by Equipment Only


Format:

{L:15
MID
IDTYP
FNLOC
FFROT
ORLOC
RPSEL
{L:n
REFP
}
DUTMS
XDIES
YDIES
ROWCT
COLCT
NULBC
PRDCT
PRAXI
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F2	Map Setup Data Acknowledge	Sent by Host Only


Format:

SDACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F3R	Map Setup Data Request	Sent by Equipment Only


Format:

{L:9
MID
IDTYP
MAPFT
FNLOC
FFROT
ORLOC
PRAXI
BCEQU
NULBC
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F4	Map Setup Data	Sent by Host Only


Format:

{L:15
MID
IDTYP
FNLOC
ORLOC
RPSEL
{L:n
REFP
}
DUTMS
XDIES
YDIES
ROWCT
COLCT
PRDCT
BCEQU
NULBC
MLCL
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F5R	Map Transmit Inquire	Sent by Equipment Only


Format:

{L:4
MID
IDTYP
MAPFT
MLCL
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F6	Map Transmit Grant	Sent by Host Only


Format:

GRNT1

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F7R	Map Data Send Type 1	Sent by Equipment Only


Format:

{L:3
MID
IDTYP
{L:n
{L:2
RSINF
BINLT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F8	Map Data Ack Type 1	Sent by Host Only


Format:

MDACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F9R	Map Data Send Type 2	Sent by Equipment Only


Format:

{L:4
MID
IDTYP
STRP
BINLT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F10	Map Data Ack Type 2	Sent by Host Only


Format:

MDACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F11R	Map Data Send Type 3	Sent by Equipment Only


Format:

{L:3
MID
IDTYP
{L:n
{L:2
XYPOS
BINLT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F12	Map Data Ack Type 3	Sent by Host Only


Format:

MDACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F13R	Map Data Request Type 1	Sent by Equipment Only


Format:

{L:2
MID
IDTYP
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F14	Map Data Type 1	Sent by Host Only


Format:

{L:3
MID
IDTYP
{L:n
{L:2
RSINF
BINLT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F15R	Map Data Request Type 2	Sent by Equipment Only


Format:

{L:2
MID
IDTYP
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F16	Map Data Type 2	Sent by Host Only


Format:

{L:4
MID
IDTYP
STRP
BINLT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F17R	Map Data Request Type 3	Sent by Equipment Only


Format:

{L:3
MID
IDTYP
SDBIN
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F18	Map Data Type 3	Sent by Host Only


Format:

{L:3
MID
IDTYP
{L:n
{L:2
XYPOS
BINLT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S12F19	Map Error Report Send	Sent by Host and Equipment


Format:

{L:2
MAPER
DATLC
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
