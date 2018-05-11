module Rated
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:like, :dislike, :cancel]
    before_action :vote_access, only: [:like, :dislike]
  end

  def like
    @resource.like(current_user)

    render_json_details
  end

  def dislike
    @resource.dislike(current_user)

    render_json_details
  end

  def cancel
    if @resource.voted?(current_user)
      @resource.cancel(current_user)

      render_json_details
    else
      head :unprocessable_entity
    end
  end

  private

  def vote_access
    if @resource.voted?(current_user) || current_user.author_of?(@resource)
      head :unprocessable_entity
    end
  end

  def find_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json_details
    render json: { rating: @resource.rating, klass: @resource.class.to_s, id: @resource.id }
  end
end
