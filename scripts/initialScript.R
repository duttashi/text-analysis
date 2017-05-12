
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

