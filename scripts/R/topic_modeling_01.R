# Topic Modelling - 01

# resources
# https://www.kaggle.com/regiso/tips-and-tricks-for-building-topic-models-in-r
# https://www.tidytextmining.com/topicmodeling.html
# http://www.bernhardlearns.com/2017/05/topic-models-lda-and-ctm-in-r-with.html
# https://cran.r-project.org/web/packages/tidytext/vignettes/topic_modeling.html


library(dplyr)
library(gutenbergr)
titles <- c("Twenty Thousand Leagues under the Sea", "The War of the Worlds",
            "Pride and Prejudice", "Great Expectations")
books <- gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")
books

library(tidytext)
library(stringr)
library(tidyr)

by_chapter <- books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, regex("^chapter ", ignore_case = TRUE)))) %>%
  ungroup() %>%
  filter(chapter > 0)

by_chapter_word <- by_chapter %>%
  unite(title_chapter, title, chapter) %>%
  unnest_tokens(word, text)

word_counts <- by_chapter_word %>%
  anti_join(stop_words) %>%
  count(title_chapter, word, sort = TRUE)

word_counts

# Latent Dirichlet Allocation with the topicmodels package
# Right now this data frame is in a tidy form, with one-term-per-document-per-row. However, the topicmodels package requires a DocumentTermMatrix (from the tm package). As described in this vignette, we can cast a one-token-per-row table into a DocumentTermMatrix with tidytext’s cast_dtm:
  
chapters_dtm <- word_counts %>%
  cast_dtm(title_chapter, word, n)

chapters_dtm

# Now we are ready to use the topicmodels package to create a four topic LDA model.

library(topicmodels)
chapters_lda <- LDA(chapters_dtm, k = 4, control = list(seed = 1234))
chapters_lda
chapters_lda_td <- tidy(chapters_lda)
chapters_lda_td
top_terms <- chapters_lda_td %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms
library(ggplot2)
theme_set(theme_bw())

top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ topic, scales = "free") +
  theme(axis.text.x = element_text(size = 15, angle = 65, hjust = 1))
