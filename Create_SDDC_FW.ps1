
$RefreshToken   = "62c26d4a-xxxx-xxxx-xxxx-913873b1dfe0"
$OrgName        = "YOUR ORG NAME"
$SDDCName       = "YOUR SDDC NAME"


Import-Module ./VMware.VMC.NSXT.psd1
Import-Module ./VMware.VMC.psd1

Connect-Vmc -RefreshToken $RefreshToken
Connect-NSXTProxy -RefreshToken $RefreshToken -OrgName $OrgName -SDDCName $SDDCName

# Create logical networks
for($i = 2; $i -lt 6; $i++)
{
    Write-Output $i
    New-NSXTSegment -Name "sddc-cgw-network-$i" -Gateway "192.168.$i.1/24" -DHCP -DHCPRange "192.168.$i.2-192.168.$i.254"
}

# Create Groups
New-NSXTGroup -GatewayType CGW -Name LS1 -IPAddress @("192.168.1.0/24")
New-NSXTGroup -GatewayType CGW -Name LS2 -IPAddress @("192.168.2.0/24")
New-NSXTGroup -GatewayType CGW -Name VPC1 -IPAddress @("172.201.0.0/16")
New-NSXTGroup -GatewayType CGW -Name VPC2 -IPAddress @("172.202.0.0/16")
New-NSXTGroup -GatewayType CGW -Name VPC3 -IPAddress @("172.203.0.0/16")


# Create MGW vCenter inbound rule
New-NSXTFirewall -GatewayType MGW -Name "vCenter Inbound" -SourceGroup @("ANY") -DestinationGroup @("VCENTER") -Service @("HTTPS","ICMP-ALL","SSO") -Logged $false -SequenceNumber 0 -Action ALLOW 

# Create CGW rules
New-NSXTFirewall -GatewayType CGW -Name "vmc2aws" -SourceGroup @("ANY") -DestinationInfraGroup @("Connected VPC Prefixes", "S3 prefixes") -Service @("ANY") -Logged $false -SequenceNumber 0 -Action ALLOW -InfraScope @("VPC Interface")
New-NSXTFirewall -GatewayType CGW -Name "aws2vmc" -SourceInfraGroup @("Connected VPC Prefixes", "S3 prefixes") -DestinationGroup @("ANY") -Service @("ANY") -Logged $false -SequenceNumber 1 -Action ALLOW -InfraScope @("VPC Interface")
New-NSXTFirewall -GatewayType CGW -Name "Internet-out" -SourceGroup LS1 -DestinationGroup @("ANY") -Service ANY -Logged $false -SequenceNumber 2 -Action ALLOW -InfraScope "Internet Interface"

# List the user firewall Rules 
Get-NSXTFirewall -GatewayType MGW
Get-NSXTFirewall -GatewayType CGW
