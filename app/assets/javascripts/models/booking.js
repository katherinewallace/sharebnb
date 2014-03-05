Sharebnb.Models.Booking = Backbone.Model.extend({
  urlRoot: "/bookings",
  
  accept: function(method, model, options){
    
    options = _(options).clone()


    var error = options.error;
    options.error = function(jqXHR, textStatus, errorThrown) {
        alert('error');
        if(error)
            error(jqXHR, textStatus, errorThrown);
    };


    var success = options.success;
    options.success = function(data, textStatus, jqXHR) {
        model.parse(data);
        if(success)
            success(data, textStatus, jqXHR);
    };

    var params = {
        type: 'GET',
        url:   model.url() + "/accept" 
    };
    $.ajax(_.extend(params, options));
    }
  
});
