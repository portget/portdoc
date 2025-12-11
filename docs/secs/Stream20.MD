S20F1R	SetSRO Attributes Request	Sent by Host Only


Comment: E170 SRO intitialization, enums are inverted booleans so Hume has renamed them
Format:


{L:6
OBJID
OBJTYPE
AUTOPOST_DISABLE
AUTOCLEAR_DISABLE
RETAINRECIPE_DISABLE
AUTOCLOSE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F2	SetSRO Attributes Acknowledge	Sent by Equipment Only


Format:

SSAACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F3R	GetOperationIDList Request	Sent by Host Only


Format:

{L:3
OBJID
OBJTYPE
OPETYPE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F4	GetOperationIDList Acknowledge	Sent by Equipment Only


Format:

{L:2
{L:n
OPEID
}
GOILACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F5R	OpenConnectionEvent Send	Sent by Equipment Only


Format:

{L:7
OBJID
OBJTYPE
OPETYPE
RMSUSERID
RMSPWD
EQUSERID
OPEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F6	OpenConnectionEvent Acknowledge	Sent by Host Only


Format:

{L:2
OPEID
OCEACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F7R	CloseConnectionEvent Send	Sent by Equipment Only


Comment: a request to close a connection
Format:


{L:4
OBJID
OBJTYPE
OPETYPE
OPEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F8	CloseConnectionEvent Acknowledge	Sent by Host Only


Format:

{L:2
OPEID
CCEACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F9R	ClearOperation Request	Sent by Host Only


Comment: clear all recipes for the Operation ID
Format:


{L:4
OBJID
OBJTYPE
OPETYPE
OPEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F10	ClearOperation Acknowledge	Sent by Equipment Only


Format:

COACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F11R	GetRecipeXIDList Request	Sent by Host Only


Comment: query recipes for the Operation ID
Format:


{L:4
OBJID
OBJTYPE
OPETYPE
OPEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F12	GetRecipeXIDList Acknowledge	Sent by Equipment Only


Format:

{L:2
{L:n
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}
GRXLACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F13R	DeleteRecipe Request	Sent by Host Only


Comment: delete specified recipes
Format:


{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F14	DeleteRecipe Acknowledge	Sent by Equipment Only


Format:

DRRACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F15R	WriteRecipe Request	Sent by Host Only


Comment: n is the number of recipes
Format:


{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
{L:n
{L:10
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
RCPBODYA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F16	WriteRecipe Acknowledge	Sent by Equipment Only


Format:

WRACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F17R	ReadRecipe Request	Sent by Host Only


Comment: n is the number of recipes
Format:


{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
{L:n
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F18	ReadRecipe Acknowledge	Sent by Equipment Only


Format:

{L:2
{L:n
{L:10
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
RCPBODYA
}
}
RRACK_S20
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F19R	QueryRecipeXIDList Event Send	Sent by Equipment Only


Format:

{L:4
OBJID
OBJTYPE
OPETYPE
OPEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F20	QueryRecipeXIDList Event Acknowledge	Sent by Host Only


Format:

{L:3
OPEID
{L:n
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}
QRXLEACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F21R	QueryRecipe Event Send	Sent by Equipment Only


Format:

{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
{L:n
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F22	QueryRecipe Event Acknowledge	Sent by Host Only


Format:

QREACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F23R	PostRecipe Event Send	Sent by Equipment Only


Format:

{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
{L:n
{L:10
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
RCPBODYA
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F24	PostRecipe Event Acknowledge	Sent by Host Only


Format:

PREACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F25R	SetPRC Attributes Request	Sent by Host Only


Comment: MAXNUMBERLIST is {L:n MAXNUMBER}
Format:


{L:5
OBJID
OBJTYPE
{L:n
MAXNUMBER
}
MAXTIME
PRCPREEXECHK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F26	SetPRC Attributes Acknowledge	Sent by Equipment Only


Format:

SPAACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F27R	PreSpecifyRecipe Request	Sent by Host Only


Format:

{L:6
OBJID
OBJTYPE
OPETYPE
OPEID
PRJOBID
{L:n
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F28	PreSpecifyRecipe Acknowledge	Sent by Equipment Only


Format:

PSRACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F29R	QueryPJRecipeXIDList Event Send	Sent by Equipment Only


Format:

{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
PRJOBID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F30	QueryPJRecipeXIDList Event Acknowledge	Sent by Host Only


Format:

{L:2
{L:n
{L:9
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
}
}
QPRKEACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F31R	Pre-Exe Check Event Send	Sent by Equipment Only


Format:

{L:6
OBJID
OBJTYPE
OPETYPE
OPEID
PRJOBID
CHKINFO
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F32	Pre-Exe Check Event Acknowledge	Sent by Host Only


Format:

{L:3
PECRSLT
{L:n
{L:10
TIMESTAMP
OPEID
ASSGNID
COPYID
REVID
RecID
VERID
TYPEID
EQID
RCPBODYA
}
}
PECEACK
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F33R	PreSpecifyRecipe Event Send	Sent by Equipment Only


Format:

{L:5
OBJID
OBJTYPE
OPETYPE
OPEID
PRJOBID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S20F34	PreSpecifyRecipe Event Acknowledge	Sent by Host Only


Format:

PSREACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
