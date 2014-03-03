Sharebnb.Views.PendingBookingsIndex = Backbone.View.extend({
  
  initialize: function(options){
    this.$el = options.el
  },
  
  tagName: "ul",
  template: JST['bookings/pending_index'],  
  
  events: {
    "click a.accept": "accept"
  },
  
  accept: function(event){
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    var booking = this.collection.get(id);
    // booking.accept()
  }
});