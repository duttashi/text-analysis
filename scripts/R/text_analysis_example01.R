# Sample script for text analysis with R
# Reference: Below is an example from https://github.com/juliasilge/tidytext
library(janeaustenr)
library(dplyr)

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number()) %>%
  ungroup()

original_books

library(tidytext)
tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books

data("stop_words")
tidy_books <- tidy_books %>%
  anti_join(stop_words)
tidy_books %>%
  count(word, sort = TRUE) 
# Sentiment analysis can be done as an inner join. Three sentiment lexicons are available via the get_sentiments() function. 
# sentiment analysis
library(tidyr)
get_sentiments("bing")

janeaustensentiment <- tidy_books %>%
  inner_join(get_sentiments("bing"), by = "word") %>% 
  count(book, index = linenumber %/% 80, sentiment) %>% 
  spread(sentiment, n, fill = 0) %>% 
  mutate(sentiment = positive - negative)

janeaustensentiment

library(ggplot2)

ggplot(janeaustensentiment, aes(index, sentiment, fill = book)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free_x")

