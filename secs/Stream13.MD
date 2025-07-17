
S13F1R	Send Data Set Send	Sent by Host and Equipment


Comment: S13F1 seems to have the L: wrapper that S13F2 is missing. Be prepared to receive DSNAME without the L:
Format:


{L:1
DSNAME
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F2	Send Data Set Ack	Sent by Host and Equipment


Comment: The standards have had an erroneous structure for years - the L:2 has been missing. Unfortunately some implementations have not realized it was an error. The latest Hume versions automagically create the L:2 wrapper when it is missing.
Format:


{L:2
DSNAME
ACKC13
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F3R	Open Data Set Request	Sent by Host and Equipment


Comment: Sent by the receiver to open a data set for reading
Format:


{L:3
HANDLE
DSNAME
CKPNT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F4	Open Data Set Data	Sent by Host and Equipment


Format:

{L:5
HANDLE
DSNAME
ACKC13
RTYPE
RECLEN
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F5R	Read Data Set Request	Sent by Host and Equipment


Format:

{L:2
HANDLE
READLN
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F6	Read Data Set Data	Sent by Host and Equipment


Format:

{L:4
HANDLE
ACKC13
CKPNT
{L:n
FILDAT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F7R	Close Data Set Send	Sent by Host and Equipment


Format:

{L:1
HANDLE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F8	Close Data Set Ack	Sent by Host and Equipment


Format:

{L:2
HANDLE
ACKC13
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F9R	Reset Data Set Send	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F10	Reset Data Set Ack	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F11R	Data Set Obj Multi-Block Inquire	Sent by Host and Equipment


Format:

{L:3
DATAID
OBJSPEC
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F12	Data Set Obj Multi-Block Grant	Sent by Host and Equipment


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F13R	Table Data Send	Sent by Host and Equipment


Comment: The first element of every row is a primary key value which identifies the row. The row items correspond in sequence to the column headers. E58 uses attributes NumCols, NumRows, and DataLength
Format:


{L:8
DATAID
OBJSPEC
TBLTYP
TBLID
TBLCMD
{L:n
{L:2
ATTRID
ATTRDATA
}
}
{L:c
COLHDR
}
{L:r
{L:m
TBLELT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F14	Table Data Ack	Sent by Host and Equipment


Format:

{L:2
TBLACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F15R	Table Data Request	Sent by Host and Equipment


Comment: Either p or q or both are 0.
Format:


{L:7
DATAID
OBJSPEC
TBLTYP
TBLID
TBLCMD
{L:p
COLHDR
}
{L:q
TBLELT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S13F16	Table Data	Sent by Host and Equipment


Format:

{L:6
TBLTYP
TBLID
{L:n
{L:2
ATTRID
ATTRDATA
}
}
{L:c
COLHDR
}
{L:r
{L:c
TBLELT
}
}
{L:2
TBLACK
{L:p
{L:2
ERRCODE
ERRTEXT
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
