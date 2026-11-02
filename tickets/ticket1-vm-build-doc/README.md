# Ticket 1 – New developer starts Monday, needs a test machine

## 1. What was asked
> "Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks"
> — Aigerim T. (Office Manager)

## 2. What was actually needed

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
- **Host Protection:** A virtual machine isolates the host system's kernel, file systems, and hardware drivers from experimental binaries, unverified packages, and configuration drift.
- **Network Protection:** Segmenting the VMs away from the office LAN prevents runaway test services or IP conflicts from impacting company equipment.
- **Rollback via Snapshots:** When the developer inevitably breaks the guest OS (e.g., corrupted kernel packages, registry errors, dependency deadlocks), reinstalling the OS wastes hours. Hypervisor baseline snapshots (`Base-Clean-Install`) enable an instantaneous rollback to a pristine state without hypervisor reinstallation.

#### 3. How much memory and disk does the host computer have?
The request omitted the physical workstation's hardware budget. Running two concurrent guests requires careful resource budgeting to avoid host memory exhaustion:
- **RAM Allocation:** Allocated 4,096 MB to Linux and 4,096 MB to Windows (totaling 8 GB), leaving 8 GB of physical RAM for the host OS on a standard 16 GB workstation.
- **Storage Allocation:** Provisioned Dynamically Allocated Virtual Disk Images (VDI)—25 GB for Ubuntu and 50 GB for Windows. Dynamic provisioning ensures the VMs consume only active disk blocks, preserving physical host storage.

#### 4. Does the test machine need the internet? Do the two guests need to see each other?
- **Internet Reachability:** Developers continuously require outbound network access to fetch public packages (`apt`, `npm`, `pip`, Windows updates) and clone remote repositories.
- **Inter-Guest Visibility:** Validating client-server software requires bidirectional network communication between the Linux and Windows guests.
- **Network Mode Selection:** Default VirtualBox NAT isolates VMs from one another, while Bridged Networking exposes guest test services directly to the physical office subnet. A dedicated **NAT Network (`NatNetwork`, 10.0.2.0/24)** was selected because it enables mutual guest-to-guest ICMP/TCP communication and outbound WAN routing while isolating the entire test environment from the corporate physical LAN.

#### 5. Which hypervisor, which licence, and which ISO?
To ensure the office manager can replicate the build legally without incurring licensing costs:
- **Hypervisor:** Oracle VirtualBox 7.x base package, distributed under the GNU General Public License (GPLv2)—100% free and legal for commercial office deployment without licensing fees.
- **Linux Guest:** Ubuntu 24.04 LTS (Open Source, free for commercial and development use).
- **Windows Guest:** Windows 11 Enterprise Evaluation ISO (Official Microsoft 90-day evaluation image, legal for testing without upfront commercial licensing).

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
- **Host specs:** 16 GB physical RAM, 8 CPU cores / 16 threads, 512 GB NVMe SSD (98 GB free).
- **Linux VM allocation (`dev-linux-test`):** 4,096 MB RAM, 2 vCPUs, 25 GB dynamically allocated VDI disk.
- **Windows VM allocation (`dev-windows-test`):** 4,096 MB RAM, 4 vCPUs, 50 GB dynamically allocated VDI disk.
- **Allocation reasoning:** Total concurrent guest memory allocation is 8 GB, leaving 8 GB exclusively for the host operating system and background tasks to prevent host memory exhaustion and paging thrash. Allocating 6 vCPUs combined across the guests leaves processing capacity for host scheduling without excessive context switching. Windows 11 requires 4 vCPUs to run its background telemetry, indexing, and GUI smoothly, whereas Ubuntu Server operates efficiently on 2 vCPUs. With 98 GB free storage on the host drive, allocating dynamic disks ensures both VMs initially consume only ~35 GB combined, preserving ~63 GB for differential snapshots (`evidence/06-snapshot-list.png`), host swap files, and project build dependencies.

