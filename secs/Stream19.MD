S19F1R	Request Process Definition Element (PDE) Directory	Sent by Host and Equipment


Comment: SEE SEMI E139. If m=0, all PDE's are returned. If n=0, no additional attributes are returned. Selection conditions are ANDed together.
Format:


{L:2
{L:m
{L:3
PDEATTRIBUTENAME
COMPARISONOPERATOR
PDEATTRIBUTEVALUE
}
}
{L:n
PDEATTRIBUTE
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F2	PDE Directory Data	Sent by Host and Equipment


Comment: the list of PDEs, and their attributes matching the request
Format:


{L:3
DIRRSPSTAT
STATUSTXT
{L:m
{L:2
UID
{L:n
{L:2
PDEATTRIBUTE
PDEATTRIBUTEVALUE
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F3R	PDE Delete Request	Sent by Host Only


Comment: L:0 is not allowed. Surprisingly the command is only defined for the host despite S19F1R being for both.
Format:


{L:n
UID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F4	PDE Delete Acknowledge	Sent by Equipment Only


Comment: Surprisingly L:0 is specified as the reply for L:0 input instead of S9F7.
Format:


{L:n
{L:3
UID
DELRSPSTAT
STATUSTXT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F5R	PDE Header Data Request	Sent by Host and Equipment


Comment: n = 0 is not allowed
Format:


{L:n
UID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F6	PDE Header Data Reply	Sent by Host and Equipment


Comment: A zero length TCID is sent if there are no code 0 PDEs. If L:0 S19F5R input then n=0 reply instead of S9F7!
Format:


{L:2
TCID
{L:n
{L:3
UID
GETRSPSTAT
STATUSTXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F7R	request the transfer of PDEs via Stream 13	Sent by Host and Equipment


Comment: n = 0 is not allowed
Format:


{L:n
UID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F8	PDE Transfer Reply	Sent by Host and Equipment


Comment: Each PDE data set with the GETRSPSTAT response code of 0 will be sent in a Stream 13 TransferContainer. A zero length TCID is sent if there are no code 0 PDEs. If L:0 S19F7R input then n=0 reply instead of S9F7!
Format:


{L:2
TCID
{L:n
{L:3
UID
GETRSPSTAT
STATUSTXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F9R	Request to Send PDE	Sent by Host and Equipment


Comment: Request permission to initiate PDE transfer using S19F11R.
Format:


{L:2
TCID
TRANSFERSIZE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F10	Initiate PDE transfer Reply	Sent by Host and Equipment


Format:

{L:3
TCID
RTSRSPSTAT
STATUSTXT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F11R	Send PDE	Sent by Host and Equipment


Comment: tells the receiver to initiate a Stream 13 transfer with the DSNAME = TCID
Format:


TCID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F12	Send PDE Acknowledge	Sent by Host and Equipment


Comment: Header only. The transfer result status is sent in S19F13.
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F13R	TransferContainer Report	Sent by Host and Equipment


Comment: Acknowledges the receipt of a TransferContainer using S13. Verification of transferred PDEs is rrequired when received by equipment.
Format:


{L:n
{L:4
UID
SENDRSPSTAT
VERIFYRSPSTAT
STATUSTXT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F14	TransferContainer Report Ack	Sent by Host and Equipment


Comment: header only acknowledges the receipt S19F13R
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F15R	Request PDE Resolution	Sent by Host Only


Comment: Request the equipment to resolve PDEs in the target. n can be 0 for no InputMap
Format:


{L:2
TARGETPDE
{L:n
{L:2
PDEREF
RESOLUTION
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F16	PDE Resolution Data	Sent by Equipment Only


Comment: The output map of the recipe structure. L:m has resolved PDEREF. n can be 0, n >= m
Format:


{L:2
{L:m
{L:2
PDEREF
RESOLUTION
}
}
{L:n
{L:3
UID
RESPDESTAT
STATUSTXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F17R	Verify PDE Request	Sent by Host Only


Comment: n can be 0 when there is no InputMap
Format:


{L:4
TARGETPDE
{L:n
{L:2
PDEREF
RESOLUTION
}
}
VERIFYTYPE
VERIFYDEPTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F18	PDE Verification Result	Sent by Equipment Only


Format:

{L:2
VERIFYSUCCESS
{L:n
{L:3
UID
VERIFYRSPSTAT
STATUSTXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F19R	S19 Multi-block Inquire	Sent by Host and Equipment


Comment: SECS-I request permission to send multi-block S19F1,3,5,6,13,15,17. Not required for HSMS.
Format:


DATALENGTH

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S19F20	S19 Multi-block Grant	Sent by Host and Equipment


Comment: Usage is not required by the standard. Should not have been included in the standard.
Format:


GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message