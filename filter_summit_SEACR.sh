#!/bin/bash

# Script for pick summit coordinates from SEACR output bed files (v1.3)
# it temporally creates a summit_temp folder 
# and appends _summits.bed to the end of filename (fixed for extension). 

# usage
# ./filter_summit_SEACR.sh seacrpeaks1.bed [seacrpeaks2.bed] seacrpeaks3.bed] ... [seacrpeaksN.bed]

mkdir -p summit_temp
awk 'FNR == 1 -F"\t|-|:" {OFS="\t"} {out = "summit_temp/"FILENAME} ; {print $1, ($8+$7)/2, ($8+$7/2)+1, $4, $5 > out}' $*
cd summit_temp
for f in $*
do
bedtools sort -i ${f} > ${f%.*}_summits.bed
rm ${f}
done

cd ..
mv summit_temp/*.bed .
rmdir summit_temp