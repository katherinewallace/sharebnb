Sharebnb.Models.Booking = Backbone.Model.extend({
  urlRoot: "/bookings",
  accept: function(opts){
    var url = this.url() + "/accept"
    options = {
      url: url,
      type: 'GET'
    };
    
    _.extend(options, opts);
    
    return (this.sync || Backbone.sync).call(this, null, this, options);
  }
});
