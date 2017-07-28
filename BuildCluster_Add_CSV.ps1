#Build out cluster and add disk to CSV
#Cluster IP you want, and node FQDN's

Param(

[parameter(
                Mandatory=$true,
                HelpMessage='Cluster IP')]
               
                [ipaddress]$CLUIP,
[parameter(
                Mandatory=$true,
                HelpMessage='NODES')]
               
                [string[]]$nodes
)

$nodz = ($nodes) -join ","
new-cluster -name labcluster -StaticAddress $CLUIP -Node $nodz
Get-ClusterAvailableDisk | Add-ClusterDisk
get-clusterResource | Where-Object {$_.OwnerGroup -eq "Available Storage"} | Add-ClusterSharedVolume