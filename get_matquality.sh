#!/bin/bash
# Get quality of matrix metrics for single-matrix mode output of pscanchip.

#usage

#./get_matquality.sh output.ris jaspar_matrix [output2.ris] [output3.ris] .... [outputN.ris]
# known score values : NFYA MA0060.1 = 0.76023
# known score values : TBP MA0108.2 = 0.7816
# known score values : USF1 MA0093.2 = 0.7766
declare -A scores=( ["MA0060.1"]=0.76023 ["MA0093.2"]=0.7766 ["MA0108.2"]=0.7816 )

score="${scores[$1]}"
echo "Filename Count TotPeaks Perc"
ls ${@:2} | xargs -i awk -v score=${score} '$10 > score {count++}END{print FILENAME, count, NR, 100*count/NR"%"}' "{}"
