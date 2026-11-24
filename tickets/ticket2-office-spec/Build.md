# Office Workstation Builds (`tickets/ticket2-office-spec/builds.md`)

All four workstations use the **AMD AM5** platform with **DDR5** memory and **PCIe 4.0 M.2 NVMe** storage so every machine can be upgraded in place over a 3-to-5-year office lifecycle without replacing the motherboard or CPU.

---

### Build 1 — Accountant
**Load:** Runs **1C:Enterprise**, 5–10 multi-sheet MS Excel workbooks, PDF readers, Chrome, and Kazakhstan banking/tax portals (NCALayer) for 8 hours a day.
**Bottleneck:** Single-core responsiveness, RAM capacity (at least 16 GB so 1C and Excel never swap to disk), and fast full-size numpad data entry—not 3D graphics.
**Trade-off:** Used the CPU's integrated AMD Radeon Graphics instead of a discrete GPU (saving `289,590 KZT`) and installed a single **16 GB DDR5-5200** stick instead of a 32 GB kit (saving `160,000 KZT`). Because the MSI PRO A620M-E motherboard has two DIMM slots, one slot stays empty for a drop-in 32 GB upgrade later.
**Parts & Compatibility:**
* **CPU:** AMD Ryzen 5 7600 BOX (AM5, 6 cores / 12 threads, includes Wraith Stealth cooler & integrated Radeon Graphics) — `115,304 KZT`
* **Motherboard:** MSI PRO A620M-E (AM5, DDR5, 2× DIMM, 1× M.2) — `99,997 KZT`
* **Memory:** AMD Radeon R5 Entertainment Series 16 GB (1×16 GB) DDR5-5200 — `122,990 KZT`
* **Storage:** Kingston NV3 1 TB M.2 PCIe 4.0 NVMe — `85,990 KZT`
* **PSU:** DeepCool PF500D-HA 500W — `20,990 KZT`
* **Case:** DeepCool Matrexx 30 Black (mATX) — `16,200 KZT`
* **Monitor:** Acer EK241YP6bi 23.8" IPS (1920×1080, 144Hz) — `49,990 KZT`
* **OS:** Microsoft Windows 11 Home 64-bit — `46,800 KZT`
* **Peripherals:** Logitech Desktop MK120 Combo (full-size keyboard with numpad + mouse) — `9,990 KZT`
**Total:** **568,251 KZT** (`budget.csv`, rows 2–10)

---

### Build 2 — Sales Manager
**Load:** Cloud CRM in Chrome, 30–40 open browser tabs, Excel price lists, and 3–4 hours of daily video calls simultaneously.
**Bottleneck:** **Memory (RAM)**, not CPU. Forty browser tabs plus video conferencing consume ~11–12 GB of RAM; anything under 16 GB triggers heavy disk swapping mid-call.
**Trade-off:** Kept the 6-core AMD Ryzen 5 7600 with integrated graphics instead of buying a Ryzen 7 or discrete GPU, and settled on **16 GB (1×16 GB) DDR5-5200** rather than a 32 GB kit (`160,000 KZT` saved) so the Web Developer could get 32 GB and the Designer could get a dedicated GPU within the 3,000,000 KZT cap. The open DIMM slot allows a simple 32 GB upgrade later.
**Parts & Compatibility:**
* **CPU:** AMD Ryzen 5 7600 BOX (AM5, includes Wraith Stealth cooler & integrated Radeon Graphics) — `115,304 KZT`
* **Motherboard:** MSI PRO A620M-E (AM5, DDR5, 2× DIMM, 1× M.2) — `99,997 KZT`
* **Memory:** AMD Radeon R5 Entertainment Series 16 GB (1×16 GB) DDR5-5200 — `122,990 KZT`
* **Storage:** Kingston NV3 1 TB M.2 PCIe 4.0 NVMe — `85,990 KZT`
* **PSU:** DeepCool PF500D-HA 500W — `20,990 KZT`
* **Case:** DeepCool Matrexx 30 Black (mATX) — `16,200 KZT`
* **Monitor:** Acer EK241YP6bi 23.8" IPS (1920×1080, 144Hz) — `49,990 KZT`
* **OS:** Microsoft Windows 11 Home 64-bit — `46,800 KZT`
* **Peripherals:** Logitech Desktop MK120 Combo — `9,990 KZT`
**Total:** **568,251 KZT** (`budget.csv`, rows 12–20)

---

