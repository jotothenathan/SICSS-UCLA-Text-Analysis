################################################################################
#                                                                              #
#   SICSS-UCLA Final Project: Royals on Reddit                                 #
#   Jonathan D. Ware                                                           #
#   June 29, 2021                                                              #
#                                                                              #
################################################################################

# Environment setup for Pulling Data from Reddit. Code pulls reddit posts before
# and after Oprah interviews Prince Harry and Meghan Markle for later semantic
# analysis to assess impact of interview on Reddit discourse.

# Install needed packages

library(RedditExtractoR)
library(dplyr)
library(magrittr)

# Check if packages loaded properly

data_sources <- reddit_urls(
  search_terms   = "Markle",
  page_threshold = 1,
  subreddit = "UnitedKingdom"
)

# Pull posts that meet a certain time frame via 'while'
# Start with posts before the Oprah Interview

i <- 1
min_date <- as.Date("2020/01/20")
max_date <- as.Date("2021/03/06")

Post_min <- min_date +1

while(Post_min > min_date){
  
  before_interview <- reddit_urls(search_terms = 'Markle', subreddit = 'unitedkingdom', page_threshold = 100, sort_by = "new") %>%
    mutate(date = as.Date(date, "%d-%m-%y"))
  
  i <- i+1
  Post_min <- min(before_interview$date)
}

before_interview %<>% filter(date >=min_date  & date <=max_date)

View(before_interview)

comments_before <- reddit_content(before_interview$URL[6])
View(comments_before)

# Pull threads after interview

i <- 1
min_date <- as.Date("2021/03/07")
max_date <- as.Date("2021/06/26")

Post_min <- min_date +1

while(Post_min > min_date){
  
  after_interview <- reddit_urls(search_terms = 'Markle', subreddit = 'unitedkingdom', page_threshold = 100, sort_by = "new") %>%
    mutate(date = as.Date(date, "%d-%m-%y"))
  
  i <- i+1
  Post_min <- min(after_interview$date)
}

after_interview %<>% filter(date >=min_date  & date <=max_date)


comments_after <- reddit_content(Data_out$URL[1])

# Specify only include threads with >2500 comments 

getcomments <- get_reddit(
  search_terms = "Prince Harry",
  page_threshold = 1,
  cn_threshold = 2500
)

# Visualize structure of first thread in data set

g <- construct_graph(comments, plot = TRUE) #plots hierarchical stricture 
plot(g) #provides basic graph of comment network

# Plot comment network with author name 
user <- user_network(comments, include_author = TRUE, agg = TRUE)
user$plot

# Semantic analysis stuff

posttext <- comments_before %>%
  select(comment) %>%
  unnest_tokens("word", comment)