

# clear the workspace
rm(list=ls())

# load harrypotter books from the package harrypotter
library(devtools)
devtools::install_github("bradleyboehmke/harrypotter")
# load the relevant libraries
library(tidyverse)      # data manipulation & plotting
library(stringr)        # text cleaning and regular expressions
library(tidytext)       # provides additional text mining functions
library(harrypotter)    # provides the first seven novels of the Harry Potter series
library(ggplot2)        # for data visualization

# read the first two books
titles <- c("Philosopher's Stone", "Chamber of Secrets")
books <- list(philosophers_stone, chamber_of_secrets)

# sneak peak into the first two chapters of chamber of secrets book
chamber_of_secrets[1:2]

# Tidying the text
# To properly analyze the text, we need to convert it into a data frame or a tibble.
typeof(chamber_of_secrets) # as you can see, at the moment it is a character vector
text_tb<- tibble(chapter= seq_along(philosophers_stone),
                 text=philosophers_stone)
str(text_tb)

# Unnest the text
# Its important to note that the unnest_token function does the following; splits the text into single words, strips all punctuation and converts each word to lowercase for easy comparability.
clean<-text_tb %>%
  unnest_tokens(word, text) 

clean_book<- tibble()
clean_book<- rbind(clean_book, clean)
clean_book

# Basic calculations
# calculate word frequency
word_freq <- clean_book %>%
  count(word, sort=TRUE)
word_freq 
# lots of stop words like the, and, to, a etc. Let's remove the stop words. 
# We can remove the stop words from our tibble with anti_join and the built-in stop_words data set provided by tidytext.
clean_book %>%
  anti_join(stop_words) %>%
  count(word, sort=TRUE) %>%
  top_n(10) %>%
  ggplot(aes(word,n))+
  geom_bar(stat = "identity")





