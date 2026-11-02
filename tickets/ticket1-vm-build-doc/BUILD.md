# BUILD.md — Virtualization & Test Machine Setup Runbook

**Audience:** Office Operations & IT Administration (Aigerim T.)  
**Purpose:** Replicable, step-by-step procedure to provision isolated Linux and Windows test virtual machines from a single host laptop without risk to physical equipment or internal networks.

---

## 1. Prerequisites: Hypervisor & ISO Media Acquisition

### Step 1. Download and Install VirtualBox
Navigate to [virtualbox.org](https://www.virtualbox.org/) and download the Oracle VirtualBox 7.x platform installer for your host operating system, then run the installer with default settings.

*Why this hypervisor and licence:* VirtualBox's core platform is released under the **GNU General Public License version 2 (GPLv2)**. It is completely free, open-source, and legally permissible to run in a corporate office environment without purchasing commercial hypervisor licenses.
> **Check:** Open your Start Menu or Applications folder and launch "Oracle VM VirtualBox". The VirtualBox Manager window opens without error.

---

### Step 2. Download the Ubuntu 24.04 LTS ISO
Visit [ubuntu.com/download/server](https://ubuntu.com/download/server) and download the official Ubuntu 24.04 LTS (Long Term Support) Server installation ISO file.

*Why Ubuntu Server LTS:* Ubuntu is the industry-standard POSIX environment for cloud and containerized backends. The Long Term Support (LTS) release provides five years of guaranteed stability and security patches without unexpected feature breakages.
> **Check:** The downloaded `.iso` file is approximately 2.5 GB to 3.0 GB in size and resides in your host `Downloads` folder.

---

### Step 3. Download the Windows 11 Enterprise Evaluation ISO
Visit the official [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise) and download the 64-bit Windows 11 Enterprise Evaluation ISO.

*Why the Evaluation Edition:* Windows 11 requires a commercial license key for permanent production use. Microsoft provides the Enterprise Evaluation image legally and free of charge for 90 days specifically for developer testing and staging environments, ensuring zero office budget is spent.
> **Check:** The downloaded Windows `.iso` file is approximately 5.5 GB to 6.5 GB in size.

---

## 2. Global Network Setup: Creating the Shared NAT Network

### Step 4. Create the Software-Defined NAT Network
In the main VirtualBox Manager window, click the **Tools** menu button (top left), select **Network**, switch to the **NAT Networks** tab, and click **Create**. Ensure IPv4 Prefix is set to `10.0.2.0/24` with DHCP enabled.

![](evidence/03-nat-network.png)

*Why NAT Network and not NAT or Bridged:* Standard "NAT" isolates every virtual machine in its own private bubble, preventing the developer from testing connections between Linux and Windows. "Bridged" connects the virtual machines directly to the physical office Wi-Fi/LAN, which risks IP conflicts and triggers network security filters. A **NAT Network** creates an internal private virtual switch (`10.0.2.0/24`) where the two guests can communicate freely with each other and reach the internet, while remaining completely shielded from the physical office network.
> **Check:** A network named `NatNetwork` appears in the list with IPv4 Prefix `10.0.2.0/24` and the **DHCP** checkbox enabled.

---

## 3. Provisioning the Linux Virtual Machine (`dev-linux-test`)

### Step 5. Create and Configure Linux VM Hardware
In VirtualBox Manager, click **Machine** > **New**. Set Name to `dev-linux-test`, attach the Ubuntu 24.04 ISO, and check **Skip Unattended Installation**. Allocate **4,096 MB RAM**, **2 vCPUs**, and create a **25.00 GB Dynamically Allocated VDI** disk. Set the Network Adapter to `NAT Network` (`NatNetwork`).

![](evidence/01-linux-settings.png)

*Why these settings:* Linux compilation and container runtimes require at least 2 cores and 4 GB RAM. Dynamic VDI storage starts small and grows only as data is written, preventing host storage exhaustion. Attaching to `NatNetwork` connects the guest to our shared virtual switch.
> **Check:** In Settings > Network > Adapter 1, **Attached to:** displays `NAT Network` and **Cable Connected** is checked.

---

### Step 6. Install Ubuntu Server OS
Start `dev-linux-test` and complete the installation wizard: select English, accept default LVM storage layouts, configure user `kenges`, and reboot.

*Why default partitioning:* LVM partitioning ensures easy virtual disk expansion later while setting up secure system updates out of the box.
> **Check:** Log in at the prompt and execute `ip -4 addr show`. Interface `enp0s3` displays an assigned IP address on `10.0.2.0/24` (specifically `10.0.2.7`).

---

## 4. Provisioning the Windows Virtual Machine (`dev-windows-test`)

### Step 7. Create and Configure Windows 11 VM Hardware
Click **Machine** > **New**. Set Name to `dev-windows-test`, Type to `Microsoft Windows`, Version to `Windows 11 (64-bit)`, and attach the Windows 11 ISO. Check **Skip Unattended Installation**. Allocate **4,096 MB RAM**, **4 vCPUs**, check **Enable EFI**, enable **TPM 2.0**, and create a **50.00 GB Dynamically Allocated VDI** disk. Set the Network Adapter to `NAT Network` (`NatNetwork`).

![](evidence/02-windows-settings.png)

*Why TPM 2.0 and EFI:* Windows 11 enforces hardware-level security checks and refuses to boot without active TPM 2.0 and UEFI emulation. 50 GB provides adequate overhead for the WinSxS component store and staging software.
> **Check:** In Settings > Display, Video Memory is set to 128 MB with VBoxSVGA controller enabled.

---

### Step 8. Install Windows 11 Enterprise OS
Start `dev-windows-test`, boot from ISO, select **Windows 11 Enterprise Evaluation**, choose **Custom: Install Windows only (advanced)**, and complete user desktop setup.

*Why clean installation:* A pristine operating system guarantees no preinstalled OEM trialware conflicts with developer test suites.
> **Check:** Windows reaches the desktop. Open Command Prompt and run `ipconfig`. The Ethernet adapter displays an IP address on `10.0.2.0/24` (specifically `10.0.2.6`).

---

## 5. Verification & Inter-Guest Communication

### Step 9. Verify Guest OS Specifications
Open terminal sessions on both machines and inspect host parameters. Log outputs into `evidence/04-guest-uname.txt`:
* **Ubuntu:** Run `uname -a`
* **Windows:** Run `systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"`

*Why this verification:* Confirms that 64-bit kernels and expected memory baselines are operational before handing the environment to the developer.
> **Check:** Consult `evidence/04-guest-uname.txt` to confirm both system properties match specification.

---

### Step 10. Configure Inbound ICMP on Windows
Inside the Windows VM, open Command Prompt as Administrator and run:
```cmd
netsh advfirewall firewall add rule name="Allow-Ping" protocol=icmpv4:8,any dir=in action=allow profile=any
