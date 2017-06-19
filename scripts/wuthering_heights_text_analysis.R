# clean the workspace environment
# Reference: http://tidytextmining.com/tidytext.html
# Reference: https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html

rm(list = ls())

# Load the required libraries
library(gutenbergr)
library(dplyr)
library(magrittr)
library(tidytext)
library(ggplot2)

# find the gutenberg title for analysis. Look for the "gutenberg_id"
gutenberg_works(title == "Wuthering Heights")

# Once the id is found, pass it as a value to function "gutenberg_download() as shown below
wuthering_heights <- gutenberg_download(768)

# Look at the data structure, its a tibble
head(wuthering_heights)
# Notice, it has two columns, the first column contains "gutenberg_id" and the second col contains the novel text.
# Do not remove the first column even though it contains a single repeating value 768, because, this column will be used subsequently for filtering data

# Data preprocessing

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

