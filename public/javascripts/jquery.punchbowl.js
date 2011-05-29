function Punchbowl(options){
  this.default_settings = {
    url  : "https://punchbowl.mangolanguages.com",
    test_url : "http://localhost:3000",
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
    var customer_url = this.settings.testMode ? this.settings.test_url + "/customers" : this.setttings.url + "/customers"
    customer_data['uuid'] = this.settings.uuid;
    $.post_json(customer_url, {'customer' : customer_data, 'auth_key' : this.settings.auth_key}, function(data){
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

