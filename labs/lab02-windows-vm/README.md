# Lab 2 — A Windows guest, and a network between them

Pair: Daler Kenges / no partner (single person work)   Driver first half: Daler Kenges
Machine: ASUS TUF Gaming A16 FA607NU - Windows 11, 16GB RAM, 8 cores/16 threads; guests Ubuntu Server + Windows 11 Enterprise eval
Date: 27.10.2026

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: no license, since it was free for 90 days.
2. Created lab02-windows: 2 vCPU, 4 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: NAT-network, both guests. Why: I implemented NAT Network because both guests must see each other and the internet, and I can't use bridged mode on campus Wi-Fi, where I'm doing the lab work.
4. Ping Ubuntu → Windows timed out because <why>. Fixed with: <the firewall rule command>
5. Overcommitment: set <x> GB + <y> GB on a <z> GB host.

## Network diagram
<diagram or image>

## Result
| | Before | After |
|---|---|---|
| Host RAM in use | | |
| Available | | |
| Committed / Swap used | | |
| What I noticed | — | |

## What did not work the first time
Step 5
1. THE GOAL:
   - Identify the Ubuntu VM IP address using ip -br a.
   - Configure a VirtualBox NAT Network port forwarding rule (Host Port 2222 -> Guest Port 22).
   - Execute an SSH command from the Windows host to save the VM's network info into a file (ip-addr-linux.txt) inside a locally cloned GitHub repository folder structure (labs/lab02-windows-vm/evidence/).

2. THE OBSTACLES & ERRORS:
   - Pathing Error: Attempting to run the script inside C:\Windows\System32, resulting in an "OpenError: Could not find a part of the path".
   - Service Error: Getting a "Connection refused" error when attempting to connect on port 2222 because the Ubuntu SSH server daemon (sshd) was installed but in an inactive (dead) state.
   - Network Mirror Hang: Attempting to run sudo apt update to refresh repositories, which hung indefinitely due to a network routing or connectivity timeout to regional Almaty mirrors (://ubuntu.com).
   - Redirection Syntax: The file output variable ($HOME) initially failing to drop cleanly onto the visual desktop space due to environmental pathing syntax.

3. THE RESOLVED SOLUTIONS:
   - Force-killed the hanging repository update via Ctrl + C.
   - Bypassed the update and explicitly started the SSH service inside Ubuntu using sudo systemctl start ssh.
   - Resolved the host pathing problem by shifting from a relative lab path to an explicit profile directory format (> "$env:USERPROFILE\Desktop\ip-addr-Linux.txt") to successfully generate a 743-byte text artifact.
   - Located the final proof file via a dynamic PowerShell filter command and uploaded it directly into the Daler-Kenges/osarch-kenges GitHub repository workspace.

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before.png](evidence/host-memory-before.png) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
