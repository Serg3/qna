require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #setup_email' do
    context 'temp email' do
      sign_in_user('user@email.temp')
      before { get :setup_email, params: { id: @user } }

      it 'renders setup_email' do
        expect(response).to render_template :setup_email
      end
    end

    context 'check email' do
      sign_in_user
      before { get :setup_email, params: { id: @user } }

      it 'redirects to root with non temp email' do
        expect(response.location).to match(root_path)
      end
    end
  end

  describe 'POST #confirm_email' do
    context 'temp email' do
      sign_in_user('user@email.temp')

      it 'changes user email' do
        patch :confirm_email, params: { id: @user, user: { email: 'user@email.com'} }
        @user.reload

        expect(@user.unconfirmed_email).to eq 'user@email.com'
      end

      it 'renders setup_email' do
        patch :confirm_email, params: { id: @user, user: { email: 'user@email.com'} }

        expect(response.location).to match(setup_email_user_path(@user))
      end
    end

    context 'check email' do
      sign_in_user

      it 'redirects to verify user' do
        patch :confirm_email, params: { id: @user, user: { email: 'user@email.com'} }
        @user.reload

        expect(@user.unconfirmed_email).to_not eq 'user@email.com'
      end
    end
  end
end
