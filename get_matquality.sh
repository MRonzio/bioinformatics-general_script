#!/bin/bash
# Get quality of matrix metrics for single-matrix mode output of pscanchip.

#usage

#./get_matquality.sh output.ris [output2.ris] [output3.ris] .... [outputN.ris]

ls $* | xargs -i awk '$10 > 0.76 {count++}END{print FILENAME, count, 100*count/NR"%"}' "{}"
