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
    "click a.cancel-btn": "cancel"
  },
  
  accept: function(event){
    var that = this;
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    var booking = this.collection.get(id);
    
    booking.accept(null, booking, {
      success: function(){
        Sharebnb.bookings.fetch();
    }})
  },
  
  cancel: function(event){
    console.log("cancelling")
    event.preventDefault();
    var id = parseInt($(event.currentTarget).attr("data-id"));
    console.log(id)
    var booking = this.collection.get(id);
    booking.save({"cancelled": true}, {success: function(){
      
    }});
    this.collection.remove(booking);
  },
  
  render: function(){
    var renderedContent = this.template(
      { bookings: this.collection.where({status: this.status})}
    );
    this.$el.html(renderedContent);
  }
  
});