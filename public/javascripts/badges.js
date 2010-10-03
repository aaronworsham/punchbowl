$(function(){

  $('.content img').click(function(){
    var blurb = "#" + this.name + "_blurb";
    $.colorbox({ scrolling:false, inline:true, opacity: 0, transition:"none",  href:blurb});
  });
  $(".test_post").click(function(){
    $.post_json(this.href, function(){
      $.colorbox.close();
    });
    return false;
  });
});
