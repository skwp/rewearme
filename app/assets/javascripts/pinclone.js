function initLayout(){
  var col_width = 284;
  var window_width = $(window).width();

  wrapper_width = (Math.floor( window_width / col_width) * col_width);
  if ( window_width > 960 ) {
    $('.wrapper').css("width", wrapper_width + "px" );
  } else {
    $('.wrapper').css("width", "944px" );
  }
}

function resort(){
  $('#masonry').imagesLoaded(function(){
    $('#masonry').masonry({
      itemSelector : '.item:visible',
      isResizable:false
    });
  });
}

$(function(){
  initLayout();
  resort();
});

$(window).resize(function(){
  initLayout();
  resort();
});
