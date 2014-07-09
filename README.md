# anon

[![Build Status](https://secure.travis-ci.org/edsu/anon.png)](http://travis-ci.org/edsu/anon)

This little coffee script will watch Wikipedia for edits from a set of named
IP ranges and will tweet when it notices one.  It was inspired by [@parliamentedits](https://twitter.com/parliamentedits) and is used to make the [@congressedits](https://twitter.com/congressedits) feed available. If you are curious the default IP ranges in the config.json.template file came from [govtrack](https://github.com/govtrack/govtrack.us-web/blob/master/website/middleware.py).

To run anon you will need to:

1. install Node
1. git clone https://github.com/edsu/anon.git
1. cd anon
1. npm install 
1. cp config.json.template config.jdon
1. add twitter credentials for your bot to config.json
1. add ip ranges/names to config.json
1. coffee anon.coffee
1. have some :coffee: and wait

## Develop

There is a small test suite for testing ip range logic:

    npm test

## License: 

* cc0
