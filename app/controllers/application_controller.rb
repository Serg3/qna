class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
    
    gon.is_user_signed_in = user_signed_in?
  end
end
