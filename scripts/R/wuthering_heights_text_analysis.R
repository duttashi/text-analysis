# clean the workspace environment
# Reference: http://tidytextmining.com/tidytext.html
# Reference: https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html

rm(list = ls())

# Load the required libraries
library(gutenbergr)
library(dplyr)
library(tidytext)
library(ggplot2)

# READ or DOWNLOAD THE DATA
# find the gutenberg title for analysis. Look for the "gutenberg_id"
gutenberg_works(title == "Wuthering Heights")

# Once the id is found, pass it as a value to function "gutenberg_download() as shown below
wuthering_heights <- gutenberg_download(768)

# Look at the data structure, its a tibble
head(wuthering_heights)
# Notice, it has two columns, the first column contains "gutenberg_id" and the second col contains the novel text.
# Do not remove the first column even though it contains a single repeating value 768, because, this column will be used subsequently for filtering data

# DATA PREPROCESSING & INITIAL VISUALIZATION

## Step 1: To create a tidy dataset, we need to restructure it in the one-token-per-row format, which as we saw earlier is done with the unnest_tokens() function.
tidy_novel_data<- wuthering_heights %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by="word") 

# use dplyr’s count() to find the most common words in the novel

tidy_novel_data %>%
  count(word, sort=TRUE)

# Lets create a custom theme
mytheme<- theme_bw()+
  theme(plot.title = element_text(color = "darkred"))+
  theme(panel.border = element_rect(color = "steelblue", size = 2))+
  theme(plot.title = element_text(hjust = 0.5)) # where 0.5 is to center

# From the count of common words from above code, now plotting the most common words
tidy_novel_data %>%
  count(word, sort = TRUE) %>%
  filter(n >100  & n<400) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  #xlab(NULL) +
  coord_flip()+
  mytheme+
  ggtitle("Top words in Wuthering Heights")

# WORDCLOUD
# load libraries
library("tm")
library("SnowballC")
library("wordcloud")

# convert to corpus
novel_corpus<- Corpus(VectorSource(tidy_novel_data[,2]))
# preprocessing the novel data
novel_corpus_clean<- tm_map(novel_corpus, tolower)
novel_corpus_clean<- tm_map(novel_corpus, removeNumbers)
novel_corpus_clean<- tm_map(novel_corpus, removeWords, stopwords("english")) 
novel_corpus_clean<- tm_map(novel_corpus, removePunctuation)
# To see the first few documents in the text file
inspect(novel_corpus)[1:10]

# build a document term matrix. Document matrix is a table containing the frequency of the words.
dtm<- DocumentTermMatrix(novel_corpus_clean)
# explicitly convert the document term matrix table to matrix format
m<- as.matrix(dtm)
# sort the matrix and store in a new data frame
word_freq<- sort(colSums(m), decreasing = TRUE)
# look at the top 5 words
head(word_freq,5)
# create a character vector 
words<- names(word_freq)
# create a data frame having the character vector and its associated number of occurences or frequency
words_df<- data.frame(word=words, freq=word_freq)

# create the first word cloud
set.seed(1234)
wordcloud (words_df$word, words_df$freq, scale=c(4,0.5), random.order=FALSE, rot.per=0.35, 
           use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"), max.words = 100)
# create the second word cloud
wordcloud (words_df$word, words_df$freq, scale=c(4,0.5), random.order=FALSE, rot.per=0.35, 
           use.r.layout=FALSE, colors=brewer.pal(8, "Accent"), max.words = 100)

# Explore frequent terms and their association with each other
findFreqTerms(dtm, lowfreq = 4)
findMostFreqTerms(dtm)
# You can analyze the association between frequent terms (i.e., terms which correlate) using findAssocs() function.
#findAssocs(dtm, terms = "master", corlimit = 0.3)

# Plot word frequencies
barplot(words_df[1:10,]$freq, las = 2, names.arg = words_df[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")

