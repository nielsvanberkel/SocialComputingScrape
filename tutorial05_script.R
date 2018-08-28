# R introduction to Twitter scraping
# Social Computing - The Univeristy of Melbourne
# Created August 2018 - Niels van Berkel

# Install required packages for scraping Twitter data
install.packages("twitteR")
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
# afl_tweets <- searchTwitter("#AFL",n=100,lang="en")

# Convert collected tweets to a dataframe for easy access
afl_tweets <- twListToDF(afl_tweets)
# Explore the data object, what information is contained in a Tweet other than the text?
afl_tweets

# Scraping of tweets by specific user:
# HughJackman_tweets <- searchTwitter("@RealHughJackman",n=40,lang="en")
HughJackman_tweets <- twListToDF(HughJackman_tweets)

# Scraping of tweets by language
# Lets look for Dutch (NL) tweets on Amsterdam!
# amsterdam_tweets_nl <- searchTwitter("Amsterdam",n=40,lang="nl")
amsterdam_tweets_nl <- twListToDF(amsterdam_tweets_nl)
# Lets look for Chinese / Mandarin (ZH) tweets on Amsterdam!
# amsterdam_tweets_zh <- searchTwitter("Amsterdam",n=40,lang="zh")
amsterdam_tweets_zh <- twListToDF(amsterdam_tweets_zh)
# Did you see the warning message in the console? We requested 40 tweets in Chinese on Amsterdam, but there are not that many available.
# This is a restriction on the free Twitter API - only recent tweets are available.

# Search twitter for tweets from a specific user.
# If not very active on Twitter (like the example), you may receive only one or even zero tweets.
# foo <- searchTwitter("from:nielsvberkel",n=40,lang="en",resultType = "recent")

# Search twitter for your own topic of interest. Change variable names accordingly.
# foo <- searchTwitter("#bar",n=40,lang="en")

# Create dataframe of scraped tweets (write your own code here)
# ...

# Now that we have some tweets, can we do a simple analysis?

# What is the average number of retweets for the Dutch / Chinese tweets on Amsterdam?
mean(amsterdam_tweets_nl$retweetCount)
mean(amsterdam_tweets_zh$retweetCount)
# Can you explain the difference?

# What is the maximum number of 'favourites' received by any tweet among the AFL tweets?
max(afl_tweets$favoriteCount)
# Select that tweet using code
afl_tweets[which.max(afl_tweets$favoriteCount),]


# Creating Plots

# Install and load required packages for creating plots
install.packages("ggplot2")
library("ggplot2")

# Plot a histogram based on the time of the tweet
ggplot(data = afl_tweets, aes(x = created)) + geom_histogram()

# Plot the retweetCount count against the time of the tweet
ggplot(data = afl_tweets, aes(x = created, y = retweetCount,  color = isRetweet)) + geom_point()


# Using Geo Location

# Scraping for tweets near Melbourne city (Using the location of Flinders Street Station)
# melb_tweets <- searchTwitter("melbourne", n=500, lang="en", geocode = "-37.818065,144.967963,1mi")

# Convert collected tweets to a dataframe
melb_tweets <- twListToDF(melb_tweets)

# Convert latitude and longitude to numeric values
melb_tweets$latitude <- as.numeric(melb_tweets$latitude)
melb_tweets$longitude <- as.numeric(melb_tweets$longitude)

# Install and load required packages for creating maps
install.packages("ggmap")
library("ggmap")

# Create a map of Melbourne city
map <- qmap('Melbourne', zoom=15)

# Add a layer of points which shows the tweet locations
map <- map + geom_point(data = melb_tweets, aes(x=longitude, y=latitude), size = 2, color = 'red')

# Print the map
map


# Backup option
# Receiving errors because classmates overloaded the account? Load 1000 pre-collected #AFL tweets from Niels' server:
# afl_tweets <- read.csv('https://www.nielsvanberkel.com/files/afl_tweets.csv')
