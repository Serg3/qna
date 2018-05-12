var ready;

ready = function() {
  $('.rate').bind('ajax:success', function(e) {
    [data, status, xhr] = e.detail;
    parentClass = ".rating_" + data.klass + "_" + data.id;
    toggleActions(parentClass, data.rating);
  });

  function toggleActions(parentClass, rating) {
    $(parentClass + ' span').html(' ' + rating);
    if ($(parentClass).find('.cancel').hasClass('hidden')) {
      $(parentClass).find('.like').addClass('hidden');
      $(parentClass).find('.dislike').addClass('hidden');
      $(parentClass).find('.cancel').removeClass('hidden');
    } else {
      $(parentClass).find('.like').removeClass('hidden');
      $(parentClass).find('.dislike').removeClass('hidden');
      $(parentClass).find('.cancel').addClass('hidden');
    }
  };
};

// $(document).ready(ready);
$(document).on('turbolinks:load', ready);
