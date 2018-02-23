# Starting with domain joined Windows Server 2016 Core Machine
Configuration PIDataArchiveOSBaseline
{
    param(
        [string]$ComputerName="localhost"
		[string[]]$ApprovedFeatures = @(
											'FileAndStorage-Services',
											'Storage-Services',
											'NET-Framework-45-Features',
											'NET-Framework-45-Core',
											'NET-WCF-Services45',
											'NET-WCF-TCP-PortSharing45',
											'BitLocker',
											'EnhancedStorage',
											'Windows-Defender-Features',
											'Windows-Defender',
											'PowerShellRoot',
											'PowerShell',
											'WoW64-Support'
										)
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xPSDesiredStateConfiguration, xNetworking

    Node $ComputerName
    {
			$AllFeatures = Get-WindowsFeature | Select-Object -ExpandProperty Name
			
			Foreach($Feature in $AllFeatures)
			{
				if($Feature -in $ApprovedFeatures)
				{
					WindowsFeatureSet "$Feature_Enable"
					{
						Name = $Feature
						Ensure = 'Present'
					}
				}
				else
				{
					WindowsFeatureSet "$Feature_Disable"
					{
						Name = $Feature
						Ensure = 'Absent'
					}
				}
			}			
	}
}