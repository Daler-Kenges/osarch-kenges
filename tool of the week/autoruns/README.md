# Autoruns (Microsoft Sysinternals)

## Overview
**Autoruns** is a free, lightweight Windows diagnostic utility from Microsoft Sysinternals. It displays every program, background service, driver, scheduled task, and script configured to launch automatically when Windows boots or when you log in.

### The Problem It Solves
Windows Task Manager (`Startup apps`) only shows a fraction of what runs at boot. Third-party updaters, vendor utilities, telemetry agents, and orphaned registry entries often hide inside **Scheduled Tasks** and **Services**, slowing down startup and consuming background RAM. Autoruns scans over 100 persistence locations in one interface so you can inspect, verify, and safely disable them.

---

## Step-by-Step Guide

> **Safety Warning:** Do not uncheck or delete entries in the **Drivers**, **Boot Execute**, **Winlogon**, or **KnownDLLs** tabs. Disabling critical system or hardware drivers can cause a Blue Screen of Death (BSOD) or prevent Windows from booting. Always **uncheck** items rather than deleting them so changes remain reversible.

### 1. Create a System Restore Point (2 min)
Press the **Windows key**, type **Create a restore point**, and open it. Select your `C:` drive, click **Configure** to ensure protection is enabled, then click **Create** and name it `Before Autoruns`.
* **Verification:** A confirmation dialog states that the restore point was created successfully.

### 2. Install Autoruns via Winget (1 min)
Open **Terminal** (PowerShell or Command Prompt) and run:
```powershell
winget install Microsoft.Sysinternals.Autoruns
