$OutputFolder = ".\"

# Windows Firewall Rules
Show-NetFirewallRule -PolicyStore ActiveStore `
							| Out-File ($OutputFolder + "\" + "Reference-Windows-FirewallRules.txt")

# Required Software Objects - Installed Programs
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* `
							| Select-Object DisplayName, Publisher, InstallDate `
							| Format-Table -AutoSize `
							| Out-File ($OutputFolder + "\" + "Reference-Windows-Programs.txt")
							
# Installed Windows Features
Get-WindowsFeature | Where-Object { $_.Installed -eq $true } `
							| Select-Object Name, Path, Installed
							| Format-Table -AutoSize `
							| Out-File ($OutputFolder + "\" + "Reference-Windows-Features.txt")

# Windows Services
Get-Service | Select-Object StartType, Status, Name, DisplayName `
							| Sort-Object StartType, Status, Name `
							| Format-Table -AutoSize `
							| Out-File ($OutputFolder + "\" + "Reference-Windows-Services.txt")		

# WDAC Policy
New-CIPolicy -Level Publisher -Fallback Hash -UserPEs -FilePath ($OutputFolder + "\" + "Reference-Windows-FilePublisherRules-FallbackHash.xml")