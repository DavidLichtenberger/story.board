var ready, addListeners;

addListeners = function() {
  $("input.slider").slider();
  $('.slider-range').on('slide', function(slider){
    $(this).closest('.range-group').first().find('input.range-slider-min-value').val(slider.value[0]);
    $(this).closest('.range-group').first().find('input.range-slider-max-value').val(slider.value[1]);
  });
};

ready = function() {
  addListeners();
  $('#conditions').on('cocoon:after-insert', addListeners);
};

$(document).ready(ready);
$(document).on('page:load', ready);
