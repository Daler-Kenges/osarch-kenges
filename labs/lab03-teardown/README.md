# Lab 3 — Teardown, and the same machine from the command line

Pair: Daler (solo work) · Date: 8.11.2026

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
Reasoning behind change is in "What did not work the first time" section.

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
| **Socket** | AM5 | LGA1700 |
| **Chipset** | AMD B650 | Intel B760 |
| **Memory type / slots** | DDR5, 4 DIMM slots | DDR4, 4 DIMM slots, max 128 GB |
| **Storage (M.2 / SATA)** | 2x M.2 (PCIe 5.0 x4 + PCIe 4.0 x4), 4x SATA 6Gb/s | 2x M.2 Gen4 x4, 4x SATA 6Gb/s |
| **CPU Support list / BIOS** | Ryzen 5 7600 confirmed on CPU Support list; minimum BIOS 0602 | i5-13400 confirmed on CPU Support list; minimum BIOS 7D99v10; latest available 7D99v1J |
| **Source (maker page link)** | https://www.asus.com/motherboards-components/motherboards/prime/prime-b650m-a/ | https://www.msi.com/Motherboard/PRO-B760M-A-WIFI-DDR4 |

## Two builds

## Build A — Ryzen 5 7600

| Part | Model | Why it fits here |
|---|---|---|
| CPU | AMD Ryzen 5 7600 | Uses DDR5 memory only |
| Motherboard | ASUS PRIME B650M-A | DDR5-only board, matches the Ryzen 5 7600's DDR5-only memory controller |
| Memory | Kingston FURY Beast DDR5-5600 | Matches the board's DDR5 slots |
| SSD | Samsung 990 PRO 1 TB | PCIe 4.0 NVMe, pairs with the board's PCIe 4.0 M.2 slot |
| Cooler | AMD Wraith Stealth | Bundled with the boxed Ryzen 5 7600 |

## Build B — Intel i5-13400

| Part | Model | Why it fits here |
|---|---|---|
| CPU | Intel Core i5-13400 | LGA1700 socket, supports DDR4 |
| Motherboard | MSI PRO B760M-A WIFI DDR4 | Supports the i5-13400 (CPU Support list) and takes DDR4 memory |
| Memory | Kingston FURY Beast DDR4-3200 | Matches the board's DDR4 slots, confirmed on MSI's memory list |
| SSD | Samsung 870 EVO 1 TB | SATA interface matches the board's SATA ports |
| Cooler | Intel Laminar RM1 | Bundled with the boxed i5-13400 |

## What each build still needs

**Ryzen build:** a case. PSU already assigned (Corsair RM750e).

**Intel build:** a power supply (not yet chosen), a SATA power cable for the 870 EVO (the board includes only the SATA data cable), and a case.

## Part 2 — Same facts, three operating systems
## Windows-specs:
PS C:\Windows\System32> Get-CimInstance Win32_PhysicalMemory | Select DeviceLocator, Capacity, Speed, ConfiguredClockSpeed, SMBIOSMemoryType, FormFactor

DeviceLocator        : DIMM 0
Capacity             : 17179869184
Speed                : 5600
ConfiguredClockSpeed : 4800
SMBIOSMemoryType     : 34
FormFactor           : 12

PS C:\Windows\System32> Get-PhysicalDisk | Select FriendlyName, MediaType, BusType, Size

FriendlyName MediaType BusType Size
------------ --------- ------- ----
KBG60ZNV512G KIOXIA SSD  NVMe    512110190592

PS C:\Windows\System32> Get-Volume C

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining      Size
----------- ------------ ------------- --------- ------------ ----------------- -------------      ----
C                        NTFS          Fixed     Healthy      OK                    117.81 GB 475.88 GB

PS C:\Windows\System32> $env:PROCESSOR_ARCHITECTURE
AMD64



## What did not work the first time
The lab sheet specifies Crucial DDR4-3200, 16 GB DIMM for the Intel build. Micron announced on December 3, 2025 that it was discontinuing the Crucial consumer brand, with retail shipments ending in February 2026 "BOISE, Idaho, Dec. 03, 2025 (GLOBE NEWSWIRE) -- Micron Technology, Inc. (Nasdaq: MU), a leader in innovative memory and storage solutions, today announced its decision to exit the Crucial consumer business, including the sale of Crucial consumer-branded products at key retailers, e-tailers and distributors worldwide.." Since Crucial consumer memory is no longer sold, I substituted the Kingston FURY Beast DDR4-3200, 2x16GB kit (KF432C16BBK2/32), which is confirmed on MSI’s own memory support list for the PRO B760M-A WIFI DDR4 at 3200 MT/s (https://investors.micron.com/news/press-release/2025/Micron-Announces-Exit-from-Crucial-Consumer-Business-12-03-2025/default.aspx). This also fixes the single-module problem in the original sheet — two 16 GB modules give dual-channel operation, which one 16 GB stick would not.

## Evidence
- evidence/windows-specs.txt — …
| Component | Visual Proof |
| :--- | :--- |
| **AMD Ryzen 5 7600** | ![AMD Ryzen 5 7600](evidence/photos/AMD%20Ryzen%205%207600.png) |
| **AMD Wraith Stealth Cooler** | ![AMD Wraith Stealth](evidence/photos/AMD%20Wraith%20Stealth%20Processor%20Air%20Cooler.png) |
| **ASUS PRIME B650M-A** | ![ASUS PRIME B650M-A](evidence/photos/ASUS%20PRIME%20B650M-A.png) |
| **Intel Core i5 13400** | ![Intel Core i5 13400](evidence/photos/Intel%20Core%20i5%2013400.png) |
| **Intel Laminar RM1** | ![Intel Laminar RM1](evidence/photos/Intel%20Laminar%20RM1.png) |
| **Kingston FURY Beast DDR4-3200 (32GB)** | ![Kingston DDR4](evidence/photos/Kingston%20FURY%20Beast%20DDR4-3200%2C%202x16GB%20kit%20KF432C16BBK2_32.png)|
| **Kingston FURY Beast DDR5-5600 (16GB)** | ![Kingston DDR5](evidence/photos/Kingston%20FURY%20Beast%20DDR5-5600%2C%2016%20GB%20%28KF556C40BB-16%29.png) |
| **MSI PRO B760M-A WIFI DDR4** | ![MSI PRO B760M-A](evidence/photos/MSI%20PRO%20B760M-A%20WIFI%20DDR4.png) |
| **Samsung 870 EVO 1 TB** | ![Samsung 870 EVO](evidence/photos/Samsung%20870%20EVO%201%20TB%20%28MZ-77E1T0OW%29.png) |
| **Samsung 990 PRO 1 TB** | ![Samsung 990 PRO](evidence/photos/Samsung%20990%20PRO%201%20TB%20%28MZ-V9P1T0BW%29.png) |

### 📄 Logs & Sources

* [Photo Sources Documentation](evidence/photo-sources.md)
* [Windows Specs Text Log](evidence/windows-specs.txt)
