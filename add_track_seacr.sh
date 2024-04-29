#!/bin/bash
# this script needs to be run from the folder where input resides.
# it adds tracking info -for UCSC genome browser visualization- to the first line of a bed file.
# it also appends "_track.bed" to the output filename.
# the resulted bed file will be moved to the "ucsc_tracks" folder whithin the same directory, 
# which will  be created if not present.
# it is specific for seacr bed files as it will cut on first 3 columns!

# usage

# ./add_track_seacr.sh file1.bed file2.bed .... fileN.bed

mkdir -p ucsc_tracks
for f in $*
do
sed "1s/^/track type=bed name=${f%.*} \n/" $f | awk '{print $1,$2,$3}' > ${f%.*}_track.bed
mv  ${f%.*}_track.bed ucsc_tracks/
done
