require_relative '../features_helper'

feature 'Sign up users', %{
  In order to be able
  An unregistered user
  I want to sign up
} do

  given(:user) { create(:user) }

  scenario 'sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    # expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

    open_email('user@email.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content('Your email address has been successfully confirmed.')
  end

  scenario 'sign up with errors' do
    visit new_user_registration_path

    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

end
