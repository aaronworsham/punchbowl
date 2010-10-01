$(function(){
  $('#new_mango_tango').submit(function(){
    $.post_json('/mango_tango', $(this).serialize(), function(data){
    });
    $.colorbox({innerWidth:"799", innerHeight:"575", scrolling:false, iframe:true, href:"/posts/new?source=tango"});
    $('#mango_tango_submit').val('Emails Sent!').css("background-color", "#aaffaa").attr("disabled", true);
    return false;
  });

});



