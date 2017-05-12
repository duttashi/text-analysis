# script title: initialScript-1.R
# Task: Accessing and comparing word frequency data

## comparing the usage of he vs. she and him vs. her
novel.wordsonly.freq.sorted["he"] # "he" occurs 1876 times
novel.wordsonly.freq.sorted["she"] # "she" occurs 114 times
novel.wordsonly.freq.sorted["him"] # "him" occurs 1058 times
novel.wordsonly.freq.sorted["her"] # "her" occurs 330 times
### This clearly indicates that moby dick is a male oriented book
novel.wordsonly.freq.sorted["him"]/novel.wordsonly.freq.sorted["her"] # him is 3.2 times more frequent than her
novel.wordsonly.freq.sorted["he"]/novel.wordsonly.freq.sorted["she"] # he is 16 times more frequent than she

## calculating the relative frequency of the words
novel.wordsonly.relfreq<- 100*(novel.wordsonly.freq.sorted/sum(novel.wordsonly.freq.sorted))
novel.wordsonly.relfreq["the"] # "the" occurs 6.6 times per every 100 words in the novel Moby Dick

plot(novel.wordsonly.relfreq[1:10], type="b",
     xlab="Top Ten Words", ylab="Percentage of Full Text", xaxt ="n")
axis(1,1:10, labels=names(novel.wordsonly.relfreq [1:10]))
