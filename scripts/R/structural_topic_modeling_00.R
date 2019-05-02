# Objective: To Explore Topic Modeling and Structural Topic Modeling, what is it and how it is useful for text mining?
# script create date: 10/11/2018
# script modified date: 
# script name: structural_topic_modeling_00.R

# Topic modelling- In machine learning and natural language processing, a topic model is a type of statistical model for discovering the abstract "topics" that occur in a collection of documents. Topic modeling is a frequently used text-mining tool for discovery of hidden semantic structures in a text body.
# The "topics" produced by topic modeling techniques are clusters of similar words. A topic model captures this intuition in a mathematical framework, which allows examining a set of documents and discovering, based on the statistics of the words in each, what the topics might be and what each document's balance of topics is.
# Topics can be defined as “a repeating pattern of co-occurring terms in a corpus”. A good topic model should result in – “health”, “doctor”, “patient”, “hospital” for a topic – Healthcare, and “farm”, “crops”, “wheat” for a topic – “Farming”.

# Algorithms for Topic Modeling
# Term Frequency,
# Inverse Document Frequency,
# NonNegative Matrix Factorization techniques,
# Latent Dirichlet Allocation is the most popular topic modeling technique 

# reference: http://www.structuraltopicmodel.com/
# reference: https://en.wikipedia.org/wiki/Topic_model
# reference: https://www.analyticsvidhya.com/blog/2016/08/beginners-guide-to-topic-modeling-in-python/
# reference: https://juliasilge.com/blog/sherlock-holmes-stm/
# reference: https://blogs.uoregon.edu/rclub/2016/04/05/structural-topic-modeling/
# reference: https://juliasilge.github.io/ibm-ai-day/slides.html#39

# load the required packages
library(tidyverse)
library(gutenbergr)
library(tidytext) # for unnest_tokens()
library(stm)

# Show all gutenberg works in the gutenbergr package
gutenberg_works<- gutenberg_works(languages = "en")
View(gutenberg_works)
# The id for novel, "The Adventures of Sherlock Holmes" is 1661
sherlock_raw<- gutenberg_download(1661)

sherlock <- sherlock_raw %>%
  mutate(story = ifelse(str_detect(text, "ADVENTURE"),
                        text,
                        NA)) %>%
  fill(story) %>%
  filter(story != "THE ADVENTURES OF SHERLOCK HOLMES") %>%
  mutate(story = factor(story, levels = unique(story)))

# create a custom function to reorder a column before plotting with facetting, such that the values are ordered within each facet.
# reference: https://github.com/dgrtwo/drlib
reorder_within <- function(x, by, within, fun = mean, sep = "___", ...) {
  new_x <- paste(x, within, sep = sep)
  stats::reorder(new_x, by, FUN = fun)
}

scale_x_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  ggplot2::scale_x_discrete(labels = function(x) gsub(reg, "", x), ...)
}

scale_y_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  ggplot2::scale_y_discrete(labels = function(x) gsub(reg, "", x), ...)
}

# Transform the text data into tidy format using `unnest_tokens()` and remove stopwords
sherlock_tidy<- sherlock %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by="word") %>%
  filter(word != "holmes")

sherlock_tidy %>%
  count(word, sort = TRUE)

# Determine the highest tf_idf words in the 12 stories on sherlock holmes? we will use the function bind_tf_idf() from the tidytext package

sherlock_tf_idf <- sherlock_tidy %>%
  count(story, word, sort = TRUE) %>%
  bind_tf_idf(word, story, n) %>%
  arrange(-tf_idf) %>%
  group_by(story) %>%
  top_n(10) %>%
  ungroup

sherlock_tf_idf %>%
  mutate(word = reorder_within(word, tf_idf, story)) %>%
  ggplot(aes(word, tf_idf, fill = story)) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ story, scales = "free", ncol = 3) +
  scale_x_reordered() +
  coord_flip() +
  theme(strip.text=element_text(size=11)) +
  labs(x = NULL, y = "tf-idf",
       title = "Highest tf-idf words in Sherlock Holmes short stories",
       subtitle = "Individual stories focus on different characters and narrative elements")

# Exploring tf-idf can be helpful before training topic models.
# let’s get started on a topic model! Using the stm package.
sherlock_sparse <- sherlock_tidy %>%
  count(story, word, sort = TRUE) %>%
  cast_sparse(story, word, n)

# Now training a topic model with 6 topics, but the stm includes lots of functions and support for choosing an appropriate number of topics for your model.
topic_model <- stm(sherlock_sparse, K = 6, 
                   verbose = FALSE, init.type = "Spectral")