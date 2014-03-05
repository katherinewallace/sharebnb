window.Sharebnb = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function(confirmedData) {
    $pendingList = $("#pending-booking-list")
    $confirmedList = $("#confirmed-booking-list")
    confirmedData = JSON.parse($("#bootstrapped-confirmed").html())
    pendingData = JSON.parse($("#bootstrapped-pending").html())
    var listing
    if(pendingData.length > 0){
      listing = pendingData[0].listing_id
    }
    
    Sharebnb.confirmedBooks = new Sharebnb.Collections.Bookings(confirmedData, {listing: listing});
    Sharebnb.pendingBooks = new Sharebnb.Collections.Bookings(pendingData, {listing: listing});
    console.log(Sharebnb.confirmedBooks)
    console.log(Sharebnb.pendingBooks)
    new Sharebnb.Views.PendingBookingsIndex({collection: Sharebnb.pendingBooks, el: $pendingList})
  }
};
