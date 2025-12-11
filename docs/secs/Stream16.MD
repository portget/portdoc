S16F1R	Process Job Data MBI	Sent by Host Only


Comment: SECS-I multiblock inquire/grant for all process management messages, optional for HSMS
Format:


{L:2
DATAID
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F2	PJD MBI Grant	Sent by Equipment Only


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F3R	Process Job Create Req	Sent by Host Only


Format:

{L:5
DATAID
MF
{L:n
MID
}
{L:3
PRRECIPEMETHOD
RCPSPEC
{L:m
{L:2
RCPPARNM
RCPPARVAL
}
}
}
PRPROCESSSTART
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F4	Process Job Create Ack	Sent by Equipment Only


Format:

{L:2
PRJOBID
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F5R	Process Job Cmd Req	Sent by Host Only


Format:

{L:4
DATAID
PRJOBID
PRCMDNAME
{L:n
{L:2
CPNAME
CPVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F6	Process Job Cmd Ack	Sent by Equipment Only


Format:

{L:2
PRJOBID
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F7[R]	Process Job Alert Notify	Sent by Equipment Only


Comment: Unlike S5F1 there is no message to enable/disable selected alerts. ACKA false indicates failure.
Format:


{L:4
TIMESTAMP
PRJOBID
PRJOBMILESTONE
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F8	Process Job Alert Ack	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F9[R]	Process Job Event Notify	Sent by Equipment Only


Comment: There is no message to define the VID list or enable/disable. Less featured than Stream 6 and superseded by Stream 17.
Format:


{L:4
PREVENTID
TIMESTAMP
PRJOBID
{L:n
{L:2
VID
V
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F10	Process Job Event Ack	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F11R	PRJobCreateEnh	Sent by Host Only


Comment: The L:n list can be {L:n MID} depending on MF, {L:j SLOTID} might be an array instead
Format:


{L:7
DATAID
PRJOBID
MF
{L:n
{L:2
CARRIERID
{L:j
SLOTID
}
}
}
{L:3
PRRECIPEMETHOD
RCPSPEC
{L:m
{L:2
RCPPARNM
RCPPARVAL
}
}
}
PRPROCESSSTART
{L:p
PRPAUSEEVENTID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F12	PRJobCreateEnh Ack	Sent by Equipment Only


Format:

{L:2
PRJOBID
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F15R	PRJobMultiCreate	Sent by Host Only


Comment: The L:n list can be {L:n MID} depending on MF, {L:j SLOTID} might be an array instead
Format:


{L:2
DATAID
{L:p
{L:6
PRJOBID
MF
{L:n
{L:2
CARRIERID
{L:j
SLOTID
}
}
}
{L:3
PRRECIPEMETHOD
RCPSPEC
{L:m
{L:2
RCPPARNM
RCPPARVAL
}
}
}
PRPROCESSSTART
{L:k
PRPAUSEEVENTID
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F16	PRJobMultiCreate Ack	Sent by Equipment Only


Format:

{L:2
{L:m
PRJOBID
}
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F17R	PRJobDequeue	Sent by Host Only


Comment: If m = 0 then the request is for all jobs that have not begun processing.
Format:


{L:m
PRJOBID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F18	PRJobDequeue Ack	Sent by Equipment Only


Format:

{L:2
{L:m
PRJOBID
}
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F19R	PRJob List Req	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F20	PRJob List Data	Sent by Equipment Only


Format:

{L:m
{L:2
PRJOBID
PRSTATE
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F21R	PRJob Create Limit Req	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F22	PRJob Create Limit Data	Sent by Equipment Only


Format:

PRJOBSPACE

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F23R	PRJob Recipe Variable Set	Sent by Host Only


Format:

{L:2
PRJOBID
{L:m
{L:2
RCPPARNM
RCPPARVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F24	PRJob Recipe Variable Ack	Sent by Host Only


Format:

{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F25R	PRJob Start Method Set	Sent by Host Only


Format:

{L:2
{L:m
PRJOBID
}
PRPROCESSSTART
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F26	PRJob Start Method Ack	Sent by Equipment Only


Format:

{L:2
{L:m
PRJOBID
}
{L:2
ACKA
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F27R	Control Job Command	Sent by Host Only


Comment: Defined by E94, used in replacement of S16F5 when Control Jobs are used
Format:


{L:3
CTLJOBID
CTLJOBCMD
{L:2
CPNAME
CPVAL
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F28	Control Job Command Ack	Sent by Equipment Only


Format:

{L:2
ACKA
{L:2
ERRCODE
ERRTEXT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F29	PRSetMtrlOrder	Sent by Host Only


Format:

PRMTRLORDER

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S16F30	PRSetMtrlOrder Ack	Sent by Equipment Only


Format:

ACKA

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message