# Objective: Read a novel from project gutenberg and then tidy it. Thereafter, count the number of words, and perform basic sentiment analysis
# Script name: tidy_text_analysis_01.R

library(gutenbergr)
library(tidytext)
library(tidyverse)
library(tm) # for Corpus()

# Show all gutenberg works in the gutenbergr package
gutenberg_works<- gutenberg_works(languages = "en")
View(gutenberg_works)
# The id for Bram Stoker's Dracula is 345
dracula<- gutenberg_download(345)
View(dracula)
str(dracula)

#head(dracula_stripped,169)
#tail(dracula_stripped,15482)

dracula_tidy<- dracula%>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by="word") 
# DATA PREPROCESSING & INITIAL VISUALIZATION

# Lets create a custom theme
mytheme<- theme_bw()+
  theme(plot.title = element_text(color = "darkred"))+
  theme(panel.border = element_rect(color = "steelblue", size = 2))+
  theme(plot.title = element_text(hjust = 0.5)) # where 0.5 is to center

# From the count of common words from above code, now plotting the most common words
dracula_tidy %>%
  count(word, sort = TRUE) %>%
  filter(n >100  & n<400) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  #xlab(NULL) +
  coord_flip()+
  mytheme+
  ggtitle("Top words in Bam Stoker's Dracula")

# convert to corpus
novel_corpus<- Corpus(VectorSource(dracula_tidy[,2]))
# build a document term matrix. Document matrix is a table containing the frequency of the words.
dtm<- DocumentTermMatrix(novel_corpus)
# preprocessing the novel data
novel_corpus_clean<- tm_map(novel_corpus, tolower)
novel_corpus_clean<- tm_map(novel_corpus, removeNumbers)
novel_corpus_clean<- tm_map(novel_corpus, removeWords, stopwords("english")) 
novel_corpus_clean<- tm_map(novel_corpus, removePunctuation)
# To see the first few documents in the text file
inspect(novel_corpus)[1:10]
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
# Plot word frequencies
barplot(words_df[1:10,]$freq, las = 2, names.arg = words_df[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")