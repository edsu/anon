#!/usr/bin/env node

const mastodon_url = 'https://botsin.space'

// this script will create an app on a mastodon instance indicated with 
// the mastodon_url variable above and will then create an access token
// for you. You will be prompted to visit a URL in your browser to authorize
// the mastodon account you want to send messages with
// 
// once complete you will be given a JSON stanza to add to the account
// in your config.json that you want to have messages sent to on Mastodon

const mastodon = require('mastodon')
const oauth    = require('oauth')
const request  = require('request')
const readline = require('readline-sync')

const createApp = () =>
  request.post(
    {
      url: mastodon_url + '/api/v1/apps',
      form: {
        client_name: 'anon',
        redirect_uris: 'urn:ietf:wg:oauth:2.0:oob',
        scopes: 'read write follow',
        website: 'https://github.com/edsu/anon'
      }
    },
    function(e, r, body) {
      const app = JSON.parse(body)
      return authorize(app)
  })


var authorize = function(app) {
  const auth = new oauth.OAuth2(
    app.client_id,
    app.client_secret,
    mastodon_url,
    null,
    '/oauth/token'
  )

  const url = auth.getAuthorizeUrl({
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
    response_type: 'code',
    scope: 'read write follow'
  })
 
  console.log("")
  console.log("Please visit this url in your browser, authorize and then enter the PIN")
  console.log("")
  console.log(url)
  console.log("")
  const pin = readline.question('PIN: ')
  console.log("")

  return auth.getOAuthAccessToken(
    pin, {
    grant_type: 'authorization_code',
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob'
  },
    function(err, access_token, refresh_token, res) {
      if (err) {
        console.log(err)
        return
      }

      const config = {
        client_id: app.client_id,
        client_secret: app.client_secret,
        access_token,
        api_url: mastodon_url
      }

      console.log("add this stanza to the account in your config.json")
      return console.log(JSON.stringify(config, null, 2))
  })
}

createApp()
