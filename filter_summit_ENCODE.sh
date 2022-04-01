#!/bin/bash
# Script for fish out summit coordinates from narrowPeak bed files,
# downloaded from ENCODE repository.
# it temporally creates a summit_temp folder 
# and appends _summits.bed to the end of filename (fixed for extension). 

# usage
# ./filter_summit_ENCODE.sh ENCODEnarrowPeak1.bed ENCODEnarrowPeak2.bed ...ENCODEnarrowPeakN.bed


mkdir -p summit_temp
awk 'FNR == 1 {FS="\t"} {OFS="\t"} {out = "summit_temp/"FILENAME} ; {print $1, $2+$10, $2+$10+1, $4, $5, $6, $7 > out}' $*
cd summit_temp
for f in $*
do
bedtools sort -i ${f} > ${f%.*}_summits.bed
rm ${f}
done

cd ..
mv summit_temp/*.bed .
rmdir summit_temp


