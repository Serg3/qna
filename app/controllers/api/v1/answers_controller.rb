class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: :show

  authorize_resource

  def index
    respond_with(@question.answers)
  end

  def show
    respond_with(@answer, serializer: AnswerShowSerializer)
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
