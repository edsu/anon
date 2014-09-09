#!/usr/bin/env coffee

ipv6          = require 'ipv6'
async         = require 'async'
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
    subnetMask = 96 + i.subnetMask
    ip = '::ffff:' + i.toV6Group() + "/" + subnetMask
    i = new ipv6.v6.Address(ip)

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
        delete account.ranges['@metadata']
  console.log "loaded config from", path
  config

loadJson = (path) ->
  if path[0] != '/' and path[0..1] != './'
    path = './' + path
  require path

getStatusLength = (edit, name, template) ->
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

lastChange = {}
isRepeat = (edit) ->
  k = "#{edit.wikipedia}"
  v = "#{edit.page}:#{edit.user}"
  r = lastChange[k] == v
  lastChange[k] = v
  return r

tweet = (account, status, edit) ->
  console.log status
  unless argv.noop or (account.throttle and isRepeat(edit))
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
      tweet account, status, edit
    else if account.namespaces? and \
        (edit.namespace not in account.namespaces) then
    else if account.ranges and edit.anonymous
      for name, ranges of account.ranges
        if isIpInAnyRange edit.user, ranges
          status = getStatus edit, name, account.template
          tweet account, status, edit

checkConfig = (config, error) ->
  if config.accounts
    async.each config.accounts, canTweet, error
  else
    error "missing accounts stanza in config"

canTweet = (account, error) ->
  try
    twitter = new Twit account
    a = account['access_token']
    twitter.get 'search/tweets', q: 'cats', (err, data, response) ->
      if err
        error err + " for access_token " + a
      else if not response.headers['x-access-level'] or \
          response.headers['x-access-level'].substring(0,10) != 'read-write'
        error "no read-write permission for access token " + a
      else
        error null
  catch err
    error "unable to create twitter client for account: " + account

main = ->
  config = getConfig argv.config
  checkConfig config, (err) ->
    if not err
      wikipedia = new WikiChanges ircNickname: config.nick
      wikipedia.listen (edit) ->
        for account in config.accounts
          inspect account, edit
    else
      console.log err

if require.main == module
  main()

# for testing
exports.address = address
exports.compareIps = compareIps
exports.isIpInRange = isIpInRange
exports.isIpInAnyRange = isIpInAnyRange
exports.ipToInt = ipToInt
exports.getStatus = getStatus
exports.main = main
