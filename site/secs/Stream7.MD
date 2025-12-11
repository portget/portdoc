
S7F1R	Process Program Load Inquire	Sent by Host and Equipment


Format:

{L:2
PPID
LENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F2	Process Program Load Grant	Sent by Host and Equipment


Format:

PPGNT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F3R	Process Program Send	Sent by Host and Equipment


Format:

{L:2
PPID
PPBODY
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F4	Process Program Send Acknowledge	Sent by Host and Equipment


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F5R	Process Program Request	Sent by Host and Equipment


Format:

PPID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F6	Process Program Data	Sent by Host and Equipment


Format:

{L:2
PPID
PPBODY
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F7R	Process Program ID Request	Sent by Equipment Only


Format:

MID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F8	Process Program ID Data	Sent by Host Only


Format:

{L:2
PPID
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F9R	Matl/Process Matrix Request	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F10	Matl/Process Matrix Data	Sent by Host and Equipment


Format:

{L:n
{L:2
PPID
{L:a
MID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F11[R]	Matl/Process Matrix Update Send	Sent by Host Only


Format:

{L:n
{L:2
PPID
{L:a
MID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F12	Matl/Process Matrix Update Ack	Sent by Equipment Only


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F13[R]	Matl/Process Matrix Delete Entry Send	Sent by Host Only


Format:

{L:n
{L:2
PPID
{L:a
MID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F14	Delete Matl/Process Matrix Entry Acknowledge	Sent by Equipment Only


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F15R	Matrix Mode Select Send	Sent by Host Only


Format:

MMODE

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F16	Matrix Mode Select Ack	Sent by Equipment Only


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F17R	Delete Process Program Send	Sent by Host Only


Comment: Host can send L:0 to delete all.
Format:


{L:n
PPID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F18	Delete Process Program Acknowledge	Sent by Equipment Only


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F19R	Current Process Program Dir Request	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F20	Current Process Program Data	Sent by Equipment Only


Format:

{L:n
PPID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F21	Process Capabilities Request	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F22	Process Capabilities Data	Sent by Equipment Only


Comment: L:x can be L:9, L:5, or L:4 with different data items
Format:


{L:5
MDLN
SOFTREV
CMDMAX
BYTMAX
{L:c
{L:11
CCODE
CNAME
RQCMD
BLKDEF
BCDS
IBCDS
NBCDS
ACDS
IACDS
NACDS
{L:p
L:x
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F23R	Formatted Process Program Send	Sent by Host and Equipment


Format:

{L:4
PPID
MDLN
SOFTREV
{L:c
{L:2
CCODE
{L:p
PPARM
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F24	Formatted Process Program Acknowledge	Sent by Host and Equipment


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F25R	Formatted Process Program Request	Sent by Host and Equipment


Format:

PPID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F26	Formatted Process Program Data	Sent by Host and Equipment


Format:

{L:4
PPID
MDLN
SOFTREV
{L:c
{L:2
CCODE
{L:p
PPARM
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F27R	Process Program Verification Send	Sent by Equipment Only


Format:

{L:2
PPID
{L:n
{L:3
ACKC7A
SEQNUM
ERRW7
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F28	Process Program Verification Acknowledge	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F29R	Process Program Verification Inquire	Sent by Equipment Only


Comment: This is a multiblock inquire for S7F27 so the LENGTH is the S7F27 message length an not the PP length.
Format:


LENGTH

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F30	Process Program Verification Grant	Sent by Host Only


Format:

PPGNT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F31R	Verification Request Send	Sent by Host Only


Format:

{L:4
PPID
MDLN
SOFTREV
{L:c
{L:2
CCODE
{L:p
PPARM
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F32	Verification Request Acknowledge	Sent by Equipment Only


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F33R	Process Program Available Request	Sent by Host and Equipment


Format:

PPID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F34	Process Program Availability Data	Sent by Host and Equipment


Format:

{L:3
PPID
UNFLEN
FRMLEN
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F35R	Process Program for MID Request	Sent by Host and Equipment


Format:

MID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F36	Process Program for MID Data	Sent by Host and Equipment


Format:

{L:3
MID
PPID
PPBODY
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F37R	Large PP Send	Sent by Host and Equipment


Format:

DSNAME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F38	Large PP Send Ack	Sent by Host and Equipment


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F39R	Large Formatted PP Send	Sent by Host and Equipment


Format:

DSNAME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F40	Large Formatted PP Ack	Sent by Host and Equipment


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F41R	Large PP Req	Sent by Host and Equipment


Format:

DSNAME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F42	Large PP Req Ack	Sent by Host and Equipment


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F43R	Large Formatted PP Req	Sent by Host and Equipment


Format:

DSNAME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S7F44	Large Formatted PP Req Ack	Sent by Host and Equipment


Format:

ACKC7

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message