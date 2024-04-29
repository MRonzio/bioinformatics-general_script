#!/bin/bash
# originally inspired by https://github.com/mattlee821/relative_file_paths

## First create Github project, without README file, but with license (maybe MIT). ##
## Then run this script ##

# usage
# ./create_project.sh project_name github_username
# e.g. ./create_project.sh mynewproject MRonzio

projectname=$1
username=$2

echo "Making new project called $projectname in:"
pwd

#script to set up new project on laptop and new git repo that is linked to github
mkdir $projectname
cd $projectname

mkdir documents
mkdir manuscript
mkdir data
mkdir script
mkdir environment
mkdir results
mkdir nextflow

# make environment for sourcing file paths in bash and R
pwd | sed "s,$USER,\$USER," > environment/environment.sh

# make .gitignore
## general list of file extensions that could contain data
(
echo *.csv
echo *.tsv
echo *.dta
echo *.txt
echo *.dat
echo *.[rR]data
echo *.[rR]data
# R file formats
#echo .Rproj.user
echo .Rhistory
echo .RData
echo .Ruserdata
#echo .Rproj
echo .Rmd
# genetic data file formats
echo *.bgen
echo *.gen
# UK Biobank data file formats
echo *.enc_ukb
echo *.enc
echo *.cwa
# NGS data
echo *.fastq.gz
echo *.fq.gz
echo *.fastq
echo *.fq
echo *.sam
echo *.bam
echo *.bai
echo *.fa
echo *.fasta
# deeptools
echo *.npz
# common directories
echo manuscript
echo data
echo nextflow
echo results
echo documents
echo environment
) > .gitignore

touch README.Rmd
git init
git add .gitignore script/
git commit -m "first commit"
git remote add origin git@github.com:$username/$projectname.git
git push -u origin main

echo "Finished"
