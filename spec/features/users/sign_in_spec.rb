require_relative '../features_helper'

feature 'Sign in users', %{
  In order to be able
  An unauthorized user
  I want to sign in
} do

  given(:user) { create(:user) }

  scenario 'sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'sign in with errors' do
    visit new_user_session_path

    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

end
