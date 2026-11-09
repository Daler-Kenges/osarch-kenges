# Lab 4 — Partition, mirror, fail, recover

Pair: <name> + <name> · Date: <date> · Hypervisor: <VirtualBox / VMware / UTM>

## Windows
<Get-Disk and Get-Volume output>
MBR or GPT: <which, and why — one or two sentences>

## Linux — layout before and after
### Before
<lsblk before>
### After
<lsblk after: md0 on sdb1 and sdd1, mounted on /mnt/mirror>

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

