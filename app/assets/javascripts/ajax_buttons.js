$(document).ready(function(){
  
  $("#trip-list").on("ajax:success", "a", function(event, data){
    var status = $(event.currentTarget).parent().parent().find('strong.status');
    $(event.currentTarget).removeClass("btn error");
    $(event.currentTarget).empty();
    $(status).addClass("error");
    $(status).html("cancelled");
    $(".flash").html("Booking has been cancelled!")
  });
  
  $("#confirmed-booking-list").on("ajax:success", "a", function(event, data){
    var booking = $(event.currentTarget).closest('ul').parent().parent()
    booking.remove();
    var remaining = $("#confirmed-booking-list").children('li')
    if(remaining.length === 0){
      $("#confirmed-booking-list").html("<li>You have no confirmed bookings</li>")
    }
    $(".flash").html("Booking has been cancelled!");
  });
  
  $(".button_to").on("ajax:success", function(event,data){
    $(event.target).closest(".photo-stuff").remove()
  });
})