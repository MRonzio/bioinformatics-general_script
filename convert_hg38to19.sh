#!/bin/bash
# starting from a list of bed files (including their directories), it
# convert them from hg38 to hg19 removing old files.

# usecase
# ./convert_hg38to19.sh listfilewithpath

filename=$1
declare -a myArray
myArray=(`cat "$filename"`)
linecount=$(awk 'END {print NR-1}' $1)

for (( i = 0 ; i <= linecount ; i++))
    do
	echo "Element [$i]: ${myAssrray[$i]}"
	codicetf=${myArray[$i]}
	echo "$codicetf"
	# liftOver input.bed hg18ToHg19.over.chain.gz output.bed unlifted.bed
	liftOver "$codicetf" ~/Scaricati/tools/hg38ToHg19.over.chain.gz "${codicetf%_hg38.bed}""_hg19.bed" "${codicetf%.*}""_unlifted.bed" bedPlus=3
	#rm "$codicetf"
	#rm "${codicetf%.*}""_unlifted.bed"
	#mv "${codicetf%_hg38*}""_hg19.bed" "$codicetf"
done



	
