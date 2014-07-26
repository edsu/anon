# anon

[![Build Status](https://secure.travis-ci.org/edsu/anon.png)](http://travis-ci.org/edsu/anon)
[![Gitter chat](https://badges.gitter.im/edsu/anon.png)](https://gitter.im/edsu/anon)

This little coffee script will watch Wikipedia for edits from a set of
named IP ranges and will tweet when it notices one.  It was inspired by
[@parliamentedits](https://twitter.com/parliamentedits) and is used to make
[@congressedits](https://twitter.com/congressedits) available.

If you are curious, the default IP ranges for the US Congress in the `config.json.template` file came from [GovTrack](https://github.com/govtrack/govtrack.us-web/blob/master/website/middleware.py). You can learn more about the significance of Congressional edits to Wikipedia [here](https://en.wikipedia.org/wiki/U.S._Congressional_staff_edits_to_Wikipedia) and [here](https://en.wikipedia.org/wiki/Wikipedia:Congressional_staffer_edits).

## Run

To run anon you will need to:

1. install [Node](http://nodejs.org)
1. `npm install -g coffee-script`
1. `git clone https://github.com/edsu/anon.git`
1. `cd anon`
1. `npm install`
1. `cp config.json.template config.json`
1. add twitter credentials for your bot to `config.json` (make sure the Twitter
app you create has read/write permission so it can tweet)
1. add IP ranges/names to `config.json`
1. modify status template if desired
1. `./anon.coffee` (you may want to run this in a screen or tmux session, or on a cloud service like Heroku (see below))
1. have some :coffee: and wait

### IP Ranges

You will notice in the example `config.json.template` that you can configure
ip address ranges using a netmask:

    "143.231.0.0/16"

or with an array of start/end IP addresses:

    ["143.231.0.0", "143.231.255.255"]

These two are equivalent, but the former is a bit faster, and easier to read.
The latter is convenient if your range is difficult to express using a netmask.

### Transparency

If you end up running an anon bot we would love to document the IP address
ranges you use for transparency purposes. Please add just the ranges
stanza of your onfig file to the `conf` directory. Name the file using your 
Twitter account, e.g. for congressedits:

    conf/congressedits.json

You can use a service like [ARIN Online](http://whois.arin.net/ui) to look up
IP address ranges by organization name.

If you would like your configuration file to reference the IP addresses in 
the external file just use the filename. So instead of:

```javascript
{
  "nick": "congressedits",
  "accounts": [
    {
      "consumer_key": "",
      "consumer_secret": "",
      "access_token": "",
      "access_token_secret": "",
      "template": "{{page}} Wikipedia article edited anonymously from {{name}} {{&url}}",
      "ranges": {
        "US House of Representatives": [
          ["143.231.0.0", "143.231.255.255"],
          ["74.119.128.0", "74.119.131.255"]
        ]
      }
    }
  ]
}
```

you would have:

```javascript
{
  "nick": "congressedits",
  "accounts": [
    {
      "consumer_key": "",
      "consumer_secret": "",
      "access_token": "",
      "access_token_secret": "",
      "template": "{{page}} Wikipedia article edited anonymously from {{name}} {{&url}}",
      "ranges": "conf/congressedits.json"
    }
  ]
}
```

### Debugging

If you would like to test without tweeting you can run anon with the
`--noop` flag, which will cause the tweet to be written to the console
but not actually sent to Twitter.

    ./anon.coffee --noop

If you would like to see all the change activity (URLs for each change) to test
that it is actually listening, use the `--verbose` flag:

    ./anon.coffee --verbose

### Alternate Configuration Files

By default anon will look for a `config.json` file in your current working
directory. If you would like to specify the location of the configuration
file, use the `--config` parameter:

    ./anon.coffee --config test.config

### Running on Heroku

A Procfile is included to facilitate running anon on the Heroku cloud service. Once you've satisfied the [Heroku prerequisites](https://devcenter.heroku.com/articles/getting-started-with-nodejs#prerequisites) and [setup Heroku](https://devcenter.heroku.com/articles/getting-started-with-nodejs#local-workstation-setup), you can run anon via:

    heroku create
    git push heroku master
    heroku ps:scale worker=1

Read more on [running Node.js applications on Heroku](https://devcenter.heroku.com/articles/getting-started-with-nodejs).

## Develop

There is not much to anon but there is a small test suite, which might
come in handy if you want to add functionality.

    npm test

## Which Wikipedias?

anon uses the [wikichanges](https://github.com/edsu/wikichanges) module
to listen to 38 language Wikipedias. wikichanges achieves this by logging
in to the Wikimedia IRC server and listening to the
[recent changes](https://meta.wikimedia.org/wiki/IRC/Channels#Recent_changes)
channels for each Wikipedia. So if you plan on running wikichanges be sure
your network supports IRC (it can sometimes be blocked).

Here are the Wikipedias that it currently supports:

* [Arabic](https://ar.wikipedia.org)
* [Bulgarian](https://bg.wikipedia.org)
* [Catalan](https://ca.wikipedia.org)
* [Chinese](https://zh.wikipedia.org)
* [Czech](https://cs.wikipedia.org)
* [Danish](https://da.wikipedia.org)
* [Dutch](https://nl.wikipedia.org)
* [English](https://en.wikipedia.org)
* [Esperanto](https://eo.wikipedia.org)
* [Euskara](https://eu.wikipedia.org)
* [Farsi](https://fa.wikipedia.org)
* [Finnish](https://fi.wikipedia.org)
* [French](https://fr.wikipedia.org)
* [German](https://de.wikipedia.org)
* [Greek](https://el.wikipedia.org)
* [Hebrew](https://he.wikipedia.org)
* [Hungarian](https://hu.wikipedia.org)
* [Indonesian](https://id.wikipedia.org)
* [Italian](https://it.wikipedia.org)
* [Japanese](https://ja.wikipedia.org)
* [Korean](https://ko.wikipedia.org)
* [Lithuanian](https://lt.wikipedia.org)
* [Malaysian](https://ms.wikipedia.org)
* [Norwegian](https://no.wikipedia.org)
* [Polish](https://pl.wikipedia.org)
* [Portuguese](https://pt.wikipedia.org)
* [Romanian](https://ro.wikipedia.org)
* [Russian](https://ru.wikipedia.org)
* [Slovak](https://sk.wikipedia.org)
* [Slovene](https://sl.wikipedia.org)
* [Spanish](https://es.wikipedia.org)
* [Swedish](https://sv.wikipedia.org)
* [Turkish](https://tr.wikipedia.org)
* [Ukrainian](https://uk.wikipedia.org)
* [Vietnamese](https://vi.wikipedia.org)
* [Volapük](https://vo.wikipedia.org)
* [Wikidata](https://wd.wikipedia.org)
* [Wikimedia Commons](https://co.wikipedia.org)

If you would like to have another one added please add a ticket to the
[wikichanges](https://github.com/edsu/wikichanges/issues?state=closed)
issue tracker.

## License:

* [CC0](LICENSE) public domain dedication
