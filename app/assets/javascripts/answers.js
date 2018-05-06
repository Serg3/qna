var ready;

ready = function() {
  $(document).on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  });
}

$(document).ready(ready);
$(document).on('turbolinks:load', ready);
