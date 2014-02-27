var DateScripts = (function(){
  
  vars = {}
  
  var init = function(){
    bind();    
  }
  
  var calcSubtotal = function(startDate, endDate){ 
    price = parseInt($("#listing-price").html());
    if (price){
      var startDate = new Date(vars.$startDate.val());
      var endDate = new Date(vars.$endDate.val())
      var msDiff = endDate-startDate;
      var oneDay = 1000*60*60*24;
      $("#subtotal").html(price * Math.floor(msDiff/oneDay))
    }
  }
  
  var bind = function(){
    vars.$startDate = $("input.start_date")
    vars.$startDate.on("blur", updateEndDate)
    vars.$endDate = $("input.end_date")
    vars.$endDate.on("blur", calcSubtotal)
  }
  
  var updateEndDate = function(){
    var startString = vars.$startDate.val();
   
    var startDate = new Date(startString);
    var endDate = new Date(startDate.getTime())
    endDate.setDate(startDate.getDate() + 7);
    vars.$endDate.val(endDate.toISOString().replace(RegExp("T.*$"), ""));
    calcSubtotal(startDate, endDate);
  }
  
  return {
    init: init
  }

})();

$(document).ready(function(){
    DateScripts.init();
  });