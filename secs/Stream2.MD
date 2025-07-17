
S2F1	Service Program Load Inquire	Sent by Host and Equipment


Format:

{L:2
SPID
LENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F2	Service Program Load Grant	Sent by Host and Equipment


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F3	Service Program Send	Sent by Host and Equipment


Format:

SPD

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F4	Service Program Send Acknowledge	Sent by Host and Equipment


Format:

SPAACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F5	Service Program Load Request	Sent by Host and Equipment


Format:

SPID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F6	Service Program Load Data	Sent by Host and Equipment


Format:

SPD

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F7	Service Program Run Send	Sent by Host and Equipment


Format:

SPID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F8	Service Program Run Acknowledge	Sent by Host and Equipment


Format:

CSAACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F9	Service Program Results Request	Sent by Host and Equipment


Format:

SPID

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F10	Service Program Results Data	Sent by Host and Equipment


Format:

SPR

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F11	Service Program Directory Request	Sent by Host and Equipment


Format:

header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F12	Service Program Directory Data	Sent by Host and Equipment


Format:

{L:n
SPID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F13R	Equipment Constant Request	Sent by Host Only


Comment: Host sends L:0 to receive all in predefined order
Format:


{L:n
ECID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F14	Equipment Constant Data	Sent by Equipment Only


Comment: An L:0 is substituted if an ECID does not exist, L format is not allowed for an ECV.
Format:


{L:n
ECV
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F15R	New Equipment Constant Send	Sent by Host Only


Comment: Constant is a misnomer, they are settable parameters.
Format:


{L:n
{L:2
ECID
ECV
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F16	New Equipment Constant Ack	Sent by Equipment Only


Comment: if any input value is not proper, none of the input values are set
Format:


EAC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F17R	Date and Time Request	Sent by Host and Equipment


Comment: NTP servers should be used instead for better accuracy and to avoid lack of time zone specification.
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F18	Date and Time Data	Sent by Host and Equipment


Comment: The value should not be used for system clock synchronization.
Format:


TIME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F19R	Reset/Initialize Send	Sent by Host Only


Format:

RIC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F20	Reset Acknowledge	Sent by Equipment Only


Format:

RAC

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F21[R]	Remote Command Send	Sent by Host Only


Comment: Compare to S2F41R. Arguments can be passed as you would on a command line.
Format:


RCMD

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F22	Remote Command Acknowledge	Sent by Equipment Only


Format:

CMDA

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F23R	Trace Initialize Send	Sent by Host Only


Comment: Set TOTSMP=0 to terminate a trace. Set zero-length TRID to delete all traces.
Format:


{L:5
TRID
DSPER
TOTSMP
REPGSZ
{L:n
SVID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F24	Trace Initialize Acknowledge	Sent by Equipment Only


Format:

TIAACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F25R	Loopback Diagnostic Request	Sent by Host and Equipment


Comment: it is useful to test the telnet escape sequence
Format:


ABS

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F26	Loopback Diagnostic Data	Sent by Host and Equipment


Format:

ABS

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F27R	Initiate Processing Request	Sent by Host Only


Comment: made obsolete by S2F41R ?
Format:


{L:3
LOC
PPID
{L:n
MID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F28	Initiate Processing Acknowledge	Sent by Equipment Only


Format:

CMDA

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F29R	Equipment Constant Namelist Request	Sent by Host Only


Comment: Host sends L:0 for all ECIDs
Format:


{L:n
ECID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F30	Equipment Constant Namelist	Sent by Equipment Only


Format:

{L:n
{L:6
ECID
ECNAME
ECMIN
ECMAX
ECDEF
UNITS
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F31R	Date and Time Set Request	Sent by Host Only


Comment: Modern equipment should use NTP servers to synchronize the system clock. SECS is inaccurate and does not include timezone info.
Format:


TIME

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F32	Date and Time Set Acknowledge	Sent by Equipment Only


Format:

TIACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F33R	Define Report	Sent by Host Only


Comment: a=0 means delete all reports and event links, b=0 means delete the RPTID type and its event links
Format:


{L:2
DATAID
{L:a
{L:2
RPTID
{L:b
VID
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F34	Define Report Acknowledge	Sent by Equipment Only


Format:

DRACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F35R	Link Event Report	Sent by Host Only


Comment: b=0 disassociates the CEID from all report links. The message links reports to an event, it does not imply a particular output sequence in the event report.
Format:


{L:2
DATAID
{L:a
{L:2
CEID
{L:b
RPTID
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F36	Link Event Report Acknowledge	Sent by Equipment Only


Format:

LRACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F37R	Enable/Disable Event Report	Sent by Host Only


Comment: n=0 means all CEIDs
Format:


{L:2
CEED
{L:n
CEID
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F38	Enable/Disable Event Report Acknowledge	Sent by Equipment Only


Format:

ERACK

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F39R	Multi-block Inquire	Sent by Host Only


Comment: for SECS-I mullti-block S2F23 F33, F35, F45, or F49, not required for HSMS
Format:


{L:2
DATAID
DATALENGTH
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F40	Multi-block Grant	Sent by Equipment Only


Format:

GRANT

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F41R	Host Command Send	Sent by Host Only


Format:

{L:2
RCMD
{L:n
{L:2
CPNAME
CPVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F42	Host Command Acknowledge	Sent by Equipment Only


Comment: n is equal to the number of parameters having errors
Format:


{L:2
HCACK
{L:n
{L:2
CPNAME
CPACK
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F43R	Configure Spooling	Sent by Host Only


Comment: m=0 turns off all streams and fns, n=0 turns on all functions in the stream, stream 1 is not spooled
Format:


{L:m
{L:2
STRID
{L:n
FCNID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F44	Configure Spooling Acknowledge	Sent by Equipment Only


Comment: m=0 when there are no errors; n is the number of functions in error in a stream
Format:


{L:2
RSPACK
{L:m
{L:3
STRID
STRACK
{L:n
FCNID
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F45R	Define Variable Limit Attributes	Sent by Host Only


Comment: L:2* can be L:2 or L:0
Format:


{L:2
DATAID
{L:m
{L:2
VID
{L:n
{L:2
LIMITID
{L:2*
UPPERDB
LOWERDB
}
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F46	Define Variable Limit Attributes Acknowledge	Sent by Equipment Only


Comment: L:2* can be L:2 or L:0, varies with VID
Format:


{L:2
VLAACK
{L:m
{L:3
VID
LVACK
{L:2*
LIMITID
LIMITACK
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F47R	Variable Limit Attribute Request	Sent by Host Only


Comment: Host sends L:0 to discover VIDs that support limits
Format:


{L:m
VID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F48	Variable Limit Attribute Send	Sent by Equipment Only


Comment: L:4* can be L:4 or L:0
Format:


{L:m
{L:2
VID
{L:4*
UNITS
LIMITMIN
LIMITMAX
{L:n
{L:3
LIMITID
UPPERDB
LOWERDB
}
}
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F49R	Enhanced Remote Command	Sent by Host Only


Comment: the standard fails to show the message is sent with reply requested; CEPVAL can be a list of same format values or CPNAME CEPVAL pairs, possible nested list inclusion is implied
Format:


{L:4
DATAID
OBJSPEC
RCMD
{L:m
{L:2
CPNAME
CEPVAL
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F50	Enhanced Remote Command Acknowledge	Sent by Equipment Only


Comment: CEPACK can be a list structure with possible nesting of additional list structures
Format:


{L:2
HCACK
{L:n
{L:2
CPNAME
CEPACK
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F51R	Request Report Identifiers	Sent by Host Only


Comment: Host sends S2F51R to discover defined RPTIDs, new 8/2021
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F52	Return Report Identifiers	Sent by Equipment Only


Format:

{L:n
RPTID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F53R	Request Report Definitions	Sent by Host Only


Comment: Host sends L:0 for all defined reports, new 8/2021
Format:


{L:n
RPTID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F54	Return Report Definitions	Sent by Equipment Only


Comment: a is 0 for unknown RPTID, n is 0 for no reports defined and L:0 request, new 8/2021
Format:


{L:n
{L:2
RPTID
{L:a
VID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F55R	Request Event Report Links	Sent by Host Only


Comment: Host sends L:0 to discover linked events and links, new 8/2021
Format:


{L:n
CEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F56	Return Event Report Links	Sent by Equipment Only


Comment: CENAME is A:0 for unknown CEID, a is 0 for no linked reports, L:0 reply to L:0 if no links defined, new 8/2021
Format:


{L:n
{L:3
CEID
CENAME
{L:a
RPTID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F57R	Request Enabled Events	Sent by Host Only


Comment: Host sends header-only to discover events that are enabled for reporting, new 8/2021
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F58	Return Enabled Events	Sent by Equipment Only


Format:

{L:n
CEID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F59R	Request Spool Streams and Functions	Sent by Host Only


Comment: Host sends header-only to discover SFs configured for spooling, new 8/2021
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F60	Return Spool Streams and Functions	Sent by Equipment Only


Comment: n=0 indicates spooling disabled, b=0 implies all Fs in stream, new 8/2021
Format:


{L:n
{L:2
STRID
{L:a
FCNID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F61R	Request Trace Identifiers	Sent by Host Only


Comment: Host sends header-only to discover S2F23 trace reports, new 8/2021
Format:


header only

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F62	Return Trace Identifiers	Sent by Equipment Only


Comment: Host configures traces with S2F23, new message 8/2021
Format:


{L:n
TRID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F63R	Request Trace Definitions	Sent by Host Only


Comment: Host sends L:0 for all traces setup with S2F23, new 8/2021
Format:


{L:n
TRID
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message
S2F64	Return Trace Definitions	Sent by Equipment Only


Comment: zero-length items sent for unknown TRID, n=0 for no traces defined and L:0 query, new 8/2021
Format:


{L:n
{L:5
TRID
DSPER
TOTSMP
REPGSZ
{L:a
SVID
}
}
}

C# Parse Message    C++ Parse Message    Java Parse Message    Python Parse Message    Tcl Parse Message