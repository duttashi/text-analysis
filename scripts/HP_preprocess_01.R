

# clear the workspace
rm(list=ls())

# load harrypotter books from the package harrypotter
library(devtools)
devtools::install_github("bradleyboehmke/harrypotter")
# load the relevant libraries
library(tidyverse)      # data manipulation & plotting
library(stringr)        # text cleaning and regular expressions
library(tidytext)       # provides additional text mining functions
library(harrypotter)    # provides the first seven novels of the Harry Potter series

# read the first two books
titles <- c("Philosopher's Stone", "Chamber of Secrets")
books <- list(philosophers_stone, chamber_of_secrets)

# sneak peak into the first two chapters of chamber of secrets book
chamber_of_secrets[1:2]
