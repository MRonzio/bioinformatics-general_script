#!/bin/bash 

set -e
mkdir -p extended
awk 'FNR == 1 {FS="\t"} {OFS="\t"} {out = "extended/"FILENAME} ; {print $1, $2-75, $2+75+1, $4, $5, $6, $7 > out}' $*
cd extended
for f in $* 
do
	mv ${f} ${f%_summits.bed}_extended.bed
done
cd ..
