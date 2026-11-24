# Ticket 2 — Kitting out the new office

## 1. What was asked
From: Daniyar K. (Director)
Subject: computers for the new office

We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included.

## 2. What was actually needed

### Why four identical machines is the wrong approach
Daniyar is wrong to buy four identical computers. Splitting 3,000,000 KZT evenly (~750,000 KZT per desk) wastes money on dedicated GPUs and color-calibrated monitors for the accountant and sales manager, while leaving the web developer short on RAM and the designer stuck with an inaccurate office panel. Matching hardware to daily bottlenecks puts the budget where work actually slows down.

### Daily workloads and primary bottlenecks
* **Accountant (Light compute, high reliability & input ergonomics):** Runs **1C:Enterprise**, multi-tab Excel workbooks, PDF readers, and Kazakhstan banking/tax portals (NCALayer) for 8 hours a day. **Bottleneck:** Single-core responsiveness, RAM headroom (16 GB minimum so 1C + Excel never swap), and screen space for wide ledger tables—not 3D graphics. Requires a full-size keyboard with a dedicated numpad.
* **Sales Manager (Light compute, heavy multitasking):** Runs a web CRM, 30–40 browser tabs, spreadsheets, and 3–4 hours of daily video calls simultaneously. **Bottleneck:** **Memory (RAM)**, not CPU. Browser tabs plus video conferencing consume 12+ GB; jumping straight to 32 GB prevents system lag mid-call.
* **Web Developer (Heavy compute & I/O, workstation ergonomics):** Runs Docker containers, local databases, an IDE (VS Code / JetBrains), local build servers, and multiple browsers concurrently. **Bottleneck:** **RAM capacity (32 GB) and multi-core CPU speed**, backed by fast NVMe storage for container builds and a reliable, comfortable keyboard for heavy daily typing.
* **Designer (Graphics & display-bound):** Works in Adobe Photoshop, Illustrator, and Figma with large layered files and high-resolution exports. **Bottleneck:** **Display color accuracy (IPS panel with ~100% sRGB coverage) and GPU acceleration**, followed by RAM and fast scratch storage so zooming, rendering, and canvas panning stay smooth.

### What the 3,000,000 KZT request left out
"Monitors included" still leaves critical day-one items unmentioned:
* **Operating system licenses:** Windows licenses are expensive and must be budgeted explicitly.
* **Peripherals:** Keyboards (numpad for accounting, durable tactile typing layout for the developer), mice, and a webcam/headset for the sales manager's calls.
* **Power & connectivity:** Surge protectors (and a basic UPS for the accountant so power blips do not corrupt local 1C databases), display cables (if not bundled with monitors), and Ethernet patch cables.

### Defining "last a few years" (Platform & Upgrade Path)
"A few years" in an office means a **3-to-5-year service life**. Buying into an end-of-life socket or filling all RAM slots on day one forces full motherboard/memory replacements later. Every build uses a current platform (**AMD AM5 with DDR5**, or **Intel LGA1700 with DDR5** on budget tiers) with **two open DIMM slots** and a spare M.2 slot so RAM or storage can be doubled in 18–24 months without replacing the machine.

### Software & Operating System requirements
* **Accountant:** Requires **Windows 11** for native 1C:Enterprise client compatibility, MS Excel macros, and Kazakhstan government/bank cryptographic software (NCALayer).
* **Sales Manager:** Requires **Windows 11** for MS Office and standard corporate call/CRM tools.
* **Designer:** Requires **Windows 11** for Adobe Creative Cloud (Photoshop/Illustrator).
* **Web Developer:** Runs **Ubuntu Linux 24.04 LTS**—legally licensed for commercial office use under open-source/Canonical terms at 0 KZT, running Docker natively without virtualization overhead and freeing ~60,000–80,000 KZT for CPU/RAM hardware.

### Questions for Daniyar vs. Assumptions Made

| What I would ask Daniyar | What I assumed instead to build the quote |
| :--- | :--- |
| Does the 3,000,000 KZT cap include OS licenses, keyboards, mice, and UPS/surge protection, or only towers + monitors? | The 3,000,000 KZT is a **hard all-in ceiling** covering all 4 towers, 4 monitors, OS licenses, and basic input peripherals. |
| Does the designer edit 4K video/3D renders, or strictly 2D web/print graphics (Figma, Photoshop, Illustrator)? | The designer handles **2D raster/vector assets and UI design**, needing a color-accurate 27" IPS monitor and an entry-level discrete GPU rather than a high-end 3D rendering card. |
| Is the company comfortable with the web developer running Linux, or does IT policy require Windows across all four desks? | **Ubuntu Linux LTS** is acceptable for the web developer (saving one Windows license), while the other three roles get **licensed Windows 11**. |
| Will the new office use wired Ethernet or Wi-Fi, and how often do power outages occur? | Desks have wired Ethernet (eliminating Wi-Fi card costs), and the accountant needs a basic **UPS** to protect 1C data. |
| Are all four hires starting on Day 1, or is one role staggered? | All four machines must be purchased and ready before the office opens. |

## 3. What I did
(How you went from roles to loads to parts; the budget; links to builds.md and budget.csv.
Then the three answers below.)

## 4. Evidence
(Links to evidence/ with one line each on what that file proves.)

## 5. What I would do differently
(At least one specific thing.)
