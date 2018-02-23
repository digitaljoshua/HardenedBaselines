# Starting with domain joined Windows Server 2016 Core Machine
Configuration PIDataArchiveOSBaseline
{
    param(
        [string]$ComputerName="localhost"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xNetworking

    Node $ComputerName
    {
            $FirewallRules = Get-NetFirewallRule | select ID
			
			# Firewall - custom rules to enable
            xFirewall PIDataArchive_ClientConnections
            {
                Direction = 'Inbound'
                Name = 'PI-Data-Archive-PINET-TCP-In'
                DisplayName = 'PI Data Archive PINET (TCP-In)'
                Description = 'Inbound rule for PI Data Archive to allow PINET traffic.'
                Group = 'PI System'
                Enabled = 'True'
                Action = 'Allow'
                Protocol = 'TCP'
                LocalPort = '5450'
                Ensure = 'Present'
            }
        
        [string[]]$FirewallRulesEnabledByDefault = @(                    
										"WINRM-HTTP-In-TCP",                  
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
										"CoreNet-ICMP4-DUFRAG-In",                   
										"CoreNet-IGMP-In",                           
										"CoreNet-IGMP-Out",                          
										"CoreNet-DHCP-In",                           
										"CoreNet-DHCP-Out",                          
										"CoreNet-DHCPV6-In",                         
										"CoreNet-DHCPV6-Out",                        
										"CoreNet-Teredo-In",                         
										"CoreNet-Teredo-Out",                        
										"CoreNet-IPHTTPS-In",                        
										"CoreNet-IPHTTPS-Out",                       
										"CoreNet-IPv6-In",                           
										"CoreNet-IPv6-Out",                          
										"CoreNet-GP-NP-Out-TCP",                     
										"CoreNet-GP-Out-TCP",                        
										"CoreNet-DNS-Out-UDP",                       
										"CoreNet-GP-LSASS-Out-TCP",                  
										"MDNS-In-UDP",                               
										"MDNS-Out-UDP"
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
										"Microsoft-Windows-Unified-Telemetry-Client"
									)
		
		# Firewall - infrastructurs rules to disable
		$FirewallRulesToDisable = $FirewallRulesDisabledByDefault + $FirewallRulesDisabledBySelection
		
        ForEach($rule in $FirewallRulesToDisable)
        {
			if($rule -in $FirewallRules)
			{
				xFirewall $rule
				{
					Name = $rule
					Enabled = 'False'
					Ensure = 'Present'
				}
			}
        }
	}
}
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
				{
					$TargetPath = $($schannelKeyPath + 'Protocols\' + $protocol.Name + '\' + $Role)
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
		#endregion 
