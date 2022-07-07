#!/bin/bash

# intended usage in background:
# nohup ./un_rsem_star_pe.sh [data folder] [results folder] [reference] [nproc] &> un_rsem_star_pe_pe.log &

# fastq file should be in .fastq.gz and paired end,
# otherwise editing of some lines of code is needed.

date

# stop if something it's wrong
set -e
echo ""

# manually set variables
TARGETDIR=$PWD # common path
DATA=$TARGETDIR/data # data folder
RESULTS=$TARGETDIR/results # results folder
REF=$HOME/RefFolder/ReferenceName  # rsem previously prepared reference
NPROC=8 # number of cores

# DATA
if [[ -z "$1" ]];
then
  DATA=$1
else
  DATA=$TARGETDIR/data # data folder

# RESULTS
if [[ -z "$2" ]];
then
  RESULTS=$2
else
  RESULTS=$TARGETDIR/results # results folder

# REF
if [[ -z "$3" ]];
then
  REF=$3
else
  REF=$HOME/RefFolder/ReferenceName  # rsem previously prepared reference

if [[ -z "$4" ]];
then
  NPROC=$4
else
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
    rsem-calculate-expression -p $NPROC --paired-end --star --estimate-rspd --no-bam-output --star-gzipped-read-file --append-names ${name}_{1,2}.fastq.gz $REF $res
	echo "ended ${onlyname} at ${date}"
done
