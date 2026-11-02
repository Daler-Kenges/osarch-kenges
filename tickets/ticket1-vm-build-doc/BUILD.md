# BUILD.md — Virtualization & Test Machine Setup Runbook

**Audience:** Office Operations & IT Administration (Aigerim T.)  
**Purpose:** Replicable, step-by-step procedure to provision isolated Linux and Windows test virtual machines from a single host laptop without risk to physical equipment or internal networks.

---

## 1. Prerequisites: Hypervisor & ISO Media Acquisition

### Step 1. Download and Install VirtualBox
Navigate to [virtualbox.org](https://www.virtualbox.org/) and download the Oracle VirtualBox 7.x platform installer for your host operating system (Windows or macOS), then run the installer with default settings.
![](evidence/screenshots/01-virtualbox-install.png)
*Why this hypervisor and licence:* VirtualBox's core platform is released under the **GNU General Public License version 2 (GPLv2)**. It is completely free, open-source, and legally permissible to run in a corporate office environment without purchasing commercial hypervisor licenses.
> **Check:** Open your Start Menu or Applications folder and launch "Oracle VM VirtualBox". The VirtualBox Manager window opens without error.

---

### Step 2. Download the Ubuntu 24.04 LTS ISO
Visit [ubuntu.com/download/server](https://ubuntu.com/download/server) and download the official Ubuntu 24.04 LTS (Long Term Support) Server installation ISO file.
![](evidence/screenshots/02-ubuntu-download.png)
*Why Ubuntu Server LTS:* Ubuntu is the industry-standard POSIX environment for cloud and containerized backends. The Long Term Support (LTS) release provides five years of guaranteed stability and security patches without unexpected feature breakages.
> **Check:** The downloaded `.iso` file is approximately 2.5 GB to 3.0 GB in size and resides in your host `Downloads` folder.

---

### Step 3. Download the Windows 11 Enterprise Evaluation ISO
Visit the official [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise) and download the 64-bit Windows 11 Enterprise Evaluation ISO.
![](evidence/screenshots/03-windows-download.png)
*Why the Evaluation Edition:* Windows 11 requires a commercial license key for permanent production use. Microsoft provides the Enterprise Evaluation image legally and free of charge for 90 days specifically for developer testing and staging environments, ensuring zero office budget is spent.
> **Check:** The downloaded Windows `.iso` file is approximately 5.5 GB to 6.5 GB in size.

---

## 2. Global Network Setup: Creating the Shared NAT Network

### Step 4. Create the Software-Defined NAT Network
In the main VirtualBox Manager window, click the **Tools** menu button (top left), select **Network**, switch to the **NAT Networks** tab, and click **Create**.
![](evidence/03-nat-network.png)
*Why NAT Network and not NAT or Bridged:* Standard "NAT" isolates every virtual machine in its own private bubble, preventing the developer from testing connections between Linux and Windows. "Bridged" connects the virtual machines directly to the physical office Wi-Fi/LAN, which risks IP conflicts and triggers network security filters. A **NAT Network** creates an internal private virtual switch (`10.0.2.0/24`) where the two guests can communicate freely with each other and reach the internet, while remaining completely shielded from the physical office network.
> **Check:** A network named `NatNetwork` appears in the list with IPv4 Prefix `10.0.2.0/24` and the **DHCP** checkbox enabled.

---

## 3. Provisioning the Linux Virtual Machine (`dev-linux-test`)

### Step 5. Create the Ubuntu Virtual Machine
In VirtualBox Manager, click **Machine** > **New**. Set Name to `dev-linux-test`, Folder to default, and ISO Image to the downloaded Ubuntu 24.04 ISO file. Check **Skip Unattended Installation**.
![](evidence/screenshots/05-linux-create-wizard.png)
*Why Skip Unattended Installation:* Unattended installation attempts to automatically configure default cloud credentials that often fail or misconfigure disk partitioning. Manual installation ensures we have explicit control over administrative credentials and networking.
> **Check:** The next setup page displays Base Memory and Processor sliders.

---

### Step 6. Allocate Linux Hardware Resources
Set Base Memory to **4,096 MB (4 GB)** and Processors to **2 vCPUs**.
![](evidence/01-linux-settings.png)
*Why these resource numbers:* Linux development workflows (compilation, Docker containers) require at least 2 cores and 4 GB of RAM to operate smoothly without bogging down. Because the host laptop has limited memory, capping Linux at 4 GB leaves sufficient headroom for the host and the second VM.
> **Check:** The slider indicators stay within the green range and do not cross into the orange or red zones.

---

### Step 7. Configure Linux Virtual Disk
Select **Create a Virtual Hard Disk Now**, specify **25.00 GB**, and choose **VDI (VirtualBox Disk Image)** with **Dynamically allocated** storage.
![](evidence/screenshots/07-linux-disk.png)
*Why Dynamically Allocated VDI:* A "Fixed-size" disk immediately consumes 25 GB of the physical laptop's storage space upon creation. A "Dynamically allocated" disk starts at under 100 MB and only grows as files are actually written inside the VM, preserving the host laptop's free storage.
> **Check:** Click **Finish**. `dev-linux-test` appears in the left VM list in "Powered Off" state.

---

### Step 8. Attach Linux to the NAT Network
Right-click `dev-linux-test`, select **Settings**, navigate to **Network** > **Adapter 1**. Set **Attached to** to `NAT Network` and select `NatNetwork` in the Name dropdown.
![](evidence/screenshots/08-linux-network.png)
*Why this configuration:* Attaching directly to `NatNetwork` connects the machine's virtual network card (`enp0s3`) to our shared private virtual router instead of the default isolated NAT.
> **Check:** Expand the **Advanced** section and confirm that **Cable Connected** is checked.

---

### Step 9. Install Ubuntu Server OS
Start `dev-linux-test`. Select **Try or Install Ubuntu Server**. Step through the installer selecting English language, default keyboard layout, and the default network configuration. Create the username `kenges` with a secure password, and select **Reboot Now** when the installation completes.
![](evidence/screenshots/09-ubuntu-desktop.png)
*Why Ubuntu defaults:* Accepting default LVM partitioning automatically configures virtual storage for safe expansion while enabling security updates out of the box.
> **Check:** After rebooting, log in with username `kenges` and run `ip -4 addr show`. Interface `enp0s3` displays an IP address starting with `10.0.2.` (e.g., `10.0.2.7`).

---

## 4. Provisioning the Windows Virtual Machine (`dev-windows-test`)

### Step 10. Create the Windows 11 Virtual Machine
Click **Machine** > **New**. Set Name to `dev-windows-test`, Type to `Microsoft Windows`, Version to `Windows 11 (64-bit)`, and attach the Windows 11 Enterprise Evaluation ISO. Check **Skip Unattended Installation**.
![](evidence/screenshots/10-windows-create-wizard.png)
*Why these settings:* Selecting the "Windows 11 (64-bit)" preset instructs VirtualBox to automatically enable ACPI, x2APIC, and hardware virtualization instructions necessary to run Windows 11.
> **Check:** Click **Next** to access the hardware allocation page.

---

### Step 11. Allocate Windows Hardware, EFI & TPM
Set Base Memory to **4,096 MB (4 GB)**, Processors to **4 vCPUs**, and check **Enable EFI (special OSes only)**. Under the VM settings System/Motherboard tab, ensure TPM is set to **v2.0**.
![](evidence/02-windows-settings.png)
*Why TPM 2.0 and EFI:* Windows 11 strictly enforces hardware security requirements; it will refuse to boot or install unless it detects an active Trusted Platform Module (TPM 2.0) and modern UEFI firmware emulation.
> **Check:** Under Settings > Display, set Video Memory to **128 MB** and Graphics Controller to **VBoxSVGA**.

---

### Step 12. Configure Windows Virtual Disk
Select **Create a Virtual Hard Disk Now**, allocate **50.00 GB**, and confirm **Dynamically allocated VDI**.
![](evidence/screenshots/12-windows-disk.png)
*Why 50 GB:* Windows 11 system files, the WinSxS component store, and basic developer runtimes require at least 35 GB of space to install cleanly and receive updates without throwing low-disk warnings.
> **Check:** Click **Finish**. `dev-windows-test` appears in the VM list.

---

### Step 13. Attach Windows to the NAT Network
Open Settings for `dev-windows-test`, go to **Network** > **Adapter 1**, set **Attached to** to `NAT Network`, and select `NatNetwork`.
![](evidence/screenshots/13-windows-network.png)
*Why this configuration:* Places the Windows virtual machine onto the identical virtual switch as the Ubuntu machine, enabling them to discover and communicate with each other.
> **Check:** Confirm the **Cable Connected** checkbox is checked, then click **OK**.

---

### Step 14. Complete Windows 11 Installation
Start `dev-windows-test` and press any key when prompted to boot from CD/DVD. Follow the Windows Setup wizard, select **Windows 11 Enterprise Evaluation**, choose **Custom: Install Windows only (advanced)**, select the 50 GB unallocated space, and complete the desktop user setup.
![](evidence/screenshots/14-windows-desktop.png)
*Why clean install:* A clean setup ensures no OEM bloatware or conflicting trialware interferes with software testing.
> **Check:** Windows boots to the desktop. Open Command Prompt (`cmd.exe`) and run `ipconfig`. The Ethernet adapter displays an IPv4 Address starting with `10.0.2.` (e.g., `10.0.2.6`).

---

## 5. Network Verification & Firewall Configuration

### Step 15. Unblock Inbound Ping on Windows
Inside the Windows VM, click Start, type `cmd`, right-click **Command Prompt**, choose **Run as administrator**, and execute:
```cmd
netsh advfirewall firewall add rule name="Allow-Ping" protocol=icmpv4:8,any dir=in action=allow profile=any
