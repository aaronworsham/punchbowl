$(function(){

  $('.content img').click(function(){
    var blurb = "#" + this.name + "_blurb";
    $.colorbox({ scrolling:false, inline:true, opacity: 0, transition:"none",  href:blurb});
  });
  
});
