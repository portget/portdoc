
S1F1R	Are You Online?	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F2	On Line Data	Different Host and Equipment Use


Comment: Equipment sends the reply to indicate an online control state, otherwise an abort reply is seen.
Equipment Send Format:


{L:2
MDLN
SOFTREV
}

C# Parse Equip Message    C++ Parse Equip Message    Java Parse Equip Message    Python Parse Equip Message    Tcl Parse Equip Message
Host Send Format:


L:0

C# Parse Host Message   C++ Parse Host Message    Java Parse Host Message    Python Parse Host Message    Tcl Parse Host Message
S1F3R	Selected Equipment Status Request	Sent by Host Only


Format:

{L:n
SVID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F4	Selected Equipment Status Data	Sent by Equipment Only


Comment: zero length value returned for unknown SVID
Format:


{L:n
SV
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F5R	Formatted Status Request	Sent by Host Only


Format:

SFCD

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F6	Formatted Status Data	Sent by Equipment Only


Comment: message structure varies, superseded by dynamic reports
Format:


{L:n
SV
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F7	Fixed Form Request	Sent by Host Only


Format:

SFCD

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F8	Fixed Form Data	Sent by Equipment Only


Comment: format varies, superseded by dynamic reports
Format:


{L:n
{L:2
SVNAME
SV0
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F9R	Material Transfer Status Request	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F10	Material Transfer Status Data	Sent by Equipment Only


Comment: An L:0 reply can be sent if there are no material ports
Format:


{L:2
TSIP
TSOP
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F11R	Status Variable Namelist Request	Sent by Host Only


Comment: Host sends L:0 to request all SVIDs.
Format:


{L:n
SVID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F12	Status Variable Namelist Reply	Sent by Equipment Only


Comment: A:0 for SVNAME and UNITS indicates unknown SVID
Format:


{L:n
{L:3
SVID
SVNAME
UNITS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F13R	Establish Communications Request	Different Host and Equipment Use


Equipment Send Format:

{L:2
MDLN
SOFTREV
}

C# Parse Equip Message    C++ Parse Equip Message    Java Parse Equip Message    Python Parse Equip Message    Tcl Parse Equip Message
Host Send Format:


L:0

C# Parse Host Message   C++ Parse Host Message    Java Parse Host Message    Python Parse Host Message    Tcl Parse Host Message
S1F14	Establish Communications Request Acknowledge	Different Host and Equipment Use


Comment: MDLN and SOFTREV may not be valid unless COMMACK value is 0
Equipment Send Format:


{L:2
COMMACK
{L:2
MDLN
SOFTREV
}
}

C# Parse Equip Message    C++ Parse Equip Message    Java Parse Equip Message    Python Parse Equip Message    Tcl Parse Equip Message
Host Send Format:


{L:2
COMMACK
L:0
}

C# Parse Host Message   C++ Parse Host Message    Java Parse Host Message    Python Parse Host Message    Tcl Parse Host Message
S1F15R	Request OFF-LINE	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F16	OFF-LINE Acknowledge	Sent by Equipment Only


Format:

OFLACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F17R	Request ON-LINE	Sent by Host Only


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F18	ON-LINE Acknowledge	Sent by Equipment Only


Format:

ONLACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F19R	Get Attribute	Sent by Host and Equipment


Comment: L:m = L:0 for all objects, L:n = L:0 for all attributes
Format:


{L:3
OBJTYPE
{L:m
OBJID
}
{L:n
ATTRID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F20	Attribute Data	Sent by Host and Equipment


Comment: Ordered per request., m=0 means OBJTYPE unknown, n=0 means instance not found, error associations are problematic
Format:


{L:2
{L:m
{L:n
ATTRDATA
}
}
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F21R	Data Variable Namelist Request	Sent by Host Only


Comment: Host sends L:0 to request all DVVALs. VIDs are limited to DVVAL variables only. (proposed ballot item 4824B, Oct 2011)
Format:


{L:n
VID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F22	Data Variable Namelist Reply	Sent by Equipment Only


Comment: A:0 for DVVALNAME and UNITS indicates unknown VID or that VID is not a DVVAL. (proposed ballot item 4824B, Oct 2011)
Format:


{L:n
{L:3
VID
DVVALNAME
UNITS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F23R	Collection Event Namelist Request	Sent by Host Only


Comment: Host sends L:0 to imply all CEIDs. (proposed ballot item 4824B, Oct 2011)
Format:


{L:n
CEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S1F24	Collection Event Namelist Reply	Sent by Equipment Only


Comment: Only associated DVVAL VIDs are listed. A:0 for CENAME and L:0 for L:a indicates non-existent CEID. (proposed ballot item 4824B, Oct 2011)
Format:


{L:n
{L:3
CEID
CENAME
{L:a
VID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message