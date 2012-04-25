PunchBowl
=======

Installation
--------
  git clone git@github.com:aaronworsham/punchbowl.git
  rake db:create
  rake db:migrate
  script/server start

Service
-------

PunchBowl is a web application service that functions in two modes

1. Authenticate A new customer to PB
2. Post for an authenticated customer a message to Twitter and/or Facebook
3. Return customer information for a given UUID

It capacity to know a unique customer is based on the usage of a UUID.  The UUID is used to look up a customer record and,
if missing, create a new customer.  Customer records have an ID as the primary key but use UUID to scope all queries.

When a Post is requested of the service for a given UUID, and that customer can be located, an HTTP POST is send from the
service to Facebook, Twitter or both (in that order) with the following information

1. Message
2. Token
3. Client Key
4. Client Secret

Both Twitter and Facebook are being interfaced with OAUTH authentication protocols.  When successful, a message is sent to the 
social network as if posted by the user.

Authenication
------

OAUTH has a protocol that follows a subscribed set of stems to authenticate a user.  Implimentation of OAUTH for Facebook and Twitter
are slightly different and so the PB web service has been tweeked to support those differences

*Common to Both* - To authenticate a user, one must be in a web browser in full screen and see the address bar.  This is done to prevent
phishing scams.  Within the requesting url will be the following

1. Client Key
2. Access Level
3. redirect url

If the user of the social network is not currently logged in, they will be asked to do so.  Once logged in, a page will show the request
from the client API key to access that users account at the specified access level.  If they click 'Accept', a response is sent back to
the redirect url with a session token

*Facebook* - Facebook will then need to pull out that session token and ask for a auth token.  Once the token is returned it is saved with the
customer account

*Twitter* - Twitter will need a Session Token sent in the first request and stored on the clients cookie in the browser.  it must then be
retrieved and sent along to get the auth token.

Posting
-----

Once you have an auth token, you are permitted to send a message to the social network on the users behalf, even while they are offline.


API
-----

PB is written to expect HTTP POST requests with JSON data.  A javascript library has been written to help intergrate a system to use 
PB, located /public/javascripts/jquery.punchbowl.js.  

Quick explanation of what is happening in this script

First, it is used in javascript like this

var x = new Punchbowl({uuid : uuid_from_flex_client, testMode : true})

Then you can call functions on the x javascript object this way

x.profile({function(){ alert('this is a callback once profile returns with data')});

This call will send a GET with the following data
- The url is a combination of the base from the settings and the uuid
- This will return JSON that is parsed automatically by JQuery
- Note that at the bottom of the js, the get_json function calls _ajax_json_request with the GET param which sets up the call to use the following
                xhrObj.setRequestHeader("Content-Type","application/json");
                xhrObj.setRequestHeader("Accept","application/json");
these tell the Rails app that this is a json request

Data back:
{"created_at":"May 30, 2011 00:45","last_post":{"created_at":"May 30, 2011 00:48","message":"bob"},
"existing_user":true,"number_of_posts":1,"uuid":3,"updated_at":"May 30, 2011 00:46","id":53,"facebook":
{"token":null,"green_lit?":false,"opt_in":true},"last_error":null,"twitter":{"token":null,"green_lit?":false,"opt_in":false}}


If the profile call cannot locate the uuid, it will return {new_user : true} and you can follow that call with the create_profile call
x.create_profile({function(){ alert('this is a callback once profile returns with data')});
The data you would pass in is 
- facebook_user (true/false)  if they checked the checkbox for facebook
- twitter_user(true/false) if they checked the checkbox for twitter

Data Back:
{"new_user":true,"url":"https://graph.facebook.com/oauth/authorize?scope=email%2Cread_stream%2Cpublish_stream%2Coffline_access&client_id=154629021224817&redirect_uri=http%3A%2F%2Fpunchbowl.dev%2Fcustomers%2F54%2Ffacebook%2Fauth_success"}

On return, you will be given a url to send them to for authentication in the browser.  We will have to set 
up some signaling to tell the app when this is user is finally authenticated.  Then you can send the post

Once we have a user and they are green_lit for facebook  and/or twitter we can send a post

x.post({message : 'bob'}, function(){console.log('bob')});

There will be more data passed in in the future, but this is enough for now

For testing, the data returned is
{status : tested}

  
Testing
------

There are both model and integration tests written for PB.  Facebook actually has a more fully fleshed out line of tests because their 
API accounts support the concept of 'test users' that can be created at the beginning of the test and deleted at the end.  

  rake spec
