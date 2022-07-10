#!bin/bash

# USAGE

./download_sra_explorer_fastq.sh output_script_downloaded_from_sra_explorer.sh


# stop if any problems
set -e 

echo ""

SRAFILE=$1

echo "reading file" $SRAFILE

# print list of file names
echo "saving list of sra files to SRA_download_filenames.txt.."
awk -F "-o" '{print $2}' $SRAFILE > SRA_download_filenames.txt


# editing download commands
echo "editing download commands.."
echo "saving download commands to download_script.sh.."
sed '1 ! s/$/ -C -/' $SRAFILE > download_script.sh


# first time
bash download_script.sh

# retry if any problem
bash download_script.sh


# remove temp script
rm download_script.sh


echo "done"

