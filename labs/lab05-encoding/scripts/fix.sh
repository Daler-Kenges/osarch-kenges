#!/bin/sh
# Lab 5: convert staff-broken.csv from RK1048 (KZ-1048) to UTF-8 with BOM and LF line endings
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv

iconv -f RK1048 -t UTF-8 "$in" > "$out"
sed -i 's/\r$//' "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
