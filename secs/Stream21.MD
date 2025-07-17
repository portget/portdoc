S21F1R	Item Load Inquire	Sent by Host and Equipment


Format:

{L:4
ITEMTYPE
ITEMID
ITEMLENGTH
ITEMVERSION
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F2	Item Load Grant	Sent by Host and Equipment


Format:

{L:2
ITEMACK
ITEMERROR
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F3R	Item Send	Sent by Host and Equipment


Comment: Each part except the last one is max size.
Format:


{L:5
ITEMTYPE
ITEMID
ITEMLENGTH
ITEMVERSION
{L:n
ITEMPART
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F4	Item Send Acknowledge	Sent by Host and Equipment


Format:

{L:2
ITEMACK
ITEMERROR
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F5R	Item Request	Sent by Host and Equipment


Format:

{L:2
ITEMTYPE
ITEMID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F6	Item Data	Sent by Host and Equipment


Format:

{L:7
ITEMACK
ITEMERROR
ITEMTYPE
ITEMID
ITEMLENGTH
ITEMVERSION
{L:n
ITEMPART
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F7R	Item Type List Request	Sent by Host and Equipment


Format:

ITEMTYPE

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F8	Item Type List Results	Sent by Host and Equipment


Format:

{L:7
ITEMACK
ITEMERROR
ITEMTYPE
{L:n
{L:3
ITEMID
ITEMLENGTH
ITEMVERSION
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F9R	Supported Item Type List Request	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F10	Supported Item Type List Result	Sent by Host and Equipment


Format:

{L:3
ITEMACK
ITEMERROR
{L:n
ITEMTYPE
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F11	Item Delete	Sent by Host Only


Format:

{L:2
ITEMTYPE
{L:n
ITEMID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F12	Item Delete Acknowledge	Sent by Host and Equipment


Format:

{L:3
ITEMACK
ITEMTYPE
{L:n
{L:3
ITEMID
ITEMACK
ITEMERROR
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F13R	Request Permission To Send Item	Sent by Host and Equipment


Format:

{L:5
ITEMTYPE
ITEMID
ITEMLENGTH
ITEMVERSION
ITEMPARTCOUNT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F14	Grant Permission To Send Item	Sent by Host and Equipment


Format:

{L:2
ITEMACK
ITEMERROR
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F15R	Item Request	Sent by Host and Equipment


Format:

{L:2
ITEMTYPE
ITEMID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F16	Item Request Grant	Sent by Host and Equipment


Format:

{L:7
ITEMACK
ITEMERROR
ITEMTYPE
ITEMID
ITEMLENGTH
ITEMVERSION
ITEMPARTCOUNT
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F17R	Send Item Part	Sent by Host and Equipment


Comment: Each part message is not sent until the reply for the previous part is received.
Format:


{L:8
ITEMTYPE
ITEMID
ITEMLENGTH
ITEMVERSION
ITEMINDEX
ITEMPARTCOUNT
ITEMPARTLENGTH
ITEMPART
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F18	Send Item Part Acknowledge	Sent by Host and Equipment


Comment: Non-zero ITEMACK causes retry (32) or abort
Format:


{L:2
ITEMACK
ITEMERROR
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F19R	Item Type Feature Support	Sent by Host and Equipment


Comment: a zero-length list requests for all supported item types, new 6/2022
Format:


{L:n
ITEMTYPE
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S21F20	Item Type Feature Support Results	Sent by Host and Equipment


Comment: On success, ITEMACK is zero and ITEMERROR shall be zero-length
Format:


{L:n
{L:4
ITEMACK
ITEMERROR
ITEMTYPE
ITEMTYPESUPPORT
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message