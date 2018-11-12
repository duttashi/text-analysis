# clear the workspace
rm(list = ls())

# Load the moby dick novel
mobydick.data<- scan("data/plainText/melville.txt", what = "character", sep = "\n")

# find out the begining & end of of the main text
mobydick.start<-which(mobydick.data=="CHAPTER 1. Loomings.")
mobydick.end<-which(mobydick.data=="orphan.")


# save the metadata to a separate object
mobydick.startmeta<- mobydick.data[1:mobydick.start-1]
mobydick.endmeta<- mobydick.data[(mobydick.end+1):length(mobydick.end)]
metadata<- c(austen.startmeta, austen.endmeta)
novel.data<- mobydick.data[mobydick.start: mobydick.end]
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

# Count the unique word occurences
length(unique(novel.wordsonly)) # 16,872 unique words
# count the number of whale hits
length(novel.wordsonly[novel.wordsonly=="whale"]) # 1,150 times the word whale appears

# Accessing and understanding word data
novel.wordsonly.freq.sorted["he"] # The word he occurs 1876 times
novel.wordsonly.freq.sorted["she"] # 114
novel.wordsonly.freq.sorted["him"] # 1058
novel.wordsonly.freq.sorted["her"] # 330

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

# Dispersion Analysis
whales.v<- which(novel.wordsonly="whale")




