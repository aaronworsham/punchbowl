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


        
});



