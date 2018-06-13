class SubscriptionsController < ActionController::Base
  authorize_resource

  def create
    @resource = Question.find(params[:question_id])
    @resource.subscribe(current_user)

    redirect_to @resource, notice: 'You have successfully subscribed.'
  end

  def destroy
    @resource = Subscription.find(params[:id])
    @resource.question.unsubscribe(@resource.user)

    redirect_to @resource.question, notice: 'You have successfully unsubscribed.'
  end
end
