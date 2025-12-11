S14F1R	Get Attributes Request	Sent by Host and Equipment


Comment: List lengths can be 0, and OBJSPEC can be zero-length.
Format:


{L:5
OBJSPEC
OBJTYPE
{L:i
OBJID
}
{L:q
{L:3
ATTRID
ATTRDATA
ATTRRELN
}
}
{L:a
ATTRID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F2	Attribute Data	Sent by Host and Equipment


Format:

{L:2
{L:n
{L:2
OBJID
{L:a
{L:2
ATTRID
ATTRDATA
}
}
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F3R	Set Attributes	Sent by Host and Equipment


Format:

{L:4
OBJSPEC
OBJTYPE
{L:i
OBJID
}
{L:n
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F4	Set Attributes Reply	Sent by Host and Equipment


Format:

{L:2
{L:i
{L:2
OBJID
{L:n
{L:2
ATTRID
ATTRDATA
}
}
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F5R	Get Type Data	Sent by Host and Equipment


Comment: Asks for the types of objects owned by the type of specified object
Format:


OBJSPEC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F6	Type Data	Sent by Host and Equipment


Format:

{L:2
{L:n
OBJTYPE
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F7R	Get Attribute Names for the types	Sent by Host and Equipment


Format:

{L:2
OBJSPEC
{L:n
OBJTYPE
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F8	Attribute Names of the object types	Sent by Host and Equipment


Format:

{L:2
{L:n
{L:2
OBJTYPE
{L:a
ATTRID
}
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F9R	Create Obj Request	Sent by Host and Equipment


Format:

{L:3
OBJSPEC
OBJTYPE
{L:a
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F10	Create Obj Ack	Sent by Host and Equipment


Format:

{L:3
OBJSPEC
{L:b
{L:2
ATTRID
ATTRDATA
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F11R	Delete Obj Request	Sent by Host and Equipment


Format:

{L:2
OBJSPEC
{L:a
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F12	Delete Obj Ack	Sent by Host and Equipment


Format:

{L:2
{L:b
{L:2
ATTRID
ATTRDATA
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F13R	Object Attach Request	Sent by Host and Equipment


Format:

{L:2
OBJSPEC
{L:a
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F14	Object Attach Ack	Sent by Host and Equipment


Format:

{L:3
OBJTOKEN
{L:b
{L:2
ATTRID
ATTRDATA
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F15R	Attached Obj Action Req.	Sent by Host and Equipment


Format:

{L:4
OBJSPEC
OBJCMD
OBJTOKEN
{L:a
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F16	Attached Obj Action Ack	Sent by Host and Equipment


Format:

{L:2
{L:b
{L:2
ATTRID
ATTRDATA
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F17R	Supervised Obj Action Req	Sent by Host and Equipment


Format:

{L:4
OBJSPEC
OBJCMD
TARGETSPEC
{L:a
{L:2
ATTRID
ATTRDATA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F18	Supervised Obj Action Ack	Sent by Host and Equipment


Format:

{L:2
{L:b
{L:2
ATTRID
ATTRDATA
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F19R	Generic Service Req	Sent by Host Only


Format:

{L:5
DATAID
OPID
OBJSPEC
SVCNAME
{L:m
{L:2
SPNAME
SPVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F20	Generic Service Ack	Sent by Host and Equipment


Comment: it is not a mistake that SVCACK is included twice
Format:


{L:4
SVCACK
LINKID
{L:n
{L:2
SPNAME
SPVAL
}
}
{L:2
SVCACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F21R	Generic Service Completion	Sent by Host and Equipment


Format:

{L:5
DATAID
OPID
LINKID
{L:n
{L:2
SPNAME
SPVAL
}
}
{L:2
SVCACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F22	Generic Service Comp Ack	Sent by Host and Equipment


Format:

DATAACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F23R	Multi-block Generic Service Inquire	Sent by Host and Equipment


Comment: You are advised not to implement this message.
Format:


{L:2
DATAID
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F24	Multi-block Generic Service Grant	Sent by Host and Equipment


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F25R	Service Name Request	Sent by Host and Equipment


Format:

{L:2
OBJSPEC
{L:n
OBJTYPE
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F26	Service Name Data	Sent by Host and Equipment


Format:

{L:2
{L:n
{L:2
OBJTYPE
{L:a
SVCNAME
}
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F27R	Service Parameter Name Req	Sent by Host and Equipment


Format:

{L:3
OBJSPEC
OBJTYPE
{L:n
SVCNAME
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S14F28	Service Parameter Name Data	Sent by Host and Equipment


Format:

{L:2
{L:n
{L:2
SVCNAME
{L:a
SPNAME
}
}
}
{L:2
OBJACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message