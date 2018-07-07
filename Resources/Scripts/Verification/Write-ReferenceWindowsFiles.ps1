# ************************************************************************
# *
# * Copyright 2016 OSIsoft, LLC
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *   <http://www.apache.org/licenses/LICENSE-2.0>
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# *
# ************************************************************************

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
							| Select-Object Name, Path, Installed `
							| Format-Table -AutoSize `
							| Out-File ($OutputFolder + "\" + "Reference-Windows-Features.txt")

# Windows Services
Get-Service | Select-Object StartType, Status, Name, DisplayName `
							| Sort-Object StartType, Status, Name `
							| Format-Table -AutoSize `
							| Out-File ($OutputFolder + "\" + "Reference-Windows-Services.txt")		

# WDAC Policy
New-CIPolicy -Level Publisher -Fallback Hash -UserPEs -FilePath ($OutputFolder + "\" + "Reference-Windows-FilePublisherRules-FallbackHash.xml")