# Lab 3 — Teardown, and the same machine from the command line

Pair: <name> + <name> · Date: <date>

## Part 1 — Ten parts
### Processors:
### AMD Ryzen 5 7600
![](evidence/photos/ryzen5-7600.png)
6-core/12-thread AM5 processor, 3.8 GHz base / 5.1 GHz boost, 65 W TDP. Connects to an AM5 socket. Limit: uses DDR5 memory only — incompatible with any DDR4 board. 
Source: (https://www.amd.com/en/products/processors/desktops/ryzen/7000-series/amd-ryzen-5-7600.html)
### Intel Core i5 13400
10-core (6P+4E)/16-thread LGA1700 processor, 2.5–4.6 GHz, 65 W base. Connects to an LGA1700 socket. Limit: needs a board with a BIOS that supports 13th Gen; runs DDR4 or DDR5 depending on the board’s memory slots. 
Source: (https://www.intel.com/content/www/us/en/products/sku/230494/intel-core-i513600kf-processor-24m-cache-up-to-5-10-ghz/specifications.html)

### Motherboard
### ASUS PRIME B650M-A
AM5 motherboard with the B650 chipset, 4 DDR5 slots, 2 M.2 slots (PCIe 5.0 x4 and PCIe 4.0 x4) and 4 SATA ports. Connects an AM5 CPU to DDR5 memory and up to two M.2 drives. Limit: accepts only AM5 processors and DDR5 memory — no DDR4 support.
Source: (https://www.asus.com/motherboards-components/motherboards/prime/prime-b650m-a/)
### MSI PRO B760M-A WIFI DDR4
LGA1700 motherboard with the B760 chipset, 4 DDR4 slots (max 128 GB), 2 M.2 Gen4 x4 slots and 4 SATA ports. Connects an LGA1700 CPU to DDR4 memory and up to two M.2 drives. Limit: accepts only LGA1700 CPUs and DDR4 memory — the i5-13400 needs BIOS 7D99v10 or newer.
Source: (https://www.msi.com/Motherboard/PRO-B760M-A-WIFI-DDR4)

### Memory
### Kingston FURY Beast DDR5-5600, 16 GB (single module)
DDR5 DIMM, 16 GB, rated 5600 MT/s, CL40, Intel XMP profile. Connects to a DDR5 slot on an AM5 board. Limit: a single module runs single-channel; the Ryzen 5 7600 caps two-DIMM speed at 5200 MT/s regardless of the module’s rating.
Source: (https://www.kingston.com/en/memory/gaming/kingston-fury-beast-ddr5-memory)
### Kingston FURY Beast DDR4-3200, 2x16 GB kit (KF432C16BBK2/32)
DDR4 DIMM kit, 32 GB total (2x16 GB), rated 3200 MT/s CL16 under XMP Profile #1; JEDEC default is 2400 MT/s. Connects to two DDR4 slots on an LGA1700 board, running dual-channel. Limit: XMP must be enabled in BIOS to reach 3200; without it, the board defaults to 2400.
Source: (https://www.kingston.com/en/memory/gaming/kingston-fury-beast-ddr4-memory)
### Note: the memory kit above was used as replacement for Crucial DDR4-3200, 16 GB DIMM module. 
Reasoning behind change is in "What went wrong" section.

### SSD module
### Samsung 990 PRO 1 TB
NVMe SSD, 1 TB, M.2 2280 form factor, PCIe 4.0 x4 interface, up to 7,450 MB/s read. Connects to an M.2 PCIe slot. Limit: speed drops to PCIe 3.0 levels (about 3,500 MB/s) if installed in an older PCIe 3.0 slot.
Source: (https://www.samsung.com/sg/memory-storage/nvme-ssd/990-pro-1tb-nvme-pcie-gen-4-mz-v9p1t0bw/)
### Samsung 870 EVO 1 TB
SATA SSD, 1 TB, 2.5-inch form factor, SATA 6 Gb/s interface, up to 560 MB/s read. Connects to a SATA data port plus a SATA power connector. Limit: capped at SATA’s roughly 560 MB/s ceiling regardless of the drive’s internal speed.
Source: (https://www.samsung.com/kz_ru/memory-storage/sata-ssd/870-evo-1tb-sata-3-2-5-ssd-mz-77e1t0bw/)

### Cooling
### AMD Wraith Stealth (cooler)
Stock air cooler bundled with the boxed Ryzen 5 7600, single 92 mm fan, aluminum heatsink, 4-pin PWM connector. Connects to the AM5 socket’s stock mounting bracket. Limit: rated for 65 W TDP chips — not sized for higher-power processors.
Source: no standalone product page on amd.com — cited via the Ryzen 5 7600 page above, which confirms it ships bundled (AMD’s “Processors with Included Cooling Solution” table). Multitronic source as an alternative: (https://www.multitronic.fi/en/products/2634624)
### Intel Laminar RM1 (cooler)
Stock air cooler bundled with the boxed i5-13400, aluminum heatsink with RGB ring, push-pin mount. Connects to the LGA1700 socket’s push-pin holes. Limit: designed for 65 W-class chips; Intel doesn’t bundle it with unlocked (K-series) CPUs that draw more power.
Source: (https://www.intel.com/content/www/us/en/support/articles/000089627/processors.html)

(… one block per part …)

Step 3 — Motherboard table
| Field | ASUS PRIME B650M-A | MSI PRO B760M-A WIFI DDR4 |
|---|---|---|
| **Socket** |  |  |
| **Chipset** |  |  |
| **Memory type / slots** |  |  |
| **Storage (M.2 / SATA)** |  |  |
| **CPU Support list / BIOS** |  |  |
| **Source (maker page link)** |  |  |

## Two builds
### Build 1
| Part | Model | Why it fits here |
### Build 2
| Part | Model | Why it fits here |
What each build still needs: …

## Part 2 — Same facts, three operating systems
<the table>
<2–3 sentences: how the names differ; what the VM showed>

## What did not work the first time
<at least one real thing: what you saw, what it was, what you did>

## Evidence
- evidence/windows-specs.txt — …
- evidence/linux-specs.txt — …
