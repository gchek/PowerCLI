$RefreshToken   = "62c26d4a-6794-4ead-ad4c-913873b1dfe0"
$OrgName        = "VMC-SET-EMEA"
$SDDCName       = "GC-API-SDDC"


Import-Module ./VMware.VMC.NSXT.psd1
Import-Module ./VMware.VMC.psd1

Connect-Vmc -RefreshToken $RefreshToken
Connect-NSXTProxy -RefreshToken $RefreshToken -OrgName $OrgName -SDDCName $SDDCName

Get-NSXTOverviewInfo 
New-NSXTRouteBasedVPN -Name VPN-T1 `
    -PublicIP 52.57.121.190 `
    -RemotePublicIP 18.195.62.72 `
    -BGPLocalIP 169.254.62.2 `
    -BGPRemoteIP 169.254.62.1 `
    -BGPlocalASN 65056 `
    -RemoteBGPASN 64512 `
    -BGPNeighborID 65 `
    -TunnelEncryption AES_256 `
    -TunnelDigestEncryption SHA2_256 `
    -IKEEncryption AES_256 `
    -IKEDigestEncryption SHA2_256 `
    -DHGroup GROUP14 `
    -IKEVersion IKE_V1 `
    -PresharedPassword VMware123. 

New-NSXTRouteBasedVPN -Name VPN-T2 `
    -PublicIP 52.57.121.190 `
    -RemotePublicIP 52.59.49.147 `
    -BGPLocalIP 169.254.61.2 `
    -BGPRemoteIP 169.254.61.1 `
    -BGPlocalASN 65056 `
    -RemoteBGPASN 64512 `
    -BGPNeighborID 66 `
    -TunnelEncryption AES_256 `
    -TunnelDigestEncryption SHA2_256 `
    -IKEEncryption AES_256 `
    -IKEDigestEncryption SHA2_256 `
    -DHGroup GROUP14 `
    -IKEVersion IKE_V1 `
    -PresharedPassword VMware123. 

Get-NSXTRouteBasedVPN 

