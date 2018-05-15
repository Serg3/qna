class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers_for_question_#{params['id']}"
  end
end
