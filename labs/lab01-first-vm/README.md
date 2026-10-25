# Lab 1 — Your first virtual machine

Pair: <you> / <partner>   Driver first half: <name>
Machine: <your laptop and OS>, guest Ubuntu Server <version>
Date: <dd.mm.2026>

## What I did
1. Installed <hypervisor> <version>. Licence: <link>
2. Created VM lab01-ubuntu: <n> vCPU, <n> GB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it: <the commands you ran>
5. Rolled back to clean-install: <the commands that prove it is fixed>

## Resource justification
<One paragraph, against your host's real totals from Lab 0.>

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
<At least one thing: what I saw, what it turned out to be, what I did.>

## Evidence
- [evidence/vm-settings.png](evidence/vm-settings.png) — CPU, memory and disk as configured
- [evidence/guest-release.txt](evidence/guest-release.txt) — Ubuntu Server is running in the guest
- [evidence/broken.png](evidence/broken.png) — the guest in its broken state
- [evidence/snapshot-list.png](evidence/snapshot-list.png) — the snapshot, after the rollback
