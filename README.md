# anon

[![Build Status](https://secure.travis-ci.org/edsu/anon.png)](http://travis-ci.org/edsu/anon)
[![Gitter chat](https://badges.gitter.im/edsu/anon.png)](https://gitter.im/edsu/anon)

This little coffee script will watch Wikipedia for edits from a set of
named IP ranges and will tweet when it notices one.  It was inspired by
[@parliamentedits](https://twitter.com/parliamentedits) and is used to make
[@congressedits](https://twitter.com/congressedits) available. It is now being
used a [community](#community) of users to post selected Wikipedia edits to 
Twitter.

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

If you would like your configuration file to reference the IP addresses in 
the external file just use the filename. So instead of:

```javascript
{
  "nick": "anon1234",
  "accounts": [
    {
      "consumer_key": "",
      "consumer_secret": "",
      "access_token": "",
      "access_token_secret": "",
      "template": "{{page}} Wikipedia article edited anonymously from {{name}} {{&url}}",
      "ranges": {
        "Home Network": [
          ["192.168.1.1", "192.168.255.255"]
        ]
      }
    }
  ]
}
```

you would have:

```javascript
{
  "nick": "anon1234",
  "accounts": [
    {
      "consumer_key": "",
      "consumer_secret": "",
      "access_token": "",
      "access_token_secret": "",
      "template": "{{page}} Wikipedia article edited anonymously from {{name}} {{&url}}",
      "ranges": "ranges.json"
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
[wikichanges](https://github.com/edsu/wikichanges/issues)
issue tracker.

## Community

Below is a list of known anon instances. Please feel free to add, in an alphabetic order, your
own by sending a pull request.

* [@2dekameredits](https://twitter.com/2dekameredits)
* [@academyedits](https://twitter.com/academyedits)
* [@AUSgovEdits](https://twitter.com/AUSgovEdits)
* [@AussieParlEdits](https://twitter.com/AussieParlEdits)
* [@bcgovedits](https://twitter.com/bcgovedits)
* [@bclegedits](https://twitter.com/bclegedits)
* [@beehive_edits](https://twitter.com/beehive_edits)
* [@berlinEDUedits](https://twitter.com/berlinEDUedits)
* [@brwikiedits](https://twitter.com/brwikiedits)
* [@bundesedit](https://twitter.com/bundesedit)
* [@ciaedits](https://twitter.com/ciaedits)
* [@cmuedits](https://twitter.com/cmuedits)
* [@congresseditors](https://twitter.com/congresseditors)
* [@congressedits](https://twitter.com/congressedits)
* [@DailEireannEdit](https://twitter.com/DailEireannEdit)
* [@EduskuntaEdit](https://twitter.com/EduskuntaEdit)
* [@EstadoEdita](https://twitter.com/EstadoEdita)
* [@euroedit](https://twitter.com/euroedit)
* [@FloridaEdits](https://twitter.com/FloridaEdits)
* [@FTingetWikiEdit](https://twitter.com/FTingetWikiEdit)
* [@gccaedits](https://twitter.com/gccaedits)
* [@goldmanedits](https://twitter.com/goldmanedits)
* [@gruedits](https://twitter.com/gruedits)
* [@harvardedits](https://twitter.com/harvardedits)
* [@hgbedit](https://twitter.com/hgbedit)
* [@IEGoveEdits](https://twitter.com/IEGovEdits)
* [@IrishGovEdits](https://twitter.com/IrishGovEdits)
* [@israeledits](https://twitter.com/israeledits)
* [@ItaGovEdits](https://twitter.com/ItaGovEdits)
* [@kameredits](https://twitter.com/kameredits)
* [@LAGovEdits](https://twitter.com/lagovedits)
* [@LATechEdits](https://twitter.com/LATechEdits)
* [@LRSwikiedits](https://twitter.com/LRSwikiedits)
* [@MITedits](https://twitter.com/MITedits)
* [@monsantoedits](https://twitter.com/monsantoedits)
* [@NATOedits](https://twitter.com/NATOedits)
* [@NCGAedits](https://twitter.com/NCGAedits)
* [@nsaedits](https://twitter.com/nsaedits)
* [@nsgovedits](https://twitter.com/nsgovedits)
* [@oiledits](https://twitter.com/oiledits)
* [@ONgovEdits](https://twitter.com/ONgovEdits)
* [@OverheidEdits](https://twitter.com/OverheidEdits)
* [@PakistanEdits] (https://twitter.com/PakistanEdits)
* [@Parlamento_Wiki](https://twitter.com/Parlamento_Wiki)
* [@parliamentedits](https://twitter.com/parliamentedits)
* [@parlizaedits](https://twitter.com/parlizaedits)
* [@pentagon-edits](https://twitter.com/pentagonedits)
* [@phrmaedits](https://twitter.com/phrmaedits)
* [@politikedits](https://twitter.com/politikedits)
* [@rcmp_edits](https://twitter.com/rcmp_edits)
* [@Regierungsedits](https://twitter.com/Regierungsedits)
* [@reichstagedits](https://twitter.com/reichstagedits)
* [@RialtasWatch](https://twitter.com/RialtasWatch)
* [@RiksdagWikiEdit](https://twitter.com/RiksdagWikiEdit)
* [@RuGovEdits_en](https://twitter.com/RuGovEdits_en)
* [@RuGovEdits](https://twitter.com/RuGovEdits)
* [@stanfordedits](https://twitter.com/stanfordedits)
* [@swissgovedit](https://twitter.com/swissgovedit)
* [@UaGovEdits_en](https://twitter.com/UaGovEdits_en)
* [@UaGovEdits](https://twitter.com/UaGovEdits)
* [@UaGoveEdits_ru](https://twitter.com/UaGovEdits_ru)
* [@un_edits](https://twitter.com/un_edits)
* [@valleyedits](https://twitter.com/valleyedits)
* [@wikiAssemblee](https://twitter.com/wikiAssemblee)
* [@wikistorting](https://twitter.com/wikistorting)

## License:

* [CC0](LICENSE) public domain dedication
