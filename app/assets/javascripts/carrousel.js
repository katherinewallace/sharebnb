var Carrousel = (function(){
  var els = {} 
  var currentItem = 0;
  
  var init = function(){
    var $carrousel = $("#carrousel");
    els.$itemsHolder = $carrousel.find("> ul");
    els.$items = els.$itemsHolder.find("> li");
    els.itemWidth = els.$items.first().width();
    els.$nextButton = $("#carrousel-nav > .next");
    els.$previousButton = $("#carrousel-nav > .previous");
    els.$numberLabel = $("#carrousel-nav > .number");
    bind();
    move();
  }
  
  var move = function(){
    html = (currentItem + 1) + " / " + els.$items.length;
    els.$numberLabel.html(html);
    
    leftPosition = currentItem * els.itemWidth * -1;
    els.$itemsHolder.animate({"left": leftPosition + "px"}, 800);
  }
  
  var bind = function(){
    els.$nextButton.on("click", next);
    els.$previousButton.on("click", previous);
  }
  
  var next = function(){
    currentItem++;

    if(currentItem == els.$items.length){
      currentItem = 0;
    }

    move();
  }
  
  var previous = function(){
    console.log(currentItem)
    currentItem--;

    if(currentItem < 0){
      currentItem = els.$items.length-1;
    }

    move();
  }
  
  return {
    init: init
  }
})();