#!/usr/bin/env coffee

# this script will output a json dictionary of US Congress Wikipedia
# articles for the purpose of adding it to a config.json whitelist
#
# you'll need to:
#
#     npm install async request yaml

async = require 'async'
yaml = require 'yamljs'
request = require 'request'

whitelist = {}

urls = [
  # current legislators
  'https://raw.githubusercontent.com/unitedstates/congress-legislators/master/legislators-current.yaml',
  # historical legislators
  'https://raw.githubusercontent.com/unitedstates/congress-legislators/master/legislators-historical.yaml'
]

getWikipediaPages = (url, callback) ->
  res = request.get url, (e, r, b) ->
    for person in yaml.parse b
      if person.id.wikipedia
        whitelist[person.id.wikipedia] = true
    callback null

async.eachSeries urls, getWikipediaPages, (err) ->
  unless err
    console.log JSON.stringify whitelist, null, 2
