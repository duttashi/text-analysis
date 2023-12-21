import spacy
import numpy as np
import pandas as pd

# import the english language model
nlp = spacy.load("en_core_web_sm")

# dataset: https://www.kaggle.com/datasets/mrisdal/fake-news
# reference: https://www.kaggle.com/code/sudalairajkumar/getting-started-with-spacy
df = pd.read_csv("../../data/fake_news_data/fake.csv")
print(df.shape)
print(df.head())
print(df.columns)
print(df['title'].head())

txt = df['title'][0]
print(txt)
doc = nlp(txt)
olist = []
for token in doc:
    l = [token.text,
         token.idx,
         token.lemma_,
         token.is_punct,
         token.is_space,
         token.shape_,
         token.pos_,
         token.tag_]
    olist.append(l)

odf = pd.DataFrame(olist)
odf.columns = ["Text", "StartIndex", "Lemma", "IsPunctuation", "IsSpace", "WordShape", "PartOfSpeech", "POSTag"]
print(odf)

# Named Entity Recognition:
# A named entity is a "real-world object" that's assigned a name – for example, a person, a country, a product or a book title.
# We also get named entity recognition as part of spacy package. It is inbuilt in the english language model and we can also train our own entities if needed.
doc = nlp(txt)
olist = []
for ent in doc.ents:
    olist.append([ent.text, ent.label_])

odf = pd.DataFrame(olist)
odf.columns = ["Text", "EntityType"]
print(odf)