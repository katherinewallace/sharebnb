var DateScripts = (function(){
  
  var calcSubtotal = function(startDate, endDate){ 
    price = parseInt($("#listing-price").html());
    if (price){
      var msDiff = endDate-startDate;
      var oneDay = 1000*60*60*24;
      $("#subtotal").html(price * Math.floor(msDiff/oneDay))
    }
  }
  
  var updateEndDate = function(startString){
    var startDate = new Date(startString)
    var endDate = new Date(startDate.getTime())
      
    endDate.setDate(startDate.getDate() + 7);
    $endDate = $(event.currentTarget).nextAll("input.end_date").first()
    if($endDate.length === 0){
      $endDate = $("input.end_date");
    }

    $endDate.val(endDate.toISOString().replace(RegExp("T.*$"), ""));
    calcSubtotal(startDate, endDate);
  }
  
  return {
    updateEndDate: updateEndDate,
    calcSubtotal: calcSubtotal
  }

})();

$(document).ready(function(){
  $('.start_date').datepicker({
      dateFormat: "yy-mm-dd",
      onSelect: function(){
        var startString = $('.start_date').datepicker("getDate");
        DateScripts.updateEndDate(startString);
      }
    });
  $('.end_date').datepicker({
      dateFormat: "yy-mm-dd",
      onSelect: function(){
        var startString = $('.start_date').datepicker("getDate");
        var endString = $('.end_date').datepicker("getDate");
        var startDate = new Date(startString);
        var endDate = new Date(endString);
        DateScripts.calcSubtotal(startDate, endDate);
      }
    });
});