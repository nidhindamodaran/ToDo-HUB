//-----------------infinite scrolling-----------------------//
$(document).ready(function() {
  console.log('hi');
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 150) {
        $('.pagination').html('<center><img id= "ajax_loader_img" src="ajax-loade.gif" alt="Loading..." title="Loading..."/></center>');
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});
