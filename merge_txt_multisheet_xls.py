#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 14 9:57:52 2022

merge multiple input files into a single multisheet excel file,
with each sheet names as file name

@author: MRonzio
"""

import os
import pandas as pd
import argparse
import openpyxl
from openpyxl.utils.dataframe import dataframe_to_rows

# COMMAND LINE OPTIONS
def cliopt():
    parser = argparse.ArgumentParser(description='multiple text files merger in excel')
    parser.add_argument('-o', '--outfile', dest='outfilename', default='merge.xls', help='output excel filename including extension')
    parser.add_argument('-i', '--inputfiles', dest='files', help='input files to merge',nargs='*',required=True)
    parser.add_argument('-s', '--sep', dest='separator', help='if multiple columns: separator character, default is tab, i.e. \t', default="\t")
    return parser.parse_args()

opt=cliopt()
files = opt.files
separator=opt.separator

workbook = openpyxl.Workbook()
for file in files:
    if os.path.isfile(file):
        filename=os.path.basename(file)
        workbook.create_sheet(filename)
        print(f"Created {filename} excel sheet")
        df=pd.read_table(file,sep=separator, header=None)
        for r in dataframe_to_rows(df, index=False, header=False):
            workbook[filename].append(r)

workbook.remove(workbook['Sheet'])
workbook.save(opt.outfilename)


print("done")