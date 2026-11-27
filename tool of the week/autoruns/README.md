Guide to use autoruns
1) Press the Windows key, type Create a restore point, and open it. Select your C: drive, click Configure to ensure protection is turned on, then click Create and name it something like "Before Autoruns".
Verification: A confirmation dialog states that the restore point was created successfully.
2) Open Terminal and type "winget install Microsoft.Sysinternals.Autoruns" to install auto runs.
Verification: At the bottom of output "Successfully installed" is displayed
2.1).Run Autoruns as Administrator and Save a Baseline:1 min.Right-click Autoruns64.exe and select Run as administrator. Wait for the bottom-left status bar to say Ready, then click File - Save and save a .arn backup file to your Desktop.Verification: The title bar shows (Administrator) and your .arn baseline file appears on the Desktop.
3.Hide Microsoft and Windows Entries:1 min.Click Options - Scan Options in the top menu. Check Hide Microsoft entries, Hide Windows entries, and Verify code signatures, then click Rescan.Verification: The list shrinks dramatically, showing only third-party software and drivers.
4.Trim the Logon Tab:3 min.Switch to the Logon tab. Uncheck apps you do not need immediately at startup—such as game launchers (Steam, Epic), chat apps (Discord, Teams), cloud updaters, and printer utilities. Also uncheck any yellow (File not found) rows.Verification: Only essential utilities (like your touchpad driver, audio manager, or password manager) remain checked.
5.Disable Bloat in Scheduled Tasks:2 min.Switch to the Scheduled Tasks tab. Look for third-party auto-updaters (Adobe, Google, Java, or laptop manufacturer telemetry tools) and uncheck them. Leave antivirus and backup tasks alone.Verification: Unnecessary background updaters are unchecked without touching any security tools.
6.Check Third-Party Services (Optional):2 min.Switch to the Services tab. Only uncheck services you clearly recognize as optional (such as RGB lighting controllers or vendor bloatware). Skip anything related to Intel, AMD, NVIDIA, Realtek, Wi-Fi, or security software.Verification: Every unchecked service is a recognized non-essential app.
7.Reboot and Verify Boot Time:2 min.Restart your laptop. Once on the desktop, press Ctrl + Shift + Esc to open Task Manager, go to the Startup apps tab, and check Last BIOS time in the top-right corner, while noting how quickly your desktop becomes responsive.Verification: Windows boots normally, all essential hardware (Wi-Fi, audio, touchpad) works, and the desktop becomes usable noticeably faster.


Alt:

2. Alternative: Run Without Installing (PowerShell)

If winget isn't available or you don't want to install anything permanently, run this in PowerShell to download, extract, and launch it in one go:
powershell
Invoke-WebRequest -Uri "https://sysinternals.com" -OutFile "$env:TEMP\Autoruns.zip"; Expand-Archive "$env:TEMP\Autoruns.zip" -DestinationPath "$env:TEMP\Autoruns" -Force; Start-Process "$env:TEMP\Autoruns\Autoruns64.exe" -Verb RunAs
Используйте код с осторожностью.

3. Alternative: Command-Line Only (autorunsc)

If you want to view startup items directly inside the terminal text output rather than opening the graphical window, run:
powershell
autorunsc64 -a * -c -h -s -v
Используйте код с осторожностью.
• -a * scans all categories.
• -h checks file hashes.
• -s verifies digital signatures.
• -v checks VirusTotal.

