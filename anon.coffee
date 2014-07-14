Netmask     = require('netmask').Netmask
minimist    = require 'minimist'
WikiChanges = require('wikichanges').WikiChanges

argv = minimist process.argv.slice(2), default: config: './config.json'

ipToInt = (ip) ->
  octets = (parseInt(s) for s in ip.split('.'))
  result = 0
  result += n*Math.pow(255,i) for n,i in octets.reverse()
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

loadNotifier = (config) ->
  notifier_class = require("./notifiers/#{config['notifier']}").notifier
  return new notifier_class(config)
  
main = ->
  config = require(argv.config)
  notifiers = (loadNotifier(c) for c in config['notifiers'])

  wikipedia = new WikiChanges(ircNickname: config.nick)
  wikipedia.listen (edit) ->
    # if we have an anonymous edit, then edit.user will be the ip address
    # we iterate through each group of ip ranges looking for a match
    if edit.anonymous
      for name, ranges of config.ranges
        if isIpInAnyRange edit.user, ranges
          status = edit.page + ' Wikipedia article edited anonymously by ' + name + ' ' + edit.url
          console.log status
          return if argv.noop
          notifier.notify(status) for notifier in notifiers
          return

if require.main == module
  main()

# export these for testing
exports.compareIps = compareIps
exports.isIpInRange = isIpInRange
exports.isIpInAnyRange = isIpInAnyRange
exports.run = main
