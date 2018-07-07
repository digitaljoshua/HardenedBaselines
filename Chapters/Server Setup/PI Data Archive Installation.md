# PI Data Archive Installation

## Pre-Installation
1. Perform the pre-installation tasks for the PI Data Archive described in Phase 1 of [Install a PI Data Archive server](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-9A426A4E-19AC-407B-BCB0-1A4B2F0BE580) in the OSIsoft Live Library.  The tasks below are listed to aid consistency with the baseline.   
    1. Baseline uses Scenario E in [Determine the disk volumes for your deployment](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-BEBB4194-0F3A-427D-88E6-8F6AE2FEDB61), with separate drives for the Operation System, PI root directory, PI Archives, PI Event queues, and PI Backups.  ProvisionDisks_ScenarioE.ps1 is an example DSC Configuration defining disk the configuration.  This example assumes there are 5 disks attached with the OS residing on disk number 0.   
    2. [Disable the Windows Time Zone (TZ) environment variable](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-0C38B6E6-B945-461B-AB42-0C212476315E) using the DSC Configuration Disable_TZVariable.ps1 or your preferred method. 

## Installation
For detailed guidance on PI Data Archive installation, please see Phase 2 of [Install a PI Data Archive server](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-9A426A4E-19AC-407B-BCB0-1A4B2F0BE580).  This baseline uses steps in [Install PI Data Archive in silent mode](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-3EAF6EA9-7EE9-4906-9E96-5EB02D7D2C90) with the file Setup_silent.ini as an example silent.ini installation configuration file.  If using the example Setup_silent.ini, you must alter the AF Server parameter and the installation directories to match your environment.
1.	Extract the PI Data Archive installation kit into the desired folder
2.	Acquire your license file by following the process documented in [License PI Data Archive](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-06AA6A50-DF6E-4097-9BD3-B6E39AF21806).
3.	Copy your acquired license file into the extracted folder from step 1.
4.	Copy Setup_silent.ini into the extracted folder and rename to silent.ini.
5.	Move the setup files onto the target server.
6.	Navigate to folder with the PI Data Archive setup files.
7.	Run silent.bat -check to verify that all contents are properly placed.
PS C:\Users\PIAdmin\Documents\Setup\Extracted>.\silent.bat -check
8.	Run silent.bat -install to install the PI Data Archive.
PS C:\Users\PIAdmin\Documents\Setup\Extracted>.\silent.bat -install
9.	Reboot the server.

