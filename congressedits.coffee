Twit = require 'twit'
config = require './config.json'
wikichanges = require 'wikichanges'

# listen for Wikipedia changes
wikipedia = new wikichanges.WikiChanges(ircNickname: config.nick)

# configure Twitter client
twitter = new Twit config

# ranges from:
# https://en.wikipedia.org/wiki/Wikipedia:Congressional_staffer_edits
# https://github.com/govtrack/govtrack.us-web/blob/master/website/middleware.py

house = [
  ['143.231.0.0', '143.231.255.255']
  ['137.18.0.0', '137.18.255.255']
  ['143.228.0.0', '143.228.255.255']
  ['12.185.56.0', '12.185.56.7']
  ['12.147.170.144', '12.147.170.159']
  ['74.119.128.0', '74.119.131.255']
]

senate = [
  ['156.33.0.0', '156.33.255.255']
]

ipToQuad = (ip) ->
  return (parseInt(s) for s in ip.split('.'))

compareIps = (ip1, ip2) ->
  q1 = ipToQuad(ip1)
  q2 = ipToQuad(ip2)
  if "#{q1}" is "#{q2}"
    r = 0
  else if q1 < q2
    r = -1
  else
    r = 1
  return r

isIpInRange = (ip, block) ->
  return compareIps(ip, block[0]) >= 0 and compareIps(ip, block[1]) <= 0

isIpInAnyRange = (ip, blocks) ->
  for block in blocks
    if isIpInRange(ip, block)
      return true
  return false

tweet = (source, edit) ->
  text = edit.page + ' Wikipedia article edited anonymously by ' + source + ' ' + edit.url
  console.log text
  twitter.post 'statuses/update', status: text, (err, data, response) ->
    if err
      console.log err

main = ->
  wikipedia.listen (edit) ->
    if edit.anonymous
      if isIpInAnyRange edit.user, house
        tweet 'House of Representatives', edit
      else if isIpInAnyRange edit.user, senate
        tweet 'US Senate', edit

if require.main == module
  main()

# export these for testing

exports.compareIps = compareIps
exports.isIpInRange = isIpInRange
exports.isIpInAnyRange = isIpInAnyRange
