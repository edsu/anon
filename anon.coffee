#!/usr/bin/env coffee

ipv6          = require 'ipv6'
Twit          = require 'twit'
minimist      = require 'minimist'
Mustache      = require 'mustache'
{WikiChanges} = require 'wikichanges'

argv = minimist process.argv.slice(2), default:
  verbose: false
  config: './config.json'

address = (ip) ->
  if ':' in ip
    i = new ipv6.v6.Address(ip)
  else
    i = new ipv6.v4.Address(ip)

ipToInt = (ip) ->
  i = address(ip)
  i.bigInteger()

compareIps = (ip1, ip2) ->
  r = ipToInt(ip1).compareTo(ipToInt(ip2))
  if r == 0
    0
  else if r > 0
    1
  else
    -1

isIpInRange = (ip, block) ->
  if Array.isArray block
    compareIps(ip, block[0]) >= 0 and compareIps(ip, block[1]) <= 0
  else
    a = address(ip)
    b = address(block)
    if not a.v4 and b.v4
      b = new ipv6.v6.Address('::ffff:' + block)
    a.isInSubnet(b)

isIpInAnyRange = (ip, blocks) ->
  blocks.filter((block) -> isIpInRange(ip, block)).length > 0

getConfig = (path) ->
  config = loadJson path
  # see if ranges are externally referenced as a separate .json files
  if config.accounts
    for account in config.accounts
      if typeof account.ranges == 'string'
        account.ranges = loadJson account.ranges
  config

loadJson = (path) ->
  if path[0] != '/' and path[0..1] != './'
    path = './' + path
  require path

getStatusLength = (edit, name, template) ->
  # returns length of the tweet based on shortened url
  # https://support.twitter.com/articles/78124-posting-links-in-a-tweet
  fakeUrl = 'http://t.co/BzHLWr31Ce'
  status = Mustache.render template, name: name, url: fakeUrl, page: edit.page
  status.length

getStatus = (edit, name, template) ->
  len = getStatusLength edit, name, template
  if len > 140
    newLength = edit.page.length - (len - 139)
    page = edit.page[0..newLength]
  else
    page = edit.page
  Mustache.render template,
    name: name
    url: edit.url
    page: page

tweet = (account, status) ->
  console.log status
  unless argv.noop
    twitter = new Twit account
    twitter.post 'statuses/update', status: status, (err) ->
      console.log err if err

inspect = (account, edit) ->
  if edit.url
    if argv.verbose
      console.log edit.url
    if account.whitelist and account.whitelist[edit.wikipedia] \
        and account.whitelist[edit.wikipedia][edit.page]
      status = getStatus edit, edit.user, account.template
      tweet account, status
    else if account.ranges and edit.anonymous
      for name, ranges of account.ranges
        if isIpInAnyRange edit.user, ranges
          status = getStatus edit, name, account.template
          console.log edit.user
          tweet account, status

main = ->
  config = getConfig argv.config
  wikipedia = new WikiChanges ircNickname: config.nick
  wikipedia.listen (edit) ->
    for account in config.accounts
      inspect account, edit

if require.main == module
  main()

# export these for testing
exports.compareIps = compareIps
exports.isIpInRange = isIpInRange
exports.isIpInAnyRange = isIpInAnyRange
exports.ipToInt = ipToInt
exports.getStatus = getStatus
exports.main = main
