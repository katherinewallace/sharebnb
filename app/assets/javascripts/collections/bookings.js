Sharebnb.Collections.Bookings = Backbone.Collection.extend({
  
  initialize: function (attributes, options){
    this.listing_id = options.listing
  },
  
  url: "/listings/" + this.listing_id + "/bookings",
  
  model: Sharebnb.Models.Booking

});
