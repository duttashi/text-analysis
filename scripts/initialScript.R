
# Load the data
text.data<- scan("data/plainText/melville.txt", what = "character", sep = "\n")
str(text.data)
text.data[1]
text.data[408] # The main text of the novel, "moby dick" begins at line 408
text.data[18576] # The main text of the novel, "moby dick" ends at line 18576

# To find out the begining & end of of the main text, do the following
text.start<- which(text.data=="CHAPTER 1. Loomings.") #408L
text.end<- which(text.data=="orphan.") #18576L
text.start
text.end

# what is the length of text
length(text.data) # there are 18,874 lines of text in the file
# save the metadata to a separate object
text.startmetadata<- text.data[1:text.start-1]
text.endmetadata<- text.data[(text.end+1):length(text.end)]
metadata<- c(text.startmetadata, text.endmetadata)
novel.data<- text.data[text.start: text.end]
head(novel.data)
tail(novel.data)

# Formatting the text for subsequent data analysis

## Get rid of line breaks "\n" such that all line are put into one long string.
## This is achived using paste function to join and collapse all lines into one long string
novel.data<- paste(novel.data, collapse = " ")
## The paste function with the collapse argument provides a way of gluing together a bunch of separate pieces using a glue character that you define as the value for the collapse argument. In this case, you are going to glue together the lines (the pieces) using a blank space character (the glue). 

# Data preprocessing
## convert all words to lowercase
novel.lower<- tolower(novel.data)
## extract all words only
novel.words<- strsplit(novel.lower, "\\W") # where \\W is a regex to match any non-word character.  
head(novel.words)
str(novel.words) # The words are contained in a list format

novel.words<- unlist(novel.words)
str(novel.words) # Convert list to a character vector

## Removing the blanks. First, find out the non blank positions
notblanks<- which(novel.words!="") 
head(notblanks)

novel.wordsonly<-novel.words[notblanks]
head(novel.wordsonly)
totalwords<-length(novel.wordsonly) # total words=214889 words
whale.hits<-length(novel.wordsonly[which(novel.wordsonly=="whale")]) # the word 'whale occurs 1150 times
whale.hits.perct<- whale.hits/totalwords
whale.hits.perct # The word whale occurs 0.005% times in whole text
length(unique(novel.wordsonly)) # there are 16,872 unique words in the novel
novel.wordsonly.freq<- table(novel.wordsonly) # the table() will build up the contigency table that contains the count of every word occurence
novel.wordsonly.freq.sorted<- sort(novel.wordsonly.freq, decreasing = TRUE) # sort the data with most frequent words first followed by least frequent words
head(novel.wordsonly.freq.sorted)
tail(novel.wordsonly.freq.sorted)

### Practice: Find the top 10 most frequent words in the text
novel.wordsonly.freq.sorted[c(1:10)]
### Practice: Visualize the top 10 most frequent words in the text
plot(novel.wordsonly.freq.sorted[c(1:10)])
