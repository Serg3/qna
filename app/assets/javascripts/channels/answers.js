var ready = function () {
  var questionId = $('.question').data('id')

  App.cable.subscriptions.create({ channel: 'AnswersChannel', id: questionId }, {
    connected: function() {
      console.log('Connected answers!');
      this.perform('follow');
    },

    received: function(data) {
      if (data.answer.user_id != gon.user_id) {
        $('.answers').prepend(JST['templates/answer'](data));
        rateAnswer();
      }
    }
  });
};

$(document).on('turbolinks:load', ready);
