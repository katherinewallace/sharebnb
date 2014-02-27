$(document).ready(function(){

  
  var Event = function(text, className) {
      this.text = text;
      this.className = className;
  };
  
 var ranges = $('#bootstrapped-ranges').html();
 
 ranges = JSON.parse(ranges);
  var events = {};
  ranges.forEach(function(range){
    startString = String(range[0]) + " 00:00:00"
    endString = String(range[1] + " 00:00:00")
    var startDate = new Date(startString)
    var endDate = new Date(endString)
    while (startDate < endDate){
      events[startDate] = new Event("Available", "blue")
      
      var newDate = startDate.setDate(startDate.getDate() + 1);
      startDate = new Date(newDate);
    }
  })

   $("#listing-calendar").datepicker({
      beforeShowDay: function(date) {
         var month = $(".calendar").datepicker('getDate').getMonth()
          var event = events[date];
          if (event) {
              return [true, event.className, event.text];
          }
          else {
              return [true, '', ''];
          }
        }
  });
  
})