#!/bin/bash

# intended usage in background:
# nohup ./run_rsem_bowtie2_pe.sh &> run_rsem_bowtie2_pe.log &

# fastq file should be in .fastq.gz and paired end,
# otherwise editing of some lines of code is needed.

date

# stop if something it's wrong
set -e
echo ""

TARGETDIR=$HOME # common path
DATA=$TARGETDIR/data # data folder
RESULTS=$TARGETDIR/results # results folder
REF=$HOME/RefFolder/ReferenceName  # rsem previously prepared reference
NPROC=8 # number of cores


if test -d $RESULTS;then
	echo "directory already present, using it"
else
	echo "directory not present, i'm creating it"
	mkdir -p $RESULTS
fi

for f in $DATA/*_1.fastq.gz
	do
	name=${f%_*}
	onlyname=$(basename $name)
	res=$RESULTS/$onlyname
	if test -f "$res".genes.results;then
		echo "$onlyname already done, skipping it..."
		continue
	fi
	echo "starting processing ${onlyname} at ${date}"
	echo "Read 1 and Read 2: ${name}_{1,2}.fastq.gz"
	#echo $TARGETDIR
	#echo $DATA
	#echo $RESULTS
	#echo $REF
	#echo $name
	rsem-calculate-expression -p $NPROC --paired-end --bowtie2 --estimate-rspd --no-bam-output --append-names ${name}_{1,2}.fastq.gz $REF $res
	echo "ended ${onlyname} at ${date}"
done
