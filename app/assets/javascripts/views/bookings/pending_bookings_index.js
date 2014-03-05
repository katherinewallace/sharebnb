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
    var that = this;
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    var booking = this.collection.get(id);
    
    booking.accept(null, booking, {
      success: function(){
        Sharebnb.pendingBooks.fetch({add: false, success: function(){
          console.log(Sharebnb.pendingBooks)
        }
          
        });
    }})
  },
  
  confirmBook: function(booking){
    Sharebnb.confirmedBooks.add(Sharebnb.pendingBooks.remove(booking))
    console.log(Sharebnb.confirmedBooks)
    console.log(Sharebnb.pendingBooks)
  }
});