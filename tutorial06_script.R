# R introduction to Twitter scraping
# Social Computing - The Univeristy of Melbourne
# Created August 2018 - Niels van Berkel

# Install required packages for scraping Twitter data
# install.packages("twitteR")
library("twitteR")

# Authenticate with Twitter. I set up a developer account which can be used for this subject only.
# Create your own account at developer.twitter.com if interested in more serious applications.

# Please do not test the limits of the API as that can result in the account being shut down.
# Same goes with scraping of 'questionable' content, use your own account for that if interested.

# The lecturer will provide you with letters to complete the secret strings
lecture_secret_1 <- ""
lecture_secret_2 <- ""

account_key <- "g4nlVMLIYueBZAz45770FpoNh"
account_secret <- paste("teLnox4GoVXheXhtfhBBE8rsNf6VqnvesG9Lk7rYsnXhRUaLJ", lecture_secret_1, sep = "")
access_token <- "1022637363845951503-O9aXVu2eUrClQCR5Y8RSBaAZRsiD8o"
access_secret <- paste("wzoU6gdgShcESiFdcBjNRGjR10ixwkbUWQBitSMpEaUW", lecture_secret_2, sep = "")

setup_twitter_oauth(account_key, account_secret, access_token, access_secret)
# Choose either 0 or 1 in the console below, does not matter at this point.

# Scraping of tweets by hashtag / topic:
tweets <- searchTwitter("#studentlife",n=100,lang="en",resultType="recent")

# Convert collected tweets to a dataframe for easy access
tweets <- twListToDF(tweets)
# Explore the data object, what information is contained in a Tweet other than the text?
tweets


# Remove URL information
tweets$stripped_text <- gsub("http.*","",  tweets$text)
tweets$stripped_text <- gsub("http.*","",  tweets$stripped_text)

# Lets use the tidytext library to 'clean up' our tweets. Removes punctuation, capitals, etc.
# install.packages("tidytext")
library(tidytext)
library(dplyr)
library(ggplot2)

tweets_cleaned <- tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)

# plot the top 15 words -- notice any issues?
tweets_cleaned %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")


data("stop_words")
head(stop_words)

# Add custom words to the stop words. For example 'rt' shows up a lot. Guess why?
str(stop_words)
df <- data.frame("rt","SMART")
names(df)<-c("word","lexicon")

stop_words <- rbind(stop_words, df)



nrow(tweets_cleaned)
# remove stop words from your list of words
tweets_cleaned <- tweets_cleaned %>%
  anti_join(stop_words)
nrow(tweets_cleaned)

# plot again
tweets_cleaned %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")

# Load dictionary with -5 to 5 sentiment score assigned to each word
afinn <- get_sentiments("afinn")
# Load dictionary with positive / negative sentiment words
bing <- get_sentiments("bing") %>% 
  count(sentiment)

sentiment_tweets <- tweets_cleaned %>%
  inner_join(afinn) %>%
  count(word, sort = TRUE)

sentiment_tweets <- merge(sentiment_tweets, afinn, by = "word")

# install.packages("wordcloud")
library(wordcloud)

tweets_cleaned %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 1000))
