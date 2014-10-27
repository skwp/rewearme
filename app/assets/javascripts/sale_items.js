// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(function(){
  function filterPrice(limit) {
    if(!$.isNumeric(limit)) {
      showAllItems();
      return;
    }

    $(".price_in_currency").each(function(i, price) {
      var item = $(price).parents(".item");
      var numericPrice = parseFloat($(price).text());
      limit = parseFloat(limit);

      if(numericPrice <= limit) {
        item.show();
      } else {
        item.hide();
      }
    });

    reloadLayout();
  }

  function reloadLayout() {
    $("#masonry").masonry('reload');
  }

  function showAllItems() {
    $(".item").show();
    reloadLayout();
  }

  function filterItems(query) {
    if(query.trim() === "") {
      console.log("Showing all items");
      showAllItems();
      return;
    }

    $(".item").each(function(i, item) {
      var text = $(item).text();
      if (text.match(new RegExp(query, 'i'))) {
        $(item).show();
      } else {
        $(item).hide();
      }
    });

    reloadLayout();
  }

  $('#price_filter').keypress(function (e) {
    if (e.which == 13) {
    filterPrice(parseFloat($("#price_filter").val()));
    }
  });

  $('#query').keydown(function (e) {
    if (e.which == 13) {
      filterItems($("#query").val());
    }
  });

  $(".item").each(function(i, item) {
    $(item).click(function() {
      var _items = [];
      $.getJSON('/sale_items/' + $(item).data('id') + '/images.json', {}, function(response){
        $.each(response, function(key, val) {
          _items.push({'href' : val});
        });

        $.fancybox(_items, {
          'padding'           : 0,
          'transitionIn'      : 'none',
          'transitionOut'     : 'none',
          'type'              : 'image',
          'changeFade'        : 0
        });
      });
    });

    // TODO: replace with resized version of hires image
    // $(item).children("img").attr("src", $(item).data("hires"));
  });

  
});
