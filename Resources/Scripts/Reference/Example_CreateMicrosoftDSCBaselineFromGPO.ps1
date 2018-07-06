# Security baseline for Windows 10 v1607 (“Anniversary Update”) and Windows Server 2016
# https://blogs.technet.microsoft.com/secguide/2016/10/17/security-baseline-for-windows-10-v1607-anniversary-edition-and-windows-server-2016/
Import-Module BaselineManagement
# GPO {088E04EC-440C-48CB-A8D7-A89D0162FBFB} corresponds to Windows Server 2016 Member Server Baseline - Computer
$GPOPath = $env:USERPROFILE + 'Documents\BaselineFiles\MSBaselines\Windows 10 Version 1607 and Windows Server 2016 Security Baseline\Windows-10-RS1-and-Server-2016-Security-Baseline\GPOs\{088E04EC-440C-48CB-A8D7-A89D0162FBFB}'
$OutputPath = '.\'
$ConfigName = 'HardenedConfig_Microsoft_WindowsServer2016_MemberBaseline'
ConvertFrom-GPO -OutputConfigurationScript -OutputPath $OutputPath -Path $GPOPath
Rename-Item -Path ($OutputPath.TrimEnd('\') + "\DSCFromGPO.ps1") -NewName ($ConfigName + ".ps1")