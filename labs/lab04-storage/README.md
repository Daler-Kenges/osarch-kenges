# Lab 4 — Partition, mirror, fail, recover

Pair: Daler Kenges (solo work) · Date: 15.11.2026 · Hypervisor: VirtualBox 7.2.22

## Windows
Get-Disk output:
```text
Number Friendly Name Serial Number                 HealthStatus      OperationalStatus   Total Size PartitionStyle
------ ------------- -------------                 ------------      -----------------   ---------- --------------
0      VBOX HARDDISK VBb4fb942b-5c7899b2           Healthy           Online                   64 GB GPT
1      VBOX HARDDISK VB1ec30fed-c0b3071b           Healthy           Online                    1 GB RAW
```

Get-Volume output:
```text
DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining      Size
----------- ------------ -------------- --------- ------------ ----------------- -------------      ----
E           LAB04        NTFS           Fixed     Healthy      OK                    989.98 MB 1007.93 MB

Number         : 0
FriendlyName   : VBOX HARDDISK
PartitionStyle : GPT
Size           : 68719476736

Number         : 1
FriendlyName   : VBOX HARDDISK
PartitionStyle : GPT
Size           : 1073741824

E           LAB04        NTFS           Fixed     Healthy      OK                    989.98 MB 1007.93 MB
```

MBR or GPT:
I choose GPT because Windows boots with UEFI, which uses GPT that stores a backup copy of the table and checksums it. MBR with restrictions to 2TiB and 4 channels would cause significant complexities like sacrificing primary slot for extension. GPT removes extra complexities, providing error management via checksumming the table and storing back up.

## Linux — layout before and after
### Before
```text
NAME                      SIZE TYPE FSTYPE      MOUNTPOINTS
loop0                    66.8M loop squashfs    /snap/core24/1643
loop1                     1.5M loop squashfs    /snap/hwctl/123
loop2                     1.5M loop squashfs    /snap/hwctl/131
loop3                    50.1M loop squashfs    /snap/snapd/27710
sda                        25G disk
├─sda1                      1M part
├─sda2                      2G part ext4        /boot
└─sda3                     23G part LVM2_member
  └─ubuntu--vg-ubuntu--lv 11.5G lvm  ext4        /
sdb                         1G disk
sdc                         1G disk
sdd                         1G disk
sr0                      50.7M rom  iso9660
```

### After
```text
NAME                        SIZE TYPE  FSTYPE            MOUNTPOINTS
loop0                      66.8M loop  squashfs          /snap/core24/1643
loop1                       1.5M loop  squashfs          /snap/hwctl/123
loop2                       1.5M loop  squashfs          /snap/hwctl/131
loop3                      50.1M loop  squashfs          /snap/snapd/27710
sda                          25G disk
├─sda1                        1M part
├─sda2                        2G part  ext4              /boot
└─sda3                       23G part  LVM2_member
  └─ubuntu--vg-ubuntu--lv 11.5G lvm    ext4              /
sdb                           1G disk
└─sdb1                     1022M part  linux_raid_member
  └─md0                    1021M raid1 ext4              /mnt/mirror
sdc                           1G disk
└─sdc1                     1022M part  linux_raid_member
sdd                           1G disk
└─sdd1                     1022M part  linux_raid_member
  └─md0                    1021M raid1 ext4              /mnt/mirror
sr0                        50.7M rom   iso9660
```

## What I did

**1. Create partitions, build the RAID-1 array, format, and mount:**
```bash
for d in /dev/sdb /dev/sdc /dev/sdd; do
  sudo parted -s "$d" mklabel gpt mkpart primary 1MiB 100% set 1 raid on
done
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo mkfs.ext4 -L mirror /dev/md0
sudo mkdir -p /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
sudo chown $USER: /mnt/mirror
```

**2. Write test data and record baseline checksums:**
```bash
echo "Lab 4 proof file — Kenges — $(date)" > /mnt/mirror/proof.txt
head -c 20M /dev/urandom > /mnt/mirror/random.bin
cd /mnt/mirror && sha256sum proof.txt random.bin
```

**3. Simulate disk failure and verify data integrity:**
```bash
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
cat /proc/mdstat
cd /mnt/mirror && sha256sum proof.txt random.bin
```

**4. Rebuild the array with the spare disk and configure persistence:**
```bash
sudo mdadm /dev/md0 --add /dev/sdd1
cat /proc/mdstat
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

## Three states
| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | `[2/2] [UU]` | `evidence/array-healthy.txt` |
| Degraded | `[2/1] [U_]` | `evidence/array-degraded.txt` |
| Rebuilt | `[2/2] [UU]`, `sdd1` replaced `sdc1` | `evidence/array-rebuilt.txt` |

Checksums before and after the failure: **match** (`a3bd6e48888f20bd3dd967106e5776fe547a1eef58055fd4d3a946965d3cd2e7` for `proof.txt` and `2e98f914979413be0e60c4d4e31f0f73232e6047398530c2f7c774f7700aca10` for `random.bin` remained identical before and after removing `/dev/sdc1`).

## RAID is not a backup
Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? Why?

No, RAID 1 does not help in this situation. RAID 1 mirrors every filesystem operation in real time across all member disks, so deleting a file immediately removes it from both `/dev/sdb1` and `/dev/sdd1` simultaneously. RAID protects against hardware disk failure by maintaining live redundancy, whereas recovering from accidental deletion, corruption, or ransomware requires separate point-in-time backups or snapshots.

## What did not work the first time
1. **Pasting commands into the VirtualBox VM console:** Initially, I tried pasting multi-line commands directly into the Ubuntu VirtualBox GUI window, which did not accept clipboard paste from the Windows host without Guest Additions configured. Switching to an SSH session from Windows PowerShell (`ssh -p 2222 kenges@127.0.0.1`) enabled full copy-and-paste support in both directions and made capturing unedited command outputs much cleaner.
2. **Transferring evidence files with `scp`:** When copying the evidence folder from the guest VM to the host using `scp -P 2222 -r kenges@127.0.0.1:lab04/evidence labs/lab04-storage/`, the transfer failed with `No such file or directory`. PowerShell was running in `C:\Users\...` rather than the root directory of the cloned Git repository, so the relative destination path `labs/lab04-storage/` did not exist there; copying to `$HOME\Desktop\evidence` (or navigating into the repository root first) resolved the issue.o the host using `scp -P 2222 -r kenges@127.0.0.1:lab04/evidence labs/lab04-storage/`, the transfer failed with `No such file or directory`. PowerShell was running in `C:\Users\...` rather than the root directory of the cloned Git repository, so the relative destination path `labs/lab04-storage/` did not exist there; copying to `$HOME\Desktop\evidence` (or navigating into the repository root first) resolved the issue.

## AI Usage Acknowledgment
In completing this lab, I consulted Google's Gemini as a troubleshooting and documentation assistant. Gemini helped by:
* Formatting my raw terminal outputs (`lsblk`, `mdadm`, `Get-Disk`) into proper Markdown code blocks.
* Breaking down the underlying concepts behind GPT partitions, SHA-256 hashing, and the `initramfs` rebuild process.
* Troubleshooting the `scp` relative path errors and suggesting the Windows PowerShell SSH workflow to bypass VirtualBox clipboard limitations.
* Verifying that my final evidence files matched the expected technical criteria for a successful RAID-1 rebuild.

All commands were executed manually by me in the VirtualBox environment, and the captured evidence reflects my genuine lab outputs.
