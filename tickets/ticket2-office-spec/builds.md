# Office Workstation Builds (`tickets/ticket2-office-spec/builds.md`)

All four builds are designed from the **AMD AM5** socket with **DDR5** memory and **PCIe 4.0 M.2 NVMe** storage so every workstation has a 3-to-5-year upgrade path without replacing the motherboard or CPU.

---

### Build 1 — Accountant
**Load:** Runs **1C:Enterprise**, 5–10 multi-sheet MS Excel workbooks, Adobe PDF readers, Chrome, and Kazakhstan banking/tax portals (NCALayer) simultaneously for 8 hours a day.
**Bottleneck:** Single-core responsiveness and memory headroom (16 GB so 1C + Excel never swap to disk), paired with a full-size keyboard with a dedicated numpad—not 3D graphics or multi-core compilation.
**Trade-off:** Chose the 6-core **AMD Ryzen 5 7600 BOX** (`115,304 KZT`, using its integrated Radeon Graphics and bundled Wraith Stealth cooler) and a **1×16 GB DDR5-5200** module (`122,990 KZT`) on an **MSI PRO A620M-E** (`99,997 KZT`).
* **Alternatives NOT taken:** Did **not** buy a discrete GPU (`289,590 KZT` saved), a 32 GB DDR5 kit (`160,000 KZT` saved), or a B650 motherboard (`10,002 KZT` saved), because 1C and Excel are single-thread/memory-bound and idle on a discrete GPU. Because the A620M-E has two DIMM slots, installing 1×16 GB leaves one slot free for a drop-in 32 GB upgrade later.
**Compatibility Check:** AM5 CPU ↔ AM5 A620M-E socket · DDR5-5200 UDIMM ↔ DDR5 board · M.2 PCIe 4.0 NVMe ↔ M.2 slot · ~134W peak draw ↔ 500W DeepCool PF500D-HA PSU (mATX case fitment verified).
**Total:** **568,251 KZT** (`budget.csv`, rows 2–10)

---

### Build 2 — Sales Manager
**Load:** Cloud CRM in Chrome, 30–40 open browser tabs, Excel price lists, and 3–4 hours of daily video calls (Zoom/Meet/Teams) at once.
**Bottleneck:** **Memory (RAM)**, not CPU. Forty browser tabs plus active video conferencing consume ~11–12 GB of RAM; on 8 GB Windows immediately starts swapping mid-call.
**Trade-off:** Kept the 6-core **AMD Ryzen 5 7600 BOX** with integrated graphics (`115,304 KZT`) and settled on **16 GB (1×16 GB) DDR5-5200** (`122,990 KZT`) instead of 32 GB (`282,990 KZT`).
* **Alternatives NOT taken:** Did **not** upgrade to an 8-core Ryzen 7 + tower cooler (`+115,596 KZT` vs. `115,304 KZT` BOX) or a discrete GPU (`289,590 KZT` saved), and gave up the **32 GB DDR5-5600 kit** (`160,000 KZT` saved) so the Web Developer could get 32 GB for containers and the Designer could get a dedicated GPU + calibrated display within the 3,000,000 KZT ceiling. The second DIMM slot on the A620M-E stays open for an easy 32 GB expansion.
**Compatibility Check:** AM5 CPU ↔ AM5 A620M-E socket · DDR5-5200 UDIMM ↔ DDR5 board · M.2 PCIe 4.0 NVMe ↔ M.2 slot · ~134W peak draw ↔ 500W DeepCool PF500D-HA PSU.
**Total:** **568,251 KZT** (`budget.csv`, rows 12–20)

---

### Build 3 — Web Developer
**Load:** Docker containers, local PostgreSQL/Redis databases, VS Code / JetBrains IDEs, live build watchers, and multiple test browsers running concurrently for 8 hours a day.
**Bottleneck:** **RAM capacity (32 GB) and multi-core CPU throughput**, backed by fast PCIe 4.0 NVMe I/O for container builds and a durable tactile keyboard for heavy daily typing.
**Trade-off:** Replaced Windows 11 with **Ubuntu 24.04 LTS** (`0 KZT`, legally licensed under open-source/Canonical commercial terms, running Docker natively without WSL2 virtualization overhead) and skipped a discrete GPU.
* **Alternatives NOT taken:** Did **not** buy a Windows 11 Home license (`46,800 KZT` saved) or a discrete GPU (`289,590 KZT` saved), redirecting that budget into an **8-core / 16-thread Ryzen 7 7700 OEM** (`100,990 KZT`) + **DeepCool AG400** tower cooler (`14,606 KZT`), a **4-slot MSI PRO B650M-P** (`109,999 KZT`), **32 GB (2×16 GB) DDR5-5600** (`282,990 KZT`), and a **Keychron C3 Pro** mechanical keyboard (`40,630 KZT`) instead of a `9,990 KZT` membrane combo.
**Compatibility Check:** AM5 CPU ↔ AM5 B650M-P socket · 2×16 GB DDR5-5600 ↔ 4-slot DDR5 board · M.2 PCIe 4.0 NVMe ↔ 2× M.2 slots · ~148W peak draw ↔ 500W DeepCool PF500D-HA PSU.
**Total:** **726,075 KZT** (`budget.csv`, rows 22–32)

---

### Build 4 — Designer
**Load:** Adobe Photoshop, Illustrator, and Figma with multi-layered canvases, vector exports, and client presentation mockups for 8 hours a day.
**Bottleneck:** **Display color accuracy (factory-calibrated 27" QHD 100% sRGB IPS)** and **discrete GPU hardware acceleration** for smooth canvas zooming, rendering, and GPU-accelerated filters.
**Trade-off:** Selected the 6-core **AMD Ryzen 5 7600 BOX** (`115,304 KZT`) and started with **16 GB (1×16 GB) DDR5-5200** (`122,990 KZT`) instead of 32 GB (`160,000 KZT` saved) so the budget could fund the **ASUS ProArt PA278QV** (`188,750 KZT`), an **MSI GeForce RTX 3060 12 GB** (`289,590 KZT`), and a **DeepCool PK600D 600W** PSU (`49,999 KZT`).
* **Alternatives NOT taken:** Did **not** buy a 23.8" budget IPS monitor (`49,990 KZT` — uncalibrated color and low 1080p pixel density hurt UI/print accuracy), did **not** buy an 8-core Ryzen 7 (2D Photoshop/Figma relies on single-core burst speed and GPU acceleration), and chose the **RTX 3060 12 GB** over a non-Ti **RTX 4060 8 GB** because non-Ti RTX 4060 cards were out of stock at local Kazakhstan vendors on `2026-11-24`. Three empty DIMM slots on the B650M-P make upgrading to 32 GB trivial later.
**Compatibility Check:** AM5 CPU ↔ AM5 B650M-P socket · DDR5-5200 UDIMM ↔ 4-slot DDR5 board · M.2 PCIe 4.0 NVMe ↔ M.2 slot · ~314W peak draw (with RTX 3060) ↔ 600W 80+ Bronze DeepCool PK600D PSU.
**Total:** **1,035,612 KZT** (`budget.csv`, rows 34–43)

---

### Grand Total Summary
* **Accountant:** `568,251 KZT`
* **Sales Manager:** `568,251 KZT`
* **Web Developer:** `726,075 KZT`
* **Designer:** `1,035,612 KZT`
* **Grand Total:** **2,898,189 KZT** (`101,811 KZT` under the `3,000,000 KZT` cap)
