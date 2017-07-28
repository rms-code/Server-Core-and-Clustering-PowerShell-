Enable-PSRemoting
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
Remove-WindowsFeature FS-SMB1
Install-WindowsFeature Hyper-V, RSAT-Clustering-Powershell, Hyper-V-PowerShell, Multipath-IO -IncludeManagementTools
Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools
Set-NetAdapterAdvancedProperty -name SAN* -DisplayName "Jumbo Packet" -DisplayValue "9014 bytes"
restart-computer -Force