class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    callback('VK')
  end

  def twitter
    callback('twitter')
  end

  private

  def callback(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end
end
