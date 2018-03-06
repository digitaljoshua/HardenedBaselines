Configuration PIDataArchive_WindowsHardening
{
    param(
        [string]$NodeName="localhost",
		[string]$PSTranscriptsDirectory="C:\PSTranscripts"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xPSDesiredStateConfiguration, xNetworking

    Node $NodeName
    {
	
		#region Networking
		$InterfaceAlias = "Microsoft Hyper-V Network Adapter"
        xNetBIOS DisableNetBIOS 
		{
			InterfaceAlias = $InterfaceAlias
			Setting        = 'Disable'
		}
			
		$FirewallProfiles = @(
								'Private',
								'Public',
								'Domain'
							)
			
		Foreach($Profile in $FirewallProfiles)
		{
			xFirewallProfile ("FirewallProfile_" + $Profile)
			{
				Name = $Profile
				Enabled = 'True'
				DefaultInboundAction = 'Block'
				DefaultOutboundAction = 'Block'
				AllowInboundRules = 'True'
				NotifyOnListen = 'True'
				LogFileName = '%systemroot%\system32\LogFiles\Firewall\pfirewall.log'
				LogMaxSizeKilobytes = 20480
				LogAllowed = 'False'
				LogBlocked = 'True'
			}
		}
			
		# Firewall - custom rules to enable
		$PINetMgrProgram = ($env:piserver + "bin\pinetmgr.exe")
        xFirewall PIDataArchive_ClientConnections_In
        {
            Direction = 'Inbound'
            Name = 'PI-Data-Archive-PINET-TCP-In'
            DisplayName = 'PI Data Archive PINET (TCP-In)'
            Description = 'Inbound rule for PI Data Archive to allow PINET traffic.'
            Group = 'PI System'
            Enabled = 'True'
            Action = 'Allow'
            Protocol = 'TCP'
			Service = "PINetMgr"
			Program = $PINetMgrProgram
            LocalPort = '5450'
            Ensure = 'Present'
        }
			
		xFirewall PIDataArchive_ClientConnections_Out
        {
            Direction = 'Outbound'
            Name = 'PI-Data-Archive-PINET-TCP-Out'
            DisplayName = 'PI Data Archive PINET (TCP-Out)'
            Description = 'Outbound rule for PI Data Archive to allow PINET traffic.'
            Group = 'PI System'
            Enabled = 'True'
            Action = 'Allow'
            Protocol = 'TCP'
			Service = "PINetMgr"
			Program = $PINetMgrProgram
            RemotePort = '49152-65535'
            Ensure = 'Present'
        }
        
        [string[]]$FirewallRulesEnabledByDefault = @(                    
										"WINRM-HTTP-In-TCP",                                       
										"CoreNet-ICMP4-DUFRAG-In",                   
										"CoreNet-IGMP-In",                           
										"CoreNet-IGMP-Out",                          
										"CoreNet-DHCP-In",                           
										"CoreNet-DHCP-Out",                                                 
										"CoreNet-Teredo-In",                         
										"CoreNet-Teredo-Out",                        
										"CoreNet-IPHTTPS-In",                        
										"CoreNet-IPHTTPS-Out",                                                
										"CoreNet-GP-NP-Out-TCP",                     
										"CoreNet-GP-Out-TCP",                        
										"CoreNet-DNS-Out-UDP",                       
										"CoreNet-GP-LSASS-Out-TCP"                  
                                    )
        # Firewall - infrastructure rules to enable
        ForEach($rule in $FirewallRulesEnabledByDefault)
        {
            xFirewall $rule
            {
                Name = $rule
                Enabled = 'True'
                Ensure = 'Present'
            }   
        }
		
		[string[]]$FirewallRulesDisabledByDefault = @(
										"vm-monitoring-dcom",                         
										"vm-monitoring-icmpv4",                       
										"vm-monitoring-icmpv6",                       
										"vm-monitoring-nb-session",                   
										"vm-monitoring-rpc",                          
										"SNMPTRAP-In-UDP",                            
										"SNMPTRAP-In-UDP-NoScope",                    
										"Wininit-Shutdown-In-Rule-TCP-RPC",           
										"Wininit-Shutdown-In-Rule-TCP-RPC-EPMapper",  
										"EventForwarder-In-TCP",                      
										"EventForwarder-RPCSS-In-TCP",                
										"NETDIS-UPnPHost-In-TCP",                     
										"NETDIS-UPnPHost-Out-TCP",                    
										"NETDIS-NB_Name-In-UDP",                      
										"NETDIS-NB_Name-Out-UDP",                     
										"NETDIS-NB_Datagram-In-UDP",                  
										"NETDIS-NB_Datagram-Out-UDP",                 
										"NETDIS-WSDEVNTS-In-TCP",                     
										"NETDIS-WSDEVNTS-Out-TCP",                    
										"NETDIS-WSDEVNT-In-TCP",                      
										"NETDIS-WSDEVNT-Out-TCP",                     
										"NETDIS-SSDPSrv-In-UDP",                      
										"NETDIS-SSDPSrv-Out-UDP",                     
										"NETDIS-UPnP-Out-TCP",                        
										"NETDIS-FDPHOST-In-UDP",                      
										"NETDIS-FDPHOST-Out-UDP",                     
										"NETDIS-LLMNR-In-UDP",                        
										"NETDIS-LLMNR-Out-UDP",                       
										"NETDIS-FDRESPUB-WSD-In-UDP",                 
										"NETDIS-FDRESPUB-WSD-Out-UDP",                
										"Netlogon-NamedPipe-In",                      
										"Netlogon-TCP-RPC-In",                        
										"FPSSMBD-iWARP-In-TCP",                       
										"RemoteTask-In-TCP",                          
										"RemoteTask-RPCSS-In-TCP",                    
										"WINRM-HTTP-Compat-In-TCP",                   
										"Microsoft-Windows-PeerDist-HttpTrans-In",    
										"Microsoft-Windows-PeerDist-HttpTrans-Out",   
										"Microsoft-Windows-PeerDist-WSD-In",          
										"Microsoft-Windows-PeerDist-WSD-Out",         
										"Microsoft-Windows-PeerDist-HostedServer-In", 
										"Microsoft-Windows-PeerDist-HostedServer-Out",
										"Microsoft-Windows-PeerDist-HostedClient-Out",
										"RemoteDesktop-UserMode-In-TCP",              
										"RemoteDesktop-UserMode-In-UDP",              
										"RemoteDesktop-Shadow-In-TCP",                
										"RRAS-GRE-In",                                
										"RRAS-GRE-Out",                               
										"RRAS-L2TP-In-UDP",                           
										"RRAS-L2TP-Out-UDP",                          
										"RRAS-PPTP-In-TCP",                           
										"RRAS-PPTP-Out-TCP",                          
										"RVM-VDS-In-TCP",                             
										"RVM-VDSLDR-In-TCP",                          
										"RVM-RPCSS-In-TCP",                           
										"MsiScsi-In-TCP",                             
										"MsiScsi-Out-TCP",                            
										"FPS-NB_Session-In-TCP",                      
										"FPS-NB_Session-Out-TCP",                     
										"FPS-SMB-In-TCP",                             
										"FPS-SMB-Out-TCP",                            
										"FPS-NB_Name-In-UDP",                         
										"FPS-NB_Name-Out-UDP",                        
										"FPS-NB_Datagram-In-UDP",                     
										"FPS-NB_Datagram-Out-UDP",                    
										"FPS-SpoolSvc-In-TCP",                        
										"FPS-RPCSS-In-TCP",                           
										"FPS-ICMP4-ERQ-In",                           
										"FPS-ICMP4-ERQ-Out",                          
										"FPS-ICMP6-ERQ-In",                           
										"FPS-ICMP6-ERQ-Out",                          
										"FPS-LLMNR-In-UDP",                           
										"FPS-LLMNR-Out-UDP",                          
										"RemoteEventLogSvc-In-TCP",                   
										"RemoteEventLogSvc-NP-In-TCP",                
										"RemoteEventLogSvc-RPCSS-In-TCP",             
										"SPPSVC-In-TCP",                              
										"PerfLogsAlerts-PLASrv-In-TCP",               
										"PerfLogsAlerts-DCOM-In-TCP",                 
										"PerfLogsAlerts-PLASrv-In-TCP-NoScope",       
										"PerfLogsAlerts-DCOM-In-TCP-NoScope",         
										"SLBM-MUX-IN-TCP",                            
										"RemoteSvcAdmin-In-TCP",                      
										"RemoteSvcAdmin-NP-In-TCP",                   
										"RemoteSvcAdmin-RPCSS-In-TCP",                
										"TPMVSCMGR-RPCSS-In-TCP-NoScope",             
										"TPMVSCMGR-Server-In-TCP-NoScope",            
										"TPMVSCMGR-Server-Out-TCP-NoScope",           
										"TPMVSCMGR-RPCSS-In-TCP",                     
										"TPMVSCMGR-Server-In-TCP",                    
										"TPMVSCMGR-Server-Out-TCP",                   
										"MSDTC-In-TCP",                               
										"MSDTC-Out-TCP",                              
										"MSDTC-KTMRM-In-TCP",                         
										"MSDTC-RPCSS-In-TCP",                         
										"RemoteFwAdmin-In-TCP",                       
										"RemoteFwAdmin-RPCSS-In-TCP",                 
										"WMI-RPCSS-In-TCP",                           
										"WMI-WINMGMT-In-TCP",                         
										"WMI-WINMGMT-Out-TCP",                        
										"WMI-ASYNC-In-TCP"
                                    )
									
		$FirewallRulesDisabledBySelection = @(
										"AllJoyn-Router-In-TCP",                     
										"AllJoyn-Router-Out-TCP",                    
										"AllJoyn-Router-In-UDP",                     
										"AllJoyn-Router-Out-UDP",
										"WINRM-HTTP-In-TCP-PUBLIC",
										"Microsoft-Windows-Unified-Telemetry-Client",
										"CoreNet-ICMP6-DU-In",                       
										"CoreNet-ICMP6-PTB-In",                      
										"CoreNet-ICMP6-PTB-Out",                     
										"CoreNet-ICMP6-TE-In",                       
										"CoreNet-ICMP6-TE-Out",                      
										"CoreNet-ICMP6-PP-In",                       
										"CoreNet-ICMP6-PP-Out",                      
										"CoreNet-ICMP6-NDS-In",                      
										"CoreNet-ICMP6-NDS-Out",                     
										"CoreNet-ICMP6-NDA-In",                      
										"CoreNet-ICMP6-NDA-Out",                     
										"CoreNet-ICMP6-RA-In",                       
										"CoreNet-ICMP6-RA-Out",                      
										"CoreNet-ICMP6-RS-In",                       
										"CoreNet-ICMP6-RS-Out",                      
										"CoreNet-ICMP6-LQ-In",                       
										"CoreNet-ICMP6-LQ-Out",                      
										"CoreNet-ICMP6-LR-In",                       
										"CoreNet-ICMP6-LR-Out",                      
										"CoreNet-ICMP6-LR2-In",                      
										"CoreNet-ICMP6-LR2-Out",                     
										"CoreNet-ICMP6-LD-In",                       
										"CoreNet-ICMP6-LD-Out",
										"CoreNet-IPv6-In",                           
										"CoreNet-IPv6-Out",
										"CoreNet-DHCPV6-In",                         
										"CoreNet-DHCPV6-Out",
										"MDNS-In-UDP",                               
										"MDNS-Out-UDP"
									)
		
		# Firewall - infrastructurs rules to disable
		$FirewallRulesToDisable = $FirewallRulesDisabledByDefault + $FirewallRulesDisabledBySelection
		
        ForEach($rule in $FirewallRulesToDisable)
        {
			xFirewall $rule
			{
				Name = $rule
				Enabled = 'False'
				Ensure = 'Present'
			}
        }
		#endregion
		
		#region Crypto Suites
		# TLS/SSL Security Considerations
		# https://technet.microsoft.com/en-us/library/dn786446(v=ws.11).aspx
		$schannelProtocols = @{
									'PCT 1.0'=$false;
									'SSL 2.0'=$false;
                               		'SSL 3.0'=$false;
                                	'TLS 1.0'=$true;
              		                'TLS 1.1'=$true;
                                	'TLS 1.2'=$true;
                         		}
		$schannelCiphers = @{	
									'NULL'=$false;
									'DES 56/56'=$false; 
                       		        'RC2 40/128'=$false;
                                	'RC2 56/128'=$false;
                                	'RC2 128/128'=$false;
                                	'RC4 40/128'=$false;
                                	'RC4 56/128'=$false;
									'RC4 64/128'=$false;
									'RC4 128/128'=$false;
									'Triple DES 168'=$true;
									'AES 128/128'=$true;
									'AES 256/256'=$true; 
                             	}
        [string[]]$cipherSuites = @(
                                        "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384",
                                        "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256",
                                        "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256",
                                        "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256",
                                        "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256",
                                        "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256",
                                        "TLS_RSA_WITH_AES_256_CBC_SHA256",
                                        "TLS_RSA_WITH_AES_128_CBC_SHA256",
                                        "TLS_RSA_WITH_AES_256_CBC_SHA",
                                        "TLS_RSA_WITH_AES_128_CBC_SHA"
                                    )
			
		# Value of 0 disables, 1 enables protocol or cipher
		# https://technet.microsoft.com/en-us/library/dn786418(v=ws.11).aspx#BKMK_SchannelTR_Ciphers
		$EnabledValue = "1"
		$DisabledValue = "0"

		$cryptographyKeyPath = 'HKLM:\System\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002\'
			
		xRegistry $($cryptographyKeyPath + 'Functions')
		{
			ValueName = 'Functions'
			ValueType = 'MultiString'
			Key = $cryptographyKeyPath
			ValueData = $cipherSuites
			Force = $true
		}
        
		$schannelKeyPath = "HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\"
		foreach ($cipher in $schannelCiphers.GetEnumerator())
		{
			if($cipher.Value) { $ValueData = $EnabledValue }
			else { $ValueData = $DisabledValue }

			$TargetPath = $($schannelKeyPath + 'Ciphers\' + $cipher.Name)
			xRegistry $($TargetPath + '\Enabled')
			{
				ValueName = 'Enabled'
				ValueType = 'DWORD'
				Key = $TargetPath
				ValueData = $ValueData
				Force = $true
			}
		}
		
		foreach ($protocol in $schannelProtocols.GetEnumerator())
		{	
			if($protocol.Value) 
			{
				$ValueData = $EnabledValue 
			}
			else 
			{ 
				$ValueData = $DisabledValue 
			}
			
			foreach($Role in @('Server','Client'))
			{					$TargetPath = $($schannelKeyPath + 'Protocols\' + $protocol.Name + '\' + $Role)
				xRegistry $($TargetPath + '\Enabled')
				{
					ValueName = 'Enabled'
					ValueType = 'DWORD'
					Key = $TargetPath
					ValueData = $ValueData
					Force = $true
				}
			}
		}
		#endregion
		
		#region Windows Defender
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
		#endregion
		
		#region Registry
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
		#endregion
	
		#region Windows Features
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
		
		$AllFeatures = Get-WindowsFeature | Select-Object -ExpandProperty Name
			
		Foreach($Feature in $AllFeatures)
		{
			if($Feature -in $ApprovedFeatures)
			{
				WindowsFeatureSet $( $Feature + '_Enable' )
				{
					Name = $Feature
					Ensure = 'Present'
				}
			}
			else
			{
				WindowsFeatureSet $( $Feature + '_Disable' )
				{
					Name = $Feature
					Ensure = 'Absent'
				}
			}
		}
		#endregion

		#region Windows Services
		[String[]]$ServicesToDisable = @()
		# Optional PI services to disable
		$ServicesToDisable += @(
										"PIAFLink", 
										"PIBaGen", 
										"pibatch", 
										"pibufss",
										"PIDirectoryPublisher",
										"pilogsrv",
										"pilogsrvX64",
										"pirecalc"
									)
		# Remaining OS Services not needed for PI Data Archive.
		$ServicesToDisable += @(	 
										"AppMgmt",
										"DiagTrack",
										"sacsvr",
										"SNMPTRAP",
										"seclogon",
										"WinHttpAutoProxySvc"
									)
		# Services disabled by default
		$ServicesToDisable += @(
                                        "tzautoupdate",
                                        "Browser",
                                        "AppVClient",
                                        "NetTcpPortSharing",
                                        "CscService",
                                        "RemoteAccess",
                                        "SCardSvr",
                                        "UevAgentService"
                                        "WSearch"
                                )
		# Services MS recommends disabling
		$ServicesToDisable += @(
                                        "XblAuthManager",
                                        "XblGameSave"
                                    )
		# Services MS indicates as "OK to disable"
		$ServicesToDisable += @(
                                        "AxInstSV",
                                        "bthserv",
                                        "CDPUserSvc",
                                        "PimIndexMaintenanceSvc"
                                        "dmwappushservice",
                                        "MapsBroker",
                                        "lfsvc",
                                        "SharedAccess",
                                        "lltdsvc",
                                        "wlidsvc",
                                        "NgcSvc",
                                        "NgcCtnrSvc",
                                        "NcbService",
                                        "PhoneSvc",
                                        "PcaSvc",
                                        "QWAVE",
                                        "RmSvc",
                                        "SensorDataService",
                                        "SensrSvc",
                                        "SensorService",
                                        "ShellHWDetection",
                                        "ScDeviceEnum",
                                        "SSDPSRV",
                                        "WiaRpc",
                                        "OneSyncSvc",
                                        "TabletInputService",
                                        "upnphost",
                                        "UserDataSvc",
                                        "UnistoreSvc",
                                        "WalletService",
                                        "Audiosrv",
                                        "AudioEndpointBuilder",
                                        "FrameServer",
                                        "stisvc",
                                        "wisvc",
                                        "icssvc",
                                        "WpnService",
                                        "WpnUserService"
                                )
		# Services OK to disable if not a DC or print server
		$ServicesToDisable += @('Spooler')
		# Services OK to disable if not a print server
		$ServicesToDisable += @('PrintNotify')
			
		$InstalledServices = Get-Service
      
		foreach($Service in $ServicesToDisable)
		{
			if($InstalledServices.Name -contains $Service)
			{ 
				Service $( 'DisabledService_' + $Service )
				{
					Name = $Service
					StartupType = "Disabled"
					State = "Stopped"
				}
			}
		}
		#endregion
	
		#region PowerShell Logging
		# Script block logging
        $PSLoggingKey = 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell'
		Registry "$PSLoggingKey\ScriptBlockLogging\EnableScriptBlockLogging"
        {
            Ensure = 'Present'
		    Key = "$PSLoggingKey\ScriptBlockLogging"
		    ValueData = 1
            ValueName = 'EnableScriptBlockLogging'
		    ValueType = 'DWORD'
        }

        # Transcription
        File PSTranscriptsDirectory
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = $PSTranscriptsDirectory   
        }
		
		Registry "$PSLoggingKey\Transcription\EnableTranscription"
        {
            Ensure = 'Present'
		    Key = "$PSLoggingKey\Transcription"
		    ValueData = 1
            ValueName = 'EnableTranscription'
		    ValueType = 'DWORD'
        }

        Registry "$PSLoggingKey\Transcription\EnableInvocationHeader"
        {
            Ensure = 'Present'
		    Key = "$PSLoggingKey\Transcription"
		    ValueData = 1
            ValueName = 'EnableInvocationHeader'
		    ValueType = 'DWORD'
        }
        
        Registry "$PSLoggingKey\Transcription\OutputDirectory"
        {
            Ensure = 'Present'
		    Key = "$PSLoggingKey\Transcription"
		    ValueData = $PSTranscriptsDirectory
            ValueName = 'OutputDirectory'
		    ValueType = 'ExpandString'
			DependsOn = "[File]PSTranscriptsDirectory"
        }
		#endregion
	}
}