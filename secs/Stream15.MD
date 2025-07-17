
S15F1R	Recipe Management Multi-Block Inquire	Sent by Host and Equipment


Comment: E5 fails to mention the message type is optional for HSMS
Format:


{L:3
DATAID
RCPSPEC
RMDATASIZE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F2	Recipe Management Multi-block Grant	Sent by Host and Equipment


Format:

RMGRNT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F3R	Recipe Namespace Action Req	Sent by Host and Equipment


Format:

{L:2
RMNSSPEC
RMNSCMD
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F4	Recipe Namespace Action	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F5R	Recipe Namespace Rename Req	Sent by Host and Equipment


Format:

{L:2
RMNSSPEC
RMNEWNS
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F6	Recipe Namespace Rename Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F7R	Recipe Space Req	Sent by Host and Equipment


Format:

OBJSPEC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F8	Recipe Space Data	Sent by Host and Equipment


Format:

{L:2
RMSPACE
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
S15F9R	Recipe Status Request	Sent by Host and Equipment


Format:

RCPSPEC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F10	Recipe Status Data	Sent by Host and Equipment


Format:

{L:3
RCPSTAT
RCPVERS
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
S15F11R	Recipe Version Request	Sent by Host and Equipment


Format:

{L:4
RMNSSPEC
RCPCLASS
RCPNAME
AGENT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F12	Recipe Version Data	Sent by Host and Equipment


Format:

{L:3
AGENT
RCPVERS
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
S15F13R	Recipe Create Req	Sent by Host and Equipment


Format:

{L:5
DATAID
RCPUPDT
RCPSPEC
{L:m
{L:2
RCPATTRID
RCPATTRDATA
}
}
RCPBODY
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F14	Recipe Create Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F15R	Recipe Store Req	Sent by Host and Equipment


Comment: L:2* can be L:2 or L:0; E5 documentation is inadequate for L:q other than L:3
Format:


{L:4
DATAID
RCPSPEC
RCPSECCODE
{L:3
{L:2*
RCPSECNM
{L:g
{L:2
RCPATTRID
RCPATTRDATA
}
}
}
RCPBODY
{L:m
{L:2
RCPSECNM
{L:a
{L:2
RCPATTRID
RCPATTRDATA
}
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F16	Recipe Store Ack	Sent by Host and Equipment


Format:

{L:2
RCPSECCODE
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
S15F17R	Recipe Retrieve Req	Sent by Host and Equipment


Format:

{L:2
RCPSPEC
RCPSECCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F18	Recipe Retrieve Data	Sent by Host and Equipment


Format:

{L:2
{L:q
{L:r
RCPSECNM
{L:g
{L:2
RCPATTRID
RCPATTRDATA
}
}
}
RCPBODY
{L:m
{L:2
RCPSECNM
{L:a
{L:2
RCPATTRID
RCPATTRDATA
}
}
}
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
S15F19R	Recipe Rename Req	Sent by Host and Equipment


Format:

{L:3
RCPSPEC
RCPRENAME
RCPNEWID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F20	Recipe Rename Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F21R	Recipe Action Req	Sent by Host and Equipment


Format:

{L:6
DATAID
RCPCMD
RMNSSPEC
OPID
AGENT
{L:n
RCPID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F22	Recipe Action Ack	Sent by Host and Equipment


Format:

{L:4
AGENT
LINKID
RCPCMD
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
S15F23R	Recipe Descriptor Req	Sent by Host and Equipment


Format:

{L:3
DATAID
OBJSPEC
{L:n
RCPID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F24	Recipe Descriptor Data	Sent by Host and Equipment


Format:

{L:2
{L:n
{L:a
{L:3*
RCPDESCNM
RCPDESCTIME
RCPDESCLTH
}
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
S15F25R	Recipe Parameter Update Req	Sent by Host and Equipment


Format:

{L:4
DATAID
RMNSSPEC
AGENT
{L:n
{L:3
RCPPARNM
RCPPARVAL
RCPPARRULE
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F26	Recipe Parameter Update Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F27R	Recipe Download Req	Sent by Host Only


Format:

{L:5
DATAID
RCPOWCODE
RCPSPEC
{L:m
{L:2
RCPATTRID
RCPATTRDATA
}
}
RCPBODY
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F28	Recipe Download Ack	Sent by Equipment Only


Format:

{L:3
RCPID
{L:n
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
S15F29R	Recipe Verify Req	Sent by Host Only


Format:

{L:4
DATAID
OPID
RESPEC
{L:m
RCPID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F30	Recipe Verify Ack	Sent by Equipment Only


Format:

{L:5
OPID
LINKID
RCPID
{L:n
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
S15F31R	Recipe Unload Req	Sent by Host Only


Format:

RCPSPEC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F32	Recipe Unload Data	Sent by Equipment Only


Format:

{L:4
RCPSPEC
{L:m
{L:2
RCPATTRID
RCPATTRDATA
}
}
RCPBODY
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
S15F33R	Recipe Select Req	Sent by Host Only


Format:

{L:3
DATAID
RESPEC
{L:r
{L:2
RCPID
{L:p
{L:2
RCPPARNM
RCPPARVAL
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F34	Recipe Select Ack	Sent by Equipment Only


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F35R	Recipe Delete Req	Sent by Host Only


Format:

{L:4
DATAID
RESPEC
RCPDEL
{L:n
RCPID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F36	Recipe Delete Ack	Sent by Equipment Only


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F37R	DRNS Segment Approve Action Req	Sent by Host and Equipment


Format:

{L:6
RMSEGSPEC
OBJTOKEN
RMGRNT
OPID
RCPID
RMCHGTYPE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F38	DRNS Segment Approve Action Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F39R	DRNS Recorder Seg Req	Sent by Host and Equipment


Format:

{L:5
DATAID
RMNSCMD
RMRECSPEC
RMSEGSPEC
OBJTOKEN
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F40	DRNS Recorder Seg Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F41R	DRNS Recorder Mod Req	Sent by Host and Equipment


Comment: L:c is L:7 or L:1, no explanation of L:1 item
Format:


{L:5
DATAID
RMRECSPEC
OBJTOKEN
RMNSCMD
{L:c
RCPID
RCPNEWID
RMSEGSPEC
RMCHGTYPE
OPID
TIMESTAMP
RMREQUESTOR
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F42	DRNS Recorder Mod Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F43R	DRNS Get Change Req	Sent by Host and Equipment


Format:

{L:3
DATAID
OBJSPEC
TARGETSPEC
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F44	DRNS Get Change Ack	Sent by Host and Equipment


Format:

{L:2
{L:n
{L:7
RCPID
RCPNEWID
RMSEGSPEC
RMCHGTYPE
OPID
TIMESTAMP
RMREQUESTOR
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
S15F45R	DRNS Mgr Seg Aprvl Req	Sent by Host and Equipment


Format:

{L:4
DATAID
RCPSPEC
RCPNEWID
RMCHGTYPE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F46	DRNS Mgr Seg Aprvl Ack	Sent by Host and Equipment


Format:

{L:3
RMCHGTYPE
RMGRNT
OPID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F47R	DRNS Mgr Rebuild Req	Sent by Host and Equipment


Format:

{L:5
DATAID
OBJSPEC
RMNSSPEC
RMRECSPEC
{L:n
RMSEGSPEC
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F48	DRNS Mgr Rebuild Ack	Sent by Host and Equipment


Format:

{L:2
RMACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F49R	Large Recipe Download Req	Sent by Host Only


Comment: The DSNAME is the RCPSPEC for Stream 13 transfer.
Format:


{L:2
DSNAME
RCPOWCODE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F50	Large Recipe Download Ack	Sent by Equipment Only


Format:

ACKC15

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F51R	Large Recipe Upload Req	Sent by Host Only


Comment: The DSNAME is the RCPSPEC used in Stream 13.
Format:


DSNAME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F52	Large Recipe Upload Ack	Sent by Equipment Only


Format:

ACKC15

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F53R	Recipe Verification Send	Sent by Equipment Only


Format:

{L:3
RCPSPEC
RCPID
{L:2
RMACK
{L:n
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S15F54	Recipe Verification Ack	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message