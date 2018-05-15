class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!, only: [:create, :update, :destroy, :set_best]
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :set_best]
  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    flash[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Your answer successfully updated.'
    else
      flash[:alert] = "You can not edit another user's answer!"
      redirect_to @answer.question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:alert] = "You can not delete another user's answer!"
      redirect_to @answer.question
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best

      flash[:notice] = "Answer set as best successfully."
    else
      flash[:alert] = "You can't set the best answer for another user's question."
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = @answer.attachments.map do |a|
      { id: a.id, url: a.file.url, name: a.file.identifier }
    end

    ActionCable.server.broadcast("answers_for_question_#{@answer.question_id}",
                                 answer: @answer,
                                 attachments: attachments,
                                 question_user_id: @answer.question.user_id
                               )
  end
end
