$(document).ready(function(){

  
  var Event = function(text, className) {
      this.text = text;
      this.className = className;
  };
  
 var starts = $('span.start-date');
 var events = {};
 starts.each(function(i, start){
   
   var endString = String($(start).next('span.end-date').html()) + " 00:00:00";
   var startString = String($(start).html()) + " 00:00:00";
   var startDate = new Date(startString);
   var endDate = new Date(endString);
   while (startDate <= endDate){
     events[startDate] = new Event("Available", "blue")
   
     var newDate = startDate.setDate(startDate.getDate() + 1);
     startDate = new Date(newDate);
   }
 })

   $("#listing-calendar").datepicker({
      beforeShowDay: function(date) {
         var month = date.getMonth()
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