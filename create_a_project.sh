#!/bin/bash
# originally inspired by https://github.com/mattlee821/relative_file_paths


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

# make environment for sourcing file paths in bash and R
echo "LOCAL="$PWD"" > environment/environment.sh

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
echo .Rproj.user
echo .Rhistory
echo .RData
echo .Ruserdata
echo *.Rproj
echo *.Rmd
# genetic data file formats
echo *.bgen
echo *.gen
# files generated from BlueCrystal jobs
echo out*
echo error*
echo j*.sh.e*
echo j*.sh.o*
echo *.sh.e*
echo *.sh.o*
# UK Biobank data file formats
echo *.enc_ukb
echo *.enc
echo *.cwa
# common directories
echo manuscript
echo data
echo analysis
echo environment
) > .gitignore

touch README.Rmd
git init
git add .gitignore scripts/
git commit -m "first commit"
git remote add origin https://github.com/$username/$projectname.git
git push -u origin master

echo "Finished"
