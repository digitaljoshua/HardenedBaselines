Configuration HardenedConfig_OSIsoft_PIDataArchive_Services
{
    param(
        [string]$ComputerName="localhost"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $ComputerName
    {
			[String[]]$ServicesToDisable = @()
			# Optional PI services to disable
			$ServicesToDisable += @(
										"PIAFLink", 
										"PIBaGen", 
										"pibatch", 
										"pibufss",
										"pilogsrv",
										"pilogsrvX64",
										"pirecalc"
									)
			# Remaining OS Services not needed for PI Data Archive.
			$ServicesToDisable += @(	
										"AppXSvc",  
										"AppMgmt",
										"ClipSVC",
										"DiagTrack",
										"sacsvr",
										"SNMPTRAP",
										"seclogon"
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
	}
}