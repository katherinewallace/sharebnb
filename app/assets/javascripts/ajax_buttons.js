$(document).ready(function(){
  
  $("#booking-list").on("ajax:success", "a", function(event, data){

    // Data is a cat show partial (html)
    console.log(data);
    var status = $(event.currentTarget).parent().parent().find('strong.status')
    $(event.currentTarget).removeClass("btn error")
    $(event.currentTarget).empty()
    console.log(status)
    $(status).addClass("error");
    $(status).html("cancelled");

  });
  
})