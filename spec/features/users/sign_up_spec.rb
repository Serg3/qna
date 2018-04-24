require 'rails_helper'

feature 'Sign up users', %{
  In order to be able
  An unregistered user
  I want to sign up
} do

  scenario 'sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
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
