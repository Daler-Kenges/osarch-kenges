# Lab 6 — Live processes and memory pressure

Pair: Daler Kenges (single-student work) · Date: 22.11.2026 · Guests: <Ubuntu version / Windows edition, RAM of each>

## Part 1 — Cross-tool process analysis

Process chosen: **VirtualBox Guest Additions Service (`VBoxService` on Ubuntu / `VBoxService.exe` on Windows)** — why: it runs continuously as a background system service on both guests simultaneously, enabling a direct comparison of how Windows and Linux tools report identical service workloads.

### Evidence
* **Windows Task Manager (`Details` tab):** `evidence/task-manager.png`
* **Windows Process Explorer (Tree, Columns & Handles pane):** `evidence/process-explorer.png`
* **Ubuntu `htop` (Tree view):** `evidence/htop.png`

### Ubuntu command-line metrics
```bash
$ ps -o pid,ppid,user,rss,vsz,nlwp,cmd -p 23405
    PID    PPID USER       RSS    VSZ NLWP CMD
  23405       1 root      3804 292100    9 /usr/sbin/VBoxService

$ sudo ls /proc/23405/fd | wc -l
5

$ sudo ls -l /proc/23405/fd | head
total 0
lrwx------  1 root root 64 Nov 22 17:51 0 -> /dev/null
lrwx------  1 root root 64 Nov 22 17:51 1 -> /dev/null
lrwx------  1 root root 64 Nov 22 17:51 2 -> /dev/null
lrwx------  1 root root 64 Nov 22 17:51 3 -> /dev/vboxguest
lrwx------+ 1 root root 64 Nov 22 17:51 4 -> socket:[64595]
```

Metric,Task Manager,Process Explorer,htop / ps
PID,1708,1708,23405
Parent (name and PID),— (not shown),services.exe (816),systemd (1)
"""Memory"" as shown by default","1,096 K (Memory - private working set)","2,424 K (Private Bytes) / 9,384 K (Working Set)","3,800 KiB (RES in htop) / 3,804 KiB (RSS in ps)"
Private memory,"1,096 K (Memory - private working set)","1,100 K (WS Private) / 2,424 K (Private Bytes)",420 KiB (RES - SHR: 3804 - 3384 KiB; no dedicated column)
Working set / RES,"9,328 K (Working set)","9,384 K (Working Set)","3,800 KiB (RES) / 3,804 KiB (RSS)"
Virtual size,"2,368 K (Commit size)","2,424 K (Private Bytes)","285M (VIRT) / 292,100 KiB (VSZ)"
Handles / file descriptors,194,196,5 (/proc/23405/fd)
Threads,14,14,9 (NLWP in ps; 1 main + 8 worker threads in htop)

### Where the tools disagree

1. **Default "Memory" measures different footprints:** Task Manager's default **Memory** column displays only the **private working set** (`1,096 K` — physical RAM exclusive to `VBoxService.exe`), whereas `htop`'s **RES** (`3,800` KiB) and Process Explorer's **Working Set** (`9,384 K`) include shared DLLs/libraries (`SHR` is `3,384` KiB on Ubuntu, meaning ~89% of its resident footprint is shared code).
2. **Virtual Size (`VIRT`/`VSZ`) vs. Windows Commit Size / Private Bytes:** On Linux, `htop` (`VIRT`: `285M`) and `ps` (`VSZ`: `292,100` KiB) count the entire reserved virtual address space—including mapped shared libraries and per-thread stacks across `9` threads—even though only `3.8 MiB` is backed by physical RAM. On Windows, Task Manager's **Commit size** (`2,368 K`) and Process Explorer's **Private Bytes** (`2,424 K`) count only private virtual memory committed to RAM or the pagefile.
3. **Parent Process Visibility:** Task Manager's `Details` tab omits parent process information, whereas Process Explorer displays the process hierarchy under `services.exe` (`816`) and `htop`/`ps` expose `PPID` (`1`, `systemd`).

---

## Part 2 — Memory pressure

Guest RAM: `1.6Gi` (2 GB allocated in VirtualBox; snapshot `before-lab6` taken beforehand) · swap: `2.0Gi` (`/swap.img`)

Steps:
```bash
free -h && swapon --show
stress-ng --vm 2 --vm-bytes 70% --timeout 60s
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
stress-ng --vm 2 --vm-bytes 120% --timeout 90s
stress-ng --vm 4 --vm-bytes 280% --vm-keep --timeout 45s
python3 -c 'a = []; [a.append(bytearray(100 * 1024 * 1024)) for _ in range(100)]'
```

| | Before | During (worst) | After |
| :--- | :--- | :--- | :--- |
| **Available** | `1.2Gi` | `~0Mi` (exhausted right before `18:21:29` OOM kill) | `1.2Gi` |
| **Swap used** | `0B` | `1.99Gi` (`509,385` swap pages of `2.0Gi`) | `~1Mi` |

What happened: During the progressive `stress-ng` runs (`70%` through `280%`), available RAM dropped and `/swap.img` absorbed the pressure with mild terminal lag. When the incremental 100 MB Python allocator (`python3 -c 'a = []; [a.append(bytearray(100 * 1024 * 1024)) for _ in range(100)]'`, PID `2341`) ran, it faulted and zero-filled pages until both physical RAM (`1.6Gi`) and `/swap.img` (`2.0Gi`) were completely exhausted; SSH input paused briefly around `18:21:23` (`systemd-journald` flushed caches) until the kernel OOM killer terminated `python3` (`Killed`) at `18:21:29`, immediately restoring terminal responsiveness.

### What the kernel did

```text
Nov 22 18:21:23 lab01-kenges systemd-journald[548]: Under memory pressure, flushing caches.
Nov 22 18:21:29 lab01-kenges kernel: sshd-session invoked oom-killer: gfp_mask=0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), order=0, oom_score_adj=0
Nov 22 18:21:29 lab01-kenges kernel: [   2341]  1000  2341   900708   362856   362267      589         0  7061504   509385             0 python3
Nov 22 18:21:29 lab01-kenges kernel: oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/user.slice/user-1000.slice/session-3.scope,task=python3,pid=2341,uid=1000
Nov 22 18:21:29 lab01-kenges kernel: Out of memory: Killed process 2341 (python3) total-vm:3602832kB, anon-rss:1449068kB, file-rss:2356kB, shmem-rss:0kB, UID:1000 pgtables:6896kB oom_score_adj:0
```

At `18:21:23`, `systemd-journald` flushed caches under memory pressure. Six seconds later (`18:21:29`), with `python3` (PID `2341`, started via `python3 -c 'a = []; [a.append(bytearray(100 * 1024 * 1024)) for _ in range(100)]'`) holding `3,602,832 kB` (`~3.44 GiB`) of virtual memory, `1,449,068 kB` (`~1.38 GiB`) of physical anonymous RSS, and `509,385` swap pages (`~1.99 GiB` of the `2.0 GiB` swap file), no reclaimable pages remained; the kernel invoked `oom-killer`, selected `python3` as the highest memory consumer, and terminated it with `SIGKILL` to protect system stability.

### Windows

```powershell
PS C:\Users\Daler> Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 | Format-List TimeCreated, Id, Message
Get-WinEvent : No events were found that match the specified selection criteria.
```

The Windows guest has not experienced a virtual memory exhaustion condition during its uptime, so `Get-WinEvent` returns no matching records. Unlike Linux's OOM killer—which abruptly terminates the highest-scoring process with `SIGKILL` to reclaim memory—Windows does not automatically kill processes under low memory. Instead, when system commit charge approaches the commit limit (RAM + pagefile), Windows writes **Event ID `2004`** (*"Windows successfully diagnosed a low virtual memory condition"*) under `Microsoft-Windows-Resource-Exhaustion-Detector` in the `System` log, warns the user to close applications, fails new memory allocation calls, and lists the top three memory-consuming processes by commit size inside the event details.

### What did not work the first time

* **`stress-ng` percentages (`70%`–`280%`) did not trigger an OOM kill:** `stress-ng` calculates `--vm-bytes` relative to *available RAM* (`~1.0–1.2 GiB`) rather than combined RAM + swap (`3.6 GiB`), so `/swap.img` (`2.0 GiB`) absorbed the allocations without exhausting total commit capacity.
* **Oversized `--vm-bytes` (`480%`–`520%`, `6.10 GB` single virtual request) was rejected before faulting pages:** Linux's default `vm.overcommit_memory=0` heuristic throttled/refused the single oversized virtual request instead of letting it fault physical pages until exhaustion.
* **Switching to incremental 100 MB allocations solved it:** Allocating and zero-filling 100 MB `bytearray` chunks in Python (`python3 -c 'a = []; [a.append(bytearray(100 * 1024 * 1024)) for _ in range(100)]'`) forced actual physical page faults step by step until both RAM and `/swap.img` filled completely and triggered the kernel OOM killer.
