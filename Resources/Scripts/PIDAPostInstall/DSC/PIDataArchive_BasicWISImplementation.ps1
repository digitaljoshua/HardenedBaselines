﻿<#
.SYNOPSIS

This example configuration covers a basic implementation of Windows Integrated
Security for the PI Data Archive.

.DESCRIPTION
   
This configuration is meant to configure a new install of a PI Data Archive to 
use the standard WIS implementation.

.PARAMETER NodeName

Name of the PI Data Archive server.

.PARAMETER PIAdministratorsADGroup

Windows identity to associate with an administrative role in PI.  Ideally, this 
should be a group.

.PARAMETER PIUsersADGroup

Windows identity to associate with a read only user role in PI.  Ideally, this 
should be a group.

.PARAMETER PIBuffersADGroup

Windows identity to associate with instances of PI Buffer Subsystem.  Ideally, this 
should be a group.

.PARAMETER PIInterfacesADGroup

Windows identity to associate with PI Interfaces.  Ideally, this should be a group.

.PARAMETER PIPointsAnalysisCreatorADGroup

Windows identity to associate with a power user role in PI for those who need to 
create PI Points.  Ideally, this should be a group.

.PARAMETER PIWebAppsADGroup

Windows identity to associate with PI Web Applications such as PI Vision.  Ideally, 
this should be a group.

.EXAMPLE 
.\PIDataArchive_BasicWindowsImplementation -NodeName "myPI" -PIAdministratorsADGroup 'mydomain\PI Admins' -PIUsersADGroup 'mydomain\PI Users'

