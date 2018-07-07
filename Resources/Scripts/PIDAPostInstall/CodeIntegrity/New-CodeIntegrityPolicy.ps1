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

# https://blogs.technet.microsoft.com/datacentersecurity/2016/09/20/overview-of-device-guard-in-windows-server-2016/
$policyBase = $($env:userprofile + '\Documents\PublisherSiPolicy.xml')
$policyMS = $($env:userprofile + '\Documents\MSBlockSiPolicy.xml')
$policyConfig = $($env:userprofile + '\Documents\SiPolicy.xml')
$policyBin = $($env:userprofile + '\Documents\SiPolicy.bin')
$policyP7B = $($env:WinDir + '\System32\CodeIntegrity\SiPolicy.p7b')

# Audit Policy
New-CIPolicy -Level Publisher -Fallback Hash -UserPEs -FilePath $policyBase

# Merge in Microsoft recommended policy to reduce available bypasses
# https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/steps-to-deploy-windows-defender-application-control
Merge-CIPolicy -PolicyPaths $policyBase, $policyMS -OutputFilePath $policyConfig

# Alter Policy to Enforce
Set-RuleOption -FilePath $policyConfig -Option 3 -delete

# Convert the CI Policy to the binary format and deploy it
ConvertFrom-CIPolicy $policyConfig $policyBin
Copy-Item $policyBin $policyP7B -Verbose