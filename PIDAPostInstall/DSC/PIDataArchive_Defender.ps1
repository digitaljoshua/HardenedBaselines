Configuration PIDataArchive_Defender
{
    param(
        [string]$NodeName="localhost"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $NodeName
    {	
		# Enable Device Guard
		# https://docs.microsoft.com/en-us/windows/device-security/device-guard/deploy-device-guard-enable-virtualization-based-security
		$DGRegistryKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard'

		Registry "$DGRegistryKey\EnableVirtualizationBasedSecurity"
		{
			Ensure = 'Present'
			Key = $DGRegistryKey
			ValueName = 'EnableVirtualizationBasedSecurity'
			ValueData = 1
			ValueType = 'DWORD'
		}

        Registry "$DGRegistryKey\RequirePlatformSecurityFeatures"
		{
			Ensure = 'Present'
			Key = $DGRegistryKey
			ValueName = 'RequirePlatformSecurityFeatures'
            ValueData = 1
			ValueType = 'DWORD'
		} 
        
        Registry "$DGRegistryKey\Locked"
		{
			Ensure = 'Present'
			Key = $DGRegistryKey
			ValueName = 'Locked'
            ValueData = 0
			ValueType = 'DWORD'
		}

        # Enable WDAC
		$HVCIRegistryKey = $DGRegistryKey + '\Scenarios\HypervisorEnforcedCodeIntegrity'

		Registry "$HVCIRegistryKey\Enabled"
		{
			Ensure = 'Present'
			Key = $HVCIRegistryKey
			ValueName = 'Enabled'
			ValueData = 1
			ValueType = 'DWORD'
		}
		
		Registry "$HVCIRegistryKey\Locked"
		{
			Ensure = 'Present'
			Key = $HVCIRegistryKey
			ValueName = 'Locked'
			ValueData = 0
			ValueType = 'DWORD'
		}

		# Enable Credential Guard
		# https://docs.microsoft.com/en-us/windows/access-protection/credential-guard/credential-guard-manage
		$LSARegistryKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\LSA'
		
		Registry "$LSARegistryKey\LsaCfgFlags"
		{
			Ensure = 'Present'
			Key = $LSARegistryKey
			ValueName = 'LsaCfgFlags'
			ValueData = 1
			ValueType = 'DWORD'
		}
	}
}