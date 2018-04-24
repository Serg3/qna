class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_question, only: [:show]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(questions_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
