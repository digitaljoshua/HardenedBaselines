# Connection History

## Events Logged
Example connection history records are available in [Connection history information](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-D3F250ED-EF1D-4DCF-B1B0-156BDB5E92D1) in the LiveLibrary.

## Event Record Content
PI Data Archive connection history entries include:
- IP address
- Name of the executable of the connecting application
- Connection ID as recorded by PI Network Manager
- Time connection initiated
- Time connection ended (if applicable)
- Shutdown state
- License information

## Time Stamp Synchronization Capability
Messages are stored with UTC second timestamps corresponding to the clock on the OS hosting the PI Data Archive. 

## Log Storage Capacity and Behavior
The retention period can be set to any value between 24 hours and 2 years, with 1 year as the default value. See [Connection history information](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v11/GUID-D3F250ED-EF1D-4DCF-B1B0-156BDB5E92D1) for instructions on setting the retention period.

## Response to Event Log Processing Failures
//TODO

## Log Aggregation, Correlation, and Forensic Capability
Connection history records can be queried with the pidiag utility.  Native querying capabilities include all connections from a specific IP Address, all connections from specific application, all applications on a node, etc.

For more information and query examples, see [Connection history information](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-D3F250ED-EF1D-4DCF-B1B0-156BDB5E92D1) in the LIveLibrary.

PI Nework Manager Statistics record detailed information for every active connection to the PI Data Archive.  Attributes of particular interest for correlation purposes are ID, ConTime, RegAppName, and PeerAddress  All attributes associated with a connection statistic are listed in [Statistics](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-A3D7E80C-2C74-40D3-805F-8F0F0FC26978) in the LiveLibrary.

## Log Protection Mechanisms
Log protection relies on NTFS access control to prevent exfiltration or removal of the log files.

## Configuration Capability
The ConnectionHistoryFlushInterval parameter determines how frequently updates are added to the connection history, as described in Use piconfig to set the history flush interval in the LiveLibrary.

The ConnectionDatabaseRetentionDuration parameter determines how long connections are retained in the connection history after they have ended, as described in Use piconfig to set the retention period in the LiveLibrary.

## Navigation
Return to [Event Monitoring](../Event%20Monitoring.md)