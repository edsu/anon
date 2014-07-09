# congress-edits

[![Build Status](https://secure.travis-ci.org/edsu/congressedits.png)](http://travis-ci.org/edsu/congressedits)

This little coffee script will watch Wikipedia for edits from US Congress IP ranges 
and will tweet them when it notices one. It was inspired by
[@parliamentedits](https://twitter.com/parliamentedits). You can read more about
the significance of some of these edits in the past 
[here](https://en.wikipedia.org/wiki/U.S._Congressional_staff_edits_to_Wikipedia) 
and [here](https://en.wikipedia.org/wiki/Wikipedia:Congressional_staffer_edits).

To run it you will need to:

1. install Node
1. git clone https://github.com/edsu/congress-edits.git
1. cd congress-edits
1. npm install 
1. cp config.json.template config.jdon
1. add twitter credentials
1. coffee congressedits.coffee
1. have some :coffee: and wait

## Develop

There is a small test suite for testing ip range logic:

    npm test

## License: 

* cc0




