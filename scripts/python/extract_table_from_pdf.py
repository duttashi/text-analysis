# Objective 1: Read table from multiple pdf files contained in a directory to a list
# Obkective 2: clean the pdf text data and find unique words then save them to a dictionary

# To read tables contained within the pdf files, I'm using the tabula.py library
# To install tabula.py on Python3 in windows OS, ensure Java version 8 is installed. 
# Next, open a command-prompt window, browse to python directory and execute the command, pip3 install tabula.py

import tabula, os, re, string
from collections import Counter

# path to pdf files
filePath = "C:\\Users\\Ashoo\\Documents\\PythonPlayground\\text-analysis\\data\\pdf"

stripped = [] # initialize an empty string

for filename in os.listdir(filePath): 
    # search for files ending with .txt extension and read them in memory
    if filename.strip().endswith('.pdf'):
        print(filename)
        # Mote: python will read the pdf file as 'rb' or 'wb' as a binary read and write format
        with(open(os.path.join(filePath,filename),'rb')) as pdfFiles:
            #df= tabula.read_pdf(f, stream=True)[0]
            
            # read all pdf pages
            df= tabula.read_pdf(pdfFiles, pages="all")
            print(df)
            
            # convert pdf table to csv format
            tabula.convert_into(pdfFiles, "pdf_to_csv.csv", output_format="csv", stream=True)
    pdfFiles.close()
