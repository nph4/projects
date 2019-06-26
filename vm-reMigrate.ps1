<#
    .SYNOPSIS
    Script to migrate VMs back to VMWare host
    
    .DESCRIPTION
    Migrates VMs by connecting to VCenter, importing CSV created by script
    vm-migrate.ps1. It then uses the for loop to set the target host. Finally
    it migrates the VMs to the specified target host.

    .NOTES
    Version:          0.34
    Authors:          Nelson Hickman
    Change Date:      2017.09.08
    Purpose/Change:   Updated Menu


    Version:          0.33
    Authors:          Nelson Hickman and Raymond Housz
    Change Date:      2017.09.08
    Purpose/Change:   Improved documentation

#>

#connects to VCenter
connect-viserver SERVER-NAME-HERE

#Set's target server
$hosts = Get-VMHost |
Select-Object -Property Name |
Sort-Object Name

Clear-Host
Write-Host -Object 'Please select the source host' -ForegroundColor Yellow

for ($i = 0; $i -le $hosts.name.length-1;$i++)
{
  "$hosts[{0}] {1}" -f $i, $hosts.name[$i]
}
$DstSelection = Read-Host
$target = Get-VMHost -Name $hosts.name[$DstSelection]

#imports list of servers from vm-migrate.ps1 and sets it to variable $vms
$vms = Import-Csv h:\Migrated-VMs.CSV 

#moves servers from $vms to specified host.
move-vm -vm $vms.name -destination $target -vmotionpriority high