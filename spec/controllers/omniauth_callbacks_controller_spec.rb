require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'vk' do
    before do
      request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
      get :vkontakte
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end

    it 'returns User' do
      expect(controller.current_user).to be_a(User)
    end
  end

  describe 'twitter' do
    before do
      request.env["omniauth.auth"] = mock_auth_hash(:twitter)
      get :twitter
     end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end

    it 'returns User' do
      expect(controller.current_user).to be_a(User)
    end
  end
end
