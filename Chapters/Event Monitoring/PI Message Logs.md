# PI Message Logs

See [PI Data Archive monitoring](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-291E3F6E-A950-4333-862A-21869C9F51B8) in the LiveLibrary for more details on all PI Data Archive monitoring capabilities through PI Message Logs, Connection history and Windows performance counters.

## Events Logged
Example PI Data Archive messages are provided in [PI Message Subsystem example messages](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-B9BE9843-3EA0-473E-828B-5B22C095CB92) in the LiveLibrary, including messages for:  
- Client connections
- Subsystem connections
- Disconnects
- RPC resolver events
- Dead process timeouts

## Event Record Content
PI Data Archive message structure includes:
- Timestamp: time message was written.
- Severity: classification out of critical, error, warning, information and debug.
- Source: originating component. 
- Message ID: identifier for message type.
- Text: description of the event

## Time Stamp Synchronization Capability
Messages are stored with UTC second timestamps corresponding to the clock on the OS hosting the PI Data Archive. 

## Log Storage Capacity and Behavior
The MessageLog_DayLimit parameter determines the maximum number of days the message log will be saved. See Configuration Capability below for more info. 

## Response to Event Log Processing Failures
If PI Message Subsystem is unavailable, PI Data Archive components write messages to the Windows event log.  When PI Message Subsystem starts, it merges messages from the Windows event log.  See View messages in the Windows event log for more details.

## Log Aggregation, Correlation, and Forensic Capability
PI Message Logs are retrieved via PI SMT or pigetmsg.exe utility as described in KB3248OSI8.

## Log Protection Mechanisms
Log protection relies on NTFS access control to prevent exfiltration or removal of the log files. The PIMSGSS entry in PI Database Security controls access to the message logs through the application. Application backup capability includes log files by default.

## Configuration Capability
The PI Tuning Parameter MessageLog_DayLimit determines the maximum number of days the message log will be saved.  The default value is 35 days and accepted values are between 1 and 10,000.  If altered, the parameter takes effect with the new value at startup of the PI Data Archive.

PI Message log files reside in %PISERVER%\log directory.  The %PISERVER% environmental variable can be set at installation time, but also determines the location of the parent folder of PI Data Archive service binaries and configuration files.  If it is desired to store logs on a dedicated partition or disk, then an NTFS junction point can be used to redirect the %PISERVER%\log folder to that volume.

## Navigation
Return to [Event Monitoring](../Event%20Monitoring.md)