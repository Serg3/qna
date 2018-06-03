class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: [:create]

  authorize_resource

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.by_best
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.build)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with @question
    end
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', question: @question)
  end
end
