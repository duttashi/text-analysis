# Objective #1: To read multiple text files in a given directory & write content of each text file to a list
# Objective #2: To search for a given text string in each file and write its line number to a dictionary and print it

import re, os, string
from collections import Counter

fileData = [] # initialize an empty list
stripped = []
phrase = [] # initialize an empty list
searchPhrase = 'beauty'

# the path to text files
filePath = "C:\\Users\\Ashoo\\Documents\\PythonPlayground\\text-analysis\\data\\plainText"
for filename in os.listdir(filePath): 
    # search for files ending with .txt extension and read them in memory
    if filename.strip().endswith('.txt'):
        print(filename)
        with(open(os.path.join(filePath,filename),'rt')) as f:
            try:
                # read all text with newlines included and save data to variable
                fileTxt = f.read() 
                f.close()
                
                # basic text cleaning process
                # using re library, split the text data into words
                words = re.split(r'\W+', fileTxt)
                # add split words to a list and lowercase them
                words = [word.lower() for word in words]
                # using string library, remove punctuation from words and save in table format
                table = str.maketrans('', '', string.punctuation)
                # concatenating clean data to list
                stripped += [w.translate(table) for w in words]   
                
                # search for a given string in clean text. If found then print the line number
                for num, line in enumerate(stripped,1):
                    if(searchPhrase in line):
                        print(searchPhrase, " found at line number: ",num)
            
            # if file not found, log an error        
            except IOError as e:
                logging.error('Operation failed: {}' .format(e.strerror))
                sys.exit(0)
                
        # create a dictionary that stores the unique words found in the text files 
        countlist = Counter(stripped) 

print("Count of uniique words in text files", filename, " are: ")
# print the unique word and its frequency of occurence
for key, val in countlist.items():
    print(key, val)

# print end of program statement
print("End")