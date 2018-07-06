# Windows Security Event Log

## Events Logged
Authentication to the PI Data Archive with Windows Integrated Security will register in the Windows Security event log.  Relevant event IDs for authentication events are:
- [4624](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4624) – An account was successfully logged on.
- [4672](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4672) – Special privileges assigned to new logon.
- [4634](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4634) – An account was logged off.

## Event Record Content
See [Advaced security audit policy settings](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings) in the Microsoft documentation for message format and examples.

## Time Stamp Synchronization Capability
Records are stored with UTC second timestamps corresponding to the clock on the OS hosting the PI Data Archive.

## Log Storage Capacity and Behavior
Event logs have a default maximum size of 20MB.  Oldest events are discarded when logs reach the size limit.  

## Response to Event Log Processing Failures
Logging failures will be recorded as a separate event if possible.

## Log Aggregation, Correlation, and Forensic Capability
The built in Windows Event Viewer application can be used to read and filter logs.

## Log Protection Mechanisms
Log protection relies on NTFS access control to prevent exfiltration or removal of log files.  By default, only administrators can delete events.

## Configuration Capability
Windows Event Forwarding can be leveraged to aggregate logs and integrate with a SEIM.

## Navigation
Return to [Event Monitoring](../(7)%20Event%20Monitoring.md)