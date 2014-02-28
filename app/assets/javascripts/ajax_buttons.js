$(document).ready(function(){
  
  $("#trip-list").on("ajax:success", "a", function(event, data){
    var status = $(event.currentTarget).parent().parent().find('strong.status');
    $(event.currentTarget).removeClass("btn error");
    $(event.currentTarget).empty();
    $(status).addClass("error");
    $(status).html("cancelled");

  });
  
  $("#confirmed-booking-list").on("ajax:success", "a", function(event, data){
    var booking = $(event.currentTarget).closest('ul').parent().parent()
    booking.remove();
    var remaining = $("#confirmed-booking-list").children('li')
    if(remaining.length === 0){
      $("#confirmed-booking-list").html("<li>You have no confirmed bookings</li>")
    }
  });
  
})