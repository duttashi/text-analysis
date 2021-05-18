# read kaggle reddit comments clean file
# required file: data/kaggle_reddit_data/reddit_data_clean.csv

# clean the workspace
rm(list = ls())
# load required libraries
library(readr)
library(stringr)
library(tidyverse)
library(tidytext)

df<- read_csv(file = "data/kaggle_reddit_data/reddit_data_clean.csv")
str(df)
colnames(df)

# clean the 'post' column
# remove any url contained in post 
df$post_c <- gsub('http.* *', "", df$post) 
# remove any brackets contained in title
df$title_c <- gsub('\\[|]',"", df$title)
df$title_c <- gsub('\\?',"", df$title_c)
df$title_c <- gsub('\\!',"", df$title_c)

df1<- df %>%
  # add row number
  mutate(line=row_number()) %>%
  mutate(post_ct = replace(post_c, post_c == '', 'None')) %>%
  unnest_tokens(word, post_ct) %>%
  anti_join(get_stopwords()) %>%
  #mutate(word_count = count(word)) %>%
  inner_join(get_sentiments("bing")) %>% # pull out only sentiment words
  count(sentiment, word) %>% # count the # of positive & negative words
  spread(sentiment, n, fill = 0) %>% # made data wide rather than narrow
  mutate(sentiment = positive - negative) # # of positive words - # of negative owrds
str(df1)

df2<- df %>%
  # add row number
  mutate(line=row_number()) %>%
  mutate(post_ct = replace(post_c, post_c == '', 'None')) %>%
  unnest_tokens(word, post_ct) %>%
  anti_join(get_stopwords()) %>%
  group_by(author) %>%
  inner_join(get_sentiments("bing"))%>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup() %>%
  #slice_max(n, n = 10) %>%
  #ungroup() %>%
  mutate(word = reorder(word, n)) 
view(df2)

df2 %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)+
  theme_bw()

