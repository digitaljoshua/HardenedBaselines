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

<#
.SYNOPSIS

Installs specified modules from PSGallery.

.DESCRIPTION
   
This function is intented to install resource modules required by DSC baselines.  It will also add NuGet and PSGallery if not already added.

.PARAMETER RequiredModules

String array of module names to pull from PSGallery

.EXAMPLE 
.\Install-DscBaselinePrerequisites.ps1
#>
param(
	[string[]]$RequiredModules = @(
                                            'xPSDesiredStateConfiguration',
                                            'AuditPolicyDSC',
                                            'SecurityPolicyDSC',
											'xStorage',
											'xNetworking'
                                            )
)
    # NuGet required to retrieve resources
    if(Get-PackageProvider -ListAvailable -Name NuGet -ErrorAction SilentlyContinue)
    { 
        Write-Host "NuGet Package located" 
    }
    else
    { 
        Write-Host "Attempting to install the prerequisite NuGet Package"
		Install-PackageProvider -Name NuGet -Confirm
    }
    if($(Get-PSRepository -Name PSGallery).InstallationPolicy -eq 'Trusted')
    {
	   Write-Host "PSGallery InstallationPolicy is already Trusted" 
    }
    else
    {
        Write-Host "Setting PSGallery InstallationPolicy to Trusted"
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }
    
    # Pull in required modules 
    Find-Module $RequiredModules | Install-Module
