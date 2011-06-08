$(function(){
  $('form#new_customer').submit(function(e){
    e.stopPropagation();
    console.log('hyjacked');
    $.post(this.action, $(this).serialize(), function(data){
      if(data.new_user == true){
        window.location = data.url
      };
    });
    return false;
  });
});



