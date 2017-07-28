<#
.SYNOPSIS
    .
.DESCRIPTION
    .
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of 
    LiteralPath is used exactly as it is typed. No characters are interpreted 
    as wildcards. If the path includes escape characters, enclose it in single
    quotation marks. Single quotation marks tell Windows PowerShell not to 
    interpret any characters as escape sequences.
#>
Param(

[parameter(
                Mandatory=$true,
                HelpMessage='SAN GROUP IP')]
               
                [int]$SANGROUPIP,
[parameter(
                Mandatory=$true,
                HelpMessage='Host Team IP')]
               
                [int]$HostIP,
[parameter(
                Mandatory=$true,
                HelpMessage='Default GW')]
               
                [int]$DefaultGW,
[parameter(
                Mandatory=$true,
                HelpMessage='DNS SERVER')]
               
                [int]$DNSSRV
[parameter(
                Mandatory=$true,
                HelpMessage='SAN1 IP')]
               
                [int]$SAN1
[parameter(
                Mandatory=$true,
                HelpMessage='SAN2 IP')]
               
                [int]$SAN2
)
New-NetIPAddress -InterfaceAlias "SAN1" -IPAddress $SAN1 -PrefixLength 24
New-NetIPAddress -InterfaceAlias "SAN2" -IPAddress $SAN2 -PrefixLength 24
Disable-NetAdapterBinding -InterfaceAlias SAN1 -ComponentID ms_tcpip6
Disable-NetAdapterBinding -InterfaceAlias SAN2 -ComponentID ms_tcpip6
New-NetLbfoTeam -Name HostTeam -TeamMembers host1,host2 -confirm
New-NetLbfoTeam -Name GuestTeam -TeamMembers guest1,guest2 -confirm
New-NetIPAddress -InterfaceAlias "HostTeam" -IPAddress $HostIP -PrefixLength 24 -DefaultGateway $DefaultGW
Set-DnsClientServerAddress -InterfaceAlias "HostTeam" -Addresses $DNSSRV
Start-Service MSiSCSI
Set-Service -Name MSiSCSI -Status Running -StartupType auto
New-IscsiTargetPortal -TargetPortalAddress $SANGROUPIP
Get-IscsiTarget 
Connect-IscsiTarget -InitiatorPortalAddress $SAN1 -IsMultipathEnabled $true -IsPersistent $true -TargetPortalAddress $SANGROUPIP
Connect-IscsiTarget -InitiatorPortalAddress $SAN2 -IsMultipathEnabled $true -IsPersistent $true -TargetPortalAddress $SANGROUPIP
Get-IscsiTarget
Get-IscsiSession
Register-IscsiSession
Enable-MSDSMAutomaticClaim -BusType iSCSI
Set-MPIOSetting -NewDiskTimeout 60
$d = (get-disk | ?{$_.OperationalStatus -eq "Offline"}).Number
Set-Disk $d -IsOffline $false
get-disk
New-VMSwitch -Name GuestVMS -NetAdapterName GuestTeam
Import-Module FailoverClusters