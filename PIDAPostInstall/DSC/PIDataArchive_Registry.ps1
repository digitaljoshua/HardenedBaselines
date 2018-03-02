Configuration PIDataArchive_Networking
{
    param(
        [string]$NodeName="localhost"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $NodeName
    {
		
		$RegistryKey = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\'
		
		Registry "$RegistryKey\DisabledComponents"
		{
			Ensure = 'Present'
			Key = $RegistryKey
			ValueName = 'DisabledComponents'
			ValueData = 255
			ValueType = 'DWORD'
		}
		
		$RegistryKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient\'
		
		Registry "$RegistryKey\EnableMulticast"
		{
			Ensure = 'Present'
			Key = $RegistryKey
			ValueName = 'EnableMulticast'
			ValueData = 0
			ValueType = 'DWORD'
		}
		
		$RegistryKey = 'HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings\'
		
		Registry "$RegistryKey\Enabled"
		{
			Ensure = 'Present'
			Key = $RegistryKey
			ValueName = 'Enabled'
			ValueData = 0
			ValueType = 'DWORD'
		}
	}
}