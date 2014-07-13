Twit        = require 'twit'
Netmask     = require('netmask').Netmask
minimist    = require 'minimist'
WikiChanges = require('wikichanges').WikiChanges

argv = minimist process.argv.slice(2), default: config: './config.json'

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
  if Array.isArray block
    return compareIps(ip, block[0]) >= 0 and compareIps(ip, block[1]) <= 0
  else
    return new Netmask(block).contains ip

isIpInAnyRange = (ip, blocks) ->
  for block in blocks
    if isIpInRange(ip, block)
      return true
  return false

main = ->
  config = require(argv.config)
  twitter = new Twit config unless argv['noop']
  wikipedia = new WikiChanges(ircNickname: config.nick)
  wikipedia.listen (edit) ->
    # if we have an anonymous edit, then edit.user will be the ip address
    # we iterate through each group of ip ranges looking for a match
    if edit.anonymous
      for name, ranges of config.ranges
        if isIpInAnyRange edit.user, ranges
          status = edit.page + ' Wikipedia article edited anonymously by ' + name + ' ' + edit.url
          console.log status
          return if argv['noop']
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
exports.run = main
