#!/usr/bin/env coffee

# This script outputs a JSON dictionary of Wikipedia articles about current 
# US Congress members. The dictionary is suitable for using as a whitelist
# in your anon config.json file. 
#
# Before you use it you'll need these two dependencies:
#
#     npm install request yamljs

yaml    = require 'yamljs'
request = require 'request'

url = 'https://raw.githubusercontent.com/unitedstates/congress-legislators/master/legislators-current.yaml'

whitelist = {}
res = request.get url, (e, r, b) ->
  for person in yaml.parse b
    if person.id.wikipedia
      whitelist[person.id.wikipedia] = true
  console.log JSON.stringify whitelist, null, 2
