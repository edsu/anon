#!/usr/bin/env node

const ipv6          = require('ipv6')
const async         = require('async')
const Twit          = require('twit')
const Mastodon      = require('mastodon')
const minimist      = require('minimist')
const Mustache      = require('mustache')
const {WikiChanges} = require('wikichanges')

const argv = minimist(process.argv.slice(2), {
  default: {
    verbose: false,
    config: './config.json'
  }
})

function address(ip) {
  if (Array.from(ip).includes(':')) {
    return new ipv6.v6.Address(ip)
  } else {
    i = new ipv6.v4.Address(ip)
    const subnetMask = 96 + i.subnetMask
    ip = `::ffff:${i.toV6Group()}/${subnetMask}`
    return new ipv6.v6.Address(ip)
  }
}

function ipToInt(ip) {
  return address(ip).bigInteger()
}

function compareIps(ip1, ip2) {
  const r = ipToInt(ip1).compareTo(ipToInt(ip2))
  if (r === 0) {
    return 0
  } else if (r > 0) {
    return 1
  } else {
    return -1
  }
}

function isIpInRange(ip, block) {
  if (Array.isArray(block)) {
    return (compareIps(ip, block[0]) >= 0) && (compareIps(ip, block[1]) <= 0)
  } else {
    const a = address(ip)
    const b = address(block)
    return a.isInSubnet(b)
  }
}

function isIpInAnyRange(ip, blocks) {
  for (let block of Array.from(blocks)) {
    if (isIpInRange(ip, block)) {
      return true
    }
  }
  return false
};

function getConfig(path) {
  const config = loadJson(path)
  // see if ranges are externally referenced as a separate .json files
  if (config.accounts) {
    for (let account of Array.from(config.accounts)) {
      if (typeof account.ranges === 'string') {
        account.ranges = loadJson(account.ranges)
      }
    }
  }
  console.log("loaded config from", path)
  return config
};

function loadJson(path) {
  if ((path[0] !== '/') && (path.slice(0, 2) !== './')) {
    path = `./${path}`
  }
  return require(path)
};

function getStatusLength(edit, name, template) {
  // https://support.twitter.com/articles/78124-posting-links-in-a-tweet
  const fakeUrl = 'http://t.co/BzHLWr31Ce'
  const status = Mustache.render(template, {name, url: fakeUrl, page: edit.page})
  return status.length
}

function getStatus(edit, name, template) {
  let page = edit.page
  const len = getStatusLength(edit, name, template);
  if (len > 140) {
    const newLength = edit.page.length - (len - 139)
    page = edit.page.slice(0, +newLength + 1 || undefined)
  }
  return Mustache.render(template, {
    name,
    url: edit.url,
    page
  })
};

const lastChange = {}

function isRepeat(edit) {
  const k = `${edit.wikipedia}`
  const v = `${edit.page}:${edit.user}`
  const r = lastChange[k] === v
  lastChange[k] = v
  return r
}

function tweet(account, status, edit) {
  console.log(status)
  if (!argv.noop && (!account.throttle || !isRepeat(edit))) {
    if (account.mastodon) {
      const mastodon = new Mastodon(account.mastodon)
      mastodon.post('statuses', {status}, function(err) {
        if (err) {
          console.log(err);
        }
      })
    }
    if (account.access_token) {
      const twitter = new Twit(account);
      return twitter.post('statuses/update', {status}, function(err) {
        if (err) {
          console.log(err)
        }
      })
    }
  }
}

function inspect(account, edit) {
  if (edit.url) {
    if (argv.verbose) {
      console.log(edit.url)
    }
    if (account.whitelist && account.whitelist[edit.wikipedia]
        && account.whitelist[edit.wikipedia][edit.page]) {
      status = getStatus(edit, edit.user, account.template);
      tweet(account, status, edit);
    } else if (account.ranges && edit.anonymous) {
      for (let name in account.ranges) {
        const ranges = account.ranges[name];
        if (isIpInAnyRange(edit.user, ranges)) {
          status = getStatus(edit, name, account.template)
          tweet(account, status, edit)
        }
      }
    }
  }
}

function checkConfig(config, error) {
  if (config.accounts) {
    return async.each(config.accounts, canTweet, error)
  } else {
    return error("missing accounts stanza in config")
  }
}

function canTweet(account, error) {
  if (!account.access_token) {
    error(null)
  } else {
    try {
      const twitter = new Twit(account)
      const a = account['access_token']
      return twitter.get('search/tweets', {q: 'cats'}, function(err, data, response) {
        if (err) {
          error(err + " for access_token " + a)
        } else if (!response.headers['x-access-level'] ||
            (response.headers['x-access-level'].substring(0,10) !== 'read-write')) {
          error(`no read-write permission for access token ${a}`)
        } else {
          error(null)
        }
      });
    } catch (err) {
      error(`unable to create twitter client for account: ${account}`)
    }
  }
}

function main() {
  const config = getConfig(argv.config)
  return checkConfig(config, function(err) {
    if (!err) {
      const wikipedia = new WikiChanges({ircNickname: config.nick})
      return wikipedia.listen(edit =>
        Array.from(config.accounts).map((account) =>
          inspect(account, edit))
      );
    } else {
      return console.log(err)
    }
  })
}

if (require.main === module) {
  main()
}

module.exports = {
  main,
  address,
  ipToInt,
  compareIps,
  isIpInRange,
  isIpInAnyRange,
  getConfig,
  getStatus
}
