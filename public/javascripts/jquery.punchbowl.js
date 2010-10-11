(function($){

  var Punchbowl = {
    url  : "http://punchbowl.heroku.com",
    debug : false,
    testMode : false,
    showOverlay : function(overlay, content, customer, disableRemember){
      if (content) {   
        $(overlay).html(Dialog)
        // Clear out the remember link if not needed
        if ( disableRemember ){
          $('.dialog .never_again').hide();
        }
        // Set hiddens
        $("input[name='message']").val(content.message);
        $("input[name='uuid']").val(content.uuid);
        $("input[name='badge_name']").val(content.badge_name);
        $("input[name='language']").val(content.language);

        $('.dialog #dialog_message').html('Would you like to announce to your Facebook and Twitter friends that you completed Lesson '+
                                           content.lesson_number+' of '+content.language+'?');
        // Add submit event to a tag in form for posting
        $('#dialog_form_submit').click(function(){
          if ( $('#send_a_tweet').is(':checked') || $('#post_on_facebook').is(':checked') ) {
            $('#dialog_form').submit();
          }
          else {
            $('.content h2').text('Please select Twitter or Facebook before hitting the Post buttom');
          }
        });

        // Add an user update event for No Thanks button
        $('#dialog_no_thanks').click(function(){
          if (content.uuid && customer && customer.wants_to_be_asked !== true) {
            $.put_json(Punchbowl.url + "/customers/uuid/"+ content.uuid, JSON.stringify({"customer":{"wants_to_be_asked":false}}));
          }
          $(overlay).fadeOut("fast");
        });

        // Get the badge image url from PB and append to dialog
        $.post_json(Punchbowl.url + '/badges/name/'+content.badge_name, function(data){
          $('.dialog .badge').html('<img src='+data.badge.image_path+'>');
        });
        // Show dialog
        $(overlay).fadeIn("fast");
      }
      else{
        $.error( "no content for show overlay");
        if ( Punchbowl.debug ) {console.log("no content for show overlay");}
      }
    }
  };   
  var methods = {
    
    init : function( options ) {

      if ( options ) { 
        $.extend( Punchbowl, options );
      }      
    },
    post : function( content ) {   
      return this.each(function(i, e){
        if (content && content.badge_name && content.message  && content.language && content.lesson_number) {          
          if (content.uuid){
            if ( Punchbowl.testMode ) {
              var customer_url = Punchbowl.url + "/customers/test/uuid/"+content.uuid
            } 
            else {
              var customer_url = Punchbowl.url + "/customers/uuid/"+content.uuid
            }
            $.get_json(customer_url, function(customer){
              // console.log(customer);
              if (customer){
                // We have a customer by this uuid
                if (customer.wants_to_share === false){
                  if ( Punchbowl.debug ) {console.log("user does not what to share");}
                  // That customer has elected not to share on 
                  // social media
                }
                else if (customer.wants_to_be_asked === true){
                  if ( Punchbowl.debug ) {console.log("user whats to be asked");}
                  // Customer wants to always be asked
                  Punchbowl.showOverlay(e, content, customer, true);
                }
                else if (customer.green_lit === false){
                  if ( Punchbowl.debug ) {console.log("user is not green lit");}
                  //Customer is not green lit on 
                  //selected social media sites
                  Punchbowl.showOverlay(e, content, customer, false);
                   }
                else{
                  if ( Punchbowl.debug ) {console.log("user is ready to post to social media");}
                  //Is ready to be posted
                  $.post_json(Punchbowl.url + "/accomplishments", content);
                }
              }
              else {
                if ( Punchbowl.debug ) {console.log("user does not exist on PB");}
               //The User does not exist on PB by that uuid
                Punchbowl.showOverlay(e, content, customer, false);
              }
            });
          }
          else{
            if ( Punchbowl.debug ) {console.log("user is anonymous");}
            //User is anonymous in the Mango system
            Punchbowl.showOverlay(e, content, null, true);
          }
        }
        else {
          $.error( "Punchbowl call missing some attributes");
          if ( Punchbowl.debug ) {console.log("Punchbowl call missing some attributes");}
        }
      });
    }
  };

  var Dialog =  '<form action="'+Punchbowl.url+'/accomplishments" method="post" target="_blank", id="dialog_form">'+
                '<input type="hidden" name="message" value="" />'+
                '<input type="hidden" name="uuid" value="" />'+
                '<input type="hidden" name="badge_name" value="" />'+
                '<input type="hidden" name="language" value="" />'+
                '<div class="dialog" style="display: block; ">'+
                '<div class="content">'+
                '<h2 id="dialog_message"></h2>'+
                '<div class="twitter">'+
                '<input id="send_a_tweet" type="checkbox" name="post_to_twitter" value="true"> <label for="send_a_tweet">Post on Twitter!</label>'+
                '</div>'+
                '<div class="facebook">'+
                '<input id="post_on_facebook" type="checkbox" name="post_to_facebook" value="true"> <label for="post_on_facebook">Post on Facebook!</label>'+
                '</div>'+
                '<div class="buttons">'+
                '<a href="#" id="dialog_form_submit">Post messages</a>'+
                '<a href="#" id="dialog_no_thanks">No, thanks</a>'+
                '</div>'+
                '<div class="preferences">'+
                '<div class="never_again" style="display: block; ">'+
                '<input id="never_again" type="checkbox" name="remember_me"> <label for="never_again">Remember my preference and do not show me this message again.</label>'+
                '</div>'+
                '</div>'+
                '<div class="badge"></div>'+
                '</div>'+
                '</div>'+
                '</form>'



  $.fn.punchbowl = function( method ){

    // Method calling logic
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
    } 

  };

})(jQuery);


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

