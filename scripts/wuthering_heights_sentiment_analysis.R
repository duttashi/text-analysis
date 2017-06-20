# SENTIMENT ANALYSIS

# required packages
library(tidyverse)
library(tidytext)
library(stringi)

# The three general-purpose lexicons available in tidytext package are
# 
# AFINN from Finn Årup Nielsen,
# bing from Bing Liu and collaborators, and
# nrc from Saif Mohammad and Peter Turney.

# I will use Bing lexicon which is simply a tibble with words and positive and negative words
get_sentiments("bing") %>% head
