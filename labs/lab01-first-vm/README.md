# Lab 1 — Your first virtual machine

Pair: Daler Kenges / no partner since it's single-person work   Driver first half: Daler Kenges
Machine: ASUS TUF Gaming A16 FA607NU Windows 11, guest Ubuntu Server 'Ubuntu 64-bit'
Date: 25.10.2026

## What I did
1. Installed VirtualBox 7.2.22. Licence: https://www.virtualbox.org/wiki/GPLv3
2. Created VM lab01-ubuntu: 4 vCPU, 4 GB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it: 'cat /etc/hostname        
sudo rm /etc/hostname
cat /etc/hostname          
sudo reboot'
5. Rolled back to clean-install: 'lab01-kenges' (command that proves everything is fixed)

## Resource justification
My laptop has 16GB of RAM and 16 vCPU with over 200GB. I had chosen 4GB of RAM and 4 vCPU because it was the sufficient amount that would give the virtual machine good breathing room and let my OS, as well as websites retain wide space for operation. I chose 25GB of memory from my disk since it gave sufficient breathing room that would work at full capacity, more memory would would be otherwise wasted.

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
In the step 7 I had problems running the code in virtual machine. It display typing errors like component is undefined and etc. I applied bashing through typing in single quotation marks for string moving (with Enter) like ' ' and executing 'script.sh' method and only then the code ran properly

## Evidence
- [evidence/vm-settings.png](evidence/vm-settings.png) — CPU, memory and disk as configured
- [evidence/guest-release.txt](evidence/guest-release.txt) — Ubuntu Server is running in the guest
- [evidence/broken.png](evidence/broken.png) — the guest in its broken state
- [evidence/snapshot-list.png](evidence/snapshot-list.png) — the snapshot, after the rollback
