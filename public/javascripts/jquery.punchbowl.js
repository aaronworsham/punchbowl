// Quick explanation of what is happening in this script
// 
// First, it is used in javascript like this
// 
// var x = new Punchbowl({uuid : uuid_from_flex_client, auth_key : auth_key_from_client, testMode : true})
// 
// Now there is talk of not using an auth key and just using the uuid and a signed session, but for now these are both needed
// 
// Then you can call functions on the x javascript object this way
// 
// x.profile({function(){ alert('this is a callback once profile returns with data')});
// 
// This call will send a GET with the following data
// - The url is a combination of the base from the settings and the uuid
// - The auth_token was passed in, otherwise use 'abcdef' to test with 
// - This will return JSON that is parsed automatically by JQuery
// - Note that at the bottom of the js, the get_json function calls _ajax_json_request with the GET param which sets up the call to use the following
//                 xhrObj.setRequestHeader("Content-Type","application/json");
//                 xhrObj.setRequestHeader("Accept","application/json");
// these tell the Rails app that this is a json request
// 
// Data back:
// {"created_at":"May 30, 2011 00:45","last_post":{"created_at":"May 30, 2011 00:48","message":"bob"},
// "existing_user":true,"number_of_posts":1,"uuid":3,"updated_at":"May 30, 2011 00:46","id":53,"facebook":
// {"token":null,"green_lit?":false,"opt_in":true},"last_error":null,"twitter":{"token":null,"green_lit?":false,"opt_in":false}}
// 
// 
// If the profile call cannot locate the uuid, it will return {new_user : true} and you can follow that call with the create_profile call
// x.create_profile({function(){ alert('this is a callback once profile returns with data')});
// The data you would pass in is 
// - facebook_user (true/false)  if they checked the checkbox for facebook
// - twitter_user(true/false) if they checked the checkbox for twitter
// 
// Data Back:
// {"new_user":true,"url":"https://graph.facebook.com/oauth/authorize?scope=email%2Cread_stream%2Cpublish_stream%2Coffline_access&client_id=154629021224817&redirect_uri=http%3A%2F%2Fpunchbowl.dev%2Fcustomers%2F54%2Ffacebook%2Fauth_success"}
// 
// On return, you will be given a url to send them to for authentication in the browser.  We will have to set 
// up some signaling to tell the app when this is user is finally authenticated.  Then you can send the post
// 
// Once we have a user and they are green_lit for facebook  and/or twitter we can send a post
// 
// x.post({message : 'bob'}, function(){console.log('bob')});
// 
// There will be more data passed in in the future, but this is enough for now
// 
// For testing, the data returned is
// {status : tested}







function Punchbowl(options){
  this.default_settings = {
    url  : "https://punchbowl.mangolanguages.com",
    test_url : "http://punchbowl.dev",
    auth_key : "abcdef",
    debug : false,
    testMode : false,
    uuid : 0,
  }

// INIT
// Expects 
// - uuid
// - auth_key
//

  this.settings = $.extend(this.default_settings, options)
}

// SHOW PROFILE

// Expects:
//- uuid
// Returns:
// - New User
// - Existing User
// --- Facebook
// ----- Opt In?
// ----- Green Lit?
// --- Twitter
// ----- Opt In?
// ----- Green Lit?
//
Punchbowl.prototype.profile = function( callback ){
    var url = this.settings.testMode ? this.settings.test_url : this.settings.url
    var uuid = this.settings.uuid;
    var customer_url = url + "/customers/uuid/"+ uuid;
    if(uuid){
      $.get_json(customer_url, {auth_token : this.settings.auth_key}, function(data){
        console.log(data);
        callback(data);
      });
    }
}



// CREATE NEW PROFILE

// Expects:
// - uuid
// - facebook_user
// - twitter_user
// Returns:
// - status
// - URL
// - error

Punchbowl.prototype.create_profile = function( customer_data, callback ){
    var customer_url = this.settings.testMode ? (this.settings.test_url + "/customers") : (this.setttings.url + "/customers")
    customer_data['uuid'] = this.settings.uuid;
    $.post_json(customer_url, {'customer' : customer_data, 'auth_token' : this.settings.auth_key}, function(data){
      console.log(data);
      callback(data);
    });
}


// Expects:
// - message
// Will return
// - status
Punchbowl.prototype.post = function( content, callback ) { 
    var url = this.settings.testMode ? this.settings.test_url : this.settings.url
    if (content && content.message) {
      $.post_json(url + "/posts", { 'post'        : content, 
                                    'uuid'        : this.settings.uuid, 
                                    'test_mode'   : this.settings.testMode,
                                    'auth_token'  : this.settings.auth_key }, function(data){
        console.log("Inside profile callback function");
        callback(data);
      });
    }
    else {
      console.log('error');
    }
}


function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

function _ajax_json_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        beforeSend: function(xhrObj){
                xhrObj.setRequestHeader("Content-Type","application/json");
                xhrObj.setRequestHeader("Accept","application/json");
        }, 
        type: method,
        url: url,
        async: false,
        data: data,
        success: callback,
        dataType: type
        });
}



jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    },
    put_json: function(url, data, callback, type) {
        return _ajax_json_request(url, data, callback, type, 'PUT');
    },
    post_json: function(url, data, callback, type) {
        return _ajax_json_request(url, data, callback, type, 'POST');
    },
    get_json: function(url, data, callback, type) {
        return _ajax_json_request(url, data, callback, type, 'GET');
    }


});

