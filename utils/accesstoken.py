#!/usr/bin/env python

"""
This command line script will prompt you your Twitter app credentials and then 
will give you a Twitter URL to visit in your browser so you can grant the app
permission to tweet for you. Be sure you are logged in as the user you would
like to grant permission to in your browser.
"""

import urlparse
import oauth2 as oauth
 
consumer_key = raw_input('consumer_key: ') 
consumer_secret = raw_input('consumer_secret: ')

request_token_url = 'https://api.twitter.com/oauth/request_token'
access_token_url = 'https://api.twitter.com/oauth/access_token'
authorize_url = 'https://api.twitter.com/oauth/authorize'
 
consumer = oauth.Consumer(consumer_key, consumer_secret)
client = oauth.Client(consumer)
resp, content = client.request(request_token_url, "GET")
 
if resp['status'] != '200':
    raise Exception("Invalid response %s." % resp['status'])
 
request_token = dict(urlparse.parse_qsl(content))
 
print "Request Token:"
print "    - oauth_token        = %s" % request_token['oauth_token']
print "    - oauth_token_secret = %s" % request_token['oauth_token_secret']
print
 
# Step 2: Redirect to the provider. Since this is a CLI script we do not 
# redirect. In a web application you would redirect the user to the URL
# below.
 
print "Go to the following link in your browser:"
print "%s?oauth_token=%s" % (authorize_url, request_token['oauth_token'])
  
# After the user has granted access to you, the consumer, the provider will
# redirect you to whatever URL you have told them to redirect to. You can 
# usually define this in the oauth_callback argument as well.
accepted = 'n'
while accepted.lower() == 'n':
    accepted = raw_input('Have you authorized me? (y/n) ')
 
oauth_verifier = raw_input('What is the PIN? ')
 
# Step 3: Once the consumer has redirected the user back to the oauth_callback
# URL you can request the access token the user has approved. You use the 
# request token to sign this request. After this is done you throw away the
# request token and use the access token returned. You should store this 
# access token somewhere safe, like a database, for future use.
token = oauth.Token(request_token['oauth_token'],request_token['oauth_token_secret'])
 
token.set_verifier(oauth_verifier)
client = oauth.Client(consumer, token)
 
resp, content = client.request(access_token_url, "POST")
access_token = dict(urlparse.parse_qsl(content))
 
print "Access Token:"
print access_token.keys() # Save the output of the script which gives the access token
print access_token.values()
print "You may now access protected resources using the access tokens above."
