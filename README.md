# anon

[![Build Status](https://secure.travis-ci.org/edsu/anon.svg)](http://travis-ci.org/edsu/anon)
[![Gitter chat](https://badges.gitter.im/edsu/anon.svg)](https://gitter.im/edsu/anon)

anon will watch Wikipedia for edits from a set of named IP ranges and will tweet
when it notices one. It was inspired by
[@parliamentedits](https://twitter.com/parliamentedits) and is used to make
[@congressedits](https://twitter.com/congressedits) available. It is now being
used a [community](#community) of users to post selected Wikipedia edits to
Twitter.

anon can also send updates on [GNU Social /
Mastodon](https://github.com/tootsuite/mastodon) (see below)

## Run

To run anon you will need to:

1. install [Node](http://nodejs.org) (v6 or higher)
1. `git clone https://github.com/edsu/anon.git`
1. `cd anon`
1. `npm install`
1. `cp config.json.template config.json`
1. add twitter credentials for your bot to `config.json` (make sure the Twitter
app you create has read/write permission so it can tweet)
1. add IP ranges/names to `config.json`
1. modify status template if desired
1. `./anon.js` (you may want to use our shared instance in Wikimedia Labs, see
   below)

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

### Mastodon

If you want to send messages on Mastodon you'll need to create an application
and then get an access token for the account you want to send on. A utility is
included to help you do that:

    npm run mastodon

### Debugging

If you would like to test without tweeting you can run anon with the
`--noop` flag, which will cause the tweet to be written to the console
but not actually sent to Twitter.

    ./anon.js --noop

If you would like to see all the change activity (URLs for each change) to test
that it is actually listening, use the `--verbose` flag:

    ./anon.js --verbose

### Alternate Configuration Files

By default anon will look for a `config.json` file in your current working
directory. If you would like to specify the location of the configuration
file, use the `--config` parameter:

    ./anon.js --config test.config

### Running on Wikimedia Labs

We have a shared instance of anon running on [Wikimedia
Labs](http://tools.wmflabs.org/anon). This is useful once you have a
configuration that is working and you'd like to have the running instance
in labs use it.

## With Docker

### Build image

1. git clone the repo
1. `cd anon`
1. `docker build . -t anon`

### Run image

1. create your `config.json` file
1. `docker run -v $PWD/config.json:/opt/anon/config.json anon`

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

Additionally, the following miscellaneous Wikimedia sites: 
* [Wikidata](https://wikidata.org)
* [Wikimedia Commons](https://commons.wikimedia.org)

If you would like to have another one added please add a ticket to the
[wikichanges](https://github.com/edsu/wikichanges/issues)
issue tracker.

## Community

Below is a list of known anon instances. Please feel free to add, in an alphabetic order, your
own by sending a pull request.

* [@2dekameredits](https://twitter.com/2dekameredits)
* [@5thEstateWiki](https://twitter.com/5thEstateWiki)
* [@academyedits](https://twitter.com/academyedits)
* [@AnonGoIWPEdits](https://twitter.com/anongoiwpedits)
* [@atWikiEdits](https://twitter.com/atWikiEdits)
* [@AUSgovEdits](https://twitter.com/AUSgovEdits)
* [@AussieParlEdits](https://twitter.com/AussieParlEdits)
* [@bankedits](https://twitter.com/bankedits)
* [@bcgovedits](https://twitter.com/bcgovedits)
* [@bclegedits](https://twitter.com/bclegedits)
* [@beehive_edits](https://twitter.com/beehive_edits)
* [@berlinEDUedits](https://twitter.com/berlinEDUedits)
* [@BotDetectorCamb](https://twitter.com/BotDetectorCamb)
* [@BrockWikiEdits](https://twitter.com/BrockWikiEdits)
* [@brwikiedits](https://twitter.com/brwikiedits)
* [@bundesedit](https://twitter.com/bundesedit)
* [@ciaedits](https://twitter.com/ciaedits)
* [@cmuedits](https://twitter.com/cmuedits)
* [@congresseditors](https://twitter.com/congresseditors)
* [@congressedits](https://twitter.com/congressedits)
* [@CPDWikiEdits](https://twitter.com/CPDWikiEdits)
* [@DailEireannEdit](https://twitter.com/DailEireannEdit)
* [@EagleWikiEdits](https://twitter.com/EagleWikiEdits)
* [@EduskuntaEdit](https://twitter.com/EduskuntaEdit)
* [@EstadoEdita](https://twitter.com/EstadoEdita)
* [@euroedit](https://twitter.com/euroedit)
* [@FinlandEdits](https://twitter.com/FinlandEdits)
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
* [@lc_edits](https://twitter.com/lc_edits)
* [@LRSwikiedits](https://twitter.com/LRSwikiedits)
* [@michigan_edits](https://twitter.com/michigan_edits)
* [@MITedits](https://twitter.com/MITedits)
* [@monsantoedits](https://twitter.com/monsantoedits)
* [@NATOedits](https://twitter.com/NATOedits)
* [@NCGAedits](https://twitter.com/NCGAedits)
* [@nsaedits](https://twitter.com/nsaedits)
* [@nsgovedits](https://twitter.com/nsgovedits)
* [@NYPDedits](https://twitter.com/NYPDedits)
* [@ODTUedits](https://twitter.com/ODTUedits)
* [@oiledits](https://twitter.com/oiledits)
* [@ONgovEdits](https://twitter.com/ONgovEdits)
* [@OverheidEdits](https://twitter.com/OverheidEdits)
* [@PakistanEdits](https://twitter.com/PakistanEdits)
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
* [@TBMMedits](https://twitter.com/TBMMedits)
* [@TSKedits](https://twitter.com/TSKedits)
* [@UaGovEdits_en](https://twitter.com/UaGovEdits_en)
* [@UaGovEdits](https://twitter.com/UaGovEdits)
* [@UaGoveEdits_ru](https://twitter.com/UaGovEdits_ru)
* [@uc_wiki_edits](https://twitter.com/uc_wiki_edits)
* [@UChicago_edits](https://twitter.com/UChicago_edits)
* [@un_edits](https://twitter.com/un_edits)
* [@valleyedits](https://twitter.com/valleyedits)
* [@WhitehallEdits](https://twitter.com/WhitehallEdits)
* [@whitehousedits](https://twitter.com/whitehousedits)
* [@wikiAssemblee](https://twitter.com/wikiAssemblee)
* [@WikiCreeperEdit](https://twitter.com/WikiCreeperEdit)
* [@wikistorting](https://twitter.com/wikistorting)
* [@zagovedits](https://twitter.com/zagovedits)

## License:

* [CC0](LICENSE) public domain dedication
