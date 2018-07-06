# PI Audit Database

## Events Logged
Records the data that is added, edited, or removed from database files, as well as other events or changes to configuration that occur in the PI Data Archive to satisfy FDA Title 21 CFR Part 11 auditing requirements.  Archive and Snapshot Subsystem audit information can be configured to record to the PI Message Logs, typically for testing or troubleshooting.  See [Auditing the PI Data Archive](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-2DF085E7-7AC3-4873-80CD-F7241C0A965F) in the LiveLibrary for more information.

[Example audit records](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-1395C279-1838-44F2-99CD-7D5D251F4F18) in the LiveLibrary contains example records for: LiveLibrary.
- PI Points: Create, Delete, and Edit
- Archives: Remove and Edit
- Module and Batch Database: Modules, Module hierarchy, PI Properties, PI Batches, and PI Unit Batches.

## Event Record Content
All attributes for audit records are defined in [Audit Database file contents](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-DFE93F50-4D40-4E06-BD5B-628C4080971A) in the LiveLibrary.
- PIUser: the name of the Windows user (except in records from Archive subsystem, where ID=0)
- PITime: time and date
- Database: database affected
- Action: Change action: Add, Remove, or Edit
- AuditRecordID: Unique ID
- Name: affected record name
- ID: affected record ID
- Changes:  On Add and Remove Action, indicates attribute settings. On Edit Action, indicates before and after values.

Attributes for audit records relayed to the PI Message Logs for Archive and Snapshot Subsystems are defined in [Audit log messages for archive and snapshot changes](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-F5DF004B-FDFE-401C-A662-D2CD355CAFFA) in the LiveLibrary.
- Message source: The message source is Archive Edit
- Edit date	: Edit date
- Edit type: Delete or Replace
- Point ID: Point ID
- Connection ID: Connection ID
- User: Only in message from the PI Snapshot Subsystem
- Event time: Edit time
- New value: Only in message from the PI Snapshot Subsystem
- Old value: Only in message from PI Archive.

## Time Stamp Synchronization Capability
Records are stored with UTC second timestamps corresponding to the clock on the host OS.

## Log Storage Capacity and Behavior
As described in [Principles of operation](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-F278665F-6854-437D-88D9-7FF8581A65EA), under normal operation, there are three distinct files used by the PI Audit Database: pibasessAudit.dat, piarchssAudit.dat, and pisnapssAudit.dat.    

## Response to Event Log Processing Failures
Per [Audit Database file open failure](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-80ED356E-3418-4304-87ED-7775F605093C), if a database file cannot be opened, an alternate file is created with a tilde and time in UTC seconds appended to the file name before the file extension.

## Log Aggregation, Correlation, and Forensic Capability
The PI AuditViewer application can be used to view and analyze PI Audit Database records.  See the [PI AuditViewer overview](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-5BD2BC34-5727-44FF-9D16-B89B5184DB05) for more information.

## Log Protection Mechanisms
Log protection relies on NTFS access control to prevent exfiltration or removal.  The PIAudit entry in PI Database Security controls read access to the audit log.

## Configuration Capability
Auditing can be enabled on all or a subset of databases by setting the [EnableAudit tuning parameter](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-6ED346F9-2FA9-48E1-9B2F-55F688CBF860), as described in EnableAudit tuning parameter.  AuditMaxKBytes and AuditMaxRecords tuning parameters define the maximum size of an audit database file before rolling over into a new file in terms of file size in kilobytes and audit records, respectively.

The ArchiveEditLogging parameter enables recording auditing events to the PI Message Logs for PI Archive and PI Snapshot event deletions and edits.  The BatchDbEditLogging parameter enables recording auditing events to the PI Message Logs for PI Batch and PI Unit Batch deletions and edits.

## Navigation
Return to [Event Monitoring](../(7)%20Event%20Monitoring.md)