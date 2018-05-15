var ready = function () {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Connected!');
      this.perform('follow');
    },

    received: function(data) {
      $('tbody').append(JST['templates/question'](data));
    }
  });
}

$(document).on('turbolinks:load', ready);
