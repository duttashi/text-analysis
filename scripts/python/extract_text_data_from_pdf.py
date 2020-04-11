# Objective 1: Read multiple pdf files from a directory into a list
# Obkective 2: clean the pdf text data and find unique words then save them to a dictionary

# To read pdf files, I'm using the PyPDF2 library
# To install it on Python3 in windows OS, open a command-prompt window, browse to python directory and execute the command, pip3 install PyPDF2
# In my environment, I installed it like, `C:\Users\Ashoo\Miniconda3\pip3 install PyPDF2`
# Read the documentation of PyPDF2 library at https://pythonhosted.org/PyPDF2/
# # PyPDF2 uses a zero-based index for getting pages: The first page is page 0, the second is Introduction, and so on.

import re, os, string, PyPDF2
from collections import Counter

# path to pdf files
filePath = "C:\\Users\\Ashoo\\Documents\\PythonPlayground\\text-analysis\\data\\pdf"

stripped = [] # initialize an empty string

for filename in os.listdir(filePath): 
    # search for files ending with .txt extension and read them in memory
    if filename.strip().endswith('.pdf'):
        print(filename)
        # Mote: python will read the pdf file as 'rb' or 'wb' as a binary read and write format
        with(open(os.path.join(filePath,filename),'rb')) as f:
            
            # creating a pdf reader object
            pdfReader = PyPDF2.PdfFileReader(f)
                        
            # print the number of pages in pdf file
            number_of_pages = 0
            number_of_pages = pdfReader.getNumPages()
            #print(pdfReader.numPages)
            print("Number of pages in pdf file are: ", number_of_pages) 
            
            # create a page object and specify the page number to read.. say the first page
            #pageObj = pdfReader.getPage(0)
            # create a page object and read all pages in the pdf file
            # since page numbering starts from 0, therefore decreasing the value returned by method getNumPages by 1
            number_of_pages-=1 
            pageObj = pdfReader.getPage(number_of_pages)
            
            # extract the text from the pageObj variable
            pageContent = pageObj.extractText()
            print (pageContent.encode('utf-8'))
            
            # basic text cleaning process
            # using re library, split the text data into words
            words = re.split(r'\W+', pageContent)
            # add split words to a list and lowercase them
            words = [word.lower() for word in words]
            # using string library, remove punctuation from words and save in table format
            table = str.maketrans('', '', string.punctuation)
            # concatenating clean data to list
            stripped += [w.translate(table) for w in words]   
            
            # create a dictionary that stores the unique words found in the text files 
            countlist = Counter(stripped)                    
            
            
# print the unique word and its frequency of occurence
for key, val in countlist.items():
    print(key, val)

f.close()
# print end of program statement
print("End")
