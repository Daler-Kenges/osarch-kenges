# Ticket 1 – New developer starts Monday, needs a test machine

## 2. Requirements Analysis, Scope Gaps & Assumptions

### 2.1 The Ticket: Literal Request vs. Operational Reality
The incoming ticket presents a classic non-technical request:
> *"Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks"*

| The Ticket Says | What the Ticket Actually Means | Architectural Decision |
| :--- | :--- | :--- |
| *"A test computer" (singular)* | Modern developers require multi-platform verification across both POSIX server environments and Windows enterprise clients. | Provision two distinct virtual machines: `dev-linux-test` (Ubuntu) and `dev-windows-test` (Windows 11). |
| *"Nothing special"* | Developers need standard runtime dependencies, compilers, network diagnostics, and package management, not an empty or under-provisioned shell. | Provision baseline dev specs: 2 vCPUs / 4 GB RAM for Linux, 4 vCPUs / 4 GB RAM for Windows. |
| *"Without breaking anything"* | The physical host OS, host registry, and local office LAN must be isolated from experimental code, malware, or misconfigured daemons. | Run guests in a sandboxed hypervisor network; take clean baseline snapshots (`Base-Clean-Install`) for one-click rollback. |
| *"So I can do the next one myself"* | The runbook must be completely accessible to an Office Manager with no command-line or systems administration background. | Structure `BUILD.md` as an exhaustive, screenshot-driven procedural manual with zero assumed prerequisite jargon. |

---

### 2.2 Core Analytical Questions

#### 1. What does "nothing special" actually mean for a developer?
A developer cannot validate software within a generic, unconfigured environment. At a minimum, a modern testbed requires both a standard POSIX/Linux environment (Ubuntu 24.04 LTS) for containerized and backend workflows, and a Windows environment (Windows 11 Enterprise) for client software, Active Directory interoperability, and cross-platform binary compatibility.

#### 2. "Without breaking anything" — breaking what, and how do we recover?
* **Host Protection:** A virtual machine isolates the host system's kernel, file systems, and hardware drivers from experimental binaries, unverified packages, and configuration drift.
* **Network Protection:** Segmenting the VMs away from the office LAN prevents runaway test services or IP conflicts from impacting company equipment.
* **Rollback via Snapshots:** When the developer inevitably breaks the guest OS (e.g., corrupted kernel packages, registry errors, dependency deadlocks), reinstalling the OS wastes hours. Hypervisor baseline snapshots (`Base-Clean-Install`) enable an instantaneous rollback to an pristine state without hypervisor reinstallation.

#### 3. How much memory and disk does the host computer have?
The request omitted the physical workstation's hardware budget. Running two concurrent guests requires careful resource budgeting to avoid host memory exhaustion:
* **RAM Allocation:** Allocated 4,096 MB to Linux and 4,077 MB to Windows (totaling ~8 GB), leaving at least 8 GB of physical RAM for the host OS on a standard 16 GB workstation.
* **Storage Allocation:** Provisioned Dynamically Allocated Virtual Disk Images (VDI)—25 GB for Ubuntu and 50 GB for Windows. Dynamic provisioning ensures the VMs consume only active disk blocks, preserving physical host storage.

#### 4. Does the test machine need the internet? Do the two guests need to see each other?
* **Internet Reachability:** Developers continuously require outbound network access to fetch public packages (`apt`, `npm`, `pip`, Windows updates) and clone remote repositories.
* **Inter-Guest Visibility:** Validating client-server software requires bidirectional network communication between the Linux and Windows guests.
* **Network Mode Selection:** Default VirtualBox NAT isolates VMs from one another, while Bridged Networking exposes guest test services directly to the physical office subnet. A dedicated **NAT Network (`NatNetwork`, 10.0.2.0/24)** was selected because it enables mutual guest-to-guest ICMP/TCP communication and outbound WAN routing while isolating the entire test environment from the corporate physical LAN.

#### 5. Which hypervisor, which licence, and which ISO?
To ensure the office manager can replicate the build legally without incurring licensing costs:
* **Hypervisor:** Oracle VirtualBox 7.x base package, distributed under the GNU General Public License (GPLv2)—100% free and legal for commercial office deployment without licensing fees.
* **Linux Guest:** Ubuntu 24.04 LTS (Open Source, free for commercial and development use).
* **Windows Guest:** Windows 11 Enterprise Evaluation ISO (Official Microsoft 90-day evaluation image, legal for testing without upfront commercial licensing).

#### 6. Who is the reader?
The primary reader is Aigerim, an Office Manager. The documentation cannot use shorthand like "configure your network adapter" or "install packages via shell." Every instruction in `BUILD.md` specifies the exact menu items to click, flags to select, terminal commands to copy, and visual checkpoints to look for before moving to the next step.

---

### 2.3 Clarifying Inquiries vs. Working Assumptions

Because the office manager was unavailable for immediate technical consultation, the build proceeded on engineering assumptions to meet the Monday deadline:

| Clarifying Question for Requester | Working Assumption Made to Proceed |
| :--- | :--- |
| What are the physical host specifications (RAM, CPU cores, free SSD space)? | Assumed a standard corporate developer workstation (minimum 16 GB RAM, 6+ physical CPU cores, >80 GB free disk). |
| What specific language stacks, IDEs, or database engines does the dev need? | Provisioned minimal OS baselines with networking tools (`iputils-ping`, PowerShell), allowing the developer to self-serve specific IDEs. |
| Does the developer require access to internal company file shares or staging servers? | Isolated the machines to an internal `NatNetwork` with public WAN access; internal LAN access was denied by default for zero-trust isolation. |
| How frequently will the environment need to be restored to a clean state? | Assumed high volatility; established an initial `Base-Clean-Install` snapshot immediately following OS setup and verification. |

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
