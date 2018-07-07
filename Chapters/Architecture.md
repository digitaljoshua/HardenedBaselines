# Architecture

## Plant Architecture
//TODO: Add architecture diagram

The previous figure shows the PI Data Archive relative to the Restricted Network, Site Network and DMZ as described in the Scope in Section 1. 

## Simplified PI System Data Flow
//TODO: Add figure

The figure above shows the flow of PI System traffic from the data source (OPC UA Server) out to the Engineering workstations on site and the PI Connector Relay to corporate access. A short description for each of the numbered flows is provided below. 

1. HTTPS * - Connector reads data from data source, e.g. OPC UA over port configured for data source. 
2. AMQPS (5671) – PI Connector writes asset data to PI Connector Relay.   
3. PINET (5457) – PI Connector Relay writes asset metadata to the PI AF Server. 
4. PINET (5450) – PI Connector Relay writes time-series data to the PI Data Archive primary. 
5. PINET (5450) - PI Connector Relay writes time-series data to the PI Data Archive secondary. 
6. PINET (5457) - PI System Connector reads asset metadata from the PI AF Server. 
7. PINET (5457) - PI Vision reads asset metadata from the PI AF Server. 
8. PINET (5450) - PI System Connector reads time-series data from the PI Data Archive primary. 
9. PINET (5450) - PI Vision reads time-series data from the PI Data Archive primary. 
10. PINET (5450) - PI System Connector reads time-series data from the PI Data Archive secondary. 
11. PINET (5450) - PI Vision reads time-series data from the PI Data Archive secondary. 
12. AMQPS (5671) – PI System Connector writes asset data to PI Connector Relay. 
13. HTTPS (443) – PI Vision sends display data to clients. 
14. PINET (5457) – PI Connector Relay writes asset metadata to corporate PI AF Server. 
15. PINET (5450) – PI Connector Relay writes time-series data to corporate PI Data Archive. 
16. PINET (5450) – PI Data Archive primary synchronizes configuration data to PI Data Archive secondary. 
17. PINET (5457) – Administrator workstation writes configuration data to PI AF Server. 
18. PINET (5450) - Administrator workstation writes configuration data to PI Data Archive primary. 

## Logical Data Flows for the PI Data Archive
//TODO: Add figure

As the scope of this CSDS is bounded to the PI Data Archive server, the above Data Flow Diagram (DFD) depicts a set of logical flows into and out of the PI Data Archive server deployed according to the architecture in Figure 2-1.  

### DFD Assets
The following connected assets are present in the above DFD: 
- **AD DS & DNS:** Domain Controller server with DNS server role. 
Administrator Workstation: a typical domain-joined Windows workstation used for administration. 
- **File Server:** file server for storing offline PI Data Archive backups in case of catastrophic failure.  
- **PI Connector Relay:** a component that writes time-series data to the site PI Data Archive and asset metadata to the site PI AF Server from devices on the restricted network. 
- **PI Data Archive Server (Primary):** the primary member of a PI Data Archive configured for high availability and following the baseline defined in the PI Data Archive Baseline Hardened Configuration. 
- **PI Data Archive Server (Secondary):** the secondary member of a PI Data Archive configured for high availability. 
- **PI System Connector:** a software component reading time-series data from the site PI Data Archive server and asset metadata from the site PI AF Server. That data is sent to the PI Connector Relay in the DMZ, where it is forwarded to the corporate PI Data Archive. 
- **PI Vision Server:** server hosting the PI Vision web application for visualization of asset data. 
- **Windows Update Server:** Server hosting Windows updates. 

### DFD Trust Boundaries
- **Machine:** communications outside the PI Data Archive machine boundary.
- **External:** assets outside the site network.

### In Scope Data Flows
The following data flows are present in the above DFD and are in scope for the remainder of this document: 

- **AD DC and DNS** 

  - **Auth Request:** Group Policy and Active Directory authentication request traffic, initiated by the PI Data Archive 

   - **Auth Response:** Active Directory based Group Policy and authentication response flows to PI Data Archive 

  - **Time Signal** – NTP (123): synchronize time across domain members 

- **WSUS Server** 

  - **Patch** – HTTPS (443): response from WSUS, including Microsoft Windows Update software patches 

  - **Patch Request** – HTTPS (443): WSUS request for Microsoft Windows Update software patches 

- **File Server**  

  - **Backup** – SMB (445): regular backups are transported to a network accessible file server to prevent a single point of failure. 

- **Administrator Workstation** 

  - **PowerShell Remoting** – HTTPS (5986): remote administration tasks to the operating system. 

  - **Write configuration data** – PINET (5450): client application modifies application configuration data on the PI Data Archive. 

- **PI Connector** 

  - **Read time-series data** – PINET (5450): client application reads time series data from the PI Data Archive. 

- **PI Connector Relay** 

  - **Write time-series data** – PINET (5450): client application writes time series data to the PI Data Archive. 

- **PI Data Archive (Secondary)**

  - **Sync configuration data** – PINET (5450): application configuration information is replicated from the PI Data Archive Primary to the Secondary node.    

- **PI Vision** 

  - **Read time-series data** – PINET (5450): client application reads time-series data from the PI Data Archive. 

### Out of Scope Data Flows
All flows in Logical Flows for the PI Data Archive are in scope.

## Navigation
Previous: [Introduction](Introduction.md)   
[Table of Contents](Table%20of%20Contents.md)  
Next: [Server Setup](Server%20Setup.md)