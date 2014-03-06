window.Sharebnb = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function(confirmedData) {
    $pendingList = $("#pending-booking-list")
    $confirmedList = $("#confirmed-booking-list")
    Sharebnb.$flash = $(".flash")
    bookingData = JSON.parse($("#bootstrapped-bookings").html())
    var listing
    if(bookingData.length > 0){
      listing = bookingData[0].listing_id
    }
    
    Sharebnb.bookings = new Sharebnb.Collections.Bookings(bookingData, {listing: listing});

    new Sharebnb.Views.BookingsIndex({collection: Sharebnb.bookings, el: $pendingList, status: 0});
    new Sharebnb.Views.BookingsIndex({collection: Sharebnb.bookings, el: $confirmedList, status: 1});
  }
};
