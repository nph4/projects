<#
    .SYNOPSIS
    script to migrate VMs off of VMWare host

    .DESCRIPTION
    Connects to VCenter through connect-viserver cmdlet. It then lists the
    hosts in a sorted list via a for loop. Then it outputs the VMs on the
    host Server to the CSV file called in the $hosts variable. It then calls
    the for loop again and uses that to specify the target to migrate VMs to.
    Finally it migrates the VMs

    .NOTES
    Version:		      0.44
    Authors:  		    Nelson Hickman and Raymond Housz
    Change Date:	    2017.09.08
    Purpose/Change:   Improved documentation
    Editor:           Nelson Hickman

    Version:		      0.43
    Authors:  		    Nelson Hickman and Raymond Housz
    Change Date:	    2017.09.08
    Purpose/Change:   Improved documentation

#>
#connects to VCenter
connect-viserver SERVER-NAME-HERE

#creates menu to set source host
$hosts = Get-VMHost |
Select-Object -Property Name |
Sort-Object Name

Clear-Host
Write-Host -Object 'Please select the source host' -ForegroundColor Yellow

for ($i = 0; $i -le $hosts.name.length-1;$i++)
{
  "$hosts[{0}] {1}" -f $i, $hosts.name[$i]
}

#creates menu to set target host
$SrcSelection = Read-Host
Clear-Host
Write-Host -Object 'Please select the target host' -ForegroundColor Yellow

for ($i = 0; $i -le $hosts.name.length-1;$i++)
{
  "$hosts[{0}] {1}" -f $i, $hosts.name[$i]
}
$DstSelection = Read-Host

#exports VMs to be migrated to CSV
Get-VMHost -Name $hosts.name[$SrcSelection] |
Get-VM |
Select-Object -Property Name | Export-Csv H:\Migrated-VMs.CSV -NoTypeInformation

#Set's target server
$target = Get-VMHost -Name $hosts.name[$DstSelection]

#Pulls list of VMs from csv
$vms = Import-Csv h:\Migrated-VMs.CSV 

#Moves VMs from csv to specified server
move-vm -vm $vms.name -destination $target -vmotionpriority high