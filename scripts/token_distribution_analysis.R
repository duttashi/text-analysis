
# clean the workspace
rm(list = ls())

# Load the data
text.v <- scan("data/plainText/melville.txt", what="character", sep="\n")
start.v <- which(text.v == "CHAPTER 1. Loomings.")
end.v <- which(text.v == "orphan.")
novel.lines.v <- text.v[start.v:end.v]
novel.lines.v

## Identify the chapter break positions in the vector using the grep function
chap.positions.v <- grep("^CHAPTER \\d", novel.lines.v) # (the start of a line is marked by use of the caret symbol ˆ. with the capitalized letters CHAPTER followed by a space and then any digit (digits are                                                                         represented using an escaped d, as in \\d)
novel.lines.v[chap.positions.v] # we can see there are 135 chapter headings

## Identify the text break positions in chapters
novel.lines.v <- c(novel.lines.v, "END")
last.position.v <- length(novel.lines.v)
chap.positions.v <- c(chap.positions.v , last.position.v)
## Now, we have to figure out how to process the text, that is, the actual content of each chapter that appears between each of these chapter markers. 
## We will use the for loop

for(i in 1:length(chap.positions.v)){
  print(paste("Chapter ",i, " begins at position ",
              chap.positions.v[i]), sep="")
} # end for
chapter.raws.l <- list()
chapter.freqs.l <- list()

for(i in 1:length(chap.positions.v)){
  if(i != length(chap.positions.v)){
    chapter.title <- novel.lines.v[chap.positions.v[i]]
    start <- chap.positions.v[i]+1
    end <- chap.positions.v[i+1]-1
    chapter.lines.v <- novel.lines.v[start:end]
    chapter.words.v <- tolower(paste(chapter.lines.v, collapse=" "))
    chapter.words.l <- strsplit(chapter.words.v, "\\W")
    chapter.word.v <- unlist(chapter.words.l)
    chapter.word.v <- chapter.word.v[which(chapter.word.v!="")]
    chapter.freqs.t <- table(chapter.word.v)
    chapter.raws.l[[chapter.title]] <- chapter.freqs.t
    chapter.freqs.t.rel <- 100*(chapter.freqs.t/sum(chapter.freqs.t))
    chapter.freqs.l[[chapter.title]] <- chapter.freqs.t.rel
  }
}
