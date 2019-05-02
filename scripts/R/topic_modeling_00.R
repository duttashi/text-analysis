# Objective: Topic Modelling
# script create date: 27/4/2019
# reference: https://www.tidytextmining.com/topicmodeling.html

library(topicmodels)
data("AssociatedPress")
AssociatedPress
# set a seed so that the output of the model is predictable
ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))
#ap_lda

# word topic probabilities
library(tidytext)
ap_topics <- tidy(ap_lda, matrix = "beta")
ap_topics # the model is turned into a one-topic-per-term-per-row format.
          # For each combination, the model computes the probability of that term being generated from that topic. For example, the term “aaron” has a \(1.686917\times 10^{-12}\) probability of being generated from topic 1, but a \(3.8959408\times 10^{-5}\) probability of being generated from topic 2.

library(ggplot2)
library(dplyr)

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)
ap_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
