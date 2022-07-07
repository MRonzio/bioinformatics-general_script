#!bin/bash

# USAGE

./download_sra_explorer_fastq.sh output_script_downloaded_from_sra_explorer.sh


# stop if any problems
set -e 

echo ""

SRAFILE=$1

echo "reading file" $SRAFILE

sed '1 ! s/$/ -C -/' $SRAFILE > download_script.sh


# first time

bash download_script.sh

# retry if any problem

bash download_script.sh


# remove temp script
rm download_script.sh


echo "done"



