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
    
    Sharebnb.confirmedBooks = new Sharebnb.Collections.Bookings(confirmedData);
    Sharebnb.pendingBooks = new Sharebnb.Collections.Bookings(pendingData);
    
    new Sharebnb.Views.PendingBookingsIndex({collection: Sharebnb.pendingBooks, el: $pendingList})
  }
};