### Build 3 — Web Developer
**Load:** Docker containers, local PostgreSQL/Redis databases, VS Code / JetBrains IDEs, local build watchers, and multiple test browsers running concurrently for 8 hours a day.
**Bottleneck:** **RAM capacity (32 GB) and multi-core CPU throughput**, backed by fast NVMe storage for container builds and a durable tactile keyboard for heavy daily typing.
**Trade-off:** Replaced Windows 11 with **Ubuntu 24.04 LTS** (`0 KZT`, legally licensed under open-source/Canonical commercial terms, running Docker natively without virtualization overhead) and skipped a discrete GPU. Redirecting those savings funded an **8-core Ryzen 7 7700**, a **DeepCool AG400** tower cooler, a **4-slot MSI PRO B650M-P** motherboard, **32 GB (2×16 GB) DDR5-5600**, and a **Keychron C3 Pro** mechanical keyboard.
**Parts & Compatibility:**
* **CPU:** AMD Ryzen 7 7700 OEM (AM5, 8 cores / 16 threads, integrated Radeon Graphics) — `100,990 KZT`
* **Cooler:** DeepCool AG400 — `14,606 KZT`
* **Motherboard:** MSI PRO B650M-P (AM5, DDR5, 4× DIMM, 2× M.2) — `109,999 KZT`
* **Memory:** AMD Radeon R5 Gamer 32 GB (2×16 GB) DDR5-5600 — `282,990 KZT`
* **Storage:** Kingston NV3 1 TB M.2 PCIe 4.0 NVMe — `85,990 KZT`
* **PSU:** DeepCool PF500D-HA 500W — `20,990 KZT`
* **Case:** DeepCool Matrexx 30 Black (mATX) — `16,200 KZT`
* **Monitor:** Acer EK241YP6bi 23.8" IPS (1920×1080, 144Hz) — `49,990 KZT`
* **OS:** Ubuntu 24.04 LTS (Open-Source Commercial License) — `0 KZT`
* **Keyboard:** Keychron C3 Pro Wired Mechanical — `40,630 KZT`
* **Mouse:** Logitech B100 Black USB — `3,690 KZT`
**Total:** **726,075 KZT** (`budget.csv`, rows 22–32)

---

### Build 4 — Designer
**Load:** Adobe Photoshop, Illustrator, and Figma with large layered canvases, vector exports, and client presentation mockups for 8 hours a day.
**Bottleneck:** **Display color accuracy (factory-calibrated 27" QHD 100% sRGB IPS)** and **discrete GPU hardware acceleration** for smooth canvas zooming, rendering, and filtering.
**Trade-off:** Selected the 6-core Ryzen 5 7600 instead of a Ryzen 7 and started with **16 GB (1×16 GB) DDR5-5200** instead of 32 GB (`160,000 KZT` saved) so the budget could fund the **ASUS ProArt PA278QV** (`188,750 KZT`), an **MSI GeForce RTX 3060 12 GB** (`289,590 KZT`, chosen because non-Ti RTX 4060 8 GB cards were out of stock locally), and a **600W 80+ Bronze PSU**. Three empty DIMM slots on the B650M-P make upgrading to 32 GB trivial later.
**Parts & Compatibility:**
* **CPU:** AMD Ryzen 5 7600 BOX (AM5, includes Wraith Stealth cooler) — `115,304 KZT`
* **Motherboard:** MSI PRO B650M-P (AM5, DDR5, 4× DIMM, 2× M.2) — `109,999 KZT`
* **Memory:** AMD Radeon R5 Entertainment Series 16 GB (1×16 GB) DDR5-5200 — `122,990 KZT`
* **Storage:** Kingston NV3 1 TB M.2 PCIe 4.0 NVMe — `85,990 KZT`
* **GPU:** MSI GeForce RTX 3060 Ventus 2X 12 GB — `289,590 KZT`
* **PSU:** DeepCool PK600D 600W 80+ Bronze — `49,999 KZT`
* **Case:** DeepCool Matrexx 30 Black (mATX) — `16,200 KZT`
* **Monitor:** ASUS ProArt PA278QV 27" QHD (2560×1440) IPS, 100% sRGB — `188,750 KZT`
* **OS:** Microsoft Windows 11 Home 64-bit — `46,800 KZT`
* **Peripherals:** Logitech Desktop MK120 Combo — `9,990 KZT`
**Total:** **1,035,612 KZT** (`budget.csv`, rows 34–43)

---

### Grand Total Summary
* **Accountant:** `568,251 KZT`
* **Sales Manager:** `568,251 KZT`
* **Web Developer:** `726,075 KZT`
* **Designer:** `1,035,612 KZT`
* **Grand Total:** **2,898,189 KZT** (`101,811 KZT` under the `3,000,000 KZT` budget cap)
