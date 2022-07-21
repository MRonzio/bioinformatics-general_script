#!/bin/bash

# you need fasta index file in the same directory of the genome fasta file

# usage
# ./extend_and_get_fasta.sh genomefile bp summitbedfile

genomefile=$1
bp=$2
summitbedfile=$3

# stop if any errors
set -e

bedtools slop -i $summitbedfile -b $bp -g ${genomefile}.fai | bedtools getfasta -fi $genomefile -bed - 
