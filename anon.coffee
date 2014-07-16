#!/usr/bin/env coffee

Twit        = require 'twit'
Netmask     = require('netmask').Netmask
minimist    = require 'minimist'
WikiChanges = require('wikichanges').WikiChanges
Mustache    = require('mustache')

argv = minimist process.argv.slice(2), default:
  verbose: false
  config: './config.json'

ipToInt = (ip) ->
  octets = (parseInt(s) for s in ip.split('.'))
  result = 0
  result += n * Math.pow(255, i) for n, i in octets.reverse()
  result

compareIps = (ip1, ip2) ->
  q1 = ipToInt(ip1)
  q2 = ipToInt(ip2)
  if q1 == q2
    r = 0
  else if q1 < q2
    r = -1
  else
    r = 1
  return r

isIpInRange = (ip, block) ->
  if Array.isArray block
    return compareIps(ip, block[0]) >= 0 and compareIps(ip, block[1]) <= 0
  else
    return new Netmask(block).contains ip

isIpInAnyRange = (ip, blocks) ->
  for block in blocks
    if isIpInRange(ip, block)
      return true
  return false

getConfig = (path) ->
  if path[0] != '/' and path[0..1] != './'
    path = './' + path
  return require(path)

main = ->
  config = getConfig(argv.config)
  twitter = new Twit config unless argv.noop
  wikipedia = new WikiChanges(ircNickname: config.nick)
  wikipedia.listen (edit) ->
    if not edit.url
      return
    if argv.verbose
      console.log edit.url
    if edit.anonymous
      for name, ranges of config.ranges
        if isIpInAnyRange edit.user, ranges
          status = Mustache.render config.template,
            page: edit.page
            name: name
            url: edit.url
          console.log status
          return if argv.noop
          twitter.post 'statuses/update', status: status, (err, d, r) ->
            if err
              console.log err
          return

if require.main == module
  main()

# export these for testing
exports.compareIps = compareIps
exports.isIpInRange = isIpInRange
exports.isIpInAnyRange = isIpInAnyRange
exports.ipToInt = ipToInt
exports.run = main
