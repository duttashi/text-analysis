# We cannot work with the text data in machine learning so we need to convert them into numerical vectors,
# This script has all techniques for conversion
# A collection of functions for text data cleaning
# Script create date: May 1, 2023 location: Jhs, UP

def read_multiple_files(source_dir_path):
    import os
    dir_csv = [file for file in os.listdir(source_dir_path) if file.endswith('.csv')]
    files_csv_list = []
    for file in dir_csv:
        df = pd.read_csv(os.path.join(dir_csv, file))
        files_csv_list.append(df)
    return df

def clean_text(df_text):
    from nltk.corpus import stopwords
    from nltk.stem import SnowballStemmer
    import re
    stop = set(stopwords.words('english'))
    temp =[]
    snow = SnowballStemmer('english')
    for sentence in df_text:
        sentence = sentence.lower()                 # Converting to lowercase
        cleanr = re.compile('<.*?>')
        sentence = re.sub(cleanr, ' ', sentence)        #Removing HTML tags
        sentence = re.sub(r'[?|!|\'|"|#]',r'',sentence)
        sentence = re.sub(r'[.|,|)|(|\|/]',r' ',sentence)        #Removing Punctuations

    words = [snow.stem(word) for word in sentence.split() if word not in stopwords.words('english')]   # Stemming and removing stopwords
    temp.append(words)

    sent = []
    for row in temp:
        sequ = ''
        for word in row:
            sequ = sequ + ' ' + word
        sent.append(sequ)

    clean_sents = sent
    return clean_sents








