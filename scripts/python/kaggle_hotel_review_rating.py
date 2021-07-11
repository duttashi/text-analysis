# -*- coding: utf-8 -*-
"""
Created on Sun Jul 11 11:33:01 2021

@author: Ashish

Data source: https://www.kaggle.com/andrewmvd/trip-advisor-hotel-reviews
Objective: Hotel reviews rating prediction
"""

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import matplotlib.pyplot as plt
import seaborn as sns
import nltk
from nltk.corpus import stopwords
import string
import xgboost as xgb
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn.decomposition import TruncatedSVD
from sklearn import ensemble, metrics, model_selection, naive_bayes
color = sns.color_palette()

eng_stopwords = set(stopwords.words("english"))
pd.options.mode.chained_assignment = None

# import os

# cur_path = os.path.dirname(__file__)
# print(cur_path)

# Reference: https://github.com/SudalaiRajkumar/Kaggle/blob/master/SpookyAuthor/simple_fe_notebook_spooky_author.ipynb
# load the data
df = pd.read_csv("..\\..\\data\\kaggle_tripadvisor_hotel_reviews.csv")

# print(df.head(), df.shape)

## Feature Engineering
# Now let us come try to do some feature engineering. This consists of two main parts.

# Meta features - features that are extracted from the text like number of words, number of stop words, number of punctuations etc
# Text based features - features directly based on the text / words like frequency, svd, word2vec etc.
# Meta Features:

# We will start with creating meta featues and see how good are they at predicting the spooky authors. The feature list is as follows:

# Number of words in the text
# Number of unique words in the text
# Number of characters in the text
# Number of stopwords
# Number of punctuations
# Number of upper case words
# Number of title case words
# Average length of the words
## Number of words in the text ##
df["num_words"] = df["Review"].apply(lambda x: len(str(x).split()))
## Number of unique words in the text ##
df["num_unique_words"] = df["Review"].apply(lambda x: len(set(str(x).split())))

# Number of characters in text
df["num_chars"] = df["Review"].apply(lambda x: len(str(x)))

## Number of stopwords in the text ##
df["num_stopwords"] = df["Review"].apply(lambda x: len([w for w in str(x).lower().split() if w in eng_stopwords]))

## Number of punctuations in the text ##
df["num_punctuations"] =df['Review'].apply(lambda x: len([c for c in str(x) if c in string.punctuation]) )

## Number of title case words in the text ##
df["num_words_upper"] = df["Review"].apply(lambda x: len([w for w in str(x).split() if w.isupper()]))

## Number of title case words in the text ##
df["num_words_title"] = df["Review"].apply(lambda x: len([w for w in str(x).split() if w.istitle()]))

## Average length of the words in the text ##
df["mean_word_len"] = df["Review"].apply(lambda x: np.mean([len(w) for w in str(x).split()]))


print(df.columns)

# Let us now plot some of our new variables to see of they will be helpful in predictions.

df['num_words'].loc[df['num_words']>80] = 80 #truncation for better visuals
plt.figure(figsize=(12,8))
sns.violinplot(x='Rating', y='num_words', data=df)
plt.xlabel('Rating', fontsize=12)
plt.ylabel('Number of words in text', fontsize=12)
plt.title("Number of words by review", fontsize=15)
plt.show()

df['num_punctuations'].loc[df['num_punctuations']>10] = 10 #truncation for better visuals
plt.figure(figsize=(12,8))
sns.violinplot(x='Rating', y='num_punctuations', data=df)
plt.xlabel('Rating', fontsize=12)
plt.ylabel('Number of puntuations in text', fontsize=12)
plt.title("Number of punctuations by rating", fontsize=15)
plt.show()


# Initial Model building
## Prepare the data for modeling ###
review_mapping_dict = {1:"worse", 2:"bad", 3:"ok",4:"good",5:"best"}
train_y = df['Rating'].map(review_mapping_dict)

### recompute the trauncated variables again ###
df["num_words"] = df["Review"].apply(lambda x: len(str(x).split()))
df["mean_word_len"] = df["Review"].apply(lambda x: np.mean([len(w) for w in str(x).split()]))

cols_to_drop = ['Review']
train_X = df.drop(cols_to_drop+['Rating'], axis=1)
test_X = df.drop(cols_to_drop, axis=1)

# Training a simple XGBoost model
def runXGB(train_X, train_y, test_X, test_y=None, test_X2=None, seed_val=0, child=1, colsample=0.3):
    param = {}
    param['objective'] = 'multi:softprob'
    param['eta'] = 0.1
    param['max_depth'] = 3
    param['silent'] = 1
    param['num_class'] = 3
    param['eval_metric'] = "mlogloss"
    param['min_child_weight'] = child
    param['subsample'] = 0.8
    param['colsample_bytree'] = colsample
    param['seed'] = seed_val
    num_rounds = 2000

    plst = list(param.items())
    xgtrain = xgb.DMatrix(train_X, label=train_y)

    if test_y is not None:
        xgtest = xgb.DMatrix(test_X, label=test_y)
        watchlist = [ (xgtrain,'train'), (xgtest, 'test') ]
        model = xgb.train(plst, xgtrain, num_rounds, watchlist, early_stopping_rounds=50, verbose_eval=20)
    else:
        xgtest = xgb.DMatrix(test_X)
        model = xgb.train(plst, xgtrain, num_rounds)

    pred_test_y = model.predict(xgtest, ntree_limit = model.best_ntree_limit)
    if test_X2 is not None:
        xgtest2 = xgb.DMatrix(test_X2)
        pred_test_y2 = model.predict(xgtest2, ntree_limit = model.best_ntree_limit)
    return pred_test_y, pred_test_y2, model

kf = model_selection.KFold(n_splits=5, shuffle=True, random_state=2017)
cv_scores = []
pred_full_test = 0
pred_train = np.zeros([df.shape[0], 3])
for dev_index, val_index in kf.split(train_X):
    dev_X, val_X = train_X.loc[dev_index], train_X.loc[val_index]
    dev_y, val_y = train_y[dev_index], train_y[val_index]
    pred_val_y, pred_test_y, model = runXGB(dev_X, dev_y, val_X, val_y, test_X, seed_val=0)
    pred_full_test = pred_full_test + pred_test_y
    pred_train[val_index,:] = pred_val_y
    cv_scores.append(metrics.log_loss(val_y, pred_val_y))
    break
print("cv scores : ", cv_scores)
