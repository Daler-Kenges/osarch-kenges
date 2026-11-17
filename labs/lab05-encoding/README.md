# Lab 5 — Encoding forensics

Name: Daler Kenges · Date: 17.11.2026 · Tools: Ubuntu guest controlled via PowerShell

## What I received
![Excel before](evidence/before-excel.png)
Excel: Misread the file as Windows-1252 (or merged columns if semicolon wasn't recognized), turning Cyrillic/Kazakh names into garbled Latin mojibake instead of readable text.

![LibreOffice before](evidence/before-libreoffice.png)
LibreOffice: Import dialog defaulted to `- Automatic -` (`Cyrillic (Windows-1251)`) with `;` separator; Russian text rendered, but Kazakh-specific letters broke (e.g., `Әбдірахманова` appeared as `Jбдірахманова`).

![Powershell before](evidence/before-powershell.png)
PowerShell (`cat`): Expected UTF-8, so single-byte legacy Cyrillic/Kazakh characters rendered as replacement boxes (`□`) and stray characters.

## Diagnosis (made before the fix)
- **file said:** `Non-ISO extended-ASCII text, with CRLF line terminators` (`evidence/file-before.txt`)
- **First 16 bytes:** `49 44 3b d4 e0 ec e8 eb e8 ff 3b c8 ec ff 3b ce` (`evidence/hexdump-before.txt`)
- **Encoding:** `KZ-1048` (`RK1048` in `iconv`) — because Cyrillic and Kazakh characters are encoded as single bytes (`"А"` = `c0`, `"я"` = `ff`), and Kazakh-specific characters use KZ-1048 code points (`"Ә"` = `a3` in `"Әбдірахманова"` at offset `0x2a`, `"і"` = `b3`) rather than Windows-1251 (where `0xa3` is `"Ј"`).
- **Line ending:** `CRLF` — because line 1 ends with the two bytes `0d 0a` (`\r\n`) at offsets `0x24`–`0x25` immediately after `"Город"` and before `"101"`.
- **BOM:** `no` — because the file begins directly with `49 44` (`"ID"`) rather than `EF BB BF`, `FF FE`, or `FE FF`.
- **Separator:** `;` (semicolon) — visible as byte `3b` between column headers (`ID;Фамилия;Имя;Отдел;Должность;Город`).

## Fix

### Reasoning behind choices
- **UTF-8 with BOM (`EF BB BF`):** In the fixed file I added a UTF-8 BOM (`EF BB BF`) so Microsoft Excel on Windows automatically detects UTF-8 upon double-clicking instead of falling back to the system legacy code page, while LibreOffice Calc and Linux terminal tools still parse the file cleanly.
- **Line endings (`LF` / `0A`):** In the fixed file I converted `CRLF` (`0d 0a`) line endings to `LF` (`0a`) so the file works reliably with Unix/Linux tools and shell scripts without trailing `\r` (`^M`) errors, while modern Excel and LibreOffice Calc still read `LF`-delimited rows properly.

### Fixing script (`scripts/fix.sh`)
```sh
#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 (KZ-1048) to UTF-8 with BOM and LF line endings
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv

iconv -f RK1048 -t UTF-8 "$in" > "$out"
sed -i 's/\r$//' "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
```

## What did not work the first time
Testing WINDOWS-1251 before RK1048: Running iconv -f WINDOWS-1251 -t UTF-8 decoded Russian names properly but corrupted Kazakh letters (turning Әбдірахманова into Јбдірахманова, Қасымов into Ќасымов, and Нұрлан into Нўрлан). Checking the raw hex bytes (0xa3 for Ә) and switching the source encoding to RK1048 (KZ-1048) resolved every character cleanly.
