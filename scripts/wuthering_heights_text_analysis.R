library(gutenbergr)
library(dplyr)
library(magrittr)

# find the gutenberg title for analysis. Look for the "gutenberg_id"
gutenberg_works(title == "Wuthering Heights")

# Once the id is found, pass it as a value to function "gutenberg_download() as shown below
wuthering_heights <- gutenberg_download(768)

# Look at the data structure
head(wuthering_heights)
# Notice, it has two columns, the first column contains "gutenberg_id" and the second col contains the novel text.
# extracting the novel text column and saving it as a data frame
text_data<-as.data.frame(wuthering_heights[,2])
typeof(text_data)
str(text_data)
text_data

# Reference: http://tidytextmining.com/tidytext.html
library(tidytext)
text_data %>%
  unnest_tokens(word, text)
