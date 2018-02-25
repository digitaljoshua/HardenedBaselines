# https://blogs.technet.microsoft.com/datacentersecurity/2016/09/20/overview-of-device-guard-in-windows-server-2016/
$policyConfig = $($env:userprofile + '\Documents\Publisher.xml')
$policyBin = $($env:userprofile + '\Documents\Publisher.bin')
$policyP7B = $($env:WinDir + '\System32\CodeIntegrity\SiPolicy.p7b')

# Audit Policy
New-CIPolicy -Level Publisher -Fallback Hash -UserPEs -FilePath $policyConfig

# Alter Policy to Enforce
Set-RuleOption -FilePath $policyConfig -Option 3 -delete

# Convert the CI Policy to the binary format and deploy it
ConvertFrom-CIPolicy $policyConfig $policyBin
Copy-Item $policyBin $policyP7B -Verbose