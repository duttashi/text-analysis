# data soruce: https://www.kaggle.com/maksymshkliarevskyi/reddit-data-science-posts

# clean the workspace
rm(list = ls())

# load required libraries
library(tidyverse)
library(tidyr)

# 1. reading multiple data files from a folder into separate dataframes
filesPath = "data/kaggle_reddit_data"
temp = list.files(path = filesPath, pattern = "*.csv", full.names = TRUE)
for (i in 1:length(temp)){
  nam <- paste("df",i, sep = "_")
  assign(nam, read_csv(temp[i], na=c("","NA")))
  }

#2. Read multiple dataframe created at step 1 into a list
df_lst<- lapply(ls(pattern="df_[0-9]+"), function(x) get(x))
typeof(df_lst)
#3. combining a list of dataframes into a single data frame
# df<- bind_rows(df_lst)
df<- plyr::ldply(df_lst, data.frame)
str(df)
dim(df) # [1] 469815     25

# Data Engineering: split col created_date into date and time
df$create_date<- as.Date(df$created_date)
df$create_time<- format(df$created_date,"%H:%M:%S")
df<- separate(df, create_date, c('create_year', 'create_month', 'create_day'), sep = "-",remove = TRUE)
df<- separate(df, create_time, c('create_hour', 'create_min', 'create_sec'), sep = ":",remove = TRUE)

# drop cols not required for further analysis
df$X1<- NULL
df$created_timestamp<- NULL
df$author_created_utc<- NULL
df$full_link<- NULL
df$post_text<- NULL
df$postURL<- NULL
df$title_text<- NULL
df$created_date<- NULL


# lowercase all character data
df$title<- tolower(df$title)
df$author<- tolower(df$author)
df$post<- tolower(df$post)

# extract url from post and save as separate column
url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
df$postURL <- str_extract_all(df$post, url_pattern)
df$postURL<- NULL
# df$post_text<- str_extract_all(df$post, boundary("word"))
# df$post_text<- str_extract_all(df$post, "[a-z]+")
# df$title_text<- str_extract_all(df$title, "[a-z]+")

# extract data from list
# head(df$post_text)
# df$postText<- sapply(df$post_text, function(x) x[1])
# str(df)

# filter out selected missing values
colSums(is.na(df))
df1<- df
df1 <- df1 %>%
  # filter number of comments less than 0. this will take care of 0 & -1 comments
  # filter(num_comments > 0 ) %>%
  # filter posts with NA
  filter(!is.na(post)) %>%
  # filter subreddit_subscribers with NA
  filter(!is.na(subreddit_subscribers)) %>%
  # filter crossposts with NA
  filter(!is.na(num_crossposts)) %>%
  # # filter create date, create time with NA
  filter(!is.na(create_year)) %>%
  filter(!is.na(create_month)) %>%
  filter(!is.na(create_day)) %>%
  filter(!is.na(create_hour)) %>%
  filter(!is.na(create_min)) %>%
  filter(!is.na(create_sec))
colSums(is.na(df1))
colnames(df1)
# rearrange the cols
df1<- df1[,c(3,10,14:15,11:13,1:2,4:9)]

df_clean <- df1
str(df_clean)
# 4. write combined partially clean data to disk
write_csv(df_clean, file = "data/kaggle_reddit_data/reddit_data_clean.csv")


  
  # filter character cols with only text data. remove all special characters data
  # filter(str_detect(str_to_lower(author), "[a-zA-Z]")) %>%
  # filter(str_detect(str_to_lower(title), "[a-zA-Z]")) %>%
  # filter(str_detect(str_to_lower(id),"[a-zA-Z0-9]")) %>%
  # filter(str_detect(str_to_lower(post),"[a-zA-Z]")) %>%
  # # separate date into 3 columns
  # separate(create_date, into = c("create_year","create_month","create_day")) %>%
  # # separate time into 3 columns
  # separate(create_time, into = c("create_hour","create_min","create_sec")) %>%
  # # coerce all character cols into factor
  # mutate_if(is.character,as.factor)

##
# df_clean<-df_clean %>%
#   filter(str_detect(str_to_lower(post), url_pattern)) 











