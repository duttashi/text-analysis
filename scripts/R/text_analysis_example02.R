# clear the workspace
rm(list = ls())
# load the required libraries
library(tidytext)
library(magrittr)

# Read the text file
df<- scan("data/text_data_for_analysis.txt", what = "character", sep = "\n")

# basic eda
str(df)
typeof(df) # character vector

# convert all words to lowercase
df<- tolower(df)
## extract all words only
df<- strsplit(df, "\\W") # where \\W is a regex to match any non-word character.  
head(df)
df.words<- unlist(df)
## Removing the blanks. First, find out the non blank positions
notblanks<- which(df.words!="") 
head(notblanks)
df.wordsonly<-df.words[notblanks]
# Count the unique word occurences
length(unique(df.wordsonly)) # 194 unique words

# Accessing and understanding word data
df.wordsonly.freq<- table(df.wordsonly)
df.wordsonly.freq_sorted<- sort(df.wordsonly, decreasing = TRUE)
df.wordsonly.freq_sorted[c(1:10)]

length(df.wordsonly)
df.tbl<- tibble(idx=c(1:length(df.wordsonly)), text= df.wordsonly)
str(df.tbl)
library(tidytext)
library(dplyr) # for anti_join()
df.tbl<- df.tbl %>%
  unnest_tokens(idx, text)
str(df.tbl)

df.tbl.tidy %>%
  count(line, sort = TRUE)


