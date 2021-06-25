# -*- coding: utf-8 -*-
"""
Created on Fri Jun 25 09:12:31 2021

@author: Ashish
"""

import pdfplumber as pp
import os

cur_path = os.path.dirname(__file__)
print(cur_path)

# get data
new_path = os.path.relpath('..\\data\\pdf\\file1.pdf', cur_path)

with pp.open(new_path) as pdf:
    page = pdf.pages[0]
    text=page.extract_text()
    print(text)
    

