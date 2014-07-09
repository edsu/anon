Twit = require 'twit'
config = require './config.json'
wikichanges = require 'wikichanges'

# listen for Wikipedia changes
wikipedia = new wikichanges.WikiChanges(ircNickname: config.nick)

# configure Twitter client
twitter = new Twit config

# ranges from https://en.wikipedia.org/wiki/Wikipedia:Congressional_staffer_edits
ipRanges = [
  # House of Representatives
  /143\.228\.\d+\.\d+/
  /143\.231\.\d+\.\d+/
  # Senate
  /156\.33\.\d+\.\d+/
]

# send out a tweet
tweet = (edit) ->
  text = edit.page + ' Wikipedia article edited anonymously by Congress ' + edit.url
  console.log text
  twitter.post 'statuses/update', status: text, (err, data, response) ->
    if err
      console.log err

# listen for edits
wikipedia.listen (change) ->
  if change.anonymous
    for range in ipRanges
      if change.user.match(range)
        tweet(change)