### 3.2 Non-Default Hypervisor Settings
- **Network Mode (Standard NAT switched to NAT Network):** Default VirtualBox NAT uses a built-in isolated engine assigning identical addresses (like `10.0.2.15`) to each guest, preventing direct inter-VM routing. Switched both guests to a shared `NAT Network` (`NatNetwork`, `10.0.2.0/24`) with DHCP enabled, providing mutual pingability alongside outbound gateway routing.
- **Storage Provisioning (Dynamically Allocated VDI over Fixed-Size):** Fixed allocation would immediately lock 75 GB of the host's 98 GB free storage. Dynamically allocated disks expand on demand as data is written, preventing disk exhaustion on the host laptop.
- **Firmware & Security Settings for Windows 11:** Enabled EFI emulation (`Enable EFI`) and assigned a virtual TPM 2.0 module in the Motherboard configuration to satisfy Windows 11 installation prerequisites.

### 3.3 Execution Steps
1. Created the global software-defined `NatNetwork` (`10.0.2.0/24`) within VirtualBox Manager Tools.
2. Provisioned `dev-linux-test` (Ubuntu 24.04 Server) and `dev-windows-test` (Windows 11 Enterprise Evaluation) with assigned CPU, RAM, and dynamic storage profiles.
3. Attached Network Adapter 1 of both machines to `NatNetwork` to confirm mutual Layer-3 subnet visibility.
4. Installed base operating systems via guided setup, creating administrative accounts.
5. Installed diagnostic utilities (`iputils-ping`) on Ubuntu and added an ICMP inbound allow rule on Windows Firewall.
6. Conducted four-point bidirectional ICMP verification (`ping` between guests and to `8.8.8.8`).
7. Cleanly powered off both virtual machines and created baseline snapshots named `Base-Clean-Install`.

### 3.4 Failure Encountered and Resolution
- **Missing Networking Utilities on Ubuntu:**
  - *Issue:* Executing `ping` on Ubuntu returned `command not found` because minimal server ISO images omit ICMP diagnostic packages by default.
  - *Resolution:* Executed `sudo apt update && sudo apt install -y iputils-ping` to deploy the package.
- **Windows Firewall Silently Dropping ICMP Requests:**
  - *Issue:* Pinging the Windows guest (`10.0.2.6`) from Linux resulted in 100% packet loss despite valid adapter leases.
  - *Resolution:* Windows Defender Firewall drops inbound ICMP by default. Permitted access by executing:
    ```cmd
    netsh advfirewall firewall add rule name="Allow-Ping" protocol=icmpv4:8,any dir=in action=allow profile=any
    ```
- **Shell Command Tokenization Errors:**
  - *Issue:* Pasting command strings with leading quotes caused bash to interpret the command name and arguments as a single non-existent binary (`'ping -c 4 ...': command not found`).
  - *Resolution:* Stripped all quotation wrappers and ran commands directly per prompt line, allowing the shell to parse the executable and positional flags properly.

## 4. Evidence
- [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) — Confirms initial VM creation wizard parameters, including RAM and CPU sizing.
- [evidence/02-disk-settings.png](evidence/02-disk-settings.png) — Proves virtual storage configuration and the selection of dynamically allocated VDI formatting.
- [evidence/03-network-adapter.png](evidence/03-network-adapter.png) — Verifies attachment to the shared `NatNetwork` virtual switch and active cable connection.
- [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) — Verifies kernel details from `uname -a` on Ubuntu and hardware-detected specs from `systeminfo` on Windows.
- [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) — Proves 0% packet loss for bidirectional inter-guest pings and outbound routing to `8.8.8.8`.
- [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) — Confirms `Base-Clean-Install` baseline snapshots were created for both machines in a clean Powered Off state.

## 5. What I would do differently
Automate guest deployment using an Infrastructure-as-Code tool (such as Vagrant paired with a `Vagrantfile`) instead of clicking through manual VirtualBox GUI wizards. Scripting the build reduces end-to-end provisioning time from 45 minutes of active manual interaction to a single `vagrant up` execution, eliminating user error in wizard dialogs for non-technical operators like Aigerim.
