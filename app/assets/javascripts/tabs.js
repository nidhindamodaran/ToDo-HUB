$('#indextab a').click(function (e) {
    $('ul.nav-tabs li.active').removeClass('active')
    $(this).parent('li').addClass('active')
})
var $slider = $("#slider");
if ($slider.length > 0) {
  $slider.slider({
    min: 1,
    max: 100,
    value: 37,
    orientation: "horizontal",
    range: "min",
    slide:function( event, ui ) {
        $( "#amount" ).val( "$" + ui.value );
      }
  });
   $( "#amount" ).val( "$" + $( "#slider" ).slider( "value" ) );
}
