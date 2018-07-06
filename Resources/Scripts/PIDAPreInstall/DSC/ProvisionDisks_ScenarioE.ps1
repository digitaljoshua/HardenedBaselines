Configuration ProvisionDisks_ScenarioE
{	
	# Retries for disk creation
	[Int]$RetryCount = 5
    [Int]$RetryIntervalSec = 10

	Import-DscResource -ModuleName xStorage, PSDesiredStateConfiguration
	
	Node localhost
	{
		$DriveObjects = @()
		$DriveObjects += @{ DiskId = '1'; Purpose = 'Apps'; DriveLetter = 'F' }
		$DriveObjects += @{ DiskId = '2'; Purpose = 'Archives'; DriveLetter = 'G' }
		$DriveObjects += @{ DiskId = '3'; Purpose = 'Queues'; DriveLetter = 'H' }
		$DriveObjects += @{ DiskId = '4'; Purpose = 'Backups'; DriveLetter = 'I' }

		Foreach($DriveObject in $DriveObjects)
		{
			xWaitforDisk (($DriveObject.Purpose) + '_Disk')
			{
				DiskId = $DriveObject.DiskId
				RetryIntervalSec = $RetryIntervalSec
				RetryCount = $RetryCount
			}

			xDisk (($DriveObject.Purpose) + '_Volume')
			{
				DiskId = $DriveObject.DiskId
				DriveLetter = $DriveObject.DriveLetter
				FSFormat = 'NTFS'
				FSLabel = $DriveObject.Purpose
			}
		
			File (($DriveObject.Purpose) + '_Directory')
			{
				DestinationPath = ($DriveObject.DriveLetter+':\'+$DriveObject.Purpose)
				Type = 'Directory'
				Ensure = "Present"
			}
		}
	}
}