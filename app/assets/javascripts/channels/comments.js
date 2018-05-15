var ready = function () {
  var questionId = $('.question').data('id')

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      console.log('Connected comments!');
      this.perform('follow', {
        id: questionId
      });
    },
    
    received: function(data) {
      if (data.comment.user_id != gon.user_id) {
        var parentClass = $('.comment_' + data.comment.commentable_type + '_' + data.comment.commentable_id)
        $(parentClass).append(JST['templates/comment'](data));
      }
    }
  });
};

$(document).on('turbolinks:load', ready);
