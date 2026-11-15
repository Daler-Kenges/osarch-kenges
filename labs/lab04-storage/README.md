# Lab 4 — Partition, mirror, fail, recover

Pair: Daler Kenges (solo work) · Date: 15.11.2026 · Hypervisor: VirtualBox 7.2.22

## Windows
Get-Disk output:
Number Friendly Name Serial Number                 HealthStatus      OperationalStatus   Total Size Partition
Style                                              ------ ------------- -------------                 ------------      -----------------   ---------- ---------     0      VBOX HARDDISK VBb4fb942b-5c7899b2
Healthy           Online                   64 GB GPT   1      VBOX HARDDISK VB1ec30fed-c0b3071b           Healthy           Online                    1 GB
RAW

Get-Volume output:
DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining      Size
----------- ------------ -------------- --------- ------------ ----------------- -------------      ----
E           LAB04        NTFS           Fixed     Healthy      OK                    989.98 MB 1007.93 MB

Number         : 0
FriendlyName   : VBOX HARDDISK
PartitionStyle : GPT
Size           : 68719476736

Number         : 1
FriendlyName   : VBOX HARDDISK
PartitionStyle : GPT
Size           : 1073741824

E           LAB04        NTFS           Fixed     Healthy      OK                    989.98 MB 1007.93 MB

MBR or GPT: 
I choose GPT because Windows boots with UEFI, which uses GPT that stores a backup copy of the table and checksums it. MBR with restrictions to 2TiB and 4 channels would cause significant complexities like sacrificing primary slot for extension. GPT removes extra complexities, providing error management via checksumming the table and storing back up.

## Linux — layout before and after
### Before
<lsblk before>
### After
<lsblk after: md0 on sdb1 and sdd1, mounted on /mnt/mirror>
NAME                       SIZE TYPE  FSTYPE            MOUNTPOINTS
loop0                     66.8M loop  squashfs          /snap/core24/1643
loop1                      1.5M loop  squashfs          /snap/hwctl/123
loop2                      1.5M loop  squashfs          /snap/hwctl/131
loop3                     50.1M loop  squashfs          /snap/snapd/27710
sda                         25G disk
├─sda1                       1M part
├─sda2                       2G part  ext4              /boot
└─sda3                      23G part  LVM2_member
  └─ubuntu--vg-ubuntu--lv 11.5G lvm   ext4              /
sdb                          1G disk
└─sdb1                    1022M part  linux_raid_member
  └─md0                   1021M raid1 ext4              /mnt/mirror
sdc                          1G disk
└─sdc1                    1022M part  linux_raid_member
sdd                          1G disk
└─sdd1                    1022M part  linux_raid_member
  └─md0                   1021M raid1 ext4              /mnt/mirror
sr0                       50.7M rom   iso9660

## What I did
<the commands, in order, in code blocks — create, fail, rebuild>

## Three states
| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | [2/2] [UU] | evidence/array-healthy.txt |
| Degraded | [2/1] [U_] | evidence/array-degraded.txt |
| Rebuilt | [2/2] [UU], sdd1 replaced sdc1 | evidence/array-rebuilt.txt |
Checksums before and after the failure: <match / do not match>

## RAID is not a backup
Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? Why?
<three sentences>

## What did not work the first time
<at least one real thing: what you saw, what it was, what you did>

