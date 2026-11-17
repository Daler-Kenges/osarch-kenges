# Lab 5 — Encoding forensics

Name: Daler Kenges · Date: 17.11.2026 · Tools: Ubuntu guest controlled via PowerShell

## What I received
![Excel before](evidence/before-excel.png)
Excel: Misread the file as Windows-1252 (or merged columns if semicolon wasn't recognized), turning Cyrillic/Kazakh names into garbled Latin mojibake (e.g., Ð... / accented characters) instead of readable text.

![LibreOffice before](evidence/before-libreoffice.png)
LibreOffice: Import dialog defaulted to - Automatic - (Cyrillic (Windows-1251)) with ; separator; Russian text rendered, but Kazakh-specific letters broke (e.g., Әбдірахманова appeared as Jбдірахманова).

![Powershell before](evidence/before-powershell.png)
Powershell(cat): Expected UTF-8, so single-byte legacy Cyrillic/Kazakh characters rendered as replacement boxes (□) and stray diacritics (Ƣ, ÿ, Ƽ).

## Diagnosis (made before the fix)
- file said: <…>  (evidence/file-before.txt)
- First 16 bytes: <hex>  (evidence/hexdump-before.txt)
- Encoding: <exact name> — because <bytes>
- Line ending: <CRLF / LF> — because <bytes>
- BOM: <yes / no> — because <bytes>; in the fixed file I <kept / removed / added> it because <reason>

## Fix
<the command or scripts/fix.sh, in a code block>

## Verification
<file-after.txt summary; the screenshot evidence/opens-correctly.png>

## What did not work the first time
<at least one real thing>
