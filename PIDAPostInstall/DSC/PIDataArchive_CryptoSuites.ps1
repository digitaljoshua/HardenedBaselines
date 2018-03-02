# Starting with domain joined Windows Server 2016 Core Machine
Configuration PIDataArchive_CryptoSuites
{
    param(
        [string]$NodeName="localhost"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xPSDesiredStateConfiguration

    Node $NodeName
    {
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
	}
}