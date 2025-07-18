S3F1R	Material Status Request	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F2	Material Status Data	Sent by Equipment Only


Format:

{L:2
MF
{L:m
{L:3
LOC
QUA
MID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F3R	Time to Completion Data	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F4	Time to Completion Data	Sent by Equipment Only


Format:

{L:2
MF
{L:m
{L:3
TTC
QUA
MID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F5[R]	Material Found Send	Sent by Equipment Only


Format:

{L:2
MF
QUA
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F6	Material Found Acknowledge	Sent by Host Only


Format:

ACKC3

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F7[R]	Material Lost Send	Sent by Equipment Only


Format:

{L:3
MF
QUA
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F8	Material Lost Ack	Sent by Host Only


Format:

ACKC3

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F9R	Matl ID Equate Send	Sent by Equipment Only


Format:

{L:2
MID
EMID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F10	Matl ID Equate Ack	Sent by Host Only


Format:

ACKC3

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F11R	Matl ID Request	Sent by Equipment Only


Format:

PTN

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F12	Matl ID Request Ack	Sent by Host Only


Format:

{L:3
PTN
MIDRA
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F13R	Matl ID Send	Sent by Host Only


Format:

{L:2
PTN
MID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F14	Matl ID Ack	Sent by Equipment Only


Format:

MIDAC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F15R	SECS-I Matls Multi-block Inquire, not required for HSMS	Sent by Host Only


Format:

{L:2
DATAID
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F16	Matls Multi-block Grant	Sent by Equipment Only


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F17R	Carrier Action Request	Sent by Host Only


Format:

{L:5
DATAID
CARRIERACTION
CARRIERID
PTN
{L:n
{L:2
CATTRID
CATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F18	Carrier Action Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F19R	Cancel All Carrier Out Req	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F20	Cancel All Carrier Out Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F21R	Port Group Defn	Sent by Host Only


Comment: E87 used to refer to PORTACCESS but E5 defines ACCESSMODE
Format:


{L:3
PORTGRPNAME
ACCESSMODE
{L:n
PTN
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F22	Port Group Defn Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F23R	Port Group Action Req	Sent by Host Only


Comment: not documented in E87, port group names - is this vendor specific?
Format:


{L:3
PGRPACTION
PORTGRPNAME
{L:m
{L:2
PARAMNAME
PARAMVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F24	Port Group Action Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F25R	Port Action Req	Sent by Host Only


Format:

{L:3
PORTACTION
PTN
{L:m
{L:2
PARAMNAME
PARAMVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F26	Port Action Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F27R	Change Access	Sent by Host Only


Format:

{L:2
ACCESSMODE
{L:n
PTN
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F28	Change Access Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:n
{L:3
PTN
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F29R	Carrier Tag Read Req	Sent by Host Only


Format:

{L:4
LOCID
CARRIERSPEC
DATASEG
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F30	Carrier Tag Read Data	Sent by Equipment Only


Format:

{L:2
DATA
{L:2
CAACK
{L:s
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F31R	Carrier Tag Write Data	Sent by Host Only


Format:

{L:5
LOCID
CARRIERSPEC
DATASEG
DATALENGTH
DATA
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F32	Carrier Tag Write Ack	Sent by Equipment Only


Format:

{L:2
CAACK
{L:s
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F33	Cancel All Pod Out Req	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F34	Cancel All Pod Out Ack	Sent by Host and Equipment


Format:

{L:2
CAACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F35	Reticle Transfer Job Req	Sent by Host and Equipment


Comment: earlier standard descriptions have errors and undefined data items
Format:


{L:7
JOBACTION
PODID
INPTN
OUTPTN
{L:n
{L:2
ATTRID
ATTRDATA
}
}
{L:m
{L:3
RETICLEID
RETREMOVEINSTR
{L:r
{L:2
ATTRID
ATTRDATA
}
}
}
}
{L:k
{L:2
RETICLEID2
RETPLACEINSTR
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S3F36	Reticle Transfer Job Ack	Sent by Host and Equipment


Format:

{L:2
RPMACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message