Twit = require 'twit'

TwitterNotifier = (config) ->
  twitter = new Twit config unless argv['noop']

  notify = (status) -> 
    twitter.post 'statuses/update', status: status, (err, d, r) ->
    if err
      console.log err

  return this
  
exports.notifier = TwitterNotifier
