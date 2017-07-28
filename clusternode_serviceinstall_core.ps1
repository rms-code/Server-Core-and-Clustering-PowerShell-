#Make sure your SAN Nic's are labelled "SAN1" and "SAN2" or change the below Interface Alias's to suite yours

Param(
[parameter(
                Mandatory=$true,
                HelpMessage='SAN1 IP')]
               
                [ipaddress]$SAN1,
[parameter(
                Mandatory=$true,
                HelpMessage='SAN2 IP')]
               
                [ipaddress]$SAN2
)
New-NetIPAddress -InterfaceAlias "SAN1" -IPAddress $SAN1 -PrefixLength 24
New-NetIPAddress -InterfaceAlias "SAN2" -IPAddress $SAN2 -PrefixLength 24
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
Remove-WindowsFeature FS-SMB1
Install-WindowsFeature Hyper-V, RSAT-Clustering-Powershell, Hyper-V-PowerShell, Multipath-IO -IncludeManagementTools
Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools
Set-NetAdapterAdvancedProperty -name SAN* -DisplayName "Jumbo Packet" -DisplayValue "9014 bytes"
restart-computer -Force