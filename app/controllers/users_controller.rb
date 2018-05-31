class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:setup_email, :confirm_email]
  before_action :check_email, only: [:setup_email, :confirm_email]
  skip_before_action :check_real_email, only: [:setup_email, :confirm_email]

  def setup_email
  end

  def confirm_email
    if current_user.update(user_params)
      redirect_to setup_email_user_path(current_user),
                  notice: 'Please, check your mailbox and confirm your email adress.'
    else
      render :setup_email
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def check_email
    redirect_to root_path unless current_user.email_temp?
  end
end
