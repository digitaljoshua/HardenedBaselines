# Security Policy Configuration Tools

## Platform Tools
The Baseline Hardened Configuration in this document primarily leverages PowerShell and [Desired State Configuration](https://docs.microsoft.com/en-us/powershell/dsc/overview).

## Application Tools
The PI Security Audit Tools and the PI Security DSC module were used to verify application specific settings. Both solutions are built on top of the PowerShell Tools for the PI System.

| Tool | Description | Source | Documentation |
| --- | --- | --- | --- |
| PowerShel Tools for the PI System | PS Module exposing cmdlets to manipulate PI System objects. | [Tech Support Site](https://techsupport.osisoft.com/Products/PI-Server/PI-System-Management-Tools/Overview) | [online help](https://techsupport.osisoft.com/Documentation/PI-Powershell/title.html) | 
| PI Security Audit Tools | Audit scripts to identify security issues with a PI System installation. | [osisoft/PI-Security-Audit-Tools](https://github.com/osisoft/PI-Security-Audit-Tools) | [repo wiki](https://github.com/osisoft/PI-Security-Audit-Tools/wiki) |
| PI Security DSC | DSC Resource module that exposes DSC Resources for PI Security objects. | [osisoft/PI-Security-DSC](https://github.com/osisoft/PI-Security-DSC/) | [repo wiki](https://github.com/osisoft/PI-Security-DSC/wiki) |

## Navigation
Previous: [Baseline Verification](Baseline%20Verification.md)  
[Table of Contents](Table%20of%20Contents.md)  
Next: [Event Monitoring](Event%20Monitoring.md)