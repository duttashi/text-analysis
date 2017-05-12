# Script title: austen_text_analysis.R

# Load the data
austen.data<- scan("data/plainText/austen.txt", what = "character", sep = "\n")

# clear the workspace
rm(list=ls())

# find out the begining & end of of the main text
austen.start<-which(austen.data=="CHAPTER 1")
austen.start # main text begins from line 17
austen.end<-which(austen.data=="THE END")
austen.end # main text ends at line 10609

# save the metadata to a separate object
austen.startmeta<- austen.data[1:austen.start-1]
austen.endmeta<- austen.data[(austen.end+1):length(austen.end)]
metadata<- c(austen.startmeta, austen.endmeta)
novel.data<- austen.data[austen.start: austen.end]
head(novel.data)
tail(novel.data)

# Formatting the text for subsequent data analysis
novel.data<- paste(novel.data, collapse = " ")

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
totalwords<-length(novel.wordsonly) 

### Practice: Find the top 10 most frequent words in the text
novel.wordsonly.freq<- table(novel.wordsonly)
novel.wordsonly.freq.sorted<- sort(novel.wordsonly.freq, decreasing = TRUE)
novel.wordsonly.freq.sorted[c(1:10)]
### Practice: Visualize the top 10 most frequent words in the text
plot(novel.wordsonly.freq.sorted[c(1:10)])
## calculating the relative frequency of the words
novel.wordsonly.relfreq<- 100*(novel.wordsonly.freq.sorted/sum(novel.wordsonly.freq.sorted))

plot(novel.wordsonly.relfreq[1:10], type="b",
     xlab="Top Ten Words", ylab="Percentage of Full Text", xaxt ="n")
axis(1,1:10, labels=names(novel.wordsonly.relfreq [1:10]))