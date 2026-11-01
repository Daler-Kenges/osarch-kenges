# VM Build Guide: Linux & Windows Test Environment

This guide describes how to configure two test virtual machines (Ubuntu Linux and Windows) from scratch.

---

## Part 1: Prerequisites & Hypervisor Installation
1. Download and install [Hypervisor Name, e.g., VirtualBox 7.x].
2. Download official ISO images:
   * Ubuntu Server/Desktop 24.04 LTS
   * Windows 11 Enterprise Evaluation

---

## Part 2: Building the Linux Guest

### Step 1. Creating the Virtual Machine
1. Open the hypervisor and click **New**.
2. Set Name to `dev-linux-test`, Type to `Linux`, and Version to `Ubuntu (64-bit)`.
![](evidence/01-new-vm-wizard.png)
*Why these settings:* Setting the correct OS type and version automatically tunes hypervisor kernel paravirtualization flags and ACPI settings optimal for Linux.

### Step 2. Storage and Virtual Hard Disk
1. Select **Create a Virtual Hard Disk Now**.
2. Choose **VDI / VMDK** and set disk allocation to **Dynamically Allocated** with a size of 30 GB.
![](evidence/02-disk-settings.png)
*Why dynamic provisioning:* Dynamic allocation consumes host drive space only as the guest writes data, preventing premature exhaustion of host storage while leaving adequate headroom for developer dependencies.

### Step 3. Network Configuration
1. Open VM **Settings** > **Network**.
2. Set Adapter 1 to **NAT Network** (or configured Host-Only/NAT bridge).
![](evidence/03-network-adapter.png)
*Why NAT Network and not Bridged/Default NAT:* Standard default NAT isolates each guest in its own private sandbox where they cannot communicate directly; NAT Network places both VMs on the same virtual subnet while translating outgoing traffic through the host's IP address.
> **Check:** Boot the OS and run `ip addr` in the terminal. Verify the interface has an active IP address assigned (e.g., `10.0.2.x` or `192.168.56.x`).

### Step 4. Baseline Snapshot
1. After OS installation completes, power down the VM.
2. In the hypervisor management console, click **Snapshots** > **Take**.
3. Name the snapshot `Base-Clean-Install`.
![](evidence/06-snapshot-list.png)
*Why a baseline snapshot:* This enables the developer to revert the VM to an unmodified operating state within seconds if configuration experiments break system packages.

---

## Part 3: Building the Windows Guest
[Repeat Steps 1–4 with Windows-specific screenshots, storage sizing, and validation commands (e.g., `ipconfig /all`).]

---

## Part 4: Inter-Guest Connectivity Verification
1. Boot both virtual machines concurrently.
2. From the Linux guest, ping the Windows guest IP:
   ```bash
   ping -c 4 <windows_guest_ip>
