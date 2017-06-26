# Objective: Read a novel from project gutenberg and then tidy it. Thereafter, count the number of words, and perform basic sentiment analysis
# Script name: tidy_text_analysis_01.R

library(gutenbergr)
library(tidytext)
library(tidyverse)

# Show all gutenberg works in the gutenbergr package
gutenberg_works<- gutenberg_works(languages = "en")
View(gutenberg_works)
# The id for Bram Stoker's Dracula is 345
dracula<- gutenberg_download(345)
dracula_stripped<- gutenberg_strip(dracula$text)

#head(dracula_stripped,169)
#tail(dracula_stripped,15482)

# DATA PREPROCESSING & INITIAL VISUALIZATION

