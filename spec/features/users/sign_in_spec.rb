require 'rails_helper'

feature 'Sign in users', %{
  In order to be able
  An unauthorized user
  I want to sign in
} do

  scenario 'sign in' do
    user = create(:user)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

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
