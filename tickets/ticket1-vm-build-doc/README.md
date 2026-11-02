# Ticket 1 – New developer starts Monday, needs a test machine

## 1. What was asked
> From: Aigerim T. (Office Manager)
> Subject: test machine for new dev
> 
> Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks

## 2. What was actually needed
* **Omissions in the request:**
  * **Host hardware constraints:** The requester did not specify the physical machine's hardware budget (available RAM, CPU cores, or free disk storage), leaving the hypervisor memory ceiling undefined[cite: 2].
  * **Target toolchain & runtime:** Omitted which runtime environments, compilers, or databases the developer requires, as well as whether internal corporate network shares or external repositories are needed[cite: 2].
  * **Audience baseline:** Failed to define the office manager's technical baseline or whether host prerequisites (such as CPU virtualization flags in BIOS/UEFI) were configured[cite: 4].

* **Flaws in the request:**
  * **Singular machine vs. cross-platform testing:** The request asks for "a test computer" in the singular[cite: 4]. Modern application development requires testing compatibility across both POSIX-compliant Linux and Windows environments, necessitating two distinct virtual machines[cite: 4].
  * **"Without breaking anything" without rollback capability:** A non-technical user assumes a computer can simply be "tried out" without risk[cite: 4]. Without configuring baseline hypervisor snapshots, testing unverified code or broken packages will permanently corrupt the OS, necessitating repeated rebuilds from scratch[cite: 4].
  * **Replication feasibility:** The requester assumes she can repeat the setup herself after reading simple notes[cite: 4]. Hypervisor setup requires precise storage provisioning, adapter configuration, and guest driver integration, demanding an exhaustive, beginner-level runbook[cite: 4].

* **Clarifying questions for requester:**
  1. What is the physical specification (RAM, CPU, and free disk space) of the developer's workstation[cite: 2]?
  2. Does the developer require access to internal network shares, company staging servers, or only outbound public internet access[cite: 2]?
  3. Does the developer need specific IDEs, Docker, or root/administrative privileges inside the guest OS?
  4. Should the machine retain long-term state, or be reverted to a clean snapshot regularly[cite: 4]?

* **Assumptions made:**
  * **Hypervisor:** Selected Oracle VirtualBox 7.2.20 due to zero software licensing cost, strong cross-platform support, and straightforward GUI snapshot management for non-technical users[cite: 4].
  * **Operating Systems:** Deployed Ubuntu 24.04 LTS (for containerized, backend, and POSIX development) and Windows 11 Enterprise Evaluation (for client/desktop software testing)[cite: 4].
  * **Network Architecture:** Configured a dedicated **NAT Network** (`NatNetwork`, subnet `10.0.2.0/24`) with built-in DHCP[cite: 5]. Default VirtualBox NAT isolates VMs from each other; NAT Network allows mutual ICMP ping and inter-guest communication while isolating the test environment from the physical office LAN[cite: 4, 5].
  * **Storage Provisioning:** Used **Dynamically Allocated VDI** disks (25 GB for Ubuntu, 50 GB for Windows) to prevent exhausting the host's 98 GB free storage ceiling while leaving adequate overhead for snapshots and host paging files[cite: 4].
  * **Build Guide Scope:** Structured `BUILD.md` as an end-to-end, screenshot-guided manual assuming zero prior virtualization knowledge, explaining the functional reason behind every selected setting[cite: 4].

## 3. What I did
### 3.1 Host Sizing & Resource Math
* **Host specs:** [16 GB physical RAM, 8 CPU cores and 16 threads, 512 GB NVMe SSD (98 GB free)].
* **Linux VM allocation:** [4 GB RAM, 2 vCPUs, 25 GB dynamically allocated disk].
* **Windows VM allocation:** [4 GB RAM, 4 vCPUs, 50 GB dynamically allocated disk].
* **Allocation reasoning:** Total concurrent guest memory allocation is 8 GB, leaving 8 GB exclusively for the host OS and baseline background services to prevent host memory exhaustion and disk thrashing. Using 6 vCPU leaves ample processing power for host scheduling without CPU contention or context-switching overhead. Windows has higher baseline GUI and background telemetry overhead, justifying 4 vCPUs for smooth responsiveness, whereas Linux runs leanly and performs well on 2 vCPUs. Also, because I have only 98 GB of memory in storage, using dynamically allocated disks ensures that while both guests have access to 75 GB total capacity, they initially consume only ~35 GB of actual physical space. This leaves ~63 GB of uncommitted host storage for VirtualBox swap/pagefiles, snapshots (06-snapshot-list.png), host operating system cache, and developer dependencies, preventing disk exhaustion.

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
* What Went Wrong: Command Execution & Environment ChallengesMissing Minimal Networking Tools (iputils-ping)Issue: Attempting to execute ping inside the Ubuntu guest initially failed with a command not found error.   Resolution: Ubuntu's minimal server image does not package ICMP utilities by default. The package index had to be refreshed and the utility installed explicitly via:   Bashsudo apt update && sudo apt install -y iputils-ping
Once installed, the guest operating system had the binary necessary to initiate ICMP echo requests.   Windows Firewall Blocking ICMP PacketsIssue: Even with network adapters properly attached to the same NatNetwork, ping requests sent from Ubuntu to the Windows VM (10.0.2.6) were dropped.   Resolution: Windows Defender Firewall blocks unsolicited incoming ICMPv4 traffic across all active profiles by default. The firewall had to be temporarily lowered to establish connectivity:DOSnetsh advfirewall set allprofiles state off
To maintain host defense long-term, a persistent inbound allow rule targeting ICMPv4 (Allow-Ping) was subsequently registered before re-enabling firewall profiles.   Shell Tokenization Errors from Quoted / Clustered InputsIssue: Running ping commands repeatedly failed with 'ping -c 4 ...': command not found.   Resolution: Pasting commands with leading single quotation marks caused the Linux shell to interpret the entire line—arguments, flags, and executable name combined—as one single, nonexistent binary name. Stripping all quotation formatting and executing each command cleanly as an isolated single-line entry per prompt allowed bash to properly parse ping as the command, -c as the count switch, and the targets (8.8.8.8 / 10.0.2.6) as positional arguments. 

## 4. Evidence
* [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) — Confirms initial VM creation, CPU, and base memory allocations matching host calculations.
* [evidence/02-disk-settings.png](evidence/02-disk-settings.png) — Proves virtual disk controller configuration and dynamic provisioning type.
* [evidence/03-network-adapter.png](evidence/03-network-adapter.png) — Shows adapter attachment type and MAC address assignments.
* [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) — Output of `uname -a` (Linux) and `systeminfo` (Windows) verifying kernel versions and OS installation.
* [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) — Terminal logs proving mutual ping reachability between guests and outgoing ping to an external IP.
* [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) — Shows the clean base-state snapshots created immediately following post-install configuration.

## 5. What I would do differently
* [Specify one concrete architectural or workflow change, e.g., automate guest provisioning with Vagrant or Packer scripts instead of manual GUI wizards to reduce setup time from 45 minutes to a single non-interactive command].
