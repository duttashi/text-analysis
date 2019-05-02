# Script name: dispersion_plots.R
# vector to use: novel.wordsonly
# RQ: How to identify where in text, different words occur and how they behave over the course of the text/novel? 

# list files in working directory
ls()

# step 1: create a integer vector indicating position of each word in text
novel.time.v<- seq(1:length(novel.wordsonly)) # n.time.v
# step 2: Say, I want to see all occurences of the word, "whale" in the text
family.v<- which(novel.words == "family")
family.v
## Ultimately we want to create a dispersion plot where the x-axis is novel.time.v and the y-axis is the values need only be some reflection of the logical condition of TRUE where a family is found and FALSE or none found when an instance of family is not found
family.v.count<- rep(NA, length(novel.time.v)) # initialize a vector full of NA values
family.v.count[family.v]<-1 # using the numerical positions stored in the family.v object, so the resetting is simple with this expression
family.v.count

## Plot showing the distribution of the word, "family" across the novel
plot(family.v.count, main="Dispersion Plot of `family' in Moby Dick",
     xlab="Novel Time", ylab="family", type="h", ylim=c(0,1), yaxt='n')

man.v<- which(novel.words == "man")
man.v
## Ultimately we want to create a dispersion plot where the x-axis is novel.time.v and the y-axis is the values need only be some reflection of the logical condition of TRUE where a family is found and FALSE or none found when an instance of family is not found
man.v.count<- rep(NA, length(novel.time.v)) # initialize a vector full of NA values
man.v.count[man.v]<-1 # using the numerical positions stored in the family.v object, so the resetting is simple with this expression
man.v.count

## Plot showing the distribution of the word, "family" across the novel
plot(man.v.count, main="Dispersion Plot of `man' in Moby Dick",
     xlab="Novel Time", ylab="family", type="h", ylim=c(0,1), yaxt='n')