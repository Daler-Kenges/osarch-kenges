# Ticket 1 – New developer starts Monday, needs a test machine

## 1. What was asked
> From: Aigerim T. (Office Manager)
> Subject: test machine for new dev
> 
> Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks

## 2. What was actually needed
* **Omissions in the request:** The requester did not specify host machine resource limits, operating system requirements, target development stack, or network access requirements.
* **Flaws in the request:** The email asks for "a test computer" in the singular, but the technical requirement demands building both a Linux guest and a Windows guest. Additionally, "without breaking anything" requires configuring hypervisor-level snapshotting/rollbacks, which was not mentioned.
* **Clarifying questions for requester:**
  1. What software stack or toolchain will the new developer run?
  2. Does the test environment need access to internal company network shares or only the external internet?
  3. Does the developer require administrative rights inside the VM?
* **Assumptions made:**
  * Hypervisor choice: [VirtualBox / VMware Workstation / Hyper-V].
  * Guest OS choices: Ubuntu 24.04 LTS (for standard web/cloud dev) and Windows 10/11 Development evaluation (for desktop/client dev).
  * Isolated network layout using NAT to preserve host network security while providing internet and inter-VM communication.

## 3. What I did
### 3.1 Host Sizing & Resource Math
* **Host specs:** [e.g., 16 GB physical RAM, 8 CPU cores, 512 GB NVMe SSD (210 GB free)].
* **Linux VM allocation:** [e.g., 4 GB RAM, 2 vCPUs, 30 GB dynamically allocated disk].
* **Windows VM allocation:** [e.g., 6 GB RAM, 2 vCPUs, 60 GB dynamically allocated disk].
* **Allocation reasoning:** Total concurrent guest memory allocation is 10 GB, leaving 6 GB exclusively for the host OS and baseline background services to prevent host memory exhaustion and disk thrashing.

### 3.2 Non-Default Hypervisor Settings
* **Setting 1:** [e.g., Network mode changed from NAT Network to NAT with port forwarding / Internal Network].
  * *Reason:* [Explain why the default didn't work for inter-VM pinging or internet routing].
* **Setting 2:** [e.g., Virtual disk provisioning changed to Dynamically Allocated].
  * *Reason:* [Explain why this was chosen over Fixed Disk based on host storage limits].

### 3.3 Execution Steps
1. Configured base virtual machines via hypervisor GUI.
2. Installed base operating systems using minimal official ISO images.
3. Configured static hostnames and verified guest-to-guest IP visibility.
4. Generated base snapshots before installing test development tooling.

### 3.4 Failure Encountered and Resolution
* **Problem:** [e.g., Both VMs were assigned identical IP addresses (10.0.2.15) under default VirtualBox NAT adapters, preventing them from pinging each other].
* **Resolution:** [e.g., Created a unified NAT Network adapter profile in VirtualBox, attached both VMs to this shared network segment, and confirmed distinct DHCP allocations].

## 4. Evidence
* [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) — Confirms initial VM creation, CPU, and base memory allocations matching host calculations.
* [evidence/02-disk-settings.png](evidence/02-disk-settings.png) — Proves virtual disk controller configuration and dynamic provisioning type.
* [evidence/03-network-adapter.png](evidence/03-network-adapter.png) — Shows adapter attachment type and MAC address assignments.
* [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) — Output of `uname -a` (Linux) and `systeminfo` (Windows) verifying kernel versions and OS installation.
* [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) — Terminal logs proving mutual ping reachability between guests and outgoing ping to an external IP.
* [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) — Shows the clean base-state snapshots created immediately following post-install configuration.

## 5. What I would do differently
* [Specify one concrete architectural or workflow change, e.g., automate guest provisioning with Vagrant or Packer scripts instead of manual GUI wizards to reduce setup time from 45 minutes to a single non-interactive command].
