require_relative "../features_helper"

feature 'Authorization via providers', %{
  In order to login or sign up
  As an authenticated user
  I want to use some network providers
} do

  let(:user) { create(:user, email: 'user@temp.email') }
  let(:email) { 'user@email.com' }

  describe 'vk' do
    scenario 'sign up user', js: true do
      visit new_user_session_path

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Email'

      fill_in 'Email', with: email
      click_on 'Confirm email'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'log in user', js: true do
      auth = mock_auth_hash(:vkontakte, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from VK account.')
    end
  end

  describe 'twitter' do
    scenario 'sign up user', js: true do
      visit new_user_session_path

      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Email'

      fill_in 'Email', with: email
      click_on 'Confirm email'

      open_email(email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'log in user', js: true do
      auth = mock_auth_hash(:twitter, user.email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from twitter account.')
    end
  end
end
