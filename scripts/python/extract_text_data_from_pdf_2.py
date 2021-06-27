# -*- coding: utf-8 -*-
"""
Created on Fri Jun 25 09:12:31 2021
Pdf file data downloaded from: https://ncrb.gov.in/en/crime-in-india-table-addtional-table-and-chapter-contents
@author: Ashish
"""

import pdfplumber as pp
import os

cur_path = os.path.dirname(__file__)
print(cur_path)

# set path for loading pdf file in memory
new_path = os.path.relpath('..\\..\\data\\pdf\\pdf_tbl1.pdf', cur_path)

# read pdf, extract data
with pp.open(new_path) as pdf:
    page = pdf.pages[0]
    text=page.extract_text()
    print(text)

# set table settings in pdf file
table_settings = {
    "vertical_strategy": "lines",
    "horizontal_strategy": "text",
    "intersection_x_tolerance": 15
    }

# read pdf file, extract table data
with pp.open(new_path) as pdf:
    mypage = pdf.pages[0]
    tbls = mypage.find_tables()
    print("Tables: ", tbls)
    tbl_content = tbls[0].extract(x_tolerance=5)
    print("Table content: ",tbl_content)


