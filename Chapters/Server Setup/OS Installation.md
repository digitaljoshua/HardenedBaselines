# OS Installation 

1. Download latest Windows Server LTSC image from MSDN.  This analysis uses the file below: 

        en_windows_server_2016_updated_feb_2018_x64_dvd_11636692.iso 

2. Follow the installation wizard. 
    1. Select "Windows Server 2016 Datacenter", which will select Windows Server Core. 
    2. Activate the installation as described in Windows Server 2016 Activation. 

3. Perform initial configuration tasks with sconfig.cmd.  For more detailed instructions, follow the instructions in Configure a Server Core installation of Windows Server 2016 with sconfig.cmd.  
    1. Select "8) Network Settings" and configure network settings to establish communication with domain controller and DNS server. 
    2. Select "2) Computer Name" and rename the computer. 
    3. Select "1) Domain/Workgroup" and join the computer to the desired domain. 
    4. Select "3) Add Local Administrator" and add appropriate domain user or group as local administrator. 
    5. Select "5) Windows Update Settings" and set Windows updates to (M) Manual. 
    6. Select "6) Download and Install Updates" and download and install updates. 
    7. Select "9) Date and Time" and set time settings through option. 
    8. Select "10) Telemetry settings" and set telemetry to the lowest setting (1. Security). 
    9. Select "13) Restart Server" to reboot the server. 

4. Install prerequisite components and modules for DSC Configurations with Install-DscBaselinePrerequisites.ps1. The script performs the actions listed below. 
    1. Installs the NuGet package manager required for PSGallery. There will be a confirmation prompt to install the latest version of NuGet and to accept the package from oneget.org. Accept both prompts to install through this script. 
    2. Sets the PSGallery repository InstallationPolicy to Trusted 
    3. Installs the DSC Resource modules listed below from PSGallery for use in configurations. 
        - AuditPolicyDSC 
        - SecurityPolicyDSC 
        - xNetworking 
        - xPSDesiredStateConfiguration 
        - xStorage 

## Navigation
[Table of Contents](../Table%20of%20Contents.md)  
[Server Setup](../Server%20Setup.md)  
Next: [PI Data Archive Installation](PI%20Data%20Archive%20Installation.md)