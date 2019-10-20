setwd("C:/Coursera/Capston_Project/Prediction_Algorithm")

# Readling the data sets
filename_blogs <- "../final/en_US/en_US.blogs.txt"
filename_news <- "../final/en_US/en_US.news.txt"
filename_twitter <- "../final/en_US/en_US.twitter.txt"
Blog_lines <- readLines(filename_blogs, skipNul = TRUE, encoding = "UTF-8")
News_lines <- readLines(filename_news, skipNul = TRUE, encoding = "UTF-8")
Twitter_lines <- readLines(filename_twitter, skipNul = TRUE, encoding = "UTF-8")

# Length of the files (number of lines)
n_blog_line <- length(Blog_lines)
n_news_line <- length(News_lines)
n_twitter_line <- length(Twitter_lines)

# Reformat 
Blog_lines <- iconv(Blog_lines, 'UTF-8', 'ASCII')
News_lines <- iconv(News_lines, 'UTF-8', 'ASCII')
Twitter_lines <- iconv(Twitter_lines, 'UTF-8', 'ASCII')

# Cleaning the data sets
library(dplyr)
library(tidyr)
library(tidytext)
library(stopwords)
set.seed(1234)
nsample <- 0.05*c(n_blog_line,n_news_line,n_twitter_line)
Sampled_raw_text <- c(sample(Blog_lines,size = nsample[1],replace = FALSE),sample(News_lines,size = nsample[2],replace = FALSE),sample(Twitter_lines,size = nsample[3],replace = FALSE))

Sampled_text <- Sampled_raw_text[complete.cases(Sampled_raw_text)]
Sampled_text <- gsub(pattern = "[^[:alpha:][:space:]]*", "", Sampled_text)
Sampled_text <- gsub(pattern = "http[^[:space:]]*", "", Sampled_text)
Sampled_text <- tolower(Sampled_text)
Sampled_text <- gsub(pattern = "\\b(\\w+) \\1\\b" , "\\1", Sampled_text)

Sampled_text <- data.frame(text = Sampled_text, stringsAsFactors = FALSE)

# unigrams <- Sampled_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 1) %>% count(bigram, sort = TRUE)
bigrams <- Sampled_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 2) %>% count(bigram, sort = TRUE) %>% separate(bigram, c("word1", "word2"), sep = " ")
trigrams <- Sampled_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 3) %>% count(bigram, sort = TRUE) %>% separate(bigram, c("word1", "word2", "word3"), sep = " ")
quagrams <- Sampled_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 4) %>% count(bigram, sort = TRUE) %>% separate(bigram, c("word1", "word2", "word3", "word4"), sep = " ")
# fivegrams <- Sampled_text %>% unnest_tokens(bigram, text, token = "ngrams", n = 5) %>% count(bigram, sort = TRUE) %>% separate(bigram, c("word1", "word2", "word3", "word4", "word5"), sep = " ")


# Saving on object in RData format
save(bigrams, file = "bigrams.RData")
save(trigrams, file = "trigrams.RData")
save(quagrams, file = "quagrams.RData")

load("bigrams.RData")
load("trigrams.RData")
load("quagrams.RData")

