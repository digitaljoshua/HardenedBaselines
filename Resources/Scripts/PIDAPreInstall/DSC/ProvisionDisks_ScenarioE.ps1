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