$('#indextab a').click(function (e) {
    $('ul.nav-tabs li.active').removeClass('active')
    $(this).parent('li').addClass('active')
})
var $slider = $("#slider");
if ($slider.length > 0) {
  $slider.slider({
    min: 1,
    max: 5,
    value: 3,
    orientation: "horizontal",
    range: "min"
  }).addSliderSegments($slider.slider("option").max);
}
