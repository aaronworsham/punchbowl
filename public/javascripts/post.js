$(function(){

  $("form#new_post").validate();

  
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
        .addClass("selected");
      $("#"+$(this).attr("data_hidden_input_id")).val('true');
    }
  });


  
});

function post_thru_iframe() {
}

