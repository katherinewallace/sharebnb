Sharebnb.Views.BookingsIndex = Backbone.View.extend({
  
  initialize: function(options){
    this.$el = options.el
    this.listenTo(this.collection, "change remove", this.render)
    this.status = options.status
  },
  
  tagName: "ul",
  template: JST['bookings/index'],
  
  events: {
    "click a.accept": "accept",
    "click a.decline": "decline",
    "click a.cancel-btn": "cancel"
  },
  
  decline: function(event){
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    var booking = this.collection.get(id);
    
    booking.decline(null, booking, {
      success: function(){
        Sharebnb.bookings.fetch();
        $(Sharebnb.$flash).html("Booking has been declined!")
      }
    })
  },
  
  accept: function(event){
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    var booking = this.collection.get(id);
    
    booking.accept(null, booking, {
      success: function(){
        Sharebnb.bookings.fetch();
        $(Sharebnb.$flash).html("Booking has been accepted!")
    }})
  },
  
  cancel: function(event){
    var that = this;
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    var booking = this.collection.get(id);
    booking.cancel(null, booking, {
      success: function(){
        $(Sharebnb.$flash).html("Booking has been cancelled!")
        that.collection.remove(booking);
      }
    });
  },
  
  render: function(){
    var renderedContent = this.template(
      { bookings: this.collection.where({status: this.status})}
    );
    this.$el.html(renderedContent);
  }
  
});