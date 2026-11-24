# Ticket 2 — Kitting out the new office

## 1. What was asked

> **From:** Daniyar K. (Director)  
> **Subject:** computers for the new office  
>  
> We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included.

---

## 2. What was actually needed

### Why four identical machines is wrong
Daniyar is right to question buying four identical computers. Splitting 3,000,000 KZT evenly (~750,000 KZT per desk) wastes money on discrete graphics cards and color-calibrated monitors for the accountant and sales manager, while leaving the web developer short on RAM for containers and the designer stuck with an uncalibrated office panel. Matching each machine to its daily workload puts the money where work actually bottlenecks.

### Daily workloads and bottlenecks
* **Accountant:** Runs **1C:Enterprise**, multi-sheet MS Excel workbooks, PDF readers, and Kazakhstan banking/tax portals (NCALayer) for 8 hours/day. **Bottleneck:** Single-core responsiveness, RAM capacity (16 GB so 1C + Excel never swap), and a full-size keyboard with a dedicated numpad—not 3D graphics.
* **Sales Manager:** Runs a cloud CRM, 30–40 browser tabs, spreadsheets, and 3–4 hours of daily video calls simultaneously. **Bottleneck:** **Memory (RAM)**, not CPU; browser tabs plus video conferencing consume ~11–12 GB and cause swap lag on 8 GB systems.
* **Web Developer:** Runs Docker containers, local databases, VS Code / JetBrains IDEs, build watchers, and multiple browsers concurrently. **Bottleneck:** **RAM capacity (32 GB) and multi-core CPU throughput**, backed by fast NVMe I/O and a durable mechanical keyboard for heavy daily typing.
* **Designer:** Works in Adobe Photoshop, Illustrator, and Figma with large layered canvases and client presentation mockups. **Bottleneck:** **Display color accuracy (27" QHD 100% sRGB IPS)** and **discrete GPU hardware acceleration** so zooming, filtering, and canvas panning stay smooth.

### What the request left out
"Monitors included" still omits critical day-one items needed for working desks:
* **Operating system licenses** (Windows 11 licenses must be priced explicitly).
* **Input peripherals:** Keyboards (numpad for the accountant, durable mechanical keyboard for the developer) and mice.
* **Office power & network accessories:** Surge protectors (and a small UPS for the accountant to protect local 1C databases from power drops), plus Ethernet patch cables.

### What "last a few years" means for the platform
In an office environment, "a few years" means a **3-to-5-year service life**. Every build uses the current **AMD AM5 socket with DDR5 memory** and leaves **empty DIMM slots** (1 free slot on the A620M boards; 2–3 free slots on the B650M boards) so RAM or storage can be expanded later without replacing motherboards or CPUs.

### Software & Operating System requirements
* **Accountant, Sales Manager, Designer:** Require **Windows 11** for 1C:Enterprise, NCALayer banking certificates, MS Office, and Adobe Creative Cloud.
* **Web Developer:** Uses **Ubuntu 24.04 LTS** (`0 KZT`), which is legally licensed for commercial use under open-source/Canonical terms, runs Docker containers natively without virtualization overhead, and frees `46,800 KZT` for developer hardware.

### What I would ask Daniyar vs. What I assumed instead

| What I would ask Daniyar | What I assumed instead |
| :--- | :--- |
| Does the 3,000,000 KZT ceiling include OS licenses, keyboards, mice, and surge protectors/UPS, or only towers + monitors? | The 3,000,000 KZT budget is a **hard all-in ceiling** covering all 4 towers, 4 monitors, licensed OSes, and keyboards/mice (leaving `101,811 KZT` headroom for patch cables/surge strips). |
| Does the designer do 3D/4K video rendering, or 2D UI/graphic design and client image presentations? | The designer focuses on **2D graphic/UI design and image presentations**, prioritizing a factory-calibrated 27" QHD 100% sRGB monitor and a mid-range RTX card over a workstation Quadro GPU. |
| Is Ubuntu Linux approved for the web developer, or does company policy mandate Windows on all four PCs? | **Ubuntu 24.04 LTS** is approved for the web developer, while the other three desks receive licensed **Windows 11 Home**. |
| Will the desks connect via wired Ethernet or Wi-Fi? | Desks use wired office Ethernet, avoiding extra Wi-Fi adapter costs on mATX boards. |

---

## 3. What I did

### Hard Requirements & Sourcing Compliance
Every workstation meets all mandatory baseline rules:
* **Memory:** ≥ 16 GB DDR5 on every machine (`16 GB` on Accountant, Sales, and Designer; `32 GB` on Web Developer).
* **Storage:** Every build includes a **1 TB Kingston NV3 M.2 PCIe 4.0 NVMe SSD**.
* **Operating System:** Licensed OS on every desk—three priced **Microsoft Windows 11 Home 64-bit** licenses (`46,800 KZT` each) and **Ubuntu 24.04 LTS** (`0 KZT`, commercially licensed open-source) for the Web Developer.
* **Monitors:** One IPS monitor priced per desk (`Acer EK241YP6bi 23.8" IPS` for Accountant, Sales, and Developer; `ASUS ProArt PA278QV 27" QHD IPS` for Designer).
* **Kazakhstan Pricing & Dates:** Every price was collected in **KZT** on **`2026-11-24`** from vendors delivering locally in Kazakhstan (`Kaspi.kz`, `Shop.kz / Белый Ветер`, `DNS / dns-shop.kz`).

Full component reasoning is in [builds.md](builds.md), and the itemized UTF-8 ledger (`2,898,189 KZT` grand total) is in [budget.csv](budget.csv).

### Answers to the Director's Three Questions

1. **Which of the four machines will you upgrade first, eighteen months from now, and why?**  
   The **Sales Manager's workstation** will be upgraded first by adding an extra **16 GB AMD Radeon R5 DDR5-5200 stick** into the open slot on the MSI PRO A620M-E motherboard (or replacing it with a matched **2×16 GB DDR5-5600 dual-channel kit**). Because the Sales Manager runs 30–40 browser tabs, cloud CRM, Excel, and daily video calls simultaneously, the current single-stick 16 GB configuration restricts both total capacity and **memory bandwidth** in single-channel mode—unlocking **dual-channel mode** at 32 GB removes that bottleneck immediately without touching the CPU or motherboard.

2. **Price the same four as pre-built machines from a vendor. What does the company gain and lose by not building them?**  
   Comparable off-the-shelf towers priced on `2026-11-24` (recorded in [budget.csv](budget.csv), rows 45–49) cost **`2,082,320 KZT` for the towers alone**, and **`2,605,760 KZT`** once you add the missing monitors, three Windows 11 Home licenses, and developer keyboard/mouse:
   * *Accountant pre-built:* **HP OmniDesk Desktop M02-0016ci** (`539,990 KZT`, Shop.kz) — comes with only a **512 GB SSD** (missing the 1 TB requirement) and no OS.
   * *Sales pre-built:* **MSI PRO DP180 AI** (`352,050 KZT`, DNS) — uses an entry Intel H810 board, **512 GB SSD**, and no OS.
   * *Web Developer pre-built:* **DEXP Mars G021** (`578,590 KZT`, DNS) — Ryzen 7 8700G, 32 GB DDR5, 1 TB SSD, B650, no OS.
   * *Designer pre-built:* **ARDOR GAMING NEO M256** (`611,690 KZT`, DNS) — Ryzen 5 7500F, 16 GB DDR5, 1 TB SSD, RTX 5060 8 GB, 500W PSU, no OS.  
   By buying pre-builts, the company **gains** a single-vendor warranty, zero assembly time, and store-level tech support, and some pre-built SKUs pack stronger raw CPUs/GPUs on paper. However, the company **loses** part-level control and still pays extra to match our office requirements: pre-installed single-stick/OEM memory kits often lack **dual-channel bandwidth**, lower speeds, or matched upgrade compatibility (forcing us to discard or ignore the pre-integrated sticks when upgrading), two units fall short on storage (512 GB vs. 1 TB), and OS/monitor extras drive the true all-in cost right back up.

3. **One of these four people will complain about performance within a month. Which one, and about what?**  
   The **Sales Manager** will not be too enthusiastic about the **tight memory headroom** within the first month—specifically complaining about **background Chrome tabs reloading, sluggish switching between CRM and Excel, and brief stutters during screen-sharing calls** when 35–40 tabs are open at once. Because high DDR5 prices (`282,990 KZT` for 32 GB vs. `122,990 KZT` for 16 GB) forced the Sales build down to a single 16 GB stick to stay within the 3,000,000 KZT ceiling, Windows has very little free RAM headroom and begins compressing memory and swapping idle tabs to the NVMe SSD during peak multitasking.

---

## 4. Evidence

* [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md) — Verified socket, DDR5, M.2, and wattage compatibility lists for all four builds on PCPartPicker.
* `evidence/vendor-quotes/shared-cpu-r5.png` — Kaspi.kz quote (`2026-11-24`) for AMD Ryzen 5 7600 BOX (`115,304 KZT`, Accountant/Sales/Designer).
* `evidence/vendor-quotes/dev-cpu.png` — Shop.kz quote (`2026-11-24`) for AMD Ryzen 7 7700 OEM (`100,990 KZT`, Developer).
* `evidence/vendor-quotes/dev-cooler.png` — Kaspi.kz quote (`2026-11-24`) for DeepCool AG400 cooler (`14,606 KZT`, Developer).
* `evidence/vendor-quotes/shared-mobo-a620.png` — Kaspi.kz quote (`2026-11-24`) for MSI PRO A620M-E (`99,997 KZT`, Accountant/Sales).
* `evidence/vendor-quotes/shared-mobo-b650.png` — Kaspi.kz quote (`2026-11-24`) for MSI PRO B650M-P (`109,999 KZT`, Developer/Designer).
* `evidence/vendor-quotes/accountant-memory.png` — Shop.kz quote (`2026-11-24`) for AMD Radeon R5 16 GB DDR5-5200 (`122,990 KZT`, Accountant/Sales/Designer).
* `evidence/vendor-quotes/shared-memory-32gb.png` — Shop.kz quote (`2026-11-24`) for AMD Radeon R5 32 GB (2×16 GB) DDR5-5600 (`282,990 KZT`, Developer).
* `evidence/vendor-quotes/shared-ssd.png` — Shop.kz quote (`2026-11-24`) for Kingston NV3 1 TB M.2 PCIe 4.0 NVMe (`85,990 KZT`, all 4 builds).
* `evidence/vendor-quotes/designer-gpu.png` — Shop.kz quote (`2026-11-24`) for MSI GeForce RTX 3060 Ventus 2X 12 GB (`289,590 KZT`, Designer).
* `evidence/vendor-quotes/shared-psu-500w.png` — Shop.kz quote (`2026-11-24`) for DeepCool PF500D-HA 500W (`20,990 KZT`, Accountant/Sales/Developer).
* `evidence/vendor-quotes/designer-psu.png` — Kaspi.kz quote (`2026-11-24`) for DeepCool PK600D 600W (`49,999 KZT`, Designer).
* `evidence/vendor-quotes/shared-case.png` — Shop.kz quote (`2026-11-24`) for DeepCool Matrexx 30 Black (`16,200 KZT`, all 4 builds).
* `evidence/vendor-quotes/shared-monitor-24.png` — Shop.kz quote (`2026-11-24`) for Acer EK241YP6bi 23.8" IPS (`49,990 KZT`, Accountant/Sales/Developer).
* `evidence/vendor-quotes/designer-monitor.png` — Kaspi.kz quote (`2026-11-24`) for ASUS ProArt PA278QV 27" QHD IPS (`188,750 KZT`, Designer).
* `evidence/vendor-quotes/shared-win11-home.png` — Kaspi.kz quote (`2026-11-24`) for Microsoft Windows 11 Home 64-bit (`46,800 KZT`, Accountant/Sales/Designer).
* `evidence/vendor-quotes/shared-peripherals-mk120.png` — Kaspi.kz quote (`2026-11-24`) for Logitech Desktop MK120 combo (`9,990 KZT`, Accountant/Sales/Designer).
* `evidence/vendor-quotes/dev-keyboard.png` — DNS quote (`2026-11-24`) for Keychron C3 Pro Wired Mechanical Keyboard (`40,630 KZT`, Developer).
* `evidence/vendor-quotes/dev-mouse.png` — Shop.kz quote (`2026-11-24`) for Logitech B100 Mouse (`3,690 KZT`, Developer).
* `evidence/vendor-quotes/prebuilt-accountant.png` — Shop.kz quote (`2026-11-24`) for HP OmniDesk Desktop M02-0016ci pre-built (`539,990 KZT`).
* `evidence/vendor-quotes/prebuilt-sales.png` — DNS quote (`2026-11-24`) for MSI PRO DP180 AI pre-built (`352,050 KZT`).
* `evidence/vendor-quotes/prebuilt-dev.png` — DNS quote (`2026-11-24`) for DEXP Mars G021 pre-built (`578,590 KZT`).
* `evidence/vendor-quotes/prebuilt-designer.png` — DNS quote (`2026-11-24`) for ARDOR GAMING NEO M256 pre-built (`611,690 KZT`).

---

## 5. What I would do differently

1. **Choosing more effective graphics adapter:** If I had Nvidia GeForce RTX 4060 available as of seeking video-adapters I would equip it over RTX 3060 since it's less noisy (effective) and is faster. Although, if it's about working on images and montaging short videos - otherwise RTX 3060 with 12GB of VRAM instead of 8GB is good enough
2. **Use the remaining `101,811 KZT` headroom to buy more comfortable, ergonomic displays for the Accountant and Web Developer:** Instead of three budget 23.8" 1080p monitors (`Acer EK241YP6bi`, which have basic tilt-only stands and 144Hz gaming refresh rates unnecessary for office work), **Use the remaining `101,811 KZT` headroom to upgrade all three standard office monitors (`+33,937 KZT` per screen, up to `~83,927 KZT` each):** Instead of three budget 23.8" 250-nit panels (`Acer EK241YP6bi` at `49,990 KZT`, which have tilt-only stands and 144Hz gaming refresh rates unnecessary for office desks), I would reallocate the `101,811 KZT` surplus across the Accountant, Sales Manager, and Web Developer to buy **25-inch IPS office monitors with higher brightness (300+ nits), 100% sRGB color accuracy, and ergonomic height/tilt adjustment**—reducing eye strain and neck fatigue during 8-hour spreadsheet, CRM, and coding shifts.
