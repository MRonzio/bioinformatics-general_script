#!/bin/bash
# this script needs to be run from the folder where input resides.
# it runs pscanchip software on chip-seq summits peaks (or symmetrically extended from summits).
# the resulted bed.ris file will be moved to the "pscanchip" folder whithin the same directory, 
# which will  be created if not present.
# genome: hg19 or mm10
# matrix: any jaspar matrix (e.g. MA0060.1)

# usage
# ./run_pscanchip_singlemat.sh genome matrix file1.bed file2.bed .... fileN.bed

pscanchip_folder=$(dirname $(readlink -f $(which pscan_chip)))  # or set the absolute path of pscanchip folder
genome=$pscanchip_folder/$1
matrices=$pscanchip_folder/jaspar_2022_R.wil
matrix=$2

mkdir -p pscanchip_single_mat
for f in ${@:3}
do
pscan_chip -r $f -g $genome -M $matrices -m $matrix
mv  ${f}.ris pscanchip_single_mat/
done








