$(function(){
  $("#new_post").validate({
    rules: {
      "post[message]": {
        required: true,
        maxlength: 130,
      },
      "post[email]": {
        required: true,
        email: true
      }
    },
    messages: {
      "post[message]": {
        required:  "A blank postcard is no fun at all.", 
        maxlength: "We need to keep the postcard short."
      },
      "post[email]": {
        required: "We need to know who is sending this postcard",
        email: "Your email address must be in the format of name@domain.com"
      }
    }
  });

  $(".icons li").click(function(){
    if($(this).hasClass("selected")){
      $(this)
        .find('span')
          .hide()
        .end()
        .removeClass("selected");
      $("#"+$(this).attr("data_hidden_input_id")).val('false')
    }
    else {
      $(this)
        .find('span')
          .show()
        .end()
        .addClass("selected");;
      $("#"+$(this).attr("data_hidden_input_id")).val('true');
    }
  });

  $('#new_mango_tango').submit(function(){
    $.post('/mango_tango', $(this).serialize());
    $.colorbox({innerWidth:"799", innerHeight:"575", scrolling:false, iframe:true, href:"/posts/new?source=tango"});
    $('#mango_tango_submit').val('Emails Sent!').css("background-color", "#aaffaa").attr("disabled", true);
    return false;
  });

  $("#envelope").click(function(){
    $.colorbox({innerWidth:"799", innerHeight:"575", scrolling:false, iframe:true, href:"/posts/new?source=gift"});
  });

        
});



