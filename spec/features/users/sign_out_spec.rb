require 'rails_helper'

feature 'Sign out users', %{
  In order to be able
  An authorized user
  I want to sign out
} do

  scenario 'sign out' do
    user = create(:user)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
