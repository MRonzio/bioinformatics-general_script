#!/bin/bash

# intended usage in background:
# nohup ./get_tpm_rsem.sh datatype file1.results file2.results &> get_tpm_rsem.log &

date

# stop if something it's wrong
set -e
echo ""

dtype=$1 # isoform or gene
#samples=${@:2}
samples=("${@:2}")

#samples=$(awk -F, 'NR>1 {print $1}' ${metadatafile} | uniq) # 
# initialize the expression data file: feature column
awk -F"\t" '{print $1}' ${samples[1]} > ${dtype}_tpm.tsv

for sample in ${samples[@]}
	do
    clean_sample=${sample%.${dtype}s.results}
    echo "starting processing ${sample}"
    (echo $clean_sample && awk -F"\t" 'NR>1{print $6}' $sample) > ${dtype}_${clean_sample}.txt
    paste ${dtype}_tpm.tsv ${dtype}_${clean_sample}.txt -d "\t" > ${dtype}_tpm.temp.tsv
    mv ${dtype}_tpm.temp.tsv ${dtype}_tpm.tsv
    rm ${dtype}_${clean_sample}.txt
    echo "processed ${sample}"
done
