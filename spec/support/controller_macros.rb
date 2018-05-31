module ControllerMacros
  def sign_in_user(email = nil)
    before do
      @user = email ? create(:user, email: email) : create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]

      sign_in @user
    end
  end
end
