# SENTIMENT ANALYSIS

# required packages
library(tidyverse)
library(tidytext)
library(stringi)
library(SentimentAnalysis)

# Analyze sentiment
sentiment<- analyzeSentiment(dtm, language = "english",
                             removeStopwords = TRUE)
# Extract dictionary-based sentiment according to the QDAP dictionary
sentiment$SentimentQDAP
# View sentiment direction (i.e. positive, neutral and negative)
convertToDirection(sentiment$SentimentQDAP)

# The three general-purpose lexicons available in tidytext package are
# 
# AFINN from Finn Årup Nielsen,
# bing from Bing Liu and collaborators, and
# nrc from Saif Mohammad and Peter Turney.

# I will use Bing lexicon which is simply a tibble with words and positive and negative words
get_sentiments("bing") %>% head

wuthering_heights %>%
  # split text into words
  unnest_tokens(word, text) %>%
  # remove stop words
  anti_join(stop_words, by = "word") %>%
  # add sentiment scores to words
  left_join(get_sentiments("bing"), by = "word") %>%
  # count number of negative and positive words
  count(word, sentiment) %>%
  spread(key = sentiment, value = n) %>%
  #ungroup %>%
  # create centered score
  mutate(sentiment = positive - negative - 
           mean(positive - negative)) %>%
  # select_if(sentiment) %>%
  # reorder word levels
  #mutate(word = factor(as.character(word), levels = levels(word)[61:1])) %>%
  # plot
  ggplot(aes(x = word, y = sentiment)) + 
  geom_bar(stat = "identity", aes(fill = word)) + 
  theme_classic() + 
  theme(axis.text.x = element_text(angle = 90)) + 
  coord_flip() + 
  #ylim(0, 200) +
  coord_cartesian(ylim=c(0,40)) +  # Explain ggplot2 warning: “Removed k rows containing missing values”
  ggtitle("Centered sentiment scores", 
          subtitle = "for Wuthering Heights")