# Sysinternals Autoruns

> **Platform:** Windows | **Difficulty:** Harder | **License:** Freeware (Microsoft Sysinternals)

## Table of Contents
1. [Overview](#overview)
2. [Step-by-Step Guide](#step-by-step-guide)
3. [Alternative Methods](#alternative-methods)
4. [Working with `.arn` Snapshots](#working-with-arn-snapshots)
5. [Real-World Benchmark](#real-world-benchmark)
6. [Pros and Cons](#pros-and-cons)
7. [Target Audience & Recommendations](#target-audience--recommendations)

---

## Overview
**Autoruns** is a free, lightweight Windows diagnostic utility from Microsoft Sysinternals. It displays every program, background service, driver, scheduled task, and script configured to launch automatically when Windows boots or when you log in.

### The Problem It Solves
Windows Task Manager (`Startup apps`) only monitors a small fraction of auto-start locations. Third-party updaters, vendor utilities, telemetry agents, and orphaned registry entries often hide inside **Scheduled Tasks** and **Services**, slowing down startup and consuming background RAM. Autoruns scans over 100 persistence locations in one interface so you can inspect, verify, and safely disable them.

---

## Step-by-Step Guide

> **Safety Warning:** Do not uncheck or delete entries in the **Drivers**, **Boot Execute**, **Winlogon**, or **KnownDLLs** tabs. Disabling critical system or hardware drivers can trigger a Blue Screen of Death (BSOD) or prevent Windows from booting. Always **uncheck** items rather than deleting them so changes remain reversible.

### 1. Create a System Restore Point (2 min)
Press the **Windows key**, type **Create a restore point**, and open it. Select your `C:` drive, click **Configure** to ensure protection is turned on, then click **Create** and name it `Before Autoruns`.
* **Verification:** A confirmation dialog states that the restore point was created successfully.

### 2. Install Autoruns via Winget (1 min)
Open **Terminal** (PowerShell or Command Prompt) and run:
```powershell
winget install Microsoft.Sysinternals.Autoruns
```
* **Verification:** The terminal displays `Successfully installed` at the bottom of the output.

### 3. Run as Administrator and Save a Baseline (1 min)
Right-click `Autoruns64.exe` and select **Run as administrator**. Wait for the bottom-left status bar to display **Ready**, then click **File → Save** and save a `.arn` backup file to your Desktop (e.g., `baseline.arn`).
* **Verification:** The window title bar shows `(Administrator)` and your `.arn` baseline file appears on the Desktop.

### 4. Hide Microsoft and Windows Entries (1 min)
In the top menu, go to **Options → Scan Options**. Check **Hide Microsoft entries**, **Hide Windows entries**, and **Verify code signatures**, then click **Rescan**.
* **Verification:** The list shrinks dramatically, showing only third-party software and drivers.

### 5. Trim the Logon Tab (3 min)
Switch to the **Logon** tab. Uncheck apps you do not need immediately at startup—such as game launchers (Steam, Epic Games), chat apps (Discord, Zoom), cloud updaters, and printer utilities. Also uncheck any **yellow** (`File not found`) rows, which are leftover entries from uninstalled software.
* **Verification:** Only essential utilities (such as your touchpad driver, audio manager, or password manager) remain checked.

### 6. Disable Bloat in Scheduled Tasks (2 min)
Switch to the **Scheduled Tasks** tab. Uncheck unnecessary third-party auto-updaters and vendor telemetry tasks (e.g., Google, Adobe, Java, or laptop manufacturer utilities). Leave antivirus and backup tasks alone.
* **Verification:** Unnecessary background updaters are unchecked without touching any security tools.

### 7. Check Third-Party Services *(Optional)* (2 min)
Switch to the **Services** tab. Only uncheck services you clearly recognize as optional (such as RGB lighting controllers or redundant vendor software). Skip anything related to Intel, AMD, NVIDIA, Realtek, Wi-Fi, or security software.
* **Verification:** Every unchecked service belongs to a recognized, non-essential application.

### 8. Reboot and Verify Boot Time (2 min)
Restart your laptop. Once on the desktop, press **Ctrl + Shift + Esc** to open **Task Manager**, go to the **Startup apps** tab, and check **Last BIOS time** in the top-right corner while noting how quickly your desktop becomes responsive.
* **Verification:** Windows boots normally, all essential hardware (Wi-Fi, audio, touchpad, GPU) works, and the desktop becomes usable faster.

---

## Alternative Methods

### Run Without Installing (Portable PowerShell)
If `winget` is unavailable or you do not want to install anything permanently, run this in PowerShell to download, extract, and launch Autoruns as Administrator:
```powershell
Invoke-WebRequest -Uri "[https://download.sysinternals.com/files/Autoruns.zip](https://download.sysinternals.com/files/Autoruns.zip)" -OutFile "$env:TEMP\Autoruns.zip"
Expand-Archive "$env:TEMP\Autoruns.zip" -DestinationPath "$env:TEMP\Autoruns" -Force
Start-Process "$env:TEMP\Autoruns\Autoruns64.exe" -Verb RunAs
```

### Command-Line Only (`autorunsc64`)
To view or export startup items directly in the terminal without opening the graphical interface:
```powershell
autorunsc64 -a * -c -h -v -vt
```
* `-a *` — Scans all auto-start categories.
* `-c` — Outputs results in CSV format.
* `-h` — Calculates file hashes.
* `-v` — Verifies digital signatures.
* `-vt` — Checks file hashes against VirusTotal.

---

## Working with `.arn` Snapshots
An **`.arn` file** (Autoruns Data) is Autoruns' native binary snapshot format. Unlike `.csv` or `.txt` exports, `.arn` files capture the full state of every auto-start location—including signature verification and VirusTotal results—and can be reopened inside Autoruns for offline auditing.

> **Note:** An `.arn` file is an audit record, not an automated registry rollback.

### How to Save and Compare Snapshots
1. **Save a baseline:** Open Autoruns as Administrator, wait for **Ready**, and click **File → Save** (`baseline.arn`).
2. **Compare later:** After installing software or disabling startup items, open Autoruns and click **File → Compare**, then select `baseline.arn`.
3. **Read the diff:** **Green** rows indicate newly added entries; **red** rows indicate removed or disabled entries.

You can also save a snapshot directly from PowerShell:
```powershell
Autoruns64.exe -v -a baseline.arn
```

---

## Real-World Benchmark
* **Test Machine:** 3-month-old Windows laptop (RTX 4050, clean install, no heavy bloatware).
* **Disabled:** Non-essential entries in **Logon**, **Scheduled Tasks**, and **Services** for Google, Zoom, Discord, Steam, Epic Games, Google Play, and ASUS Armoury Crate (replaced by G-Helper).
* **Kept:** NVIDIA services (required for GPU management and maintaining a locked 240 FPS in games).
* **Result:** Boot time shortened from **7.8 seconds to 7.4 seconds**. On a newer, clean SSD machine, the main benefit is eliminating silent background updaters and freeing up RAM; older or more cluttered laptops typically see much larger boot-time reductions.

---

## Pros and Cons

### Pros
* **Deep Visibility:** Exposes hidden Scheduled Tasks, Services, and orphaned (`File not found`) entries that Task Manager misses.
* **Faster Boot & Less Memory Bloat:** Removes unnecessary background processes and speeds up login times.
* **Built-In Security Triage:** Verifies digital signatures and checks file hashes against VirusTotal.
* **Reversible & Portable:** Free, requires no installation, and lets you uncheck entries safely rather than deleting them permanently.

### Cons
* **High Risk of System Instability (Rated "Harder"):** Unlike Task Manager, Autoruns has no guardrails—disabling the wrong driver or core service can cause a BSOD or boot loop.
* **Overwhelming Default View:** The unfiltered `Everything` tab lists hundreds of technical entries that can intimidate beginners.
* **No One-Click Restore from `.arn`:** Snapshots are for auditing and comparing, not automatic system restoration.

---

## Target Audience & Recommendations

### Who Should Use Autoruns?
* **Power Users & Gamers:** Ideal for stripping out vendor bloatware (such as Armoury Crate) and background game launchers while keeping essential GPU and hardware services intact.
* **IT Administrators & Helpdesk Technicians:** Useful for troubleshooting slow machines, auditing baseline images, and hunting for persistent malware.
* **Users with Older Laptops:** Especially effective on systems that have accumulated years of auto-updaters and background utilities.

### Recommendations
1. **Always create a System Restore Point first** before modifying Services or Scheduled Tasks.
2. **Always enable "Hide Microsoft & Windows Entries"** to avoid accidentally disabling core OS components.
3. **Disable in small batches** (uncheck a few items, reboot, and test) so you immediately know what caused an issue if an app stops working.
4. **Never disable hardware vendor services you actively rely on** (e.g., NVIDIA, Intel, AMD, Realtek, or Wi-Fi drivers).
