require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :gon_user
  before_action :check_real_email

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_path, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if user_signed_in?

    gon.is_user_signed_in = user_signed_in?
  end

  def check_real_email
    if current_user&.email_temp?
      return if ['confirmations', 'sessions'].include?(controller_name)
      redirect_to setup_email_user_path(current_user)
    end
  end
end
