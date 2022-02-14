#!/bin/bash
# this script needs to be run from the folder where input resides.
# it runs pscanchip software on chip-seq summits peaks (or symmetrically extended from summits).
# the resulted bed.ris file will be moved to the "pscanchip" folder whithin the same directory, 
# which will  be created if not present.
# genome hg19 or mm10
# region mixed or promoters

# usage
# ./run_pscanchip.sh genome region file1.bed file2.bed .... fileN.bed

pscanchip_folder= dirname $(readlink -f $(which pscan_chip))  # or set the absolute path of pscanchip folder
genome=$pscanchip_folder/$1
matrix=$pscanchip_folder/jaspar_2022_R.wil
bg=$pscanchip_folder/BG/$2.jaspar_2022_R.bg

mkdir -p pscanchip
for f in ${@:3}
do
pscan_chip -r $f -g $genome -M $matrix -bg $jasparbg
mv  ${f}.ris pscanchip/
done