#>
Configuration PIDataArchive_BasicWISImplementation
{
    param(
        [String]
        $NodeName = 'localhost',
        
        [String]
        $PIAdministratorsADGroup = 'BUILTIN\Administrators',
        
        [String]
        $PIUsersADGroup = '\Everyone',
        
        [String]
        $PIBuffersADGroup = '',
        
        [String]
        $PIInterfacesADGroup = '',
        
        [String]
        $PIPointsAnalysisCreatorADGroup = '',
        
        [String]
        $PIWebAppsADGroup = ''
        
         )

    Import-DscResource -ModuleName PISecurityDSC

    Node $NodeName
    {    
        # Create identities for basic WIS roles
        $BasicWISRoles = @(
                            @{Name='PI Buffers';Description='Identity for PI Buffer Subsystem and PI Buffer Server';},
                            @{Name='PI Interfaces';Description='Identity for PI Interfaces';},
                            @{Name='PI Users';Description='Identity for the Read-only users';},
                            @{Name='PI Points&Analysis Creator';Description='Identity for PIACEService, PIAFService and users that can create and edit PI Points';}
                            @{Name='PI Web Apps';Description='Identity for PI Vision, PI WebAPI, and PI WebAPI Crawler';}
                          )

        Foreach($BasicWISRole in $BasicWISRoles)
        {
            PIIdentity "SetBasicWISRole_$($BasicWISRole.Name)"
            {
                Name = $($BasicWISRole.Name)
                Description = $($BasicWISRole.Description)
                IsEnabled = $true
                CanDelete = $false
                AllowUseInMappings = $true
                AllowUseInTrusts = $true
                Ensure = "Present"
                PIDataArchive = $NodeName
            }
        } 

        # Remove default identities
        $DefaultPIIdentities = @(
                                    'PIOperators',
                                    'PISupervisors',
                                    'PIEngineers',
                                    'pidemo'
                                )
        
        Foreach($DefaultPIIdentity in $DefaultPIIdentities)
        {
            PIIdentity "DisableDefaultIdentity_$DefaultPIIdentity"
            {
                Name = $DefaultPIIdentity
                Ensure = "Absent"
                PIDataArchive = $NodeName
            }
        }

        # Disable default identities
        $DefaultPIIdentities = @(
                                    'PIWorld',
                                    'piusers'
                                )
        
        Foreach($DefaultPIIdentity in $DefaultPIIdentities)
        {
            PIIdentity "DisableDefaultIdentity_$DefaultPIIdentity"
            {
                Name = $DefaultPIIdentity
                IsEnabled = $false
                AllowUseInTrusts = $false
                Ensure = "Present"
                PIDataArchive = $NodeName
            }
        }
        
        # Set PI Mappings 
        $DesiredMappings = @(
                                
                                @{Name=$PIAdministratorsADGroup;Identity='piadmins'},
                                @{Name=$PIBuffersADGroup;Identity='PI Buffers'},
                                @{Name=$PIInterfacesADGroup;Identity='PI Interfaces'},
                                @{Name=$PIPointsAnalysisCreatorADGroup;Identity='PI Points&Analysis Creator'},
                                @{Name=$PIUsersADGroup;Identity='PI Users'},
                                @{Name=$PIWebAppsADGroup;Identity='PI Web Apps'},
								@{Name='NT Authority\SYSTEM';Identity='piadmins'}
                            )

        Foreach($DesiredMapping in $DesiredMappings)
        {
            if($null -ne $DesiredMapping.Name -and '' -ne $DesiredMapping.Name)
            {
                PIMapping "SetMapping_$($DesiredMapping.Name)"
                {
                    Name = $DesiredMapping.Name
                    PrincipalName = $DesiredMapping.Name
                    Identity = $DesiredMapping.Identity
                    Enabled = $true
                    Ensure = "Present"
                    PIDataArchive = $NodeName
                }
            }
        }
        
        # Set PI Database Security Rules
        $DatabaseSecurityRules = @(
                                    @{Name='PIAFLINK';Security='piadmins: A(r,w)'},
                                    @{Name='PIARCADMIN';Security='piadmins: A(r,w)'},
                                    @{Name='PIARCDATA';Security='piadmins: A(r,w)'},
                                    @{Name='PIAUDIT';Security='piadmins: A(r,w)'},
                                    @{Name='PIBACKUP';Security='piadmins: A(r,w)'}, 
                                    @{Name='PIBatch';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r)'},
                                    # PIBACTHLEGACY applies to the old batch subsystem which predates the PI Batch Database.
                                    # Unless the pibatch service is running, and there is a need to keep it running, this
                                    # entry can be safely ignored. 
                                    # @{Name='PIBATCHLEGACY';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r)'},
                                    @{Name='PICampaign';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r)'},
                                    @{Name='PIDBSEC';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r) | PI Web Apps: A(r)'},
                                    @{Name='PIDS';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r) | PI Points&Analysis Creator: A(r,w)'},
                                    @{Name='PIHeadingSets';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r)'},
                                    @{Name='PIMAPPING';Security='piadmins: A(r,w) | PI Web Apps: A(r)'},
                                    @{Name='PIModules';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r)'},
                                    @{Name='PIMSGSS';Security='piadmins: A(r,w) | PIWorld: A(r,w) | PI Users: A(r,w)'},
                                    @{Name='PIPOINT';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r) | PI Interfaces: A(r) | PI Buffers: A(r,w) | PI Points&Analysis Creator: A(r,w) | PI Web Apps: A(r)'},
                                    @{Name='PIReplication';Security='piadmins: A(r,w)'},
                                    @{Name='PITransferRecords';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r)'},
                                    @{Name='PITRUST';Security='piadmins: A(r,w)'},
                                    @{Name='PITUNING';Security='piadmins: A(r,w)'},
                                    @{Name='PIUSER';Security='piadmins: A(r,w) | PIWorld: A(r) | PI Users: A(r) | PI Web Apps: A(r)'}
                                  )

        Foreach($DatabaseSecurityRule in $DatabaseSecurityRules)
        {
            PIDatabaseSecurity "SetDatabaseSecurity_$($DatabaseSecurityRule.Name)"
            {
                Name = $DatabaseSecurityRule.Name
                Security = $DatabaseSecurityRule.Security
                Ensure = "Present"
                PIDataArchive = $NodeName
            }
        }
        
        # Define security for default points
        $DefaultPIPoints = @(
                            'SINUSOID','SINUSOIDU','CDT158','CDM158','CDEP158',
                            'BA:TEMP.1','BA:LEVEL.1','BA:CONC.1','BA:ACTIVE.1','BA:PHASE.1'
                            )

        Foreach($DefaultPIPoint in $DefaultPIPoints)
        {
            PIPoint "DefaultPointSecurity_$DefaultPIPoint"
            {
                Name = $DefaultPIPoint
                Ensure = 'Present'
                PtSecurity = 'piadmins: A(r,w) | PI Buffers: A(r,w) | PIWorld: A(r) | PI Users: A(r) | PI Interfaces: A(r) | PI Points&Analysis Creator: A(r,w) | PI Web Apps: A(r)'
                DataSecurity = 'piadmins: A(r,w) | PI Buffers: A(r,w) | PIWorld: A(r) | PI Users: A(r) | PI Interfaces: A(r) | PI Points&Analysis Creator: A(r,w) | PI Web Apps: A(r)'
                PIDataArchive = $NodeName
            }
        }
    }
}