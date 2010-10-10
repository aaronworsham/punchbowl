$(function(){
  $("form#new_mango_tango").validate({
    errorLabelContainer: "#messageBox",
    wrapper: "li",
  });

  $('#new_mango_tango').submit(function(){
    if ( $(this).validate().form() ) {
      var formValues = $(this).serialize();
      var email = $(this).find('#mango_tango_customer_email').val();
      $.post_json('/mango_tango', formValues, function(data){
      });

      $.colorbox({innerWidth:"830", innerHeight:"640", scrolling:false, iframe:true, href:"/posts/new?source=mango_tango&email="+ email});
      $('#mango_tango_submit').val('Emails Sent!').css("background-color", "#aaffaa").attr("disabled", true);
    }
    else {}
    return false;
  });

});