## Post-Installation
This section includes the steps used after installation to crate the baseline used for analysis.
1.	Baseline uses Pacific DST rules for section [Synchronization of time settings on PI System computers](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-293F4478-3443-4A89-900B-070C1C2447E4).  Set time zone information by following [KB2341OSI8](https://techsupport.osisoft.com/Troubleshooting/KB/2341OSI8).  See [KB00872](https://techsupport.osisoft.com/Troubleshooting/KB/KB00872) for more information on DST and PI Data Archive servers.  This baseline uses the Pacific time zone file (pacific070120.tz) available on the Tech Support [download center](https://techsupport.osisoft.com/Troubleshooting/Releases/RL00358).
2.	Configure PI Backup according to steps in [Configure a PI Data Archive scheduled backup](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-8B4729DB-6141-42C9-9AAC-AC3F8E57F1B4).
    1.	Baseline uses backup path "I:\Backups".
    2.	Default of incremental backup is with no archives excluded is used.
3.	Install PI API 2016 for Windows Integrated Security by following steps in [Installing and upgrading PI API 2016 for Windows Integrated Security](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-CD8269B4-FB29-41C5-B809-3F45AEDA82BB).
4.	Install the PI Security Audit Tools and PI Security DSC module.
    1.	Download the PI Security Audit Tools and copy the zip file to your working folder for setup.
    2.	Extract the PI Security Audit Tools into the desired folder, e.g. %userprofile%\Documents\Setup.
    ```PowerShell
    PS C:\Users\PIAdmin\Documents\Setup>Expand-Archive .\PI-Security-Audit-Tools.zip .\
    ```  
    3.	Copy the folder \ExtractedPath\PISecurityAuditDSC\Module\PISecurityDSC to the folder %programfiles%\WindowsPowerShell\Modules to make the PI Security DSC resources available.
    ```PowerShell
    PS C:\Users\PIAdmin\Documents\Setup>Copy-Item .\PI-Security-Audit-Tools-master\PISecurityAuditDSC\Module\PISecurityDSC ($env:ProgramFiles + "\WindowsPowerShell\Modules") -Recurse -Verbose
    ```
5.	Apply Microsoft security baseline for Windows Server 2016 as recommended by the [Microsoft Security Guidance Blog](https://blogs.technet.microsoft.com/secguide/2016/10/17/security-baseline-for-windows-10-v1607-anniversary-edition-and-windows-server-2016/).
    1.	Dot source the configuration to make the PS Session aware of the configuration function.
    ```PowerShell
    PS C:\Users\PIAdmin\Documents\Setup>. .\WindowsServer2016_MicrosoftBaseline.ps1
    ```
    2.	Compile the configuration on the target machine to generate an MOF file.
    ```PowerShell
    PS C:\Users\PIAdmin\Documents\Setup> WindowsServer2016_MicrosoftBaseline
    ```
    3.	Apply the configuration with the Start-DscConfiguration cmdlet and the 
    ```PowerShell
    PS C:\Users\PIAdmin\Documents\Setup>Start-DscConfiguration -Path .\WindowsServer2016_MicrosoftBaseline -Wait -Verbose
    ```
    4.	Save the MOF file to use later for verification.
6.	Apply PI Data Archive configurations by repeating the dot-source, compile, and apply process outlined in (5).
    1.	Apply PIDataArchive_BasicWISImplementation.ps1 to create PI Mappings for role-based access and restrict PI Database security ACLs.  Specify the appropriate values for the ADGroup parameters when compiling the configuration.
    ```PowerShell
    PS C:\Users\PIAdmin\Documents\Setup> PIDataArchive_BasicWISImplementation `
        -PIAdministratorsADGroup "domain\PIAdmins" `
        -PIUsersADGroup "domain\PIUsers" `
        -PIBuffersADGroup "domain\PIBuffers" `
        -PIInterfacesADGroup "domain\PIInterfaces" `
        -PIWebAppsADGroup "domain\PIWebApps" `
        -PIPointsAnalysisCreatorADGroup "domain\PIAnalysis" 
    ```
    2.	Apply PIDataArchive_AuditBaseline.ps1 to harden the PI Data Archive application with application specific settings.
7.	Apply OS hardening measures recommended for the OS by OSIsoft, by repeating the dot-source, compile, and apply steps 1-3 in (5) with PIDataArchive_WindowsHardening.ps1.  This configuration does the following:
    1.	Enable defensive capabilities of Windows Defender.
    2.	Enable minimal Windows firewall exceptions.
    3.	Verify that only essential roles and features are enabled.
    4.	Harden the ciphers and protocols used by schannel.dll.
    5.	Disable unnecessary services.
8.	Add the server to a PI Collective by following the steps in [Create a collective](https://livelibrary.osisoft.com/LiveLibrary/content/en/server-v10/GUID-89F0B167-F42B-4643-A3F8-E692F58F5BD0) in the OSIsoft Live Library.
9.	Generate and deploy a Code Integrity Policy for Windows Defender Application Control.
    1.	Run Add-AntivirusExclusions.ps1 to add antivirus exclusions in accordance with guidance in KB01062.  Note: script assumes paths used in baseline.
    2.	Copy New-CodeIntegrityPolicy.ps1 and MSBlockSiPolicy.xml into the Documents folder.
    3.	Run New-CodeIntegrityPolicy.ps1 to:
        1.	Create a code integrity policy based on the publishers in digital signatures with a fallback to file hashes for any unsigned files in the image.
        2.	Merge in Microsoft’s recommended policy to block common application whitelisting bypasses.
    3.	Deploy the policy.
    4.	Reboot the server.

## Navigation
[Table of Contents](Table%20of%20Contents.md)  
[Server Setup](Server%20Setup.md)
Previous: [OS Installation](OS%20Installation.md)