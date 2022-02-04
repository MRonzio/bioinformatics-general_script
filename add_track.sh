#!/bin/bash
# this script needs to be run from the folder where input resides.
# it adds tracking info to the first line of a bed file, and append "_track.bed" to the filename
# the bed file will be moved to the "ucsc_tracks" folder whithin the same directory, which will 
# be created if not already present.

# usage

# ./add_tracks.sh file1.bed file2.bed .... fileN.bed

mkdir -p ucsc_tracks
for f in $*
do
sed "1s/^/track type=bed name=${f%.*} \n/" $f > ${f%.*}_track.bed
mv  ${f%.*}_track.bed ucsc_tracks/
done
